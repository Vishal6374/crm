import { useEffect, useState, useCallback } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, Building2, Settings, Users, Shield } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogDescription } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Switch } from "@/components/ui/switch";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { usePermissions } from "@/hooks/use-permissions";

type Organization = {
  id: string;
  name: string;
  created_at: string;
};

const MODULES = {
  CRM: [
    "dashboard", "chat", "leads", "contacts", "companies", 
    "deals", "projects", "tasks", "calendar"
  ],
  HRM: [
    "employees", "attendance", "payroll", "leave_requests"
  ],
  Admin: [
    "reports", "departments", "designations", "user_roles", 
    "activity_logs", "settings"
  ]
};

export default function SuperAdminPage() {
  const { toast } = useToast();
  const { role } = usePermissions();
  const [orgs, setOrgs] = useState<Organization[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [createDialogOpen, setCreateDialogOpen] = useState(false);
  const [modulesDialogOpen, setModulesDialogOpen] = useState(false);
  const [selectedOrg, setSelectedOrg] = useState<Organization | null>(null);
  const [orgModules, setOrgModules] = useState<Record<string, boolean>>({});
  const [newOrgName, setNewOrgName] = useState("");
  const [creating, setCreating] = useState(false);
  const [adminDialogOpen, setAdminDialogOpen] = useState(false);
  const [adminEmail, setAdminEmail] = useState("");
  const [addingAdmin, setAddingAdmin] = useState(false);



  const fetchOrgs = useCallback(async () => {
    try {
      const { data, error } = await supabase
        .from("organizations")
        .select("*")
        .order("created_at", { ascending: false });
      
      if (error) throw error;
      setOrgs((data || []) as Organization[]);
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "Unknown error";
      toast({ title: "Error", description: message, variant: "destructive" });
    } finally {
      setLoading(false);
    }
  }, [toast]);

  async function createOrg() {
    if (!newOrgName.trim()) return;
    setCreating(true);
    try {
      const { data, error } = await supabase
        .from("organizations")
        .insert([{ name: newOrgName }])
        .select()
        .single();

      if (error) throw error;

      toast({ title: "Organization created" });
      setOrgs([data as Organization, ...orgs]);
      setCreateDialogOpen(false);
      setNewOrgName("");
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "Unknown error";
      toast({ title: "Error", description: message, variant: "destructive" });
    } finally {
      setCreating(false);
    }
  }

  async function openModules(org: Organization) {
    setSelectedOrg(org);
    setModulesDialogOpen(true);
    try {
      const { data, error } = await supabase
        .from("tenant_modules")
        .select("module_name, enabled")
        .eq("organization_id", org.id);
      
      if (error) throw error;

      const map: Record<string, boolean> = {};
      // Initialize all modules as false first
      Object.values(MODULES).flat().forEach(m => map[m] = false);
      // Update with fetched data
      (data || []).forEach((row) => {
        const r = row as { module_name: string; enabled: boolean };
        map[r.module_name] = r.enabled;
      });
      setOrgModules(map);
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "Unknown error";
      toast({ title: "Error loading modules", description: message, variant: "destructive" });
    }
  }
    useEffect(() => {
    fetchOrgs();
  }, [fetchOrgs]);
  async function toggleModule(module: string) {
    if (!selectedOrg) return;
    
    const newValue = !orgModules[module];
    setOrgModules(prev => ({ ...prev, [module]: newValue }));

    try {
      const { error } = await supabase
        .from("tenant_modules")
        .upsert({
          organization_id: selectedOrg.id,
          module_name: module,
          enabled: newValue
        }, { onConflict: "organization_id,module_name" });

      if (error) throw error;
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "Unknown error";
      toast({ title: "Error updating module", description: message, variant: "destructive" });
      // Revert on error
      setOrgModules(prev => ({ ...prev, [module]: !newValue }));
    }
  }

  async function openAddAdmin(org: Organization) {
    setSelectedOrg(org);
    setAdminDialogOpen(true);
    setAdminEmail("");
  }

  async function addAdmin() {
    if (!selectedOrg || !adminEmail.trim()) return;
    setAddingAdmin(true);

    try {
      // 1. Find profile by email
      const { data: profiles, error: profileError } = await supabase
        .from("profiles")
        .select("id")
        .eq("email", adminEmail)
        .limit(1);

      if (profileError) throw profileError;
      if (!profiles || profiles.length === 0) {
        throw new Error("User with this email not found. They must sign up first.");
      }

      const userId = profiles[0].id;

      // 2. Update all existing user_roles records for this user to new org + tenant_admin
      const { error: updateAllRolesError } = await supabase
        .from("user_roles")
        .update({
          organization_id: selectedOrg.id,
          role: "tenant_admin",
        })
        .eq("user_id", userId);
      if (updateAllRolesError) {
        // If no rows existed, insert one canonical row
        const { error: insertRoleError } = await supabase
          .from("user_roles")
          .insert({
            user_id: userId,
            organization_id: selectedOrg.id,
            role: "tenant_admin",
          });
        if (insertRoleError) throw insertRoleError;
      }

      // 3. Update profile to reflect new organization
      const { error: profileOrgError } = await supabase
        .from("profiles")
        .update({ organization_id: selectedOrg.id })
        .eq("id", userId);
        
      if (profileOrgError) throw profileOrgError;

      // 4. Move employee record (if exists) to the selected organization
      const { error: employeeUpdateError } = await supabase
        .from("employees")
        .update({ organization_id: selectedOrg.id })
        .eq("user_id", userId);
      if (employeeUpdateError) {
        // Do not throw; employee may not exist yet
      }

      // Note: user_roles drives effective role across the app.
      // Profiles.role is not part of the current schema; avoid updating non-existent column.

      toast({ title: "Admin added successfully" });
      setAdminDialogOpen(false);
    } catch (err: unknown) {
      const message = err instanceof Error ? err.message : "Unknown error";
      toast({ title: "Error adding admin", description: message, variant: "destructive" });
    } finally {
      setAddingAdmin(false);
    }
  }

  if (role !== "super_admin") {
    return <div className="p-8 text-center">Access Denied</div>;
  }

  const filteredOrgs = orgs.filter(org => 
    org.name.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6 animate-fade-in p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Super Admin</h1>
          <p className="text-muted-foreground">Manage organizations and subscriptions</p>
        </div>
        <div className="flex items-center gap-2">
          <Dialog open={createDialogOpen} onOpenChange={setCreateDialogOpen}>
            <DialogTrigger asChild>
              <Button><Plus className="mr-2 h-4 w-4" />New Organization</Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>Create Organization</DialogTitle>
                <DialogDescription>Create a new tenant organization.</DialogDescription>
              </DialogHeader>
              <div className="space-y-4 py-4">
                <div className="space-y-2">
                  <Label>Organization Name</Label>
                  <Input 
                    value={newOrgName} 
                    onChange={(e) => setNewOrgName(e.target.value)}
                    placeholder="Acme Corp"
                  />
                </div>
                <Button onClick={createOrg} disabled={creating} className="w-full">
                  {creating ? "Creating..." : "Create Organization"}
                </Button>
              </div>
            </DialogContent>
          </Dialog>
        </div>
      </div>

      <div className="flex items-center gap-2 max-w-sm">
        <Search className="h-4 w-4 text-muted-foreground" />
        <Input 
          placeholder="Search organizations..." 
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {filteredOrgs.map(org => (
          <Card key={org.id} className="hover:shadow-md transition-shadow">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-xl font-bold">{org.name}</CardTitle>
              <Building2 className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-xs text-muted-foreground mb-4">
                ID: {org.id}
              </div>
              <div className="flex gap-2">
                <Button variant="outline" size="sm" onClick={() => openModules(org)}>
                  <Settings className="mr-2 h-4 w-4" />
                  Modules
                </Button>
                <Button variant="outline" size="sm" onClick={() => openAddAdmin(org)}>
                  <Users className="mr-2 h-4 w-4" />
                  Add Admin
                </Button>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      <Dialog open={modulesDialogOpen} onOpenChange={setModulesDialogOpen}>
        <DialogContent className="max-w-2xl max-h-[80vh] flex flex-col">
          <DialogHeader>
            <DialogTitle>Manage Modules - {selectedOrg?.name}</DialogTitle>
          </DialogHeader>
          <ScrollArea className="flex-1 pr-4">
            <div className="space-y-6 py-4">
              {Object.entries(MODULES).map(([category, modules]) => (
                <div key={category} className="space-y-3">
                  <h3 className="font-semibold text-lg">{category}</h3>
                  <div className="grid grid-cols-2 gap-4">
                    {modules.map(module => (
                      <div key={module} className="flex items-center justify-between p-3 border rounded-lg">
                        <span className="capitalize">{module.replace(/_/g, " ")}</span>
                        <Switch 
                          checked={orgModules[module] || false}
                          onCheckedChange={() => toggleModule(module)}
                        />
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </ScrollArea>
        </DialogContent>
      </Dialog>

      <Dialog open={adminDialogOpen} onOpenChange={setAdminDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Add Tenant Admin - {selectedOrg?.name}</DialogTitle>
            <DialogDescription>Assign the selected user as tenant admin for this organization.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label>User Email</Label>
              <Input 
                value={adminEmail} 
                onChange={(e) => setAdminEmail(e.target.value)}
                placeholder="user@example.com"
                type="email"
              />
              <p className="text-xs text-muted-foreground">The user must already be signed up in the system.</p>
            </div>
            <Button onClick={addAdmin} disabled={addingAdmin} className="w-full">
              {addingAdmin ? "Adding..." : "Add Admin"}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
