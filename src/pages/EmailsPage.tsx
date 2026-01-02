import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, Trash2, Edit, Mail, RefreshCw, Send, CheckCircle2, Clock } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Checkbox } from "@/components/ui/checkbox";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { usePermissions } from "@/hooks/use-permissions";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Badge } from "@/components/ui/badge";
import { format } from "date-fns";

type EmailTemplate = {
  id: string;
  name: string;
  subject: string;
  body: string;
  created_at: string;
};

type OutboxItem = {
  id: string;
  recipient_email: string;
  subject: string;
  status: string;
  sent_at: string | null;
  created_at: string;
};

export default function EmailsPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const { can } = usePermissions();
  const [templates, setTemplates] = useState<EmailTemplate[]>([]);
  const [outbox, setOutbox] = useState<OutboxItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [sendDialogOpen, setSendDialogOpen] = useState(false);
  const [editingTemplate, setEditingTemplate] = useState<EmailTemplate | null>(null);
  const [formData, setFormData] = useState({ name: "", subject: "", body: "" });
  const [sendData, setSendData] = useState({ template_id: "" });
  
  // Recipient lists
  const [employees, setEmployees] = useState<{id: string, email: string, name: string}[]>([]);
  const [leads, setLeads] = useState<{id: string, email: string, name: string}[]>([]);
  const [clients, setClients] = useState<{id: string, email: string, name: string}[]>([]);
  
  // Selections
  const [selectedEmployees, setSelectedEmployees] = useState<string[]>([]);
  const [selectedLeads, setSelectedLeads] = useState<string[]>([]);
  const [selectedClients, setSelectedClients] = useState<string[]>([]);

  useEffect(() => {
    fetchTemplates();
    fetchOutbox();
    fetchRecipients();
  }, []);

  async function fetchRecipients() {
    // Employees
    const { data: emps } = await supabase.from("employees").select("id, user_id");
    if (emps) {
        const userIds = emps.map(e => e.user_id).filter(Boolean);
        const { data: profs } = await supabase.from("profiles").select("id, email, first_name, last_name").in("id", userIds);
        const profMap = new Map(profs?.map(p => [p.id, p]) || []);
        
        setEmployees(emps.map(e => {
            const p = profMap.get(e.user_id);
            return {
                id: p?.id || "", 
                email: p?.email || "",
                name: `${p?.first_name || ""} ${p?.last_name || ""}`.trim() || p?.email || "Unknown",
            };
        }).filter(e => e.email && e.id));
    }

    // Leads
    const { data: lds } = await supabase.from("leads").select("id, title, email, contacts(first_name, last_name)");
    if (lds) {
        setLeads(lds.map(l => ({
            id: l.id,
            email: l.email || "",
            name: l.title || (l.contacts ? `${l.contacts.first_name} ${l.contacts.last_name}` : "Unknown Lead")
        })).filter(l => l.email));
    }

    // Clients
    const { data: comps } = await supabase.from("companies").select("id, name, email");
    if (comps) {
        setClients(comps.map(c => ({
            id: c.id,
            email: c.email || "",
            name: c.name
        })).filter(c => c.email));
    }
  }

  async function fetchTemplates() {
    setLoading(true);
    const { data, error } = await supabase
      .from("email_templates")
      .select("*")
      .order("created_at", { ascending: false });
    if (error) {
      console.error(error);
    } else {
      setTemplates(data || []);
    }
    setLoading(false);
  }

  async function fetchOutbox() {
    const { data, error } = await supabase
      .from("emails_outbox")
      .select("*")
      .order("created_at", { ascending: false })
      .limit(100);
    if (!error && data) {
      setOutbox(data as any);
    }
  }

  async function saveTemplate(e: React.FormEvent) {
    e.preventDefault();
    const payload = {
      name: formData.name,
      subject: formData.subject,
      body: formData.body,
      created_by: user?.id,
    };

    let error;
    if (editingTemplate) {
      const { error: err } = await supabase
        .from("email_templates")
        .update(payload)
        .eq("id", editingTemplate.id);
      error = err;
    } else {
      const { error: err } = await supabase.from("email_templates").insert([payload]);
      error = err;
    }

    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: editingTemplate ? "Template updated" : "Template created" });
      setDialogOpen(false);
      setEditingTemplate(null);
      setFormData({ name: "", subject: "", body: "" });
      fetchTemplates();
    }
  }

  async function deleteTemplate(id: string) {
    if (!confirm("Are you sure?")) return;
    const { error } = await supabase.from("email_templates").delete().eq("id", id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Template deleted" });
      fetchTemplates();
    }
  }
  
  async function sendBulkEmail(e: React.FormEvent) {
      e.preventDefault();
      if (!sendData.template_id) {
          toast({ title: "Error", description: "Please select a template", variant: "destructive" });
          return;
      }

      const template = templates.find(t => t.id === sendData.template_id);
      if (!template) return;

      const totalSelected = selectedEmployees.length + selectedLeads.length + selectedClients.length;
      if (totalSelected === 0) {
        toast({ title: "Error", description: "Please select at least one recipient", variant: "destructive" });
        return;
      }
      
      setLoading(true);
      toast({ title: "Sending emails...", description: "Processing bulk email request." });
      
      try {
        const outboxRows: any[] = [];

        const processRecipient = (id: string, email: string, name: string, userId: string | null) => {
            let subject = template.subject;
            let body = template.body;
            
            // Variable substitution
            const vars: Record<string, string> = {
                "{{name}}": name,
                "{{email}}": email,
                "{{id}}": id,
            };
            
            Object.entries(vars).forEach(([key, val]) => {
                subject = subject.replace(new RegExp(key, 'g'), val);
                body = body.replace(new RegExp(key, 'g'), val);
            });

            return {
                template_id: template.id,
                recipient_email: email,
                recipient_user_id: userId,
                subject,
                body,
                status: 'queued',
                created_by: user?.id,
                organization_id: (user as any)?.organization_id
            };
        };

        // Employees
        employees.filter(e => selectedEmployees.includes(e.id)).forEach(r => {
            outboxRows.push(processRecipient(r.id, r.email, r.name, r.id));
        });

        // Leads
        leads.filter(l => selectedLeads.includes(l.id)).forEach(r => {
            outboxRows.push(processRecipient(r.id, r.email, r.name, null));
        });

        // Clients
        clients.filter(c => selectedClients.includes(c.id)).forEach(r => {
            outboxRows.push(processRecipient(r.id, r.email, r.name, null));
        });
 
         const { error: insertError } = await supabase
             .from("emails_outbox" as any)
             .insert(outboxRows);
            
        if (insertError) throw insertError;

        toast({ title: "Success", description: `Queued ${outboxRows.length} emails for sending.` });
        setSendDialogOpen(false);
        setSelectedEmployees([]);
        setSelectedLeads([]);
        setSelectedClients([]);
        fetchOutbox();
      } catch (err: any) {
          console.error(err);
          toast({ title: "Error", description: err.message || "Failed to send emails", variant: "destructive" });
      } finally {
          setLoading(false);
      }
  }

  async function processQueue() {
      const queued = outbox.filter(o => o.status === 'queued');
      if (queued.length === 0) {
          toast({ title: "Nothing to process", description: "No queued emails found." });
          return;
      }

      setLoading(true);
      // Simulate sending
      try {
          const ids = queued.map(q => q.id);
          const { error } = await supabase
            .from("emails_outbox")
            .update({ status: 'sent', sent_at: new Date().toISOString() })
            .in("id", ids);
            
          if (error) throw error;
          
          toast({ title: "Success", description: `Processed ${ids.length} emails.` });
          fetchOutbox();
      } catch (err: any) {
          toast({ title: "Error", description: err.message, variant: "destructive" });
      } finally {
          setLoading(false);
      }
  }

  const filteredTemplates = templates.filter(t => t.name.toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Email Marketing</h1>
          <p className="page-description">Manage templates and track email campaigns</p>
        </div>
      </div>

      <Tabs defaultValue="templates" className="w-full">
        <TabsList>
          <TabsTrigger value="templates">Templates</TabsTrigger>
          <TabsTrigger value="outbox">Outbox</TabsTrigger>
        </TabsList>

        <TabsContent value="templates" className="space-y-6 mt-4">
            <div className="flex justify-between gap-4">
                <div className="relative flex-1 max-w-sm">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input placeholder="Search templates..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
                </div>
                <div className="flex gap-2">
                    <Dialog open={sendDialogOpen} onOpenChange={setSendDialogOpen}>
                        <DialogTrigger asChild><Button variant="outline"><Mail className="mr-2 h-4 w-4" />Send Bulk Email</Button></DialogTrigger>
                        <DialogContent className="max-w-4xl max-h-[90vh] flex flex-col">
                            <DialogHeader><DialogTitle>Send Bulk Email</DialogTitle></DialogHeader>
                            <div className="flex-1 overflow-y-auto py-4 space-y-4">
                                <div>
                                    <Label>Template</Label>
                                    <Select value={sendData.template_id} onValueChange={(v) => setSendData({...sendData, template_id: v})}>
                                    <SelectTrigger><SelectValue placeholder="Select a template" /></SelectTrigger>
                                    <SelectContent>
                                        {templates.map(t => <SelectItem key={t.id} value={t.id}>{t.name}</SelectItem>)}
                                    </SelectContent>
                                    </Select>
                                </div>
                                
                                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 h-[400px]">
                                    {/* Employees Column */}
                                    <div className="border rounded-lg p-3 flex flex-col">
                                        <div className="font-medium mb-2 flex justify-between items-center">
                                            <span>Employees ({employees.length})</span>
                                            <Checkbox 
                                                checked={selectedEmployees.length === employees.length && employees.length > 0}
                                                onCheckedChange={(checked) => setSelectedEmployees(checked ? employees.map(e => e.id) : [])}
                                            />
                                        </div>
                                        <ScrollArea className="flex-1">
                                            <div className="space-y-2">
                                                {employees.map(e => (
                                                    <div key={e.id} className="flex items-center space-x-2">
                                                        <Checkbox id={`emp-${e.id}`} checked={selectedEmployees.includes(e.id)} 
                                                            onCheckedChange={(checked) => {
                                                                if (checked) setSelectedEmployees([...selectedEmployees, e.id]);
                                                                else setSelectedEmployees(selectedEmployees.filter(id => id !== e.id));
                                                            }}
                                                        />
                                                        <label htmlFor={`emp-${e.id}`} className="text-sm cursor-pointer truncate">{e.name}</label>
                                                    </div>
                                                ))}
                                            </div>
                                        </ScrollArea>
                                    </div>

                                    {/* Leads Column */}
                                    <div className="border rounded-lg p-3 flex flex-col">
                                        <div className="font-medium mb-2 flex justify-between items-center">
                                            <span>Leads ({leads.length})</span>
                                            <Checkbox 
                                                checked={selectedLeads.length === leads.length && leads.length > 0}
                                                onCheckedChange={(checked) => setSelectedLeads(checked ? leads.map(l => l.id) : [])}
                                            />
                                        </div>
                                        <ScrollArea className="flex-1">
                                            <div className="space-y-2">
                                                {leads.map(l => (
                                                    <div key={l.id} className="flex items-center space-x-2">
                                                        <Checkbox id={`lead-${l.id}`} checked={selectedLeads.includes(l.id)} 
                                                            onCheckedChange={(checked) => {
                                                                if (checked) setSelectedLeads([...selectedLeads, l.id]);
                                                                else setSelectedLeads(selectedLeads.filter(id => id !== l.id));
                                                            }}
                                                        />
                                                        <label htmlFor={`lead-${l.id}`} className="text-sm cursor-pointer truncate">{l.name}</label>
                                                    </div>
                                                ))}
                                            </div>
                                        </ScrollArea>
                                    </div>

                                    {/* Clients Column */}
                                    <div className="border rounded-lg p-3 flex flex-col">
                                        <div className="font-medium mb-2 flex justify-between items-center">
                                            <span>Clients ({clients.length})</span>
                                            <Checkbox 
                                                checked={selectedClients.length === clients.length && clients.length > 0}
                                                onCheckedChange={(checked) => setSelectedClients(checked ? clients.map(c => c.id) : [])}
                                            />
                                        </div>
                                        <ScrollArea className="flex-1">
                                            <div className="space-y-2">
                                                {clients.map(c => (
                                                    <div key={c.id} className="flex items-center space-x-2">
                                                        <Checkbox id={`client-${c.id}`} checked={selectedClients.includes(c.id)} 
                                                            onCheckedChange={(checked) => {
                                                                if (checked) setSelectedClients([...selectedClients, c.id]);
                                                                else setSelectedClients(selectedClients.filter(id => id !== c.id));
                                                            }}
                                                        />
                                                        <label htmlFor={`client-${c.id}`} className="text-sm cursor-pointer truncate">{c.name}</label>
                                                    </div>
                                                ))}
                                            </div>
                                        </ScrollArea>
                                    </div>
                                </div>
                            </div>
                            <div className="pt-4 border-t mt-2">
                                <Button onClick={sendBulkEmail} className="w-full">Send Emails ({selectedEmployees.length + selectedLeads.length + selectedClients.length})</Button>
                            </div>
                        </DialogContent>
                    </Dialog>

                    <Dialog open={dialogOpen} onOpenChange={(open) => {
                        setDialogOpen(open);
                        if (!open) {
                            setEditingTemplate(null);
                            setFormData({ name: "", subject: "", body: "" });
                        }
                    }}>
                    <DialogTrigger asChild>
                        <Button onClick={() => {
                            setEditingTemplate(null);
                            setFormData({ name: "", subject: "", body: "" });
                        }}>
                        <Plus className="mr-2 h-4 w-4" />New Template
                        </Button>
                    </DialogTrigger>
                    <DialogContent className="max-w-2xl">
                        <DialogHeader><DialogTitle>{editingTemplate ? "Edit Template" : "Create Template"}</DialogTitle></DialogHeader>
                        <form onSubmit={saveTemplate} className="space-y-4">
                        <div><Label>Name</Label><Input value={formData.name} onChange={(e) => setFormData({ ...formData, name: e.target.value })} required /></div>
                        <div><Label>Subject</Label><Input value={formData.subject} onChange={(e) => setFormData({ ...formData, subject: e.target.value })} required /></div>
                        <div><Label>Body (Supports {'{{name}}'}, {'{{email}}'})</Label><Textarea value={formData.body} onChange={(e) => setFormData({ ...formData, body: e.target.value })} className="min-h-[200px]" required /></div>
                        <Button type="submit" className="w-full">Save Template</Button>
                        </form>
                    </DialogContent>
                    </Dialog>
                </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
                {loading ? <p>Loading...</p> : filteredTemplates.length === 0 ? <p className="text-muted-foreground">No templates found</p> : filteredTemplates.map((t) => (
                    <Card key={t.id}>
                        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                            <CardTitle className="text-sm font-medium">{t.name}</CardTitle>
                            <div className="flex gap-2">
                                <Button variant="ghost" size="icon" onClick={() => {
                                    setEditingTemplate(t);
                                    setFormData({ name: t.name, subject: t.subject, body: t.body });
                                    setDialogOpen(true);
                                }}><Edit className="h-4 w-4" /></Button>
                                <Button variant="ghost" size="icon" className="text-destructive" onClick={() => deleteTemplate(t.id)}><Trash2 className="h-4 w-4" /></Button>
                            </div>
                        </CardHeader>
                        <CardContent>
                            <div className="text-xs text-muted-foreground mb-2">Subject: {t.subject}</div>
                            <div className="text-sm line-clamp-3 whitespace-pre-wrap">{t.body}</div>
                        </CardContent>
                    </Card>
                ))}
            </div>
        </TabsContent>

        <TabsContent value="outbox" className="space-y-4 mt-4">
            <div className="flex justify-between items-center">
                <div className="flex items-center gap-2">
                    <h2 className="text-lg font-semibold">Email Queue</h2>
                    <Badge variant="secondary">{outbox.filter(o => o.status === 'queued').length} Queued</Badge>
                </div>
                <div className="flex gap-2">
                    <Button variant="outline" size="sm" onClick={fetchOutbox}><RefreshCw className="mr-2 h-4 w-4" /> Refresh</Button>
                    <Button onClick={processQueue} disabled={outbox.filter(o => o.status === 'queued').length === 0}>
                        <Send className="mr-2 h-4 w-4" /> Process Queue
                    </Button>
                </div>
            </div>

            <Card>
                <CardContent className="p-0">
                    <ScrollArea className="h-[600px]">
                        <div className="divide-y">
                            {outbox.length === 0 ? (
                                <div className="p-8 text-center text-muted-foreground">No emails in outbox</div>
                            ) : (
                                outbox.map(item => (
                                    <div key={item.id} className="p-4 flex items-center justify-between hover:bg-muted/50">
                                        <div className="space-y-1">
                                            <div className="flex items-center gap-2">
                                                <span className="font-medium">{item.recipient_email}</span>
                                                <Badge variant={item.status === 'sent' ? 'default' : 'secondary'} className={item.status === 'sent' ? 'bg-green-500 hover:bg-green-600' : ''}>
                                                    {item.status}
                                                </Badge>
                                            </div>
                                            <p className="text-sm text-muted-foreground">{item.subject}</p>
                                        </div>
                                        <div className="text-xs text-muted-foreground flex items-center gap-4">
                                            {item.sent_at && (
                                                <span className="flex items-center gap-1">
                                                    <CheckCircle2 className="h-3 w-3 text-green-500" />
                                                    Sent {format(new Date(item.sent_at), "MMM d, h:mm a")}
                                                </span>
                                            )}
                                            <span className="flex items-center gap-1">
                                                <Clock className="h-3 w-3" />
                                                Created {format(new Date(item.created_at), "MMM d, h:mm a")}
                                            </span>
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>
                    </ScrollArea>
                </CardContent>
            </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
