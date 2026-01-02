import { useEffect, useState, useCallback } from "react";
import { Button } from "@/components/ui/button";
import { Plus, LayoutList, LayoutGrid, Download, Upload, Trash2, CheckCircle } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { LeadForm } from "@/components/leads/LeadForm";
import { LeadFilters } from "@/components/leads/LeadFilters";
import { LeadsTable } from "@/components/leads/LeadsTable";
import { LeadsKanban } from "@/components/leads/LeadsKanban";
import { LeadDetailsSheet } from "@/components/leads/LeadDetailsSheet";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from "@/components/ui/dialog";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Label } from "@/components/ui/label";

import { Tables } from "@/integrations/supabase/types";
import { usePermissions } from "@/hooks/use-permissions";
import * as XLSX from "xlsx";

export default function LeadsPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const { can, role } = usePermissions();
  const [leads, setLeads] = useState<Tables<'leads'>[]>([]);
  const [loading, setLoading] = useState(true);
  const [viewMode, setViewMode] = useState<"table" | "kanban">("table");
  
  // Filters
  const [search, setSearch] = useState("");
  const [statusFilter, setStatusFilter] = useState("all");
  const [sourceFilter, setSourceFilter] = useState("all");
  const [dateFilter, setDateFilter] = useState("all");

  // Selection
  const [selectedLeads, setSelectedLeads] = useState<Set<string>>(new Set());
  
  // Dialogs
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [editingLead, setEditingLead] = useState<Tables<'leads'> | null>(null);
  const [selectedLeadForDetails, setSelectedLeadForDetails] = useState<Tables<'leads'> | null>(null);
  const [isDetailsOpen, setIsDetailsOpen] = useState(false);
  const [isBulkActionOpen, setIsBulkActionOpen] = useState(false);
  const [bulkActionType, setBulkActionType] = useState<"delete" | "status" | null>(null);
  const [bulkStatus, setBulkStatus] = useState("new");
  const [isExportOpen, setIsExportOpen] = useState(false);
  const [exportFormat, setExportFormat] = useState<"csv" | "xlsx">("csv");
  const [exportScope, setExportScope] = useState<"selected" | "filtered">("selected");
  const [isImportOpen, setIsImportOpen] = useState(false);
  const [importFile, setImportFile] = useState<File | null>(null);


  //   useEffect(() => {
//     const debugOrg = async () => {
//       const { data, error } = await supabase.rpc("current_org_id");

//       console.log("current_org_id:", data);
//       console.log("error:", error);
//       const {
//   data: { user },
// } = await supabase.auth.getUser();

// console.log(supabase.rpc("current_org_id"));
//     };

  //   debugOrg();
  // }, []);
  const fetchLeads = useCallback(async () => {
    setLoading(true);
    let query = supabase.from("leads").select("*").order("created_at", { ascending: false });
    if (role === "manager" && user?.id) {
      query = query.eq("user_id", user.id);
    } else if (role === "employee" && user?.id) {
      query = query.eq("assigned_to", user.id);
    }
    const { data: leadsData, error } = await query;
    
    if (error || !leadsData) {
      setLeads([]);
      setLoading(false);
      return;
    }

    const { data: profiles } = await supabase.from("profiles").select("id, full_name");

    const joinedLeads = leadsData.map(lead => ({
      ...lead,
      assigned_to_profile: profiles?.find(p => p.id === lead.assigned_to) || undefined
    }));

    setLeads(joinedLeads);
    setLoading(false);
  }, [role, user?.id]);

  useEffect(() => {
    fetchLeads();
  }, [fetchLeads]);


  const filteredLeads = leads.filter((lead) => {
    const matchesSearch = 
      (lead.company_name?.toLowerCase() || lead.title?.toLowerCase() || "").includes(search.toLowerCase()) || 
      (lead.contact_name?.toLowerCase() || "").includes(search.toLowerCase()) || 
      (lead.email?.toLowerCase() || "").includes(search.toLowerCase());
    
    const matchesStatus = statusFilter === "all" || lead.status === statusFilter;
    const matchesSource = sourceFilter === "all" || lead.source === sourceFilter;
    
    let matchesDate = true;
    if (dateFilter !== "all") {
      const date = new Date(lead.created_at);
      const now = new Date();
      if (dateFilter === "today") {
        matchesDate = date.toDateString() === now.toDateString();
      } else if (dateFilter === "week") {
        const weekAgo = new Date();
        weekAgo.setDate(now.getDate() - 7);
        matchesDate = date >= weekAgo;
      } else if (dateFilter === "month") {
        matchesDate = date.getMonth() === now.getMonth() && date.getFullYear() === now.getFullYear();
      }
    }

    return matchesSearch && matchesStatus && matchesSource && matchesDate;
  });

  const handleSelectLead = (id: string, checked: boolean) => {
    const newSelected = new Set(selectedLeads);
    if (checked) newSelected.add(id);
    else newSelected.delete(id);
    setSelectedLeads(newSelected);
  };

  const handleSelectAll = (checked: boolean) => {
    if (checked) {
      setSelectedLeads(new Set(filteredLeads.map(l => l.id)));
    } else {
      setSelectedLeads(new Set());
    }
  };

  const handleCreate = () => {
    setEditingLead(null);
    setIsFormOpen(true);
  };

  const handleEdit = (lead: Tables<'leads'>) => {
    setEditingLead(lead);
    setIsFormOpen(true);
  };

  const handleView = (lead: Tables<'leads'>) => {
    setSelectedLeadForDetails(lead);
    setIsDetailsOpen(true);
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this lead?")) return;
    
    const { error } = await supabase.from("leads").delete().eq("id", id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      await supabase.from("activity_logs").insert([{
        action: "deleted_lead",
        entity_type: "lead",
        entity_id: id,
        description: "Deleted lead",
        user_id: user?.id,
      }]);
      toast({ title: "Lead deleted successfully" });
      fetchLeads();
    }
  };

  const handleAssign = async (leadId: string, userId: string) => {
    const { error } = await supabase.from("leads").update({ assigned_to: userId }).eq("id", leadId);
    
    if (error) {
      toast({ title: "Error assigning lead", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Lead assigned successfully" });
      
      if (userId !== user?.id) {
         sendDirectMessage(user?.id || "", userId, `You have been assigned to lead #${leadId}`);
      }

      await supabase.from("activity_logs").insert([{
        action: "assigned_lead",
        entity_type: "lead",
        entity_id: leadId,
        description: `Lead assigned to user ${userId}`,
        user_id: user?.id
      }]);
      
      fetchLeads();
    }
  };

  const updateLeadStage = async (leadId: string, status: string) => {
    const prevLeads = [...leads];
    setLeads((ls) => ls.map((l) => (l.id === leadId ? { ...l, status } : l)));
    const { error } = await supabase.from("leads").update({ status }).eq("id", leadId);
    if (error) {
      setLeads(prevLeads);
      toast({ title: "Error updating status", description: error.message, variant: "destructive" });
      return;
    }
    await supabase.from("activity_logs").insert([{
      action: "lead_status_changed",
      entity_type: "lead",
      entity_id: leadId,
      description: `Lead moved to ${status}`,
      user_id: user?.id || null
    }]);
  };

  const handleConvert = async (lead: Tables<'leads'>) => {
    // 1. Create Contact
    const { data: contact, error: contactError } = await supabase.from("contacts").insert([{
      first_name: lead.contact_name ? lead.contact_name.split(' ')[0] : (lead.title || "Unknown"),
      last_name: lead.contact_name ? lead.contact_name.split(' ').slice(1).join(' ') : "",
      email: lead.email,
      phone: lead.phone,
      notes: `Converted from Lead: ${lead.company_name || lead.title}. \n${lead.notes || ""}`,
      created_by: user?.id,
      company_id: lead.company_id // If we had this mapped
    }]).select().single();

    if (contactError) {
      toast({ title: "Error converting lead", description: contactError.message, variant: "destructive" });
      return;
    }

    // 2. Update Lead Status
    await supabase.from("leads").update({ status: "qualified", contact_id: contact.id }).eq("id", lead.id);

    // 3. Log Activity
    await supabase.from("activity_logs").insert([{
      action: "converted_to_contact",
      entity_type: "lead",
      entity_id: lead.id,
      description: `Lead converted to contact #${contact.id}`,
      user_id: user?.id
    }]);

    toast({ title: "Lead converted to contact successfully" });
    fetchLeads();
  };

  const handleBulkAction = async () => {
    const leadIds = Array.from(selectedLeads);
    if (leadIds.length === 0) return;

    if (bulkActionType === "delete") {
      await supabase.from("leads").delete().in("id", leadIds);
      toast({ title: `${leadIds.length} leads deleted` });
    } else if (bulkActionType === "status") {
      await supabase.from("leads").update({ status: bulkStatus }).in("id", leadIds);
      toast({ title: `${leadIds.length} leads updated` });
    }

    setSelectedLeads(new Set());
    setIsBulkActionOpen(false);
    fetchLeads();
  };

  const openExportDialog = () => setIsExportOpen(true);

  const performExport = () => {
    const scopeIds = exportScope === "selected" ? Array.from(selectedLeads) : filteredLeads.map(l => l.id);
    const rows = (exportScope === "selected" ? filteredLeads.filter(l => scopeIds.includes(l.id)) : filteredLeads).map(lead => ({
      Company: lead.company_name || lead.title || "",
      Contact: lead.contact_name || "",
      Email: lead.email || "",
      Phone: lead.phone || "",
      Status: lead.status,
      Source: lead.source || "",
      Value: Number(lead.value || 0),
      Notes: lead.notes || "",
      CreatedAt: new Date(lead.created_at).toLocaleDateString(),
    }));

    if (exportFormat === "csv") {
      const headers = Object.keys(rows[0] || { Company: "", Contact: "", Email: "", Phone: "", Status: "", Source: "", Value: "", Notes: "", CreatedAt: "" });
      const csvContent = [
        headers.join(","),
        ...rows.map(r => headers.map(h => {
          const value = (r as Record<string, unknown>)[h];
          return `"${String(value ?? "").replace(/"/g, '""')}"`;
        }).join(",")),
      ].join("\n");
      const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
      const link = document.createElement("a");
      link.href = URL.createObjectURL(blob);
      link.download = `leads_export_${new Date().toISOString().split('T')[0]}.csv`;
      link.click();
    } else {
      const ws = XLSX.utils.json_to_sheet(rows);
      const wb = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(wb, ws, "Leads");
      XLSX.writeFile(wb, `leads_export_${new Date().toISOString().split('T')[0]}.xlsx`);
    }
    setIsExportOpen(false);
  };

  const performImport = async () => {
    if (!importFile) return;
    try {
      const ext = importFile.name.toLowerCase().split(".").pop();
      if (ext === "csv") {
        const text = await importFile.text();
        const lines = text.split(/\r?\n/).filter(l => l.trim().length > 0);
        const headers = lines[0].split(",").map(h => h.trim().toLowerCase().replace(/\s+/g, "_"));
        const records = lines.slice(1).map(line => {
          const cols = line.split(",");
          const obj: Record<string, string> = {};
          headers.forEach((h, i) => { obj[h] = (cols[i] || "").replace(/^"|"$/g, ""); });
          return obj;
        });
        await insertLeads(records);
      } else {
        const data = await importFile.arrayBuffer();
        const wb = XLSX.read(data, { type: "array" });
        const firstSheet = wb.SheetNames[0];
        const sheet = wb.Sheets[firstSheet];
        const records = XLSX.utils.sheet_to_json(sheet) as Record<string, unknown>[];
        await insertLeads(records);
      }
      toast({ title: "Leads imported successfully" });
      setIsImportOpen(false);
      setImportFile(null);
      fetchLeads();
    } catch (e) {
      toast({ title: "Import failed", description: e instanceof Error ? e.message : "Unable to import file", variant: "destructive" });
    }
  };

  const insertLeads = async (rows: Record<string, unknown>[]) => {
    const normalize = (v: unknown) => (v === undefined || v === null) ? "" : String(v);
    const payloads = rows.map(r => {
      const company = normalize(r.company) || normalize(r.company_name) || normalize(r["Company"]) || normalize(r["Company Name"]) || normalize(r.title);
      const contact = normalize(r.contact) || normalize(r.contact_name) || normalize(r["Contact"]);
      const email = normalize(r.email) || normalize(r["Email"]);
      const phone = normalize(r.phone) || normalize(r["Phone"]);
      const status = (normalize(r.status) || normalize(r["Status"]) || "new").toLowerCase();
      const source = normalize(r.source) || normalize(r["Source"]);
      const notes = normalize(r.notes) || normalize(r["Notes"]);
      const valueStr = normalize(r.value) || normalize(r["Value"]);
      const valueNum = valueStr ? parseFloat(valueStr.replace(/[^0-9.-]/g, "")) : 0;
      return {
        company_name: company || null,
        contact_name: contact || null,
        email: email || null,
        phone: phone || null,
        status: ["new","contacted","qualified","proposal","negotiation","won","lost"].includes(status) ? status : "new",
        source: source || null,
        notes: notes || null,
        description: notes || null,
        value: valueNum,
        created_by: user?.id || null,
      };
    });
    if (payloads.length > 0) {
      const { error } = await supabase.from("leads").insert(payloads);
      if (error) throw error;
    }
  };

  if (loading) {
    return <div className="flex items-center justify-center py-12 text-muted-foreground">Loading leads...</div>;
  }

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div>
          <h1 className="page-title">Leads</h1>
          <p className="page-description">Manage your sales leads pipeline</p>
        </div>
        <div className="flex gap-2">
          {selectedLeads.size > 0 && can("leads", "can_edit") && (
            <>
              <Button variant="outline" onClick={() => { setBulkActionType("status"); setIsBulkActionOpen(true); }}>
                <CheckCircle className="mr-2 h-4 w-4" /> Update Status
              </Button>
              <Button variant="destructive" onClick={() => { setBulkActionType("delete"); setIsBulkActionOpen(true); }}>
                <Trash2 className="mr-2 h-4 w-4" /> Delete ({selectedLeads.size})
              </Button>
            </>
          )}
          <Button variant="outline" onClick={openExportDialog}>
            <Download className="mr-2 h-4 w-4" /> Export
          </Button>
          <Button variant="outline" onClick={() => setIsImportOpen(true)}>
            <Upload className="mr-2 h-4 w-4" /> Import
          </Button>
          <Button 
            variant="outline"
            size="icon" 
            onClick={() => setViewMode(viewMode === "table" ? "kanban" : "table")}
            title="Toggle View"
          >
            {viewMode === "table" ? <LayoutGrid className="h-4 w-4" /> : <LayoutList className="h-4 w-4" />}
          </Button>
          {can("leads", "can_create") && (
          <Button onClick={handleCreate}>
            <Plus className="mr-2 h-4 w-4" /> New Lead
          </Button>
          )}
        </div>
      </div>

      <LeadFilters 
        search={search} onSearchChange={setSearch}
        statusFilter={statusFilter} onStatusFilterChange={setStatusFilter}
        sourceFilter={sourceFilter} onSourceFilterChange={setSourceFilter}
        dateFilter={dateFilter} onDateFilterChange={setDateFilter}
      />

      {viewMode === "table" ? (
        <LeadsTable 
          leads={filteredLeads}
          selectedLeads={selectedLeads}
          onSelectLead={handleSelectLead}
          onSelectAll={handleSelectAll}
          onEdit={can("leads", "can_edit") ? handleEdit : undefined}
          onDelete={can("leads", "can_edit") ? handleDelete : undefined}
          onConvert={can("leads", "can_edit") ? handleConvert : undefined}
          onView={handleView}
        />
      ) : (
        <LeadsKanban 
          leads={filteredLeads}
          onEdit={can("leads", "can_edit") ? handleEdit : undefined}
          onDelete={can("leads", "can_edit") ? handleDelete : undefined}
          onConvert={can("leads", "can_edit") ? handleConvert : undefined}
          onView={handleView}
          onUpdateStatus={can("leads", "can_edit") ? (leadId, status) => updateLeadStage(leadId, status) : undefined}
        />
      )}

      <LeadForm 
        open={isFormOpen} 
        onOpenChange={setIsFormOpen} 
        onSuccess={fetchLeads} 
        initialData={editingLead} 
      />

      <LeadDetailsSheet 
        lead={selectedLeadForDetails} 
        open={isDetailsOpen} 
        onOpenChange={setIsDetailsOpen} 
      />

      {can("leads", "can_edit") && (
      <Dialog open={isBulkActionOpen} onOpenChange={setIsBulkActionOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Bulk {bulkActionType === "delete" ? "Delete" : "Update"}</DialogTitle>
          </DialogHeader>
          {bulkActionType === "delete" ? (
            <p>Are you sure you want to delete {selectedLeads.size} leads? This action cannot be undone.</p>
          ) : (
            <div className="space-y-4">
              <Label>New Status</Label>
              <Select value={bulkStatus} onValueChange={setBulkStatus}>
                <SelectTrigger>
                  <SelectValue />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="new">New</SelectItem>
                  <SelectItem value="contacted">Contacted</SelectItem>
                  <SelectItem value="qualified">Qualified</SelectItem>
                  <SelectItem value="proposal">Proposal</SelectItem>
                  <SelectItem value="negotiation">Negotiation</SelectItem>
                  <SelectItem value="won">Won</SelectItem>
                  <SelectItem value="lost">Lost</SelectItem>
                </SelectContent>
              </Select>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsBulkActionOpen(false)}>Cancel</Button>
            <Button variant={bulkActionType === "delete" ? "destructive" : "default"} onClick={handleBulkAction}>
              Confirm
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
      )}

      <Dialog open={isExportOpen} onOpenChange={setIsExportOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Export Leads</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <div className="space-y-2">
              <Label>Format</Label>
              <Select value={exportFormat} onValueChange={(v) => setExportFormat(v as "csv" | "xlsx")}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="csv">CSV</SelectItem>
                  <SelectItem value="xlsx">Excel (.xlsx)</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Scope</Label>
              <Select value={exportScope} onValueChange={(v) => setExportScope(v as "selected" | "filtered")}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="selected">Selected only</SelectItem>
                  <SelectItem value="filtered">All filtered</SelectItem>
                </SelectContent>
              </Select>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setIsExportOpen(false)}>Cancel</Button>
            <Button onClick={performExport}>Export</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={isImportOpen} onOpenChange={setIsImportOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Import Leads</DialogTitle>
          </DialogHeader>
          <div className="space-y-4">
            <input
              type="file"
              accept=".csv, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, .xlsx"
              onChange={(e) => setImportFile(e.target.files?.[0] || null)}
            />
            <p className="text-sm text-muted-foreground">Supported: CSV or Excel (.xlsx). Columns: Company, Contact, Email, Phone, Status, Source, Value, Notes.</p>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setIsImportOpen(false); setImportFile(null); }}>Cancel</Button>
            <Button onClick={performImport} disabled={!importFile}>Import</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
