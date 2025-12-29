import { useEffect, useState } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Plus, DollarSign, MoreHorizontal, Pencil, Trash2, CheckCircle, XCircle, MoveHorizontal, MessageSquare } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import type { Database } from "@/integrations/supabase/types";

const stages = [
  { value: "prospecting", label: "Prospecting", color: "bg-muted text-muted-foreground" },
  { value: "qualification", label: "Qualification", color: "bg-info/10 text-info" },
  { value: "proposal", label: "Proposal", color: "bg-warning/10 text-warning" },
  { value: "negotiation", label: "Negotiation", color: "bg-primary/10 text-primary" },
  { value: "closed_won", label: "Closed Won", color: "bg-success/10 text-success" },
  { value: "closed_lost", label: "Closed Lost", color: "bg-destructive/10 text-destructive" },
];

export default function DealsPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [deals, setDeals] = useState<(Database["public"]["Tables"]["deals"]["Row"] & { companies?: { name: string }, contacts?: { first_name: string, last_name: string } })[]>([]);
  const [companies, setCompanies] = useState<{ id: string; name: string }[]>([]);
  const [contacts, setContacts] = useState<{ id: string; first_name: string; last_name: string }[]>([]);
  const [loading, setLoading] = useState(true);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [commentsOpenDealId, setCommentsOpenDealId] = useState<string | null>(null);
  const [dealComments, setDealComments] = useState<Record<string, Array<{ id: string; content: string; created_at: string; author_id: string }>>>({});
  const [commentText, setCommentText] = useState("");
  const [commentMention, setCommentMention] = useState<string>("");
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    value: "",
    stage: "prospecting",
    probability: "50",
    company_id: "",
    contact_id: "",
    expected_close_date: "",
  });

  useEffect(() => {
    fetchDeals();
    fetchCompanies();
    fetchContacts();
  }, []);

  async function fetchDeals() {
    const { data, error } = await supabase
      .from("deals")
      .select("*, companies(name), contacts(first_name, last_name)")
      .order("created_at", { ascending: false });
    if (!error) setDeals(data || []);
    setLoading(false);
  }

  async function fetchCompanies() {
    const { data } = await supabase.from("companies").select("id, name").order("name");
    if (data) setCompanies(data);
  }

  async function fetchContacts() {
    const { data } = await supabase.from("contacts").select("id, first_name, last_name").order("first_name");
    if (data) setContacts(data);
  }

  async function createDeal(e: React.FormEvent) {
    e.preventDefault();
    const { error } = await supabase.from("deals").insert([{
      title: formData.title,
      description: formData.description,
      value: parseFloat(formData.value) || 0,
      stage: formData.stage as "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost",
      probability: parseInt(formData.probability) || 50,
      company_id: formData.company_id || null,
      contact_id: formData.contact_id || null,
      expected_close_date: formData.expected_close_date || null,
      created_by: user?.id,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Deal created successfully" });
      setDialogOpen(false);
      setFormData({ title: "", description: "", value: "", stage: "prospecting", probability: "50", company_id: "", contact_id: "", expected_close_date: "" });
      fetchDeals();
    }
  }

  const dealsByStage = stages.map((stage) => ({
    ...stage,
    deals: deals.filter((d) => d.stage === stage.value),
    total: deals.filter((d) => d.stage === stage.value).reduce((sum, d) => sum + Number(d.value || 0), 0),
  }));

  async function updateDealStage(deal: Database["public"]["Tables"]["deals"]["Row"], stage: string) {
    const { error } = await supabase.from("deals").update({ stage }).eq("id", deal.id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    if (["proposal", "negotiation"].includes(stage)) {
      await supabase.from("tasks").insert([{
        title: `Follow-up: ${stage} for ${deal.title}`,
        description: `Automated task created when deal moved to ${stage}`,
        priority: "medium",
        status: "todo",
        due_date: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString().split("T")[0],
        created_by: user?.id || "",
        deal_id: deal.id,
      }]);
      await supabase.from("activity_logs").insert([{
        action: "deal_stage_changed",
        entity_type: "deal",
        entity_id: deal.id,
        description: `Stage set to ${stage} and follow-up task created`,
        user_id: user?.id || null,
      }]);
    } else if (["closed_won", "closed_lost"].includes(stage)) {
      await supabase.from("activity_logs").insert([{
        action: stage === "closed_won" ? "deal_won" : "deal_lost",
        entity_type: "deal",
        entity_id: deal.id,
        description: `Deal marked ${stage}`,
        user_id: user?.id || null,
      }]);
    }
    fetchDeals();
  }

  async function fetchDealMessages(dealId: string) {
    const { data } = await supabase
      .from("messages")
      .select("id, content, created_at, author_id")
      .eq("entity_type", "deal")
      .eq("entity_id", dealId)
      .order("created_at", { ascending: false });
    const map = { ...dealComments };
    map[dealId] = (data || []) as Array<{ id: string; content: string; created_at: string; author_id: string }>;
    setDealComments(map);
  }

  async function postDealMessage(dealId: string) {
    const mentions = commentMention ? [commentMention] : [];
    const { error } = await supabase.from("messages").insert([{
      entity_type: "deal",
      entity_id: dealId,
      author_id: user?.id || "",
      content: commentText,
      mentions,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    await supabase.from("activity_logs").insert([{
      action: "comment_added",
      entity_type: "deal",
      entity_id: dealId,
      description: "Comment added to deal",
      user_id: user?.id || null,
    }]);
    setCommentText("");
    setCommentMention("");
    fetchDealMessages(dealId);
  }

  async function deleteDeal(id: string) {
    if (!confirm("Delete this deal?")) return;
    const { error } = await supabase.from("deals").delete().eq("id", id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    fetchDeals();
  }

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Deals</h1>
          <p className="page-description">Track your sales pipeline</p>
        </div>
        <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
          <DialogTrigger asChild>
            <Button><Plus className="mr-2 h-4 w-4" />New Deal</Button>
          </DialogTrigger>
          <DialogContent className="max-w-lg">
            <DialogHeader><DialogTitle>Create New Deal</DialogTitle></DialogHeader>
            <form onSubmit={createDeal} className="space-y-4">
              <div><Label>Deal Title</Label><Input value={formData.title} onChange={(e) => setFormData({ ...formData, title: e.target.value })} required /></div>
              <div><Label>Description</Label><Textarea value={formData.description} onChange={(e) => setFormData({ ...formData, description: e.target.value })} /></div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>Value ($)</Label><Input type="number" value={formData.value} onChange={(e) => setFormData({ ...formData, value: e.target.value })} /></div>
                <div><Label>Probability (%)</Label><Input type="number" min="0" max="100" value={formData.probability} onChange={(e) => setFormData({ ...formData, probability: e.target.value })} /></div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Stage</Label>
                  <Select value={formData.stage} onValueChange={(v) => setFormData({ ...formData, stage: v })}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>{stages.map((s) => <SelectItem key={s.value} value={s.value}>{s.label}</SelectItem>)}</SelectContent>
                  </Select>
                </div>
                <div><Label>Expected Close</Label><Input type="date" value={formData.expected_close_date} onChange={(e) => setFormData({ ...formData, expected_close_date: e.target.value })} /></div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Company</Label>
                  <Select value={formData.company_id} onValueChange={(v) => setFormData({ ...formData, company_id: v })}>
                    <SelectTrigger><SelectValue placeholder="Select company" /></SelectTrigger>
                    <SelectContent>{companies.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}</SelectContent>
                  </Select>
                </div>
                <div>
                  <Label>Contact</Label>
                  <Select value={formData.contact_id} onValueChange={(v) => setFormData({ ...formData, contact_id: v })}>
                    <SelectTrigger><SelectValue placeholder="Select contact" /></SelectTrigger>
                    <SelectContent>{contacts.map((c) => <SelectItem key={c.id} value={c.id}>{c.first_name} {c.last_name}</SelectItem>)}</SelectContent>
                  </Select>
                </div>
              </div>
              <Button type="submit" className="w-full">Create Deal</Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {loading ? (
        <p className="text-muted-foreground text-center py-8">Loading...</p>
      ) : (
        <div className="overflow-x-auto">
          <div className="flex gap-4 px-1 pb-2">
            {dealsByStage.map((stage) => (
              <div
                key={stage.value}
                className="w-72 flex-shrink-0 rounded-lg border bg-muted/30"
                onDragOver={(e) => e.preventDefault()}
                onDrop={(e) => {
                  const dealId = e.dataTransfer.getData("dealId");
                  if (!dealId) return;
                  const deal = deals.find((d) => d.id === dealId);
                  if (deal) updateDealStage(deal, stage.value);
                }}
              >
                <div className="sticky top-0 z-10 p-3 border-b bg-card/80 backdrop-blur">
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium">{stage.label}</span>
                    <Badge variant="secondary">{stage.deals.length}</Badge>
                  </div>
                  <p className="text-xs text-muted-foreground flex items-center gap-1 mt-1">
                    <DollarSign className="h-3 w-3" />{stage.total.toLocaleString()}
                  </p>
                </div>
                <div className="p-2 space-y-2">
                  {stage.deals.length === 0 ? (
                    <p className="text-xs text-muted-foreground text-center py-4">No deals</p>
                  ) : (
                    stage.deals.map((deal) => (
                      <Card key={deal.id} className="bg-card shadow-sm" draggable onDragStart={(e) => e.dataTransfer.setData("dealId", deal.id as string)}>
                        <CardContent className="p-3">
                          <div className="flex items-start justify-between gap-2">
                            <div className="min-w-0">
                              <h4 className="font-medium text-sm truncate">{deal.title}</h4>
                              <p className="text-xs text-muted-foreground">${Number(deal.value || 0).toLocaleString()}</p>
                              {deal.companies?.name && <p className="text-xs text-muted-foreground mt-1">{deal.companies.name}</p>}
                            </div>
                            <DropdownMenu>
                              <DropdownMenuTrigger asChild>
                                <Button variant="ghost" size="icon"><MoreHorizontal className="h-4 w-4" /></Button>
                              </DropdownMenuTrigger>
                              <DropdownMenuContent align="end">
                                <DropdownMenuItem onClick={() => updateDealStage(deal, "qualification")}>
                                  <MoveHorizontal className="mr-2 h-4 w-4" /> Move to Qualification
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => updateDealStage(deal, "proposal")}>
                                  <MoveHorizontal className="mr-2 h-4 w-4" /> Move to Proposal
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => updateDealStage(deal, "negotiation")}>
                                  <MoveHorizontal className="mr-2 h-4 w-4" /> Move to Negotiation
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => updateDealStage(deal, "closed_won")}>
                                  <CheckCircle className="mr-2 h-4 w-4 text-success" /> Mark Won
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => updateDealStage(deal, "closed_lost")}>
                                  <XCircle className="mr-2 h-4 w-4 text-destructive" /> Mark Lost
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => deleteDeal(deal.id)}>
                                  <Trash2 className="mr-2 h-4 w-4" /> Delete
                                </DropdownMenuItem>
                                <DropdownMenuItem onClick={() => { setCommentsOpenDealId(deal.id as string); fetchDealMessages(deal.id as string); }}>
                                  <MessageSquare className="mr-2 h-4 w-4" /> Comments
                                </DropdownMenuItem>
                              </DropdownMenuContent>
                            </DropdownMenu>
                          </div>
                        </CardContent>
                      </Card>
                    ))
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      <Dialog open={!!commentsOpenDealId} onOpenChange={(open) => {
        setCommentsOpenDealId(open ? commentsOpenDealId : null);
        if (!open) { setCommentText(""); setCommentMention(""); }
      }}>
        <DialogContent>
          <DialogHeader><DialogTitle>Deal Comments</DialogTitle></DialogHeader>
          <div className="space-y-3 max-h-[50vh] overflow-y-auto">
            {(commentsOpenDealId ? (dealComments[commentsOpenDealId] || []) : []).map((m) => (
              <div key={m.id} className="p-2 rounded-md bg-muted/40">
                <div className="text-sm">{m.content}</div>
                <div className="text-xs text-muted-foreground">{new Date(m.created_at).toLocaleString()}</div>
              </div>
            ))}
          </div>
          <div className="space-y-2">
            <Label>Add a comment</Label>
            <Textarea value={commentText} onChange={(e) => setCommentText(e.target.value)} />
            <Label>Mention (optional)</Label>
            <Select value={commentMention} onValueChange={(v) => setCommentMention(v)}>
              <SelectTrigger><SelectValue placeholder="Select contact to mention" /></SelectTrigger>
              <SelectContent>
                <SelectItem value="">None</SelectItem>
                {contacts.map((c) => (
                  <SelectItem key={c.id} value={c.id}>{c.first_name} {c.last_name}</SelectItem>
                ))}
              </SelectContent>
            </Select>
            <Button onClick={() => commentsOpenDealId && postDealMessage(commentsOpenDealId)} disabled={!commentText.trim()}>Post</Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
