import { useEffect, useMemo, useState, useCallback } from "react";
import { useParams } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, Users, ClipboardList, CalendarDays, Eye, Pencil, Trash2, UserPlus, Calendar, Clock, CheckCircle2, Link as LinkIcon } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Textarea } from "@/components/ui/textarea";
import type { Tables } from "@/integrations/supabase/types";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { ChatWindow } from "@/components/chat/ChatWindow";
import { useAuth } from "@/contexts/AuthContext";
import { usePermissions } from "@/hooks/use-permissions";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Badge } from "@/components/ui/badge";

type Project = Tables<"projects">;
type Employee = Tables<"employees"> & { profiles: Pick<Tables<"profiles">, "id" | "full_name" | "email"> | null };
type Member = Tables<"project_members"> & { employees: Employee | null };
type Task = Tables<"tasks">;
type Event = Tables<"project_meetings">;
type Channel = Tables<"chat_channels">;

export default function ProjectDetailPage() {
  const { id } = useParams();
  const { toast } = useToast();
  const { user } = useAuth();
  const { can, role, orgId } = usePermissions();
  const [project, setProject] = useState<Project | null>(null);
  const [members, setMembers] = useState<Member[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [events, setEvents] = useState<Event[]>([]);
  const [meetingsTab, setMeetingsTab] = useState<"upcoming" | "past">("upcoming");
  const [upcomingEvents, setUpcomingEvents] = useState<Event[]>([]);
  const [pastEvents, setPastEvents] = useState<Event[]>([]);
  const [pageUpcoming, setPageUpcoming] = useState(0);
  const [pagePast, setPagePast] = useState(0);
  const PAGE_SIZE = 20;
  const [channel, setChannel] = useState<Channel | null>(null);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [newMemberEmployeeId, setNewMemberEmployeeId] = useState<string>("");
  const [profiles, setProfiles] = useState<Pick<Tables<"profiles">, "id" | "full_name" | "email">[]>([]);
  const [taskDialogOpen, setTaskDialogOpen] = useState(false);
  const [taskForm, setTaskForm] = useState({
    title: "",
    description: "",
    priority: "medium",
    status: "todo",
    due_date: "",
    assigned_to: "",
  });

  const filteredTasks = useMemo(() => tasks.filter((t) => t.title.toLowerCase().includes(search.toLowerCase())), [tasks, search]);

  const syncChannelParticipants = useCallback(async (ch: Channel, currentMembers: Member[]) => {
    const { data: existingRows } = await supabase
      .from("chat_participants")
      .select("user_id")
      .eq("channel_id", ch.id);
    const existing = new Set((existingRows || []).map((r) => (r as { user_id: string }).user_id));
    const userIds: string[] = [];
    if (user?.id) userIds.push(user.id);
    currentMembers.forEach((m) => {
      const uid = m.employees?.profiles?.id;
      if (uid) userIds.push(uid);
    });
    const toInsert = userIds.filter((uid) => !existing.has(uid)).map((uid) => ({ channel_id: ch.id, user_id: uid }));
    if (toInsert.length > 0) {
      const { error } = await supabase.from("chat_participants").insert(toInsert);
      if (error) {
        toast({ title: "Error", description: error.message, variant: "destructive" });
      }
    }
  }, [user?.id, toast]);

  const fetchAll = useCallback(async () => {
    if (!id) return;
    setLoading(true);
    const [projRes, memRes, empRes, taskRes, evtRes, chanRes, profRes, profListRes] = await Promise.all([
      supabase.from("projects").select("*").eq("id", id as string).maybeSingle(),
      supabase.from("project_members").select("*, employees(*, profiles(id,full_name,email))").eq("project_id", id as string),
      (orgId 
        ? supabase.from("employees").select("id, employee_id, user_id, status").eq("organization_id", orgId as string).order("created_at", { ascending: false })
        : supabase.from("employees").select("id, employee_id, user_id, status").order("created_at", { ascending: false })
      ),
      supabase.from("tasks").select("*").eq("project_id", id as string).order("created_at", { ascending: false }),
      supabase.from("project_meetings").select("*").eq("project_id", id as string).order("start_time", { ascending: true }),
      supabase.from("chat_channels").select("*").eq("project_id", id as string).maybeSingle(),
      orgId ? supabase.from("profiles").select("id,full_name,email").eq("organization_id", orgId) : Promise.resolve({ data: [] }),
      orgId ? supabase.from("profiles").select("id,full_name,email").eq("organization_id", orgId) : Promise.resolve({ data: [] }),
    ]);
    setProject(projRes.data || null);
    const membersList = (memRes.data || []) as Member[];
    setMembers(membersList);
    const empRows = (empRes.data || []) as { id: string; employee_id: string; user_id: string | null; status: string }[];
    const profRows = (profListRes.data || []) as { id: string; full_name: string | null; email: string | null }[];
    const joinedEmployees: Employee[] = empRows.map((e) => {
      const prof = e.user_id ? profRows.find((p) => p.id === e.user_id) : null;
      return {
        ...(e as unknown as Tables<"employees">),
        profiles: prof ? { id: prof.id, full_name: prof.full_name, email: prof.email } : null,
      } as Employee;
    });
    setEmployees(joinedEmployees);
    setTasks((taskRes.data || []) as Task[]);
    setEvents((evtRes.data || []) as Event[]);
    setChannel(chanRes.data || null);
    setProfiles((profRes.data || []) as Pick<Tables<"profiles">, "id" | "full_name" | "email">[]);
    setLoading(false);
    
    if (chanRes.data) {
       await syncChannelParticipants(chanRes.data, membersList);
    }
  }, [id, syncChannelParticipants, orgId]);

  useEffect(() => {
    fetchAll();
  }, [fetchAll]);

  useEffect(() => {
    const now = new Date();
    const uAll = events.filter(e => new Date(e.start_time as unknown as string) >= now);
    const pAll = events.filter(e => new Date(e.end_time as unknown as string) < now);
    setUpcomingEvents(uAll.slice(0, PAGE_SIZE));
    setPastEvents(pAll.slice(0, PAGE_SIZE));
    setPageUpcoming(0);
    setPagePast(0);
  }, [events]);

  async function ensureChannel() {
    if (!id) return;
    if (channel?.id) return;

    const { data: existing } = await supabase.from("chat_channels").select("*").eq("project_id", id as string).maybeSingle();
    if (existing) {
      setChannel(existing);
      await syncChannelParticipants(existing, members);
      return;
    }

    const name = project?.name ? `Project: ${project.name}` : "Project Chat";
    const { data: created, error } = await supabase
      .from("chat_channels")
      .insert([{ project_id: id as string, name, type: "group", created_by: user?.id || "" }])
      .select()
      .single();
    
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else if (created) {
      setChannel(created);
      await syncChannelParticipants(created, members);
      toast({ title: "Project chat created" });
    }
  }

  async function addMember(e: React.FormEvent) {
    e.preventDefault();
    if (!id || !newMemberEmployeeId) return;
    const { error } = await supabase.from("project_members").insert([{ project_id: id, employee_id: newMemberEmployeeId }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      setDialogOpen(false);
      setNewMemberEmployeeId("");
      fetchAll();
      if (channel) {
         // Re-sync participants if channel exists
         // But fetchAll calls it anyway if we update members. 
         // However, fetchAll fetches from DB.
      }
    }
  }

  async function removeMember(memberId: string) {
    if (!confirm("Remove this member?")) return;
    const { error } = await supabase.from("project_members").delete().eq("id", memberId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Member removed" });
      fetchAll();
    }
  }

  async function createTask(e: React.FormEvent) {
    e.preventDefault();
    if (!orgId) return;
    const { error } = await supabase.from("tasks").insert([{
      title: taskForm.title,
      description: taskForm.description,
      priority: taskForm.priority as "low" | "medium" | "high" | "urgent",
      status: taskForm.status as "todo" | "in_progress" | "completed" | "cancelled",
      due_date: taskForm.due_date || null,
      assigned_to: taskForm.assigned_to || null,
      project_id: id as string,
      organization_id: orgId as string,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Task created" });
      fetchAll();
      setTaskDialogOpen(false);
      setTaskForm({ title: "", description: "", priority: "medium", status: "todo", due_date: "", assigned_to: "" });
    }
  }

  async function moveTask(taskId: string, status: string) {
    if (!orgId) return;
    const { error } = await supabase
      .from("tasks")
      .update({ status, completed_at: status === "completed" ? new Date().toISOString() : null })
      .eq("id", taskId)
      .eq("project_id", id as string);
    if (!error) fetchAll();
  }

  async function assignTask(taskId: string, userId: string) {
    const { error } = await supabase
      .from("tasks")
      .update({ assigned_to: userId || null })
      .eq("id", taskId)
      .eq("project_id", id as string);
    if (!error) fetchAll();
  }

  async function scheduleMeeting(e: React.FormEvent) {
    e.preventDefault();
    if (!(role === "manager" || role === "admin")) {
      toast({ title: "Not allowed", description: "You do not have permission to create project meetings.", variant: "destructive" });
      return;
    }
    const form = e.target as HTMLFormElement;
    const formDataObj = Object.fromEntries(new FormData(form));
    const { error } = await supabase.from("project_meetings").insert([{
      title: String(formDataObj.title || "Meeting"),
      start_time: String(formDataObj.start_time || ""),
      end_time: String(formDataObj.end_time || ""),
      meeting_link: String(formDataObj.meeting_link || ""),
      project_id: id as string,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Meeting scheduled" });
      fetchAll();
      form.reset();
    }
  }

  if (!id) return null;

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">{project?.name || "Project"}</h1>
          {project?.description && <p className="page-description">{project.description}</p>}
        </div>
      </div>

      <Card>
        <CardContent className="p-4">
          <div className="flex items-center justify-between">
            <h2 className="font-semibold flex items-center gap-2"><Users className="h-4 w-4" />Members</h2>
            <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
              <DialogTrigger asChild><Button size="sm"><Plus className="h-4 w-4 mr-1" />Add</Button></DialogTrigger>
              <DialogContent>
                <DialogHeader><DialogTitle>Add Member</DialogTitle></DialogHeader>
                <form onSubmit={addMember} className="space-y-4">
                  <div>
                    <Label>Employee</Label>
                    <Select value={newMemberEmployeeId} onValueChange={setNewMemberEmployeeId}>
                      <SelectTrigger><SelectValue placeholder="Select employee" /></SelectTrigger>
                      <SelectContent>{employees.map((e) => <SelectItem key={e.id} value={e.id}>{e.profiles?.full_name || e.profiles?.email || e.employee_id}</SelectItem>)}</SelectContent>
                    </Select>
                  </div>
                  <Button type="submit" className="w-full">Add Member</Button>
                </form>
              </DialogContent>
            </Dialog>
          </div>
          <div className="mt-4 space-y-2">
            {members.length === 0 ? (
              <p className="text-sm text-muted-foreground">No members yet</p>
            ) : members.map((m) => (
              <div key={m.id} className="flex items-center justify-between p-2 rounded-md border">
                <div className="text-sm">{m.employees?.profiles?.full_name || m.employees?.profiles?.email || "Employee"}</div>
                <Button variant="ghost" size="sm" className="text-destructive" onClick={() => removeMember(m.id)}>Remove</Button>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      <Tabs defaultValue="chat">
        <TabsList>
          <TabsTrigger value="chat">Chat</TabsTrigger>
          <TabsTrigger value="tasks">Tasks</TabsTrigger>
          <TabsTrigger value="meetings">Meetings</TabsTrigger>
        </TabsList>
        <TabsContent value="chat" className="mt-4">
          {!channel?.id ? (
            <div className="flex flex-col items-center justify-center h-[200px] border rounded-md bg-muted/20">
              <p className="text-muted-foreground mb-4">Project chat not initialized</p>
              <Button onClick={ensureChannel}>Create Project Chat</Button>
            </div>
          ) : (
            <div className="h-[60vh] border rounded-md">
              <ChatWindow channelId={channel.id} />
            </div>
          )}
        </TabsContent>
        <TabsContent value="tasks" className="mt-4">
          <Card>
            <CardContent className="p-4 space-y-4">
              <div className="flex items-center justify-between">
                <h3 className="font-semibold flex items-center gap-2"><ClipboardList className="h-4 w-4" />Tasks</h3>
                <Dialog open={taskDialogOpen} onOpenChange={setTaskDialogOpen}>
                  <DialogTrigger asChild><Button size="sm"><Plus className="h-4 w-4 mr-1" />New Task</Button></DialogTrigger>
                  <DialogContent>
                    <DialogHeader><DialogTitle>New Task</DialogTitle></DialogHeader>
                    <form onSubmit={createTask} className="space-y-4">
                      <div><Label>Title</Label><Input value={taskForm.title} onChange={(e) => setTaskForm({ ...taskForm, title: e.target.value })} required /></div>
                      <div><Label>Description</Label><Textarea value={taskForm.description} onChange={(e) => setTaskForm({ ...taskForm, description: e.target.value })} /></div>
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <Label>Priority</Label>
                          <Select value={taskForm.priority} onValueChange={(v) => setTaskForm({ ...taskForm, priority: v })}>
                            <SelectTrigger><SelectValue /></SelectTrigger>
                            <SelectContent>
                              <SelectItem value="low">Low</SelectItem>
                              <SelectItem value="medium">Medium</SelectItem>
                              <SelectItem value="high">High</SelectItem>
                              <SelectItem value="urgent">Urgent</SelectItem>
                            </SelectContent>
                          </Select>
                        </div>
                        <div><Label>Due Date</Label><Input type="date" value={taskForm.due_date} onChange={(e) => setTaskForm({ ...taskForm, due_date: e.target.value })} /></div>
                      </div>
                      <div className="grid grid-cols-2 gap-4">
                        <div>
                          <Label>Status</Label>
                          <Select value={taskForm.status} onValueChange={(v) => setTaskForm({ ...taskForm, status: v })}>
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
                          <Select value={taskForm.assigned_to} onValueChange={(v) => setTaskForm({ ...taskForm, assigned_to: v })}>
                            <SelectTrigger><SelectValue placeholder="Select user" /></SelectTrigger>
                            <SelectContent>
                              {profiles.map((p) => (
                                <SelectItem key={p.id} value={p.id}>{p.full_name || p.email}</SelectItem>
                              ))}
                            </SelectContent>
                          </Select>
                        </div>
                      </div>
                      <Button type="submit" className="w-full">Create Task</Button>
                    </form>
                  </DialogContent>
                </Dialog>
              </div>
              <div className="space-y-2">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input placeholder="Search tasks..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
                </div>
                <div className="flex gap-4 overflow-x-auto">
                  {["todo", "in_progress", "completed", "cancelled"].map((status) => {
                    const colTasks = (tasks || []).filter((t) => (t.title || "").toLowerCase().includes(search.toLowerCase()) && t.status === status);
                    return (
                      <div
                        key={status}
                        className="w-80 flex-shrink-0 rounded-lg border bg-muted/30"
                        onDragOver={(e) => e.preventDefault()}
                        onDrop={(e) => {
                          const taskId = e.dataTransfer.getData("taskId");
                          if (taskId) moveTask(taskId, status);
                        }}
                      >
                        <div className="sticky top-0 z-10 p-3 border-b bg-card/80 backdrop-blur flex items-center justify-between">
                          <span className="text-sm font-medium">{status.replace("_", " ").replace(/\b\w/g, c => c.toUpperCase())}</span>
                          <span className="text-xs">{colTasks.length}</span>
                        </div>
                        <div className="p-2 space-y-2">
                          {colTasks.length === 0 ? (
                            <p className="text-xs text-muted-foreground text-center py-4">No tasks</p>
                          ) : (
                            colTasks.map((task) => (
                              <Card
                                key={task.id}
                                className="bg-card shadow-sm cursor-move hover:shadow-md transition-shadow border group"
                                draggable
                                onDragStart={(e) => e.dataTransfer.setData("taskId", task.id as string)}
                                onDragOver={(e) => e.preventDefault()}
                                onDrop={(e) => {
                                  const uid = e.dataTransfer.getData("userId");
                                  if (uid) assignTask(task.id as string, uid);
                                }}
                              >
                                <CardContent className="p-4">
                                  <div className="flex items-center justify-between">
                                    <div className="flex items-center gap-2">
                                      <Badge className="bg-muted text-muted-foreground">{task.priority}</Badge>
                                    </div>
                                  </div>
                                  <h3 className="font-medium mt-2">{task.title}</h3>
                                  <div className="mt-3 flex items-center justify-between gap-3">
                                    <div className="inline-flex items-center gap-2 text-sm">
                                      <Calendar className="h-4 w-4" />
                                      {task.due_date ? new Date(task.due_date).toLocaleDateString() : "No deadline"}
                                    </div>
                                    <div />
                                  </div>
                                  <div className="mt-3 flex items-center justify-between gap-2">
                                    <div className="text-xs text-muted-foreground">
                                      {task.assigned_to ? (() => {
                                        const p = profiles.find(u => u.id === task.assigned_to);
                                        return p ? `Assigned to ${p.full_name || p.email}` : "Unknown";
                                      })() : "Unassigned"}
                                    </div>
                                    <div className="flex items-center gap-2">
                                      <Select onValueChange={(v) => assignTask(task.id as string, v)}>
                                        <SelectTrigger className="w-[36px] justify-center" title="Assign">
                                          <UserPlus className="h-4 w-4" />
                                        </SelectTrigger>
                                        <SelectContent>
                                          {profiles.map((p) => (
                                            <SelectItem key={p.id} value={p.id}>{p.full_name || p.email}</SelectItem>
                                          ))}
                                        </SelectContent>
                                      </Select>
                                    </div>
                                  </div>
                                </CardContent>
                              </Card>
                            ))
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
        <TabsContent value="meetings" className="mt-4">
          <Card>
            <CardContent className="p-4 space-y-4">
               <div className="flex items-center justify-between">
                <h3 className="font-semibold flex items-center gap-2"><CalendarDays className="h-4 w-4" />Meetings</h3>
                {can("calendar", "can_create") && (
                <Dialog>
                  <DialogTrigger asChild><Button size="sm"><Plus className="h-4 w-4 mr-1" />Schedule</Button></DialogTrigger>
                  <DialogContent>
                    <DialogHeader><DialogTitle>Schedule Meeting</DialogTitle></DialogHeader>
                    <form onSubmit={scheduleMeeting} className="space-y-4">
                      <div><Label>Title</Label><Input name="title" required /></div>
                      <div className="grid grid-cols-2 gap-4">
                        <div><Label>Start</Label><Input type="datetime-local" name="start_time" required /></div>
                        <div><Label>End</Label><Input type="datetime-local" name="end_time" required /></div>
                      </div>
                      <div><Label>Link (optional)</Label><Input name="meeting_link" /></div>
                      <Button type="submit" className="w-full">Schedule</Button>
                    </form>
                  </DialogContent>
                </Dialog>
                )}
              </div>
              <div className="space-y-2">
                <div className="flex gap-2 justify-end">
                  <Button variant={meetingsTab === "upcoming" ? "default" : "secondary"} size="sm" onClick={() => setMeetingsTab("upcoming")}>Upcoming</Button>
                  <Button variant={meetingsTab === "past" ? "default" : "secondary"} size="sm" onClick={() => setMeetingsTab("past")}>Past</Button>
                </div>
                <div className="border rounded-md h-[50vh] overflow-y-auto" onScroll={(e) => {
                  const el = e.currentTarget;
                  if (meetingsTab === "upcoming") {
                    if (el.scrollTop + el.clientHeight >= el.scrollHeight - 20) {
                      const now = new Date();
                      const all = events.filter(ev => new Date(ev.start_time as unknown as string) >= now);
                      const nextPage = pageUpcoming + 1;
                      const next = all.slice(0, (nextPage + 1) * PAGE_SIZE);
                      if (next.length > upcomingEvents.length) {
                        setUpcomingEvents(next);
                        setPageUpcoming(nextPage);
                      }
                    }
                  } else {
                    if (el.scrollTop + el.clientHeight >= el.scrollHeight - 20) {
                      const now = new Date();
                      const all = events.filter(ev => new Date(ev.end_time as unknown as string) < now);
                      const nextPage = pagePast + 1;
                      const next = all.slice(0, (nextPage + 1) * PAGE_SIZE);
                      if (next.length > pastEvents.length) {
                        setPastEvents(next);
                        setPagePast(nextPage);
                      }
                    }
                  }
                }}>
                  {(meetingsTab === "upcoming" ? upcomingEvents : pastEvents).length === 0 ? (
                    <p className="text-sm text-muted-foreground text-center py-4">No meetings scheduled</p>
                  ) : (
                    (meetingsTab === "upcoming" ? upcomingEvents : pastEvents).map(e => (
                      <div key={e.id} className="p-3 border-b flex justify-between items-center">
                        <div>
                          <p className="font-medium">{e.title}</p>
                          <p className="text-xs text-muted-foreground">
                            {new Date(e.start_time as unknown as string).toLocaleString()} - {new Date(e.end_time as unknown as string).toLocaleString()}
                          </p>
                        </div>
                        {e.meeting_link && (
                          <Button variant="ghost" size="sm" asChild>
                            <a href={e.meeting_link} target="_blank" rel="noopener noreferrer"><LinkIcon className="h-4 w-4" /></a>
                          </Button>
                        )}
                      </div>
                    ))
                  )}
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
