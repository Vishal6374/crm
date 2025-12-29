import { useEffect, useState, useCallback } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Plus, Search, Calendar, CheckCircle2, Circle, Pencil, User, Link, UserPlus, X } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import { Checkbox } from "@/components/ui/checkbox";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import type { Tables } from "@/integrations/supabase/types";

const priorityColors: Record<string, string> = {
  low: "bg-muted text-muted-foreground",
  medium: "bg-info/10 text-info",
  high: "bg-warning/10 text-warning",
  urgent: "bg-destructive/10 text-destructive",
};

type Task = Tables<"tasks"> & {
  lead_id?: string | null
  deal_id?: string | null
};
type ProfileSummary = Pick<Tables<"profiles">, "id" | "full_name" | "email">;
type LeadSummary = { id: string; title?: string | null; company_name?: string | null };
type DealSummary = { id: string; title: string; value?: number | null };

export default function TasksPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const [tasks, setTasks] = useState<Task[]>([]);
  const [profiles, setProfiles] = useState<ProfileSummary[]>([]);
  const [leads, setLeads] = useState<LeadSummary[]>([]);
  const [deals, setDeals] = useState<DealSummary[]>([]);
  const [taskCollaborators, setTaskCollaborators] = useState<Record<string, string[]>>({});
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [commentsOpenTaskId, setCommentsOpenTaskId] = useState<string | null>(null);
  const [taskComments, setTaskComments] = useState<Record<string, Array<{ id: string; content: string; created_at: string; author_id: string }>>>({});
  const [commentText, setCommentText] = useState("");
  const [commentMention, setCommentMention] = useState<string>("");
  const [formData, setFormData] = useState({
    title: "",
    description: "",
    priority: "medium",
    status: "todo",
    due_date: "",
    assigned_to: "",
    lead_id: "",
    deal_id: "",
  });

  const fetchTaskCollaborators = useCallback(async (taskIds: string[]) => {
    const { data, error } = await supabase
      .from("task_collaborators")
      .select("task_id, user_id")
      .in("task_id", taskIds);
    if (error) return;
    const map: Record<string, string[]> = {};
    (data || []).forEach((row) => {
      const t = (row as { task_id: string; user_id: string }).task_id;
      const u = (row as { task_id: string; user_id: string }).user_id;
      if (!map[t]) map[t] = [];
      map[t].push(u);
    });
    setTaskCollaborators(map);
  }, []);

  const fetchTasks = useCallback(async () => {
    const { data, error } = await supabase
      .from("tasks")
      .select("*")
      .order("created_at", { ascending: false });
    if (!error) setTasks(data || []);
    setLoading(false);
    if (data && data.length) {
      await fetchTaskCollaborators(data.map((t) => t.id as string));
    } else {
      setTaskCollaborators({});
    }
  }, [fetchTaskCollaborators]);

  const fetchProfiles = useCallback(async () => {
    const { data } = await supabase
      .from("profiles")
      .select("id, full_name, email")
      .order("full_name");
    if (data) setProfiles(data);
  }, []);

  const fetchLeads = useCallback(async () => {
    const { data } = await supabase
      .from("leads")
      .select("id, title, company_name")
      .order("created_at", { ascending: false })
      .limit(100);
    if (data) setLeads(data);
  }, []);

  const fetchDeals = useCallback(async () => {
    const { data } = await supabase
      .from("deals")
      .select("id, title, value")
      .order("created_at", { ascending: false })
      .limit(100);
    if (data) setDeals(data);
  }, []);

  useEffect(() => {
    fetchTasks();
    fetchProfiles();
    fetchLeads();
    fetchDeals();
  }, [fetchTasks, fetchProfiles, fetchLeads, fetchDeals]);

  async function createTask(e: React.FormEvent) {
    e.preventDefault();
    const { error } = await supabase.from("tasks").insert([{
      title: formData.title,
      description: formData.description,
      priority: formData.priority as "low" | "medium" | "high" | "urgent",
      status: formData.status as "todo" | "in_progress" | "completed" | "cancelled",
      due_date: formData.due_date || null,
      assigned_to: formData.assigned_to || null,
      lead_id: formData.lead_id || null,
      deal_id: formData.deal_id || null,
      created_by: user?.id,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Task created successfully" });
      setDialogOpen(false);
      setFormData({ title: "", description: "", priority: "medium", status: "todo", due_date: "", assigned_to: "", lead_id: "", deal_id: "" });
      setEditingId(null);
      fetchTasks();
    }
  }

  async function updateTask(e: React.FormEvent) {
    e.preventDefault();
    if (!editingId) return;
    const { error } = await supabase
      .from("tasks")
      .update({
        title: formData.title,
        description: formData.description,
        priority: formData.priority as "low" | "medium" | "high" | "urgent",
        status: formData.status as "todo" | "in_progress" | "completed" | "cancelled",
        due_date: formData.due_date || null,
        assigned_to: formData.assigned_to || null,
        lead_id: formData.lead_id || null,
        deal_id: formData.deal_id || null,
      })
      .eq("id", editingId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Task updated successfully" });
      setDialogOpen(false);
      setFormData({ title: "", description: "", priority: "medium", status: "todo", due_date: "", assigned_to: "", lead_id: "", deal_id: "" });
      setEditingId(null);
      fetchTasks();
    }
  }

  async function toggleTaskStatus(task: Task) {
    const newStatus = task.status === "completed" ? "todo" : "completed";
    const { error } = await supabase
      .from("tasks")
      .update({ status: newStatus, completed_at: newStatus === "completed" ? new Date().toISOString() : null })
      .eq("id", task.id);
    if (!error) fetchTasks();
  }

  async function assignTask(taskId: string, userId: string) {
    const { error } = await supabase
      .from("tasks")
      .update({ assigned_to: userId || null })
      .eq("id", taskId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      await supabase.from("task_timings").upsert([{ task_id: taskId, assigned_at: new Date().toISOString() }], { onConflict: "task_id" });
      await supabase.from("activity_logs").insert([{
        action: "task_reassigned",
        entity_type: "task",
        entity_id: taskId,
        description: "Task owner reassigned",
        user_id: user?.id || null,
      }]);
      toast({ title: "Task reassigned" });
      fetchTasks();
    }
  }

  async function startTask(task: Task) {
    const { error } = await supabase
      .from("tasks")
      .update({ status: "in_progress" })
      .eq("id", task.id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    await supabase.from("task_timings").upsert([{ task_id: task.id as string, started_at: new Date().toISOString() }], { onConflict: "task_id" });
    await supabase.from("activity_logs").insert([{
      action: "task_started",
      entity_type: "task",
      entity_id: task.id,
      description: "Task marked in progress",
      user_id: user?.id || null,
    }]);
    fetchTasks();
  }

  async function completeTask(task: Task) {
    const now = new Date();
    const { data: timing } = await supabase
      .from("task_timings")
      .select("started_at")
      .eq("task_id", task.id)
      .maybeSingle();
    const startedAt = timing?.started_at ? new Date(timing.started_at) : null;
    const totalSeconds = startedAt ? Math.max(0, Math.floor((now.getTime() - startedAt.getTime()) / 1000)) : null;
    const { error } = await supabase
      .from("tasks")
      .update({ status: "completed", completed_at: now.toISOString() })
      .eq("id", task.id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    await supabase.from("task_timings").upsert([{
      task_id: task.id as string,
      completed_at: now.toISOString(),
      total_seconds: totalSeconds ?? null,
    }], { onConflict: "task_id" });
    await supabase.from("activity_logs").insert([{
      action: "task_completed",
      entity_type: "task",
      entity_id: task.id,
      description: "Task marked completed",
      user_id: user?.id || null,
    }]);
    fetchTasks();
  }

  async function fetchTaskMessages(taskId: string) {
    const { data } = await supabase
      .from("messages")
      .select("id, content, created_at, author_id")
      .eq("entity_type", "task")
      .eq("entity_id", taskId)
      .order("created_at", { ascending: false });
    const map = { ...taskComments };
    map[taskId] = (data || []) as Array<{ id: string; content: string; created_at: string; author_id: string }>;
    setTaskComments(map);
  }

  async function postTaskMessage(taskId: string) {
    const mentions = commentMention ? [commentMention] : [];
    const { error } = await supabase.from("messages").insert([{
      entity_type: "task",
      entity_id: taskId,
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
      entity_type: "task",
      entity_id: taskId,
      description: "Comment added to task",
      user_id: user?.id || null,
    }]);
    setCommentText("");
    setCommentMention("");
    fetchTaskMessages(taskId);
  }

  async function addCollaborator(taskId: string, userId: string) {
    const existing = taskCollaborators[taskId] || [];
    if (existing.includes(userId)) return;
    const { error } = await supabase.from("task_collaborators").insert([{ task_id: taskId, user_id: userId }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      const updated = { ...taskCollaborators };
      updated[taskId] = [...(updated[taskId] || []), userId];
      setTaskCollaborators(updated);
      await supabase.from("activity_logs").insert([{
        action: "collaborator_added",
        entity_type: "task",
        entity_id: taskId,
        description: "Collaborator added to task",
        user_id: user?.id || null,
      }]);
      toast({ title: "Collaborator added" });
    }
  }

  async function removeCollaborator(taskId: string, userId: string) {
    const { error } = await supabase
      .from("task_collaborators")
      .delete()
      .eq("task_id", taskId)
      .eq("user_id", userId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      const updated = { ...taskCollaborators };
      updated[taskId] = (updated[taskId] || []).filter((id) => id !== userId);
      setTaskCollaborators(updated);
      await supabase.from("activity_logs").insert([{
        action: "collaborator_removed",
        entity_type: "task",
        entity_id: taskId,
        description: "Collaborator removed from task",
        user_id: user?.id || null,
      }]);
      toast({ title: "Collaborator removed" });
    }
  }

  useEffect(() => {
    const channel = supabase
      .channel("task_collaborators_changes")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "task_collaborators" },
        (payload) => {
          const r = payload.new as { task_id?: string; user_id?: string } | null;
          const o = payload.old as { task_id?: string; user_id?: string } | null;
          if (payload.eventType === "INSERT" && r?.task_id && r?.user_id) {
            const updated = { ...taskCollaborators };
            updated[r.task_id] = [...(updated[r.task_id] || []), r.user_id];
            setTaskCollaborators(updated);
          }
          if (payload.eventType === "DELETE" && o?.task_id && o?.user_id) {
            const updated = { ...taskCollaborators };
            updated[o.task_id] = (updated[o.task_id] || []).filter((id) => id !== o.user_id);
            setTaskCollaborators(updated);
          }
        }
      )
      .subscribe();
    return () => {
      supabase.removeChannel(channel);
    };
  }, [taskCollaborators]);

  const filteredTasks = tasks.filter((t) => t.title.toLowerCase().includes(search.toLowerCase()));
  const todoTasks = filteredTasks.filter((t) => t.status === "todo" || t.status === "in_progress");
  const completedTasks = filteredTasks.filter((t) => t.status === "completed");

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Tasks</h1>
          <p className="page-description">Manage your work items</p>
        </div>
        <Dialog
          open={dialogOpen}
          onOpenChange={(open) => {
            setDialogOpen(open);
            if (!open) {
              setEditingId(null);
              setFormData({ title: "", description: "", priority: "medium", status: "todo", due_date: "", assigned_to: "", lead_id: "", deal_id: "" });
            }
          }}
        >
          <DialogTrigger asChild>
            <Button
              onClick={() => {
                setEditingId(null);
                setFormData({ title: "", description: "", priority: "medium", status: "todo", due_date: "", assigned_to: "", lead_id: "", deal_id: "" });
              }}
            >
              <Plus className="mr-2 h-4 w-4" />New Task
            </Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader><DialogTitle>{editingId ? "Edit Task" : "Create New Task"}</DialogTitle></DialogHeader>
            <form onSubmit={editingId ? updateTask : createTask} className="space-y-4">
              <div><Label>Title</Label><Input value={formData.title} onChange={(e) => setFormData({ ...formData, title: e.target.value })} required /></div>
              <div><Label>Description</Label><Textarea value={formData.description} onChange={(e) => setFormData({ ...formData, description: e.target.value })} /></div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Priority</Label>
                  <Select value={formData.priority} onValueChange={(v) => setFormData({ ...formData, priority: v })}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="low">Low</SelectItem>
                      <SelectItem value="medium">Medium</SelectItem>
                      <SelectItem value="high">High</SelectItem>
                      <SelectItem value="urgent">Urgent</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div><Label>Due Date</Label><Input type="date" value={formData.due_date} onChange={(e) => setFormData({ ...formData, due_date: e.target.value })} /></div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Status</Label>
                  <Select value={formData.status} onValueChange={(v) => setFormData({ ...formData, status: v })}>
                    <SelectTrigger><SelectValue /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="todo">To Do</SelectItem>
                      <SelectItem value="in_progress">In Progress</SelectItem>
                      <SelectItem value="completed">Completed</SelectItem>
                      <SelectItem value="cancelled">Cancelled</SelectItem>
                    </SelectContent>
                  </Select>
                </div>
                <div>
                  <Label>Assign To</Label>
                  <Select value={formData.assigned_to} onValueChange={(v) => setFormData({ ...formData, assigned_to: v })}>
                    <SelectTrigger><SelectValue placeholder="Select user" /></SelectTrigger>
                    <SelectContent>
                      {profiles.map((p) => (
                        <SelectItem key={p.id} value={p.id}>{p.full_name || p.email}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <Label>Link Lead</Label>
                  <Select value={formData.lead_id} onValueChange={(v) => setFormData({ ...formData, lead_id: v === "none" ? "" : v })}>
                    <SelectTrigger><SelectValue placeholder="Optional" /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="none">None</SelectItem>
                      {leads.map((l) => (
                        <SelectItem key={l.id} value={l.id}>{l.company_name || l.title}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
                <div>
                  <Label>Link Deal</Label>
                  <Select value={formData.deal_id} onValueChange={(v) => setFormData({ ...formData, deal_id: v === "none" ? "" : v })}>
                    <SelectTrigger><SelectValue placeholder="Optional" /></SelectTrigger>
                    <SelectContent>
                      <SelectItem value="none">None</SelectItem>
                      {deals.map((d) => (
                        <SelectItem key={d.id} value={d.id}>{d.title}</SelectItem>
                      ))}
                    </SelectContent>
                  </Select>
                </div>
              </div>
              <Button type="submit" className="w-full">{editingId ? "Update Task" : "Create Task"}</Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search tasks..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
        <div className="flex-1 overflow-x-auto">
          <div className="flex items-center gap-2">
            {profiles.map((p) => {
              const initials = (p.full_name || p.email || "U").slice(0, 2).toUpperCase();
              return (
                <div key={p.id} draggable onDragStart={(e) => e.dataTransfer.setData("userId", p.id)} className="flex items-center gap-2 p-2 rounded-md bg-muted/40">
                  <Avatar className="h-6 w-6">
                    <AvatarFallback className="text-[10px]">{initials}</AvatarFallback>
                  </Avatar>
                  <span className="text-xs">{p.full_name || p.email}</span>
                </div>
              );
            })}
          </div>
        </div>
      </div>

      {loading ? (
        <p className="text-muted-foreground text-center py-8">Loading...</p>
      ) : (
        <div className="grid gap-6 lg:grid-cols-2">
          <div className="space-y-4">
            <h2 className="font-semibold flex items-center gap-2">
              <Circle className="h-4 w-4" /> To Do ({todoTasks.length})
            </h2>
            {todoTasks.length === 0 ? (
              <p className="text-muted-foreground text-sm">No pending tasks</p>
              ) : (
                todoTasks.map((task) => (
                  <Card key={task.id} className="hover:shadow-md transition-shadow"
                    onDragOver={(e) => e.preventDefault()}
                    onDrop={(e) => {
                      const uid = e.dataTransfer.getData("userId");
                      if (uid) assignTask(task.id as string, uid);
                    }}
                  >
                    <CardContent className="p-4">
                      <div className="flex items-start gap-3">
                        <Checkbox checked={task.status === "completed"} onCheckedChange={() => toggleTaskStatus(task)} className="mt-1" />
                        <div className="flex-1 min-w-0">
                          <div className="flex items-center gap-2">
                            <h3 className="font-medium truncate">{task.title}</h3>
                            <Badge className={priorityColors[task.priority]}>{task.priority}</Badge>
                          </div>
                          {task.description && <p className="text-sm text-muted-foreground mt-1 line-clamp-2">{task.description}</p>}
                          {task.due_date && (
                            <div className="flex items-center gap-1 text-xs text-muted-foreground mt-2">
                              <Calendar className="h-3 w-3" />{new Date(task.due_date).toLocaleDateString()}
                            </div>
                          )}
                          <div className="flex items-center gap-2 mt-2">
                            {task.assigned_to && (
                              <span className="text-xs text-muted-foreground">Owner</span>
                            )}
                            <div className="flex items-center gap-1">
                              {(taskCollaborators[task.id as string] || []).map((uid) => {
                                const p = profiles.find((pp) => pp.id === uid);
                                const initials = (p?.full_name || p?.email || "U").slice(0, 2).toUpperCase();
                                const canRemove = user?.id === task.assigned_to;
                                return (
                                  <div key={uid} className="relative">
                                    <Avatar className="h-6 w-6">
                                      <AvatarFallback className="text-[10px]">{initials}</AvatarFallback>
                                    </Avatar>
                                    {canRemove && (
                                      <Button
                                        variant="ghost"
                                        size="icon"
                                        className="absolute -top-1 -right-1 h-4 w-4"
                                        onClick={() => removeCollaborator(task.id as string, uid)}
                                      >
                                        <X className="h-3 w-3" />
                                      </Button>
                                    )}
                                  </div>
                                );
                              })}
                            </div>
                          </div>
                          {(task.lead_id || task.deal_id) && (
                            <div className="flex items-center gap-2 text-xs mt-2">
                              {task.lead_id && (
                                <span className="inline-flex items-center gap-1 text-muted-foreground"><Link className="h-3 w-3" />Lead</span>
                              )}
                              {task.deal_id && (
                                <span className="inline-flex items-center gap-1 text-muted-foreground"><Link className="h-3 w-3" />Deal</span>
                              )}
                            </div>
                          )}
                        </div>
                        <div className="flex items-center gap-1">
                          <Button
                            variant="ghost"
                            size="icon"
                            onClick={() => {
                              setEditingId(task.id);
                              setFormData({
                                title: task.title || "",
                                description: task.description || "",
                                priority: task.priority || "medium",
                                status: task.status || "todo",
                                due_date: task.due_date?.split("T")[0] || "",
                                assigned_to: task.assigned_to || "",
                                lead_id: task.lead_id || "",
                                deal_id: task.deal_id || "",
                              });
                              setDialogOpen(true);
                            }}
                          >
                            <Pencil className="h-4 w-4" />
                          </Button>
                          <Select onValueChange={(v) => addCollaborator(task.id as string, v)}>
                            <SelectTrigger className="w-[44px] justify-center">
                              <UserPlus className="h-4 w-4" />
                            </SelectTrigger>
                            <SelectContent>
                              {profiles.map((p) => (
                                <SelectItem key={p.id} value={p.id}>{p.full_name || p.email}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                          {task.status !== "in_progress" && task.status !== "completed" && (
                            <Button variant="secondary" size="sm" onClick={() => startTask(task)}>Start</Button>
                          )}
                          {task.status !== "completed" && (
                            <Button variant="default" size="sm" onClick={() => completeTask(task)}>Complete</Button>
                          )}
                          <Dialog open={commentsOpenTaskId === task.id} onOpenChange={(open) => {
                            setCommentsOpenTaskId(open ? (task.id as string) : null);
                            if (open) fetchTaskMessages(task.id as string);
                            if (!open) { setCommentText(""); setCommentMention(""); }
                          }}>
                            <DialogTrigger asChild>
                              <Button variant="outline" size="sm">Comments</Button>
                            </DialogTrigger>
                            <DialogContent>
                              <DialogHeader><DialogTitle>Comments</DialogTitle></DialogHeader>
                              <div className="space-y-3 max-h-[50vh] overflow-y-auto">
                                {(taskComments[task.id as string] || []).map((m) => {
                                  const author = profiles.find((p) => p.id === m.author_id);
                                  return (
                                    <div key={m.id} className="p-2 rounded-md bg-muted/40">
                                      <div className="text-sm">{m.content}</div>
                                      <div className="text-xs text-muted-foreground">
                                        {(author?.full_name || author?.email || "User")} • {new Date(m.created_at).toLocaleString()}
                                      </div>
                                    </div>
                                  );
                                })}
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
                                <Button onClick={() => postTaskMessage(task.id as string)} disabled={!commentText.trim()}>Post</Button>
                              </div>
                            </DialogContent>
                          </Dialog>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                ))
              )}
          </div>

          <div className="space-y-4">
            <h2 className="font-semibold flex items-center gap-2">
              <CheckCircle2 className="h-4 w-4 text-success" /> Completed ({completedTasks.length})
            </h2>
            {completedTasks.length === 0 ? (
              <p className="text-muted-foreground text-sm">No completed tasks</p>
            ) : (
              completedTasks.map((task) => (
                <Card key={task.id} className="opacity-60 hover:opacity-100 transition-opacity">
                  <CardContent className="p-4">
                    <div className="flex items-start gap-3">
                      <Checkbox checked={true} onCheckedChange={() => toggleTaskStatus(task)} className="mt-1" />
                      <div className="flex-1 min-w-0">
                        <h3 className="font-medium truncate line-through">{task.title}</h3>
                        {task.completed_at && (
                          <p className="text-xs text-muted-foreground mt-1">Completed {new Date(task.completed_at).toLocaleDateString()}</p>
                        )}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))
            )}
          </div>
        </div>
      )}
    </div>
  );
}
