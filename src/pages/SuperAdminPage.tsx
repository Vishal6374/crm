import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { useAuth } from "@/contexts/AuthContext";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter, DialogDescription } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Building2, Plus, Settings, ShieldAlert, Trash2, UserPlus, Activity } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { format } from "date-fns";

type Organization = {
  id: string;
  name: string;
  created_at: string;
  status: string;
};

type TenantModule = {
  id: string;
  module: string;
  enabled: boolean;
};

type Log = {
  id: string;
  action: string;
  entity_type: string;
  details: any;
  created_at: string;
  profiles?: { full_name: string | null; email: string | null };
  organization_id: string | null;
};

export default function SuperAdminPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const navigate = useNavigate();
  const [tenants, setTenants] = useState<Organization[]>([]);
  const [logs, setLogs] = useState<Log[]>([]);
  const [loading, setLoading] = useState(true);
  const [checkingAuth, setCheckingAuth] = useState(true);
  const [isSuperAdmin, setIsSuperAdmin] = useState(false);

  // Create Org State
  const [createDialogOpen, setCreateDialogOpen] = useState(false);
  const [newOrgName, setNewOrgName] = useState("");

  // Manage Org State
  const [selectedTenant, setSelectedTenant] = useState<Organization | null>(null);
  const [tenantModules, setTenantModules] = useState<TenantModule[]>([]);
  const [manageDialogOpen, setManageDialogOpen] = useState(false);
  const [assignAdminEmail, setAssignAdminEmail] = useState("");
  
  // Delete Confirmation
  const [deleteConfirmOpen, setDeleteConfirmOpen] = useState(false);
  const [orgToDelete, setOrgToDelete] = useState<Organization | null>(null);

  useEffect(() => {
    if (user) {
        checkSuperAdmin();
    }
  }, [user]);

  async function checkSuperAdmin() {
    if (!user) return;
    try {
        const { data, error } = await supabase
        .from("profiles")
        .select("super_admin")
        .eq("id", user.id)
        .single();
        
        if (error) {
            console.error("Error checking super admin:", error);
            toast({ title: "Error", description: "Failed to verify permissions.", variant: "destructive" });
            navigate("/dashboard");
            return;
        }

        if (!data?.super_admin) {
            toast({ title: "Access Denied", description: "You are not a super admin.", variant: "destructive" });
            navigate("/dashboard");
            return;
        }
        setIsSuperAdmin(true);
        fetchTenants();
        fetchLogs();
    } catch (err) {
        console.error("Unexpected error:", err);
    } finally {
        setCheckingAuth(false);
    }
  }

  async function fetchTenants() {
    setLoading(true);
    const { data, error } = await supabase
      .from("organizations")
      .select("*")
      .order("created_at", { ascending: false });
    
    if (error) {
      toast({ title: "Error fetching tenants", description: error.message, variant: "destructive" });
    } else {
      setTenants(data || []);
    }
    setLoading(false);
  }

  async function fetchLogs() {
    const { data, error } = await supabase
      .from("activity_logs")
      .select("*, profiles(full_name, email)")
      .order("created_at", { ascending: false })
      .limit(100);

    if (error) {
      console.error("Error fetching logs:", error);
    } else {
      setLogs(data || []);
    }
  }

  async function createTenant() {
    if (!newOrgName.trim()) return;
    
    const { data, error } = await supabase
      .from("organizations")
      .insert([{ name: newOrgName, status: "active" }])
      .select()
      .single();

    if (error) {
      toast({ title: "Error creating tenant", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Tenant created" });
      setCreateDialogOpen(false);
      setNewOrgName("");
      fetchTenants();
      // Initialize modules for new tenant
      await initializeModules(data.id);
    }
  }

  async function initializeModules(orgId: string) {
    const modules = [
      'dashboard','chat','leads','contacts','companies','deals','projects','tasks','calendar',
      'employees','attendance','payroll','leave_requests','reports','departments','designations',
      'user_roles','activity_logs','settings'
    ];
    
    const inserts = modules.map(m => ({
      organization_id: orgId,
      module: m,
      enabled: true
    }));

    await supabase.from("tenant_modules").insert(inserts);
  }

  async function openManageDialog(org: Organization) {
    setSelectedTenant(org);
    const { data } = await supabase
      .from("tenant_modules")
      .select("*")
      .eq("organization_id", org.id);
    
    setTenantModules(data || []);
    setManageDialogOpen(true);
  }

  async function toggleModule(moduleId: string, current: boolean) {
    const { error } = await supabase
      .from("tenant_modules")
      .update({ enabled: !current })
      .eq("id", moduleId);
    
    if (error) {
      toast({ title: "Error updating module", description: error.message, variant: "destructive" });
    } else {
      setTenantModules(prev => prev.map(m => m.id === moduleId ? { ...m, enabled: !current } : m));
    }
  }

  async function toggleTenantStatus(org: Organization) {
    const newStatus = org.status === "active" ? "suspended" : "active";
    const { error } = await supabase
      .from("organizations")
      .update({ status: newStatus })
      .eq("id", org.id);
    
    if (error) {
      toast({ title: "Error updating status", description: error.message, variant: "destructive" });
    } else {
      toast({ title: `Tenant ${newStatus}` });
      fetchTenants();
    }
  }

  async function confirmDelete(org: Organization) {
    setOrgToDelete(org);
    setDeleteConfirmOpen(true);
  }

  async function deleteTenant() {
    if (!orgToDelete) return;
    const { error } = await supabase
      .from("organizations")
      .delete()
      .eq("id", orgToDelete.id);
    
    if (error) {
      toast({ title: "Error deleting tenant", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Tenant deleted" });
      fetchTenants();
      setDeleteConfirmOpen(false);
      setOrgToDelete(null);
    }
  }

  async function assignTenantAdmin() {
    if (!assignAdminEmail || !selectedTenant) return;

    // 1. Find user by email
    const { data: profiles, error: profileError } = await supabase
      .from("profiles")
      .select("id")
      .eq("email", assignAdminEmail)
      .single();
    
    if (profileError || !profiles) {
      toast({ title: "User not found", description: "Please ensure the user has signed up first.", variant: "destructive" });
      return;
    }

    // 2. Assign Role and Update Organization
          const { error: roleError } = await supabase
            .from("user_roles")
            .insert({
              user_id: profiles.id,
              role: "tenant_admin",
              organization_id: selectedTenant.id
            });
          
          if (roleError) {
            if (roleError.message.includes("unique constraint")) {
               toast({ title: "Failed to assign", description: "This user might already have a role or this tenant already has an admin.", variant: "destructive" });
            } else {
               toast({ title: "Error assigning admin", description: roleError.message, variant: "destructive" });
            }
          } else {
            // 3. Update Profile's Organization (Move them to this tenant)
            await supabase
              .from("profiles")
              .update({ organization_id: selectedTenant.id })
              .eq("id", profiles.id);

            toast({ title: "Tenant Admin Assigned", description: `${assignAdminEmail} is now an admin for ${selectedTenant.name}` });
            setAssignAdminEmail("");
          }
  }

  if (!isSuperAdmin) return null;

  return (
    <div className="space-y-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Super Admin Console</h1>
          <p className="text-muted-foreground">Manage organizations and system settings</p>
        </div>
        <Dialog open={createDialogOpen} onOpenChange={setCreateDialogOpen}>
          <DialogTrigger asChild>
            <Button><Plus className="h-4 w-4 mr-2" />Create Organization</Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader><DialogTitle>Create New Organization</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div className="space-y-2">
                <Label>Organization Name</Label>
                <Input value={newOrgName} onChange={e => setNewOrgName(e.target.value)} placeholder="Acme Corp" />
              </div>
              <Button onClick={createTenant} className="w-full">Create</Button>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      <Tabs defaultValue="organizations">
        <TabsList>
          <TabsTrigger value="organizations">Organizations</TabsTrigger>
          <TabsTrigger value="logs">System Logs</TabsTrigger>
        </TabsList>
        
        <TabsContent value="organizations" className="mt-4">
          <Card>
            <CardHeader><CardTitle>Organizations ({tenants.length})</CardTitle></CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Name</TableHead>
                    <TableHead>Created At</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {tenants.map(org => (
                    <TableRow key={org.id}>
                      <TableCell className="font-medium">
                        <div className="flex items-center gap-2">
                          <Building2 className="h-4 w-4 text-muted-foreground" />
                          {org.name}
                        </div>
                      </TableCell>
                      <TableCell>{new Date(org.created_at).toLocaleDateString()}</TableCell>
                      <TableCell>
                        <Badge variant={org.status === "active" ? "default" : "destructive"}>
                          {org.status}
                        </Badge>
                      </TableCell>
                      <TableCell className="text-right">
                        <div className="flex justify-end gap-2">
                          <Button variant="outline" size="sm" onClick={() => openManageDialog(org)}>
                            <Settings className="h-4 w-4 mr-1" /> Manage
                          </Button>
                          <Button 
                            variant="ghost" 
                            size="sm" 
                            className={org.status === "active" ? "text-destructive" : "text-green-600"}
                            onClick={() => toggleTenantStatus(org)}
                          >
                            <ShieldAlert className="h-4 w-4" />
                          </Button>
                          <Button 
                            variant="ghost" 
                            size="sm" 
                            className="text-destructive hover:bg-destructive/10"
                            onClick={() => confirmDelete(org)}
                          >
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="logs">
          <Card>
            <CardHeader>
                <CardTitle>System Activity Logs</CardTitle>
                <CardDescription>Recent 100 activities across the platform</CardDescription>
            </CardHeader>
            <CardContent>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Time</TableHead>
                    <TableHead>User</TableHead>
                    <TableHead>Action</TableHead>
                    <TableHead>Entity</TableHead>
                    <TableHead>Organization</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {logs.map(log => (
                    <TableRow key={log.id}>
                      <TableCell className="text-xs text-muted-foreground">
                        {format(new Date(log.created_at), "MMM d, HH:mm")}
                      </TableCell>
                      <TableCell>{log.profiles?.full_name || log.profiles?.email || "Unknown"}</TableCell>
                      <TableCell><Badge variant="outline">{log.action}</Badge></TableCell>
                      <TableCell className="text-sm">{log.entity_type}</TableCell>
                      <TableCell className="text-xs text-muted-foreground font-mono">
                        {log.organization_id ? log.organization_id.slice(0, 8) + "..." : "System"}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {/* Manage Dialog */}
      <Dialog open={manageDialogOpen} onOpenChange={setManageDialogOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Manage {selectedTenant?.name}</DialogTitle>
          </DialogHeader>
          <div className="space-y-6">
            
            {/* Assign Admin Section */}
            <div className="p-4 bg-muted/50 rounded-lg space-y-3">
                <h3 className="text-sm font-medium flex items-center gap-2">
                    <UserPlus className="h-4 w-4" /> Assign Tenant Admin
                </h3>
                <div className="flex gap-2">
                    <Input 
                        placeholder="Enter user email..." 
                        value={assignAdminEmail} 
                        onChange={e => setAssignAdminEmail(e.target.value)}
                    />
                    <Button onClick={assignTenantAdmin} disabled={!assignAdminEmail}>Assign</Button>
                </div>
                <p className="text-xs text-muted-foreground">
                    Note: User must already be signed up in the system.
                </p>
            </div>

            {/* Modules Section */}
            <div>
              <h3 className="text-lg font-medium mb-4">Enabled Modules</h3>
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
                {tenantModules.map(m => (
                  <div key={m.id} className="flex items-center justify-between p-3 border rounded-lg">
                    <span className="capitalize">{m.module.replace("_", " ")}</span>
                    <Switch 
                      checked={m.enabled} 
                      onCheckedChange={() => toggleModule(m.id, m.enabled)} 
                    />
                  </div>
                ))}
              </div>
            </div>
          </div>
        </DialogContent>
      </Dialog>

      {/* Delete Confirmation Dialog */}
      <Dialog open={deleteConfirmOpen} onOpenChange={setDeleteConfirmOpen}>
        <DialogContent>
            <DialogHeader>
                <DialogTitle>Delete Organization?</DialogTitle>
                <DialogDescription>
                    This action cannot be undone. All data associated with <strong>{orgToDelete?.name}</strong> will be permanently deleted.
                </DialogDescription>
            </DialogHeader>
            <DialogFooter>
                <Button variant="outline" onClick={() => setDeleteConfirmOpen(false)}>Cancel</Button>
                <Button variant="destructive" onClick={deleteTenant}>Delete Permanently</Button>
            </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
