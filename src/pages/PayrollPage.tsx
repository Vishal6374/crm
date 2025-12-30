import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Plus, Search, IndianRupee, MoreHorizontal, Pencil, Trash2 } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Checkbox } from "@/components/ui/checkbox";
import { usePermissions } from "@/hooks/use-permissions";

type EmployeeSummary = {
  id: string;
  employee_id: string;
  salary: number | null;
  profiles?: { full_name: string | null } | null;
};

type EmployeeRow = {
  id: string;
  employee_id: string;
  user_id: string;
  salary: number | null;
};

type ProfileRow = {
  id: string;
  full_name: string | null;
};

type PayrollRow = {
  id: string;
  employee_id: string;
  month: number;
  year: number;
  basic_salary: number | null;
  allowances: number | null;
  deductions: number | null;
  net_salary: number | null;
  status: "pending" | "processed" | "paid";
  paid_at?: string | null;
  created_at: string;
};

const statusColors: Record<string, string> = {
  pending: "bg-warning/10 text-warning",
  processed: "bg-info/10 text-info",
  paid: "bg-success/10 text-success",
};

const months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

export default function PayrollPage() {
  const { toast } = useToast();
  const { can } = usePermissions();
  const [payroll, setPayroll] = useState<(PayrollRow & { employees?: EmployeeSummary })[]>([]);
  const [employees, setEmployees] = useState<EmployeeSummary[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editing, setEditing] = useState<PayrollRow | null>(null);
  const [genDialogOpen, setGenDialogOpen] = useState(false);
  const [genMonth, setGenMonth] = useState((new Date().getMonth() + 1).toString());
  const [genYear, setGenYear] = useState(new Date().getFullYear().toString());
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [formData, setFormData] = useState({
    employee_id: "",
    month: (new Date().getMonth() + 1).toString(),
    year: new Date().getFullYear().toString(),
    basic_salary: "",
    allowances: "0",
    deductions: "0",
    status: "pending",
  });

  useEffect(() => {
    fetchPayroll();
    fetchEmployees();
  }, []);

  async function fetchPayroll() {
    const { data: payrollData, error } = await supabase
      .from("payroll")
      .select("*")
      .order("year", { ascending: false })
      .order("month", { ascending: false })
      .limit(100);
    
    if (error) {
      console.error("Error fetching payroll:", error);
      return;
    }

    const { data: empsData } = await supabase.from("employees").select("id, employee_id, user_id, salary");
    const { data: profilesData } = await supabase.from("profiles").select("id, full_name");

    const joinedPayroll = (payrollData || []).map((pay) => {
      const payRow = pay as unknown as PayrollRow;
      const emp = (empsData || []).find((e) => (e as EmployeeRow).id === payRow.employee_id) as EmployeeRow | undefined;
      const prof = (profilesData || []).find((p) => (p as ProfileRow).id === emp?.user_id) as ProfileRow | undefined;
      const employees: EmployeeSummary | undefined = emp
        ? {
            id: emp.id,
            employee_id: emp.employee_id,
            salary: emp.salary,
            profiles: prof ? { full_name: prof.full_name } : null,
          }
        : undefined;
      return { ...(payRow as PayrollRow), employees };
    });

    setPayroll(joinedPayroll);
    setLoading(false);
  }

  async function fetchEmployees() {
    const { data: empsData } = await supabase
      .from("employees")
      .select("id, employee_id, user_id, salary")
      .eq("status", "active")
      .order("employee_id");
    
    if (!empsData) return;

    const { data: profilesData } = await supabase.from("profiles").select("id, full_name");

    const joinedEmployees = (empsData || []).map((emp) => {
      const empRow = emp as EmployeeRow;
      const prof = (profilesData || []).find((p) => (p as ProfileRow).id === empRow.user_id) as ProfileRow | undefined;
      return {
        id: empRow.id,
        employee_id: empRow.employee_id,
        salary: empRow.salary ?? null,
        profiles: prof ? { full_name: prof.full_name } : null,
      };
    });

    setEmployees(joinedEmployees);
  }

  async function createPayroll(e: React.FormEvent) {
    e.preventDefault();
    const basic = parseFloat(formData.basic_salary) || 0;
    const allowances = parseFloat(formData.allowances) || 0;
    const deductions = parseFloat(formData.deductions) || 0;
    const netSalary = basic + allowances - deductions;

    if (editing) {
      const { error } = await supabase.from("payroll").update({
        employee_id: formData.employee_id,
        month: parseInt(formData.month),
        year: parseInt(formData.year),
        basic_salary: basic,
        allowances,
        deductions,
        net_salary: netSalary,
        status: formData.status as "pending" | "processed" | "paid",
      }).eq("id", editing.id);
      if (error) {
        toast({ title: "Error", description: error.message, variant: "destructive" });
        return;
      }
      toast({ title: "Payroll record updated" });
    } else {
      const { error } = await supabase.from("payroll").insert([{
        employee_id: formData.employee_id,
        month: parseInt(formData.month),
        year: parseInt(formData.year),
        basic_salary: basic,
        allowances,
        deductions,
        net_salary: netSalary,
        status: formData.status as "pending" | "processed" | "paid",
      }]);
      if (error) {
        toast({ title: "Error", description: error.message, variant: "destructive" });
        return;
      }
      toast({ title: "Payroll record created successfully" });
    }
    setDialogOpen(false);
    setEditing(null);
    setFormData({ employee_id: "", month: (new Date().getMonth() + 1).toString(), year: new Date().getFullYear().toString(), basic_salary: "", allowances: "0", deductions: "0", status: "pending" });
    fetchPayroll();
  }

  async function updatePayrollStatus(id: string, status: "pending" | "processed" | "paid") {
    const { error } = await supabase
      .from("payroll")
      .update({ status, paid_at: status === "paid" ? new Date().toISOString() : null })
      .eq("id", id);
    if (!error) fetchPayroll();
  }

  async function bulkMarkPaid() {
    if (selected.size === 0) return;
    const ids = Array.from(selected);
    const { error } = await supabase
      .from("payroll")
      .update({ status: "paid", paid_at: new Date().toISOString() })
      .in("id", ids);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    toast({ title: `${ids.length} payroll records marked paid` });
    setSelected(new Set());
    fetchPayroll();
  }

  function toggleSelect(id: string) {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  }

  function toggleSelectAll(items: { id: string }[]) {
    setSelected((prev) => {
      if (prev.size === items.length) return new Set();
      return new Set(items.map((i) => i.id));
    });
  }

  const filteredPayroll = payroll.filter((p) =>
    p.employees?.employee_id?.toLowerCase().includes(search.toLowerCase()) ||
    p.employees?.profiles?.full_name?.toLowerCase().includes(search.toLowerCase())
  );

  const totalPending = payroll.filter((p) => p.status === "pending").reduce((sum, p) => sum + Number(p.net_salary || 0), 0);
  const totalPaid = payroll.filter((p) => p.status === "paid").reduce((sum, p) => sum + Number(p.net_salary || 0), 0);

  return (
    <div className="space-y-6 animate-fade-in">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="page-title">Payroll</h1>
            <p className="page-description">Manage salary and compensation</p>
          </div>
        <div className="flex items-center gap-2">
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            {can("payroll", "can_create") && (
              <DialogTrigger asChild>
                <Button><Plus className="mr-2 h-4 w-4" />Create Payroll</Button>
              </DialogTrigger>
            )}
          <DialogContent>
            <DialogHeader><DialogTitle>Create Payroll Record</DialogTitle></DialogHeader>
            <form onSubmit={createPayroll} className="space-y-4">
              <div>
                <Label>Employee</Label>
                <Select value={formData.employee_id} onValueChange={(v) => {
                  const emp = employees.find((e) => e.id === v);
                  setFormData({ ...formData, employee_id: v, basic_salary: emp?.salary?.toString() || "" });
                }}>
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
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Month</Label>
                  <Select value={formData.month} onValueChange={(v) => setFormData({ ...formData, month: v })}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>
                      {months.map((m, i) => <SelectItem key={i + 1} value={(i + 1).toString()}>{m}</SelectItem>)}
                    </SelectContent>
                  </Select>
                </div>
                <div><Label>Year</Label><Input type="number" value={formData.year} onChange={(e) => setFormData({ ...formData, year: e.target.value })} required /></div>
              </div>
              <div><Label>Basic Salary</Label><Input type="number" value={formData.basic_salary} onChange={(e) => setFormData({ ...formData, basic_salary: e.target.value })} required /></div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>Allowances</Label><Input type="number" value={formData.allowances} onChange={(e) => setFormData({ ...formData, allowances: e.target.value })} /></div>
                <div><Label>Deductions</Label><Input type="number" value={formData.deductions} onChange={(e) => setFormData({ ...formData, deductions: e.target.value })} /></div>
              </div>
              <Button type="submit" className="w-full">Create Payroll</Button>
            </form>
            </DialogContent>
          </Dialog>
          <Dialog open={genDialogOpen} onOpenChange={setGenDialogOpen}>
            {can("payroll", "can_edit") && (
              <DialogTrigger asChild>
                <Button variant="outline"><IndianRupee className="mr-2 h-4 w-4" />Generate Monthly</Button>
              </DialogTrigger>
            )}
            <DialogContent>
              <DialogHeader><DialogTitle>Generate Monthly Payroll</DialogTitle></DialogHeader>
              <div className="space-y-4">
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label>Month</Label>
                    <Select value={genMonth} onValueChange={setGenMonth}>
                      <SelectTrigger><SelectValue /></SelectTrigger>
                      <SelectContent>{months.map((m, i) => <SelectItem key={i + 1} value={(i + 1).toString()}>{m}</SelectItem>)}</SelectContent>
                    </Select>
                  </div>
                  <div>
                    <Label>Year</Label>
                    <Input type="number" value={genYear} onChange={(e) => setGenYear(e.target.value)} />
                  </div>
                </div>
                <Button
                  onClick={async () => {
                    const monthNum = parseInt(genMonth);
                    const yearNum = parseInt(genYear);
                    const start = new Date(yearNum, monthNum - 1, 1);
                    const end = new Date(yearNum, monthNum, 0);
                    const daysInMonth = end.getDate();
                    const { data: active } = await supabase
                      .from("employees")
                      .select("id, salary, profiles:user_id(full_name)")
                      .eq("status", "active");
                    for (const emp of active || []) {
                      const { data: existing } = await supabase
                        .from("payroll")
                        .select("id")
                        .eq("employee_id", emp.id)
                        .eq("month", monthNum)
                        .eq("year", yearNum)
                        .limit(1);
                      if (existing && existing.length > 0) continue;
                      const { data: absences } = await supabase
                        .from("attendance")
                        .select("status")
                        .eq("employee_id", emp.id)
                        .gte("date", start.toISOString().split("T")[0])
                        .lte("date", end.toISOString().split("T")[0])
                        .eq("status", "absent");
                      const basic = Number(emp.salary || 0);
                      const absentDays = (absences || []).length;
                      const perDay = basic / daysInMonth;
                      const deductions = perDay * absentDays;
                      const net = basic - deductions;
                      await supabase.from("payroll").insert([{
                        employee_id: emp.id,
                        month: monthNum,
                        year: yearNum,
                        basic_salary: basic,
                        allowances: 0,
                        deductions,
                        net_salary: net,
                        status: "pending",
                      }]);
                    }
                    toast({ title: "Monthly payroll generated" });
                    setGenDialogOpen(false);
                    fetchPayroll();
                  }}
                >
                  Generate
                </Button>
              </div>
            </DialogContent>
          </Dialog>
          {can("payroll", "can_edit") && (
            <Button variant="outline" onClick={bulkMarkPaid} disabled={selected.size === 0}>Mark Selected Paid</Button>
          )}
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2">
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 rounded-lg bg-warning/10"><IndianRupee className="h-5 w-5 text-warning" /></div>
              <div><p className="text-sm text-muted-foreground">Pending Payments</p><p className="text-2xl font-bold">₹{totalPending.toLocaleString()}</p></div>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="p-4">
            <div className="flex items-center gap-3">
              <div className="p-2 rounded-lg bg-success/10"><IndianRupee className="h-5 w-5 text-success" /></div>
              <div><p className="text-sm text-muted-foreground">Total Paid (This Year)</p><p className="text-2xl font-bold">₹{totalPaid.toLocaleString()}</p></div>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="flex gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search by employee..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
      </div>

      <Card>
        <CardHeader><CardTitle>Payroll Records</CardTitle></CardHeader>
        <CardContent className="p-0">
          <table className="data-table">
            <thead>
              <tr>
                <th className="w-10">
                  <Checkbox
                    checked={selected.size > 0 && selected.size === filteredPayroll.length}
                    onCheckedChange={() => toggleSelectAll(filteredPayroll)}
                  />
                </th>
                <th>Employee</th><th>Period</th><th>Basic</th><th>Allowances</th><th>Deductions</th><th>Net</th><th>Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={9} className="text-center py-8">Loading...</td></tr>
              ) : filteredPayroll.length === 0 ? (
                <tr><td colSpan={9} className="text-center py-8 text-muted-foreground">No payroll records found</td></tr>
              ) : (
                filteredPayroll.map((p) => (
                  <tr key={p.id} className="hover:bg-muted/50">
                    <td>
                      <Checkbox checked={selected.has(p.id)} onCheckedChange={() => toggleSelect(p.id)} />
                    </td>
                    <td className="font-medium">{p.employees?.profiles?.full_name || p.employees?.employee_id}</td>
                    <td>{months[p.month - 1]} {p.year}</td>
                    <td>₹{Number(p.basic_salary || 0).toLocaleString()}</td>
                    <td className="text-success">₹{Number(p.allowances || 0).toLocaleString()}</td>
                    <td className="text-destructive">₹{Number(p.deductions || 0).toLocaleString()}</td>
                    <td className="font-semibold">₹{Number(p.net_salary || 0).toLocaleString()}</td>
                    <td><Badge className={statusColors[p.status]}>{p.status}</Badge></td>
                    <td className="text-right">
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button variant="ghost" size="icon"><MoreHorizontal className="h-4 w-4" /></Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                          {p.status === "pending" && can("payroll", "can_edit") && (
                            <DropdownMenuItem onClick={() => updatePayrollStatus(p.id, "processed")}>Process</DropdownMenuItem>
                          )}
                          {p.status === "processed" && can("payroll", "can_edit") && (
                            <DropdownMenuItem onClick={() => updatePayrollStatus(p.id, "paid")}>Mark Paid</DropdownMenuItem>
                          )}
                          {can("payroll", "can_edit") && (<DropdownMenuItem onClick={() => {
                            setEditing(p);
                            setFormData({
                              employee_id: p.employee_id,
                              month: p.month.toString(),
                              year: p.year.toString(),
                              basic_salary: (p.basic_salary || 0).toString(),
                              allowances: (p.allowances || 0).toString(),
                              deductions: (p.deductions || 0).toString(),
                              status: p.status,
                            });
                            setDialogOpen(true);
                          }}>
                            <Pencil className="mr-2 h-4 w-4" /> Edit
                          </DropdownMenuItem>)}
                          {can("payroll", "can_edit") && (<DropdownMenuItem onClick={async () => {
                            if (!confirm("Delete this payroll record?")) return;
                            const { error } = await supabase.from("payroll").delete().eq("id", p.id);
                            if (error) {
                              toast({ title: "Error", description: error.message, variant: "destructive" });
                              return;
                            }
                            toast({ title: "Payroll deleted" });
                            fetchPayroll();
                          }}>
                            <Trash2 className="mr-2 h-4 w-4" /> Delete
                          </DropdownMenuItem>)}
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
    </div>
  );
}
