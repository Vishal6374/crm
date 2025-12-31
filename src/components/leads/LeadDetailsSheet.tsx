import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Mail, Phone, Building, User, Calendar, IndianRupee, Globe, FileText, Clock } from "lucide-react";
import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
import { format } from "date-fns";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";

import { Tables, TablesInsert } from "@/integrations/supabase/types";
import { LeadWithDetails } from "@/types/app";

interface LeadDetailsSheetProps {
  lead: LeadWithDetails | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

const statusColors: Record<string, string> = {
  new: "bg-info/10 text-info",
  contacted: "bg-warning/10 text-warning",
  qualified: "bg-primary/10 text-primary",
  proposal: "bg-chart-4/10 text-chart-4",
  negotiation: "bg-chart-5/10 text-chart-5",
  won: "bg-success/10 text-success",
  lost: "bg-destructive/10 text-destructive",
};

export function LeadDetailsSheet({ lead, open, onOpenChange }: LeadDetailsSheetProps) {
  const [activities, setActivities] = useState<Tables<'activity_logs'>[]>([]);
  const [loadingActivities, setLoadingActivities] = useState(false);
  const [notes, setNotes] = useState("");
  const [addingNote, setAddingNote] = useState(false);
  const [comments, setComments] = useState<Array<{ id: string; content: string; created_at: string; author_id: string }>>([]);
  const [commentText, setCommentText] = useState("");
  const [commentMention, setCommentMention] = useState<string>("");
  const [profiles, setProfiles] = useState<Array<{ id: string; full_name: string | null; email: string | null }>>([]);

  const fetchActivities = useCallback(async () => {
    if (!lead) return;
    setLoadingActivities(true);
    const { data, error } = await supabase
      .from("activity_logs")
      .select("*")
      .eq("entity_type", "lead")
      .eq("entity_id", lead.id)
      .order("created_at", { ascending: false });

    if (!error) {
      setActivities(data || []);
    }
    setLoadingActivities(false);
  }, [lead]);

  const fetchComments = useCallback(async () => {
    if (!lead) return;
    const { data } = await supabase
      .from("messages")
      .select("*")
      .eq("entity_type", "lead")
      .eq("entity_id", lead.id)
      .order("created_at", { ascending: false });
    setComments(data || []);
  }, [lead]);

  const fetchProfiles = useCallback(async () => {
    const { data } = await supabase
      .from("profiles")
      .select("id, full_name, email")
      .order("full_name");
    setProfiles(data || []);
  }, []);

  useEffect(() => {
    if (lead?.id && open) {
      fetchActivities();
      fetchComments();
      fetchProfiles();
    }
  }, [lead?.id, open, fetchActivities, fetchComments, fetchProfiles]);

  async function postComment() {
    if (!lead) return;
    const mentions = commentMention ? [commentMention] : [];
    const commentPayload: TablesInsert<'messages'> = {
      entity_type: "lead",
      entity_id: lead.id,
      author_id: lead.user_id || null,
      content: commentText,
      mentions,
    };
    const { error } = await supabase.from("messages").insert([commentPayload]);
    if (error) return;
    const activityPayload: TablesInsert<'activity_logs'> = {
      action: "comment_added",
      entity_type: "lead",
      entity_id: lead.id,
      description: "Comment added to lead",
      user_id: lead.user_id || null,
    };
    await supabase.from("activity_logs").insert([activityPayload]);
    setCommentText("");
    setCommentMention("");
    fetchComments();
  }

  if (!lead) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px] overflow-y-auto">
        <SheetHeader className="mb-6">
          <div className="flex items-center justify-between">
            <Badge className={statusColors[lead.status] || "bg-muted"}>
              {lead.status.charAt(0).toUpperCase() + lead.status.slice(1)}
            </Badge>
            <span className="text-sm text-muted-foreground">
              Added {format(new Date(lead.created_at), "MMM d, yyyy")}
            </span>
          </div>
          <SheetTitle className="text-2xl font-bold mt-2">{lead.company_name || lead.title}</SheetTitle>
          <SheetDescription className="flex items-center gap-2 text-base">
            <User className="h-4 w-4" />
            {lead.contact_name}
          </SheetDescription>
        </SheetHeader>

        <Tabs defaultValue="details" className="w-full">
          <TabsList className="w-full">
            <TabsTrigger value="details" className="flex-1">Details</TabsTrigger>
            <TabsTrigger value="activity" className="flex-1">Activity Log</TabsTrigger>
            <TabsTrigger value="comments" className="flex-1">Comments</TabsTrigger>
          </TabsList>

          <TabsContent value="details" className="space-y-6 mt-6">
            <div className="space-y-4">
              <h3 className="font-semibold text-lg flex items-center gap-2">
                <Building className="h-5 w-5 text-muted-foreground" />
                Contact Information
              </h3>
              <div className="grid grid-cols-1 gap-4 p-4 bg-muted/30 rounded-lg">
                <div className="flex items-center gap-3">
                  <Mail className="h-4 w-4 text-muted-foreground" />
                  <a href={`mailto:${lead.email}`} className="text-primary hover:underline">
                    {lead.email || "No email provided"}
                  </a>
                </div>
                <div className="flex items-center gap-3">
                  <Phone className="h-4 w-4 text-muted-foreground" />
                  <a href={`tel:${lead.phone}`} className="hover:underline">
                    {lead.phone || "No phone provided"}
                  </a>
                </div>
                <div className="flex items-center gap-3">
                  <Globe className="h-4 w-4 text-muted-foreground" />
                  <span>{lead.source || "No source specified"}</span>
                </div>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-semibold text-lg flex items-center gap-2">
                <IndianRupee className="h-5 w-5 text-muted-foreground" />
                Deal Information
              </h3>
              <div className="grid grid-cols-2 gap-4 p-4 bg-muted/30 rounded-lg">
                <div>
                  <span className="text-sm text-muted-foreground block">Estimated Value</span>
                  <span className="font-semibold text-lg">
                    ₹{Number(lead.value || 0).toLocaleString()}
                  </span>
                </div>
                <div>
                  <span className="text-sm text-muted-foreground block">Pipeline Stage</span>
                  <span className="capitalize">{lead.status}</span>
                </div>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-semibold text-lg flex items-center gap-2">
                <FileText className="h-5 w-5 text-muted-foreground" />
                Notes
              </h3>
              <div className="p-4 bg-muted/30 rounded-lg min-h-[100px] whitespace-pre-wrap text-sm">
                {lead.notes || lead.description || "No notes added."}
              </div>
            </div>
          </TabsContent>

          <TabsContent value="activity" className="mt-6">
            <ScrollArea className="h-[calc(100vh-300px)] pr-4">
              {loadingActivities ? (
                <div className="text-center py-8 text-muted-foreground">Loading activity...</div>
              ) : activities.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">No activity recorded yet.</div>
              ) : (
                <div className="space-y-6">
                  {activities.map((activity) => (
                    <div key={activity.id} className="relative pl-6 pb-6 border-l last:border-0 last:pb-0">
                      <div className="absolute left-[-5px] top-0 h-2.5 w-2.5 rounded-full bg-primary" />
                      <div className="space-y-1">
                        <p className="text-sm font-medium leading-none">
                          {activity.description || activity.action}
                        </p>
                        <p className="text-xs text-muted-foreground flex items-center gap-1">
                          <Clock className="h-3 w-3" />
                          {format(new Date(activity.created_at), "MMM d, yyyy 'at' h:mm a")}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </ScrollArea>
          </TabsContent>
          <TabsContent value="comments" className="mt-6 space-y-4">
            <div className="space-y-3 max-h-[50vh] overflow-y-auto pr-4">
              {comments.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">No comments yet.</div>
              ) : comments.map((m) => (
                <div key={m.id} className="p-2 rounded-md bg-muted/40">
                  <div className="text-sm">{m.content}</div>
                  <div className="text-xs text-muted-foreground">{format(new Date(m.created_at), "MMM d, yyyy h:mm a")}</div>
                </div>
              ))}
            </div>
            <div className="space-y-2">
              <Label>Add a comment</Label>
              <Textarea value={commentText} onChange={(e) => setCommentText(e.target.value)} />
              <Label>Mention (optional)</Label>
              <Select value={commentMention} onValueChange={(v) => setCommentMention(v)}>
                <SelectTrigger><SelectValue placeholder="Select user to mention" /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="">None</SelectItem>
                  {profiles.map((p) => (
                    <SelectItem key={p.id} value={p.id}>{p.full_name || p.email}</SelectItem>
                  ))}
                </SelectContent>
              </Select>
              <Button onClick={postComment} disabled={!commentText.trim()}>Post</Button>
            </div>
          </TabsContent>
        </Tabs>
      </SheetContent>
    </Sheet>
  );
}
