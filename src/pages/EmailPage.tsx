import { useState, useEffect, useMemo } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Plus, Mail, Send, X } from "lucide-react";
import { usePermissions } from "@/hooks/use-permissions";
import { Checkbox } from "@/components/ui/checkbox";
import { Label } from "@/components/ui/label";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { DialogDescription } from "@radix-ui/react-dialog";

type EmailTemplate = {
  id: string;
  name: string;
  subject: string;
  body: string;
  created_at: string;
};

type EmailBatch = {
  id: string;
  template_id: string;
  target_role: string | null;
  status: string;
  created_at: string;
  email_templates: { name: string };
};

type UserWithRole = {
  id: string;
  full_name: string | null;
  email: string | null;
  role: string;
};

export default function EmailPage() {
  const { toast } = useToast();
  const queryClient = useQueryClient();
  const { can, orgId, loading } = usePermissions();
  const [isCreateOpen, setIsCreateOpen] = useState(false);
  const [isSendOpen, setIsSendOpen] = useState(false);
  const [newTemplate, setNewTemplate] = useState({ name: "", subject: "", body: "" });
  
  // Extended Send Config
  const [sendConfig, setSendConfig] = useState({ 
    templateId: "", 
    targetMode: "role" as "role" | "specific",
    targetRole: "all",
    selectedUserIds: [] as string[],
    manualEmails: [] as string[]
  });
  
  const [manualEmailInput, setManualEmailInput] = useState("");

  // Fetch Templates
  const { data: templates, isLoading: templatesLoading } = useQuery({
    queryKey: ["email_templates"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("email_templates")
        .select("*")
        .order("created_at", { ascending: false });
      
      if (error) throw error;
      return data as EmailTemplate[];
    },
    enabled: can("email", "can_view"),
  });

  // Fetch Batches (History)
  const { data: batches, isLoading: batchesLoading } = useQuery({
    queryKey: ["email_batches"],
    queryFn: async () => {
      const { data, error } = await supabase
        .from("email_batches")
        .select("*, email_templates(name)")
        .order("created_at", { ascending: false })
        .limit(20);
      
      if (error) throw error;
      return data as unknown as EmailBatch[];
    },
    enabled: can("email", "can_view"),
  });

  // Fetch Users and Roles for selection
  const { data: usersData } = useQuery({
    queryKey: ["email_users"],
    queryFn: async () => {
      if (!orgId) return [];
      const { data: profileData, error: profileError } = await supabase
        .from("profiles")
        .select("id, full_name, email")
        .eq("organization_id", orgId as string);
      if (profileError) throw profileError;
      const { data: rolesData, error: rolesError } = await supabase
        .from("user_roles")
        .select("user_id, role")
        .eq("organization_id", orgId as string);
      if (rolesError) throw rolesError;
      const roleMap = new Map(rolesData.map(r => [r.user_id, r.role]));
      return (profileData || []).map(p => ({
        id: p.id,
        full_name: p.full_name,
        email: p.email,
        role: roleMap.get(p.id) || "unknown"
      })) as UserWithRole[];
    },
    enabled: isSendOpen && can("email", "can_create"),
  });

  // Group users by role
  const usersByRole = useMemo(() => {
    if (!usersData) return {};
    const groups: Record<string, UserWithRole[]> = {};
    usersData.forEach(u => {
      if (!groups[u.role]) groups[u.role] = [];
      groups[u.role].push(u);
    });
    return groups;
  }, [usersData]);

  // Create Template Mutation
  const createTemplateMutation = useMutation({
    mutationFn: async (template: typeof newTemplate) => {
      const { data: session } = await supabase.auth.getSession();
      const { data: profile } = await supabase.from('profiles').select('organization_id').eq('id', session.session?.user.id).single();
      
      const { error } = await supabase.from("email_templates").insert({
        ...template,
        organization_id: profile?.organization_id,
        created_by: session.session?.user.id
      });
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["email_templates"] });
      setIsCreateOpen(false);
      setNewTemplate({ name: "", subject: "", body: "" });
      toast({ title: "Success", description: "Email template created" });
    },
    onError: (error) => {
      toast({ variant: "destructive", title: "Error", description: error.message });
    },
  });

  // Send Bulk Email Mutation
  const sendEmailMutation = useMutation({
    mutationFn: async (config: typeof sendConfig) => {
      // Ensure we don't send "all" as a role, and handle empty arrays
      const targetRole = config.targetMode === "role" && config.targetRole !== "all" ? config.targetRole : null;
      const specificUserIds = config.targetMode === "specific" && config.selectedUserIds.length > 0 ? config.selectedUserIds : null;
      const manualEmails = config.targetMode === "specific" && config.manualEmails.length > 0 ? config.manualEmails : null;

      const { error } = await supabase.rpc("enqueue_bulk_email", {
        _template_id: config.templateId,
        _target_role: targetRole,
        _specific_user_ids: specificUserIds,
        _manual_emails: manualEmails
      });
      if (error) throw error;
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["email_batches"] });
      setIsSendOpen(false);
      // Reset sensitive fields but keep some defaults if needed
      setSendConfig(prev => ({ ...prev, selectedUserIds: [], manualEmails: [] })); 
      toast({ title: "Success", description: "Bulk email queued successfully" });
    },
    onError: (error) => {
      toast({ variant: "destructive", title: "Error", description: error.message });
    },
  });

  const handleAddManualEmail = () => {
    if (!manualEmailInput || !manualEmailInput.includes("@")) return;
    if (sendConfig.manualEmails.includes(manualEmailInput)) return;
    setSendConfig(prev => ({
      ...prev,
      manualEmails: [...prev.manualEmails, manualEmailInput]
    }));
    setManualEmailInput("");
  };

  const removeManualEmail = (email: string) => {
    setSendConfig(prev => ({
      ...prev,
      manualEmails: prev.manualEmails.filter(e => e !== email)
    }));
  };

  const toggleUserSelection = (userId: string) => {
    setSendConfig(prev => {
      const isSelected = prev.selectedUserIds.includes(userId);
      if (isSelected) {
        return { ...prev, selectedUserIds: prev.selectedUserIds.filter(id => id !== userId) };
      } else {
        return { ...prev, selectedUserIds: [...prev.selectedUserIds, userId] };
      }
    });
  };

  if (!can("email", "can_view")) {
    return <div className="p-8">You do not have permission to view this page.</div>;
  }

  return (
    <div className="space-y-6 p-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Email Marketing</h1>
          <p className="text-muted-foreground">Manage templates and send bulk emails.</p>
        </div>
        <div className="flex gap-2">
          {can("email", "can_create") && (
            <>
              <Dialog open={isCreateOpen} onOpenChange={setIsCreateOpen}>
                <DialogTrigger asChild>
                  <Button variant="outline">
                    <Plus className="mr-2 h-4 w-4" /> New Template
                  </Button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader>
                    <DialogTitle>Create Email Template</DialogTitle>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <div className="space-y-2">
                      <label>Template Name</label>
                      <Input
                        value={newTemplate.name}
                        onChange={(e) => setNewTemplate({ ...newTemplate, name: e.target.value })}
                        placeholder="e.g. Monthly Newsletter"
                      />
                    </div>
                    <div className="space-y-2">
                      <label>Subject</label>
                      <Input
                        value={newTemplate.subject}
                        onChange={(e) => setNewTemplate({ ...newTemplate, subject: e.target.value })}
                        placeholder="Subject line (supports {{name}})"
                      />
                    </div>
                    <div className="space-y-2">
                      <label>Body</label>
                      <Textarea
                        value={newTemplate.body}
                        onChange={(e) => setNewTemplate({ ...newTemplate, body: e.target.value })}
                        placeholder="Email content (supports {{name}}, {{role}})"
                        className="h-32"
                      />
                    </div>
                    <Button onClick={() => createTemplateMutation.mutate(newTemplate)} disabled={createTemplateMutation.isPending}>
                      {createTemplateMutation.isPending ? "Creating..." : "Create Template"}
                    </Button>
                  </div>
                </DialogContent>
              </Dialog>

              <Dialog open={isSendOpen} onOpenChange={setIsSendOpen}>
                <DialogTrigger asChild>
                  <Button>
                    <Send className="mr-2 h-4 w-4" /> Send Bulk Email
                  </Button>
                </DialogTrigger>
                <DialogContent className="max-w-3xl">
                  <DialogHeader>
                    <DialogTitle>Send Bulk Email</DialogTitle>
                    <DialogDescription>Queue a new email blast to users or manual recipients.</DialogDescription>
                  </DialogHeader>
                  <div className="space-y-4 py-4">
                    <div className="space-y-2">
                      <label>Select Template</label>
                      <Select
                        value={sendConfig.templateId}
                        onValueChange={(val) => setSendConfig({ ...sendConfig, templateId: val })}
                      >
                        <SelectTrigger>
                          <SelectValue placeholder="Choose a template" />
                        </SelectTrigger>
                        <SelectContent>
                          {templates?.map((t) => (
                            <SelectItem key={t.id} value={t.id}>{t.name}</SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>

                    <Tabs value={sendConfig.targetMode} onValueChange={(v) => setSendConfig({...sendConfig, targetMode: v as "role" | "specific"})}>
                      <TabsList className="grid w-full grid-cols-2">
                        <TabsTrigger value="role">Target by Role</TabsTrigger>
                        <TabsTrigger value="specific">Specific Users & Manual</TabsTrigger>
                      </TabsList>
                      
                      <TabsContent value="role" className="space-y-4 pt-4">
                        <div className="space-y-2">
                          <label>Target Role</label>
                          <Select
                            value={sendConfig.targetRole}
                            onValueChange={(val) => setSendConfig({ ...sendConfig, targetRole: val })}
                          >
                            <SelectTrigger>
                              <SelectValue placeholder="Select target audience" />
                            </SelectTrigger>
                            <SelectContent>
                              <SelectItem value="all">All Users</SelectItem>
                              <SelectItem value="admin">Admins</SelectItem>
                              <SelectItem value="manager">Managers</SelectItem>
                              <SelectItem value="employee">Employees</SelectItem>
                              <SelectItem value="client">Clients</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                      </TabsContent>
                      
                      <TabsContent value="specific" className="space-y-4 pt-4">
                        <div className="grid grid-cols-2 gap-4">
                          <div className="col-span-2 md:col-span-1 border rounded-md p-3">
                             <h4 className="font-medium mb-2">Select Users</h4>
                             <ScrollArea className="h-[200px]">
                               <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                                 {Object.entries(usersByRole).map(([role, users]) => (
                                   <div key={role} className="mb-4">
                                     <h5 className="text-xs font-bold uppercase text-muted-foreground mb-2">{role}</h5>
                                     <div className="space-y-2">
                                       {users.map(u => (
                                         <div key={u.id} className="flex items-center space-x-2">
                                           <Checkbox 
                                             id={`user-${u.id}`} 
                                             checked={sendConfig.selectedUserIds.includes(u.id)}
                                             onCheckedChange={() => toggleUserSelection(u.id)}
                                           />
                                           <Label htmlFor={`user-${u.id}`} className="text-sm cursor-pointer truncate">
                                              {u.full_name || u.email}
                                           </Label>
                                         </div>
                                       ))}
                                     </div>
                                   </div>
                                 ))}
                               </div>
                             </ScrollArea>
                          </div>

                          <div className="col-span-2 md:col-span-1 border rounded-md p-3">
                             <h4 className="font-medium mb-2">Manual Emails</h4>
                             <div className="flex gap-2 mb-2">
                               <Input 
                                 placeholder="email@example.com" 
                                 value={manualEmailInput}
                                 onChange={(e) => setManualEmailInput(e.target.value)}
                                 onKeyDown={(e) => {
                                   if (e.key === 'Enter') {
                                     e.preventDefault();
                                     handleAddManualEmail();
                                   }
                                 }}
                               />
                               <Button size="sm" onClick={handleAddManualEmail} type="button">Add</Button>
                             </div>
                             <ScrollArea className="h-[160px]">
                               <div className="space-y-1">
                                 {sendConfig.manualEmails.map((email) => (
                                   <div key={email} className="flex items-center justify-between bg-muted p-2 rounded-md text-sm">
                                     <span className="truncate max-w-[150px]" title={email}>{email}</span>
                                     <button onClick={() => removeManualEmail(email)} className="text-muted-foreground hover:text-destructive">
                                       <X className="h-3 w-3" />
                                     </button>
                                   </div>
                                 ))}
                                 {sendConfig.manualEmails.length === 0 && (
                                    <p className="text-xs text-muted-foreground text-center py-4">No manual emails added</p>
                                 )}
                               </div>
                             </ScrollArea>
                          </div>
                        </div>
                      </TabsContent>
                    </Tabs>

                    <Button 
                      onClick={() => sendEmailMutation.mutate(sendConfig)} 
                      disabled={sendEmailMutation.isPending || !sendConfig.templateId}
                      className="w-full"
                    >
                      {sendEmailMutation.isPending ? "Queueing..." : "Queue Email Blast"}
                    </Button>
                  </div>
                </DialogContent>
              </Dialog>
            </>
          )}
        </div>
      </div>

      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Mail className="h-5 w-5" /> Templates
            </CardTitle>
          </CardHeader>
          <CardContent>
            {templatesLoading ? (
              <div>Loading...</div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Name</TableHead>
                    <TableHead>Subject</TableHead>
                    <TableHead className="text-right">Created</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {templates?.map((template) => (
                    <TableRow key={template.id}>
                      <TableCell className="font-medium">{template.name}</TableCell>
                      <TableCell>{template.subject}</TableCell>
                      <TableCell className="text-right">
                        {new Date(template.created_at).toLocaleDateString()}
                      </TableCell>
                    </TableRow>
                  ))}
                  {templates?.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={3} className="text-center text-muted-foreground">
                        No templates found
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Send className="h-5 w-5" /> Recent Blasts
            </CardTitle>
          </CardHeader>
          <CardContent>
            {batchesLoading ? (
              <div>Loading...</div>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Template</TableHead>
                    <TableHead>Target</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead className="text-right">Date</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {batches?.map((batch) => (
                    <TableRow key={batch.id}>
                      <TableCell className="font-medium">{batch.email_templates?.name || "Unknown"}</TableCell>
                      <TableCell className="capitalize">{batch.target_role || "All Users"}</TableCell>
                      <TableCell className="capitalize">{batch.status}</TableCell>
                      <TableCell className="text-right">
                        {new Date(batch.created_at).toLocaleDateString()}
                      </TableCell>
                    </TableRow>
                  ))}
                  {batches?.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={4} className="text-center text-muted-foreground">
                        No history found
                      </TableCell>
                    </TableRow>
                  )}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
