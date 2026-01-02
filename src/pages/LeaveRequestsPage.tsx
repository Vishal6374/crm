import { useEffect, useState, useCallback } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Plus, Search, Calendar, MoreHorizontal, Trash2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import type { Database } from "@/integrations/supabase/types";
import { usePermissions } from "@/hooks/use-permissions";

const statusColors: Record<string, string> = {
  pending: "bg-warning/10 text-warning",
  approved: "bg-success/10 text-success",
  rejected: "bg-destructive/10 text-destructive",
};

const leaveTypeLabels: Record<string, string> = {
  annual: "Annual Leave",
  sick: "Sick Leave",
  maternity: "Maternity Leave",
  paternity: "Paternity Leave",
  emergency: "Emergency Leave",
};

export default function LeaveRequestsPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const { can, role } = usePermissions();
  const [leaveRequests, setLeaveRequests] = useState<(Database["public"]["Tables"]["leave_requests"]["Row"] & { employees?: { employee_id: string; profiles?: { full_name: string | null } } })[]>([]);
  const [employees, setEmployees] = useState<{ id: string; employee_id: string; user_id: string | null; profiles?: { full_name: string | null } }[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [formData, setFormData] = useState({
    employee_id: "",
    leave_type: "annual",
    start_date: "",
    end_date: "",
    reason: "",
  });

  const fetchLeaveRequests = useCallback(async () => {
    const { data: empsData } = await supabase.from("employees").select("id, employee_id, user_id");
    const currentEmpId = (empsData || []).find((e) => e.user_id === user?.id)?.id || null;
    let builder = supabase
      .from("leave_requests")
      .select("*")
      .order("created_at", { ascending: false });
    if (role === "employee" && currentEmpId) {
      builder = builder.eq("employee_id", currentEmpId);
    }
    const { data: requestsData, error } = await builder;
    
    if (error) {
      console.error("Error fetching leave requests:", error);
      return;
    }

    const { data: profilesData } = await supabase.from("profiles").select("id, full_name");

    const joinedRequests = requestsData.map(req => {
      const emp = empsData?.find(e => e.id === req.employee_id);
      const prof = profilesData?.find(p => p.id === emp?.user_id);
      return {
        ...req,
        employees: emp ? {
          employee_id: emp.employee_id,
          profiles: prof ? { full_name: prof.full_name } : null
        } : undefined
      };
    });

    setLeaveRequests(joinedRequests);
    setLoading(false);
  }, [role, user?.id]);

  const fetchEmployees = useCallback(async () => {
    const { data: empsData } = await supabase
      .from("employees")
      .select("id, employee_id, user_id, status")
      .eq("status", "active")
      .order("employee_id");
    
    if (!empsData) return;

    const { data: profilesData } = await supabase.from("profiles").select("id, full_name");

    const joinedEmployees = empsData.map(emp => {
      const prof = profilesData?.find(p => p.id === emp.user_id);
      return {
        id: emp.id,
        employee_id: emp.employee_id,
        user_id: emp.user_id,
        profiles: prof ? { full_name: prof.full_name } : null
      };
    });

    if (role === "employee") {
      const me = joinedEmployees.find((e) => e.id && empsData.find((x) => x.id === e.id)?.user_id === user?.id);
      setEmployees(me ? [me] : []);
    } else {
      setEmployees(joinedEmployees);
    }
  }, [role, user?.id]);

  useEffect(() => {
    fetchLeaveRequests();
    fetchEmployees();
  }, [fetchLeaveRequests, fetchEmployees]);

  async function createLeaveRequest(e: React.FormEvent) {
    e.preventDefault();
    if (!can("leave_requests", "can_create")) {
      toast({ title: "Not allowed", description: "You do not have permission to create leave requests.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("leave_requests").insert([{
      employee_id: formData.employee_id,
      leave_type: formData.leave_type as "annual" | "sick" | "maternity" | "paternity" | "emergency",
      start_date: formData.start_date,
      end_date: formData.end_date,
      reason: formData.reason,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Leave request submitted successfully" });
      setDialogOpen(false);
      setFormData({ employee_id: "", leave_type: "annual", start_date: "", end_date: "", reason: "" });
      fetchLeaveRequests();
    }
  }

  async function updateLeaveStatus(id: string, status: "approved" | "rejected") {
    if (!can("leave_requests", "can_approve")) {
      toast({ title: "Not allowed", description: "You do not have permission to approve or reject leave requests.", variant: "destructive" });
      return;
    }

    // Check if the requester is an HR, and if so, enforce that only Tenant Admin can approve
    const request = leaveRequests.find((r) => r.id === id);
    if (request && request.employees?.employee_id) {
       // We need the user_id of the requester. 
       // The current leaveRequests state has employees joined, but maybe not user_id directly exposed in the join unless I selected it.
       // The fetchLeaveRequests function selects "*, employees(*, profiles(id,full_name))". 
       // employees table has user_id. So request.employees.user_id should be available if I type it right.
       
       // Let's fetch the requester's roles to check if they are HR
       const emp = employees.find(e => e.id === request.employee_id);
       if (emp?.user_id) {
          const { data: userRoles } = await supabase
            .from("user_roles")
            .select("roles(name)")
            .eq("user_id", emp.user_id);
          
          const isRequesterHR = userRoles?.some((ur: any) => ur.roles?.name === "hr");
          const isApproverAdmin = role === "tenant_admin";

          if (isRequesterHR && !isApproverAdmin) {
             toast({ title: "Not allowed", description: "HR leave requests can only be approved by the Tenant Admin.", variant: "destructive" });
             return;
          }
       }
    }

    const { error } = await supabase
      .from("leave_requests")
      .update({ status, approved_by: user?.id, approved_at: new Date().toISOString() })
      .eq("id", id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: `Leave request ${status}` });
      if (status === "approved") {
        const lr = leaveRequests.find((x) => x.id === id);
        if (lr) {
          const start = new Date(lr.start_date);
          const end = new Date(lr.end_date);
          for (let d = new Date(start); d <= end; d.setDate(d.getDate() + 1)) {
            const dateStr = d.toISOString().split("T")[0];
            const existing = await supabase
              .from("attendance")
              .select("id")
              .eq("employee_id", lr.employee_id)
              .eq("date", dateStr)
              .maybeSingle();
            if (existing.data?.id) {
              await supabase.from("attendance").update({
                status: "absent",
                check_in: null,
                check_out: null,
                notes: `Leave: ${lr.leave_type}`,
              }).eq("id", existing.data.id);
            } else {
              await supabase.from("attendance").insert([{
                employee_id: lr.employee_id,
                date: dateStr,
                status: "absent",
                check_in: null,
                check_out: null,
                notes: `Leave: ${lr.leave_type}`,
              }]);
            }
          }
          await supabase.from("activity_logs").insert([{
            action: "leave_approved",
            entity_type: "leave",
            entity_id: lr.id,
            description: `Attendance updated for approved leave`,
            user_id: user?.id || null,
          }]);
        }
      }
      fetchLeaveRequests();
    }
  }

  const filteredRequests = leaveRequests.filter((r) =>
    r.employees?.employee_id?.toLowerCase().includes(search.toLowerCase()) ||
    r.employees?.profiles?.full_name?.toLowerCase().includes(search.toLowerCase())
  );

  const pendingCount = leaveRequests.filter((r) => r.status === "pending").length;

  const calculateDays = (start: string, end: string) => {
    const startDate = new Date(start);
    const endDate = new Date(end);
    const diffTime = Math.abs(endDate.getTime() - startDate.getTime());
    return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
  };

  return (
    <div className="space-y-6 animate-fade-in">
      {!can("leave_requests", "can_view") ? (
        <div className="text-sm text-muted-foreground">You do not have permission to view leave requests.</div>
      ) : (
      <>
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Leave Requests</h1>
          <p className="page-description">Manage time-off requests</p>
        </div>
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          {can("leave_requests", "can_create") && (
            <DialogTrigger asChild>
              <Button><Plus className="mr-2 h-4 w-4" />Request Leave</Button>
            </DialogTrigger>
          )}
          <DialogContent>
            <DialogHeader><DialogTitle>Submit Leave Request</DialogTitle></DialogHeader>
            <form onSubmit={createLeaveRequest} className="space-y-4">
              <div>
                <Label>Employee</Label>
                <Select value={formData.employee_id} onValueChange={(v) => setFormData({ ...formData, employee_id: v })}>
                  <SelectTrigger><SelectValue placeholder="Select employee" /></SelectTrigger>
                  <SelectContent>
                    {employees.map((e) => (
                      <SelectItem key={e.id} value={e.id}>
                        {e.profiles?.full_name || e.employee_id}
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div>
                <Label>Leave Type</Label>
                <Select value={formData.leave_type} onValueChange={(v) => setFormData({ ...formData, leave_type: v })}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="annual">Annual Leave</SelectItem>
                    <SelectItem value="sick">Sick Leave</SelectItem>
                    <SelectItem value="maternity">Maternity Leave</SelectItem>
                    <SelectItem value="paternity">Paternity Leave</SelectItem>
                    <SelectItem value="emergency">Emergency Leave</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>Start Date</Label><Input type="date" value={formData.start_date} onChange={(e) => setFormData({ ...formData, start_date: e.target.value })} required /></div>
                <div><Label>End Date</Label><Input type="date" value={formData.end_date} onChange={(e) => setFormData({ ...formData, end_date: e.target.value })} required /></div>
              </div>
              <div><Label>Reason</Label><Textarea value={formData.reason} onChange={(e) => setFormData({ ...formData, reason: e.target.value })} placeholder="Reason for leave..." /></div>
              <Button type="submit" className="w-full">Submit Request</Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {pendingCount > 0 && (
        <Card className="border-warning">
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 rounded-lg bg-warning/10"><Calendar className="h-5 w-5 text-warning" /></div>
              <div><p className="text-sm text-muted-foreground">Pending Approval</p><p className="text-2xl font-bold">{pendingCount} request{pendingCount > 1 ? "s" : ""}</p></div>
            </div>
          </CardContent>
        </Card>
      )}

      <div className="flex gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search by employee..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
      </div>

      <Card>
        <CardHeader><CardTitle>Leave Requests</CardTitle></CardHeader>
        <CardContent className="p-0">
          <table className="data-table">
            <thead>
              <tr><th>Employee</th><th>Type</th><th>Duration</th><th>Days</th><th>Reason</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={7} className="text-center py-8">Loading...</td></tr>
              ) : filteredRequests.length === 0 ? (
                <tr><td colSpan={7} className="text-center py-8 text-muted-foreground">No leave requests found</td></tr>
              ) : (
                filteredRequests.map((r) => (
                  <tr key={r.id} className="hover:bg-muted/50">
                    <td className="font-medium">{r.employees?.profiles?.full_name || r.employees?.employee_id}</td>
                    <td>{leaveTypeLabels[r.leave_type]}</td>
                    <td>{new Date(r.start_date).toLocaleDateString()} - {new Date(r.end_date).toLocaleDateString()}</td>
                    <td>{calculateDays(r.start_date, r.end_date)}</td>
                    <td className="text-muted-foreground max-w-[200px] truncate">{r.reason || "-"}</td>
                    <td><Badge className={statusColors[r.status]}>{r.status}</Badge></td>
                    <td className="text-right">
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" size="icon"><MoreHorizontal className="h-4 w-4" /></Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          {r.status === "pending" && can("leave_requests", "can_approve") && (
                            <>
                              <DropdownMenuItem onClick={() => updateLeaveStatus(r.id, "approved")}>Approve</DropdownMenuItem>
                              <DropdownMenuItem onClick={() => updateLeaveStatus(r.id, "rejected")}>Reject</DropdownMenuItem>
                            </>
                          )}
                          {can("leave_requests", "can_edit") && (
                          <DropdownMenuItem onClick={async () => {
                            if (!confirm("Delete this leave request?")) return;
                            const { error } = await supabase.from("leave_requests").delete().eq("id", r.id);
                            if (!error) {
                              toast({ title: "Leave request deleted" });
                              fetchLeaveRequests();
                            }
                          }}>
                            <Trash2 className="mr-2 h-4 w-4" /> Delete
                          </DropdownMenuItem>
                          )}
                        </DropdownMenuContent>
                      </DropdownMenu>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </CardContent>
      </Card>
      </>
      )}
    </div>
  );
}
