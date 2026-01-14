import { useEffect, useState, useCallback } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Plus, Shield, Trash2, UserPlus, Check } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogDescription } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Input } from "@/components/ui/input";

import { Tables } from "@/integrations/supabase/types";
import { usePermissions } from "@/hooks/use-permissions";
import { useAuth } from "@/contexts/AuthContext";

interface UserRoleWithProfile extends Tables<'user_roles'> {
  profiles: { full_name: string | null; email: string | null } | null;
}

const roleColors: Record<string, string> = {
  tenant_admin: "bg-destructive/10 text-destructive",
  admin: "bg-destructive/10 text-destructive",
  manager: "bg-warning/10 text-warning",
  employee: "bg-info/10 text-info",
  viewer: "bg-muted/50 text-muted-foreground",
  hr: "bg-purple-500/10 text-purple-600",
  finance: "bg-amber-500/10 text-amber-600",
};

const roleDescriptions: Record<string, string> = {
  tenant_admin: "Tenant admin of organization",
  admin: "Full system access",
  manager: "Team management access",
  employee: "Basic access",
  viewer: "Read-only access",
  hr: "HR module access",
  finance: "Finance module access",
};

export default function UserRolesPage() {
  const { toast } = useToast();
  const { can, role, orgId } = usePermissions();
  const { user } = useAuth();
  const [userRoles, setUserRoles] = useState<UserRoleWithProfile[]>([]);
  const [profiles, setProfiles] = useState<Pick<Tables<'profiles'>, "id" | "full_name" | "email">[]>([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [formData, setFormData] = useState({ user_id: "", role: "employee" });
  const [inviteDialogOpen, setInviteDialogOpen] = useState(false);
  const [inviteEmail, setInviteEmail] = useState("");
  const [inviteRole, setInviteRole] = useState("employee");
  const [inviteFound, setInviteFound] = useState(false);
  const [invitedUserId, setInvitedUserId] = useState<string | null>(null);

  const fetchUserRoles = useCallback(async () => {
    if (!orgId) {
      setUserRoles([]);
      setLoading(false);
      return;
    }
    const { data: rolesData, error } = await supabase
      .from("user_roles")
      .select("*")
      .eq("organization_id", orgId as string)
      .order("created_at", { ascending: false });
    if (error) {
      return;
    }
    const { data: profilesData } = await supabase
      .from("profiles")
      .select("id, full_name, email")
      .eq("organization_id", orgId as string);
    const joinedRoles = (rolesData || []).map(role => ({
      ...role,
      profiles: profilesData?.find(p => p.id === role.user_id) || null
    })) as UserRoleWithProfile[];
    setUserRoles(joinedRoles);
    setLoading(false);
  }, [orgId]);

  const fetchProfiles = useCallback(async () => {
    if (!orgId) {
      setProfiles([]);
      return;
    }
    const { data } = await supabase
      .from("profiles")
      .select("id, full_name, email")
      .eq("organization_id", orgId as string)
      .order("full_name");
    if (data) setProfiles(data);
  }, [orgId]);

  useEffect(() => {
    fetchUserRoles();
    fetchProfiles();
  }, [fetchUserRoles, fetchProfiles]);

  async function createUserRole(e: React.FormEvent) {
    e.preventDefault();
    if (!can("user_roles", "can_create")) {
      toast({ title: "Not allowed", description: "You do not have permission to assign roles.", variant: "destructive" });
      return;
    }
    if (!orgId) {
      toast({ title: "Organization not selected", description: "No tenant organization context.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("user_roles").insert([{
      user_id: formData.user_id,
      role: formData.role as "admin" | "manager" | "employee" | "viewer" | "hr" | "finance",
      organization_id: orgId as string,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Role assigned successfully" });
      setDialogOpen(false);
      setFormData({ user_id: "", role: "employee" });
      fetchUserRoles();
    }
  }

  async function deleteUserRole(id: string) {
    if (!can("user_roles", "can_edit")) {
      toast({ title: "Not allowed", description: "You do not have permission to remove roles.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("user_roles").delete().eq("id", id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Role removed" });
      fetchUserRoles();
    }
  }

  const roleStats = {
    tenant_admin: userRoles.filter((r) => r.role === "tenant_admin").length,
    admin: userRoles.filter((r) => r.role === "admin").length,
    manager: userRoles.filter((r) => r.role === "manager").length,
    employee: userRoles.filter((r) => r.role === "employee").length,
    viewer: userRoles.filter((r) => r.role === "viewer").length,
    hr: userRoles.filter((r) => r.role === "hr").length,
    finance: userRoles.filter((r) => r.role === "finance").length,
  };

  useEffect(() => {
    const validateInvite = async () => {
      if (!inviteEmail.trim()) {
        setInviteFound(false);
        setInvitedUserId(null);
        return;
      }
      const { data } = await supabase
        .from("profiles")
        .select("id")
        .eq("email", inviteEmail)
        .maybeSingle();
      if (data?.id) {
        setInviteFound(true);
        setInvitedUserId(data.id as string);
      } else {
        setInviteFound(false);
        setInvitedUserId(null);
      }
    };
    validateInvite();
  }, [inviteEmail]);

  async function sendInvite(e: React.FormEvent) {
    e.preventDefault();
    if (role !== "admin") {
      toast({ title: "Not allowed", description: "Only tenant admins can invite users.", variant: "destructive" });
      return;
    }
    if (!orgId) {
      toast({ title: "Organization not selected", description: "No tenant organization context.", variant: "destructive" });
      return;
    }
    if (!inviteFound || !invitedUserId) {
      toast({ title: "User not registered yet", description: "Ask the user to sign up first.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("notifications").insert([{
      user_id: invitedUserId,
      title: "Organization Invite",
      body: `role:${inviteRole}`,
      type: "user_invite",
      entity_type: null,
      entity_id: orgId as string,
      read: false,
      organization_id: orgId as string,
    }]);
    if (error) {
      toast({ title: "Error sending invite", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Invite sent" });
      setInviteDialogOpen(false);
      setInviteEmail("");
      setInviteRole("employee");
    }
  }

  return (
    <div className="space-y-6 animate-fade-in">
      {!can("user_roles", "can_view") ? (
        <div className="text-sm text-muted-foreground">You do not have permission to view user roles.</div>
      ) : (
        <>
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">User Roles</h1>
          <p className="page-description">Manage access control</p>
        </div>
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          {can("user_roles", "can_create") && (
            <DialogTrigger asChild>
              <Button><Plus className="mr-2 h-4 w-4" />Assign Role</Button>
            </DialogTrigger>
          )}
          <DialogContent>
            <DialogHeader><DialogTitle>Assign User Role</DialogTitle></DialogHeader>
            <form onSubmit={createUserRole} className="space-y-4">
              <div>
                <Label>User</Label>
                <Select value={formData.user_id} onValueChange={(v) => setFormData({ ...formData, user_id: v })}>
                  <SelectTrigger><SelectValue placeholder="Select user" /></SelectTrigger>
                  <SelectContent>
                    {profiles.map((p) => (
                      <SelectItem key={p.id} value={p.id}>{p.full_name || p.email}</SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div>
                <Label>Role</Label>
                <Select value={formData.role} onValueChange={(v) => setFormData({ ...formData, role: v })}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="admin">Admin</SelectItem>
                    <SelectItem value="manager">Manager</SelectItem>
                    <SelectItem value="employee">Employee</SelectItem>
                    <SelectItem value="viewer">Viewer</SelectItem>
                    <SelectItem value="hr">HR</SelectItem>
                    <SelectItem value="finance">Finance</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <Button type="submit" className="w-full">Assign Role</Button>
            </form>
          </DialogContent>
        </Dialog>
        {role === "admin" && (
          <Dialog open={inviteDialogOpen} onOpenChange={setInviteDialogOpen}>
            <DialogTrigger asChild>
              <Button variant="outline"><UserPlus className="mr-2 h-4 w-4" />Invite User</Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Invite User to Organization</DialogTitle>
                <DialogDescription>Send an invite to add a user to this organization.</DialogDescription>
              </DialogHeader>
              <form onSubmit={sendInvite} className="space-y-4">
                <div>
                  <Label>User Email</Label>
                  <div className="flex items-center gap-2">
                    <Input
                      type="email"
                      value={inviteEmail}
                      onChange={(e) => setInviteEmail(e.target.value)}
                      placeholder="user@example.com"
                    />
                    {inviteFound && (
                      <span className="inline-flex items-center justify-center h-6 w-6 rounded-full bg-green-600">
                        <Check className="h-4 w-4 text-white" />
                      </span>
                    )}
                  </div>
                </div>
                <div>
                  <Label>Role</Label>
                  <Select value={inviteRole} onValueChange={(v) => setInviteRole(v)}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="admin">Admin</SelectItem>
                      <SelectItem value="manager">Manager</SelectItem>
                      <SelectItem value="employee">Employee</SelectItem>
                      <SelectItem value="viewer">Viewer</SelectItem>
                      <SelectItem value="hr">HR</SelectItem>
                      <SelectItem value="finance">Finance</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <Button type="submit" className="w-full">Send Invite</Button>
              </form>
            </DialogContent>
          </Dialog>
        )}
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        {(["tenant_admin","admin","manager","employee","viewer","hr","finance"] as const).map((role) => (
          <Card key={role}>
            <CardContent className="p-4">
              <div className="flex items-center gap-3">
                <div className={`p-2 rounded-lg ${roleColors[role].replace("text-", "bg-").replace("/10", "/10")}`}>
                  <Shield className={`h-5 w-5 ${roleColors[role].split(" ")[1]}`} />
                </div>
                <div>
                  <p className="text-sm text-muted-foreground capitalize">{role}s</p>
                  <p className="text-2xl font-bold">{roleStats[role]}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Card>
        <CardHeader><CardTitle>User Role Assignments</CardTitle></CardHeader>
        <CardContent className="p-0">
          <table className="data-table">
            <thead>
              <tr><th>User</th><th>Email</th><th>Role</th><th>Permissions</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {loading ? (
                <tr><td colSpan={5} className="text-center py-8">Loading...</td></tr>
              ) : userRoles.length === 0 ? (
                <tr><td colSpan={5} className="text-center py-8 text-muted-foreground">No role assignments found</td></tr>
              ) : (
                userRoles.map((ur) => (
                  <tr key={ur.id} className="hover:bg-muted/50">
                    <td className="font-medium">{ur.profiles?.full_name || "Unknown"}</td>
                    <td className="text-muted-foreground">{ur.profiles?.email}</td>
                    <td><Badge className={roleColors[ur.role]}>{ur.role}</Badge></td>
                    <td className="text-muted-foreground">{roleDescriptions[ur.role]}</td>
                    <td>
                      {can("user_roles", "can_edit") && (
                        <Button variant="ghost" size="icon" className="text-destructive" onClick={() => deleteUserRole(ur.id)}>
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      )}
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
