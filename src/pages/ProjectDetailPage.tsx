import { useEffect, useMemo, useState, useCallback } from "react";
import { useParams } from "react-router-dom";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
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
import { TaskDetailsSheet } from "@/components/tasks/TaskDetailsSheet";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Badge } from "@/components/ui/badge";
import { Checkbox } from "@/components/ui/checkbox";
import { ScrollArea } from "@/components/ui/scroll-area";

type Project = Tables<"projects">;
type Employee = Tables<"employees"> & { profiles: Pick<Tables<"profiles">, "id" | "full_name" | "email"> | null };
type Member = Tables<"project_members"> & { employees: Employee | null };
type Task = Tables<"project_tasks">;
type Event = Tables<"project_meetings">;
type Channel = Tables<"chat_channels">;

const priorityColors: Record<string, string> = {
  low: "bg-muted text-muted-foreground",
  medium: "bg-info/10 text-info",
  high: "bg-warning/10 text-warning",
  urgent: "bg-destructive/10 text-destructive",
};

const priorityBorder: Record<string, string> = {
  low: "border-l-4 border-l-muted",
  medium: "border-l-4 border-l-info",
  high: "border-l-4 border-l-warning",
  urgent: "border-l-4 border-l-destructive",
};

const statusColumns = [
  { id: "todo", label: "To Do" },
  { id: "in_progress", label: "In Progress" },
  { id: "completed", label: "Completed" },
] as const;

export default function ProjectDetailPage() {
  const { id } = useParams<{ id: string }>();
  const { toast } = useToast();
  const { user } = useAuth();
  const { can, role } = usePermissions();
  const [project, setProject] = useState<Project | null>(null);
  const [members, setMembers] = useState<Member[]>([]);
  const [employees, setEmployees] = useState<Employee[]>([]);
  const [tasks, setTasks] = useState<Task[]>([]);
  const [events, setEvents] = useState<Event[]>([]);
  const [channel, setChannel] = useState<Channel | null>(null);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [newMemberEmployeeId, setNewMemberEmployeeId] = useState<string>("");
  const [viewTask, setViewTask] = useState<Task | null>(null);
  
  // Task management state
  const [taskDialogOpen, setTaskDialogOpen] = useState(false);
  const [editingTask, setEditingTask] = useState<Task | null>(null);
  const [taskFormData, setTaskFormData] = useState({
    title: "",
    description: "",
    priority: "medium",
    status: "todo",
    assigned_to: "",
    due_date: "",
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
    setLoading(true);
    const [projRes, memRes, empRes, taskRes, evtRes, chanRes] = await Promise.all([
      supabase.from("projects").select("*").eq("id", id as string).maybeSingle(),
      supabase.from("project_members").select("*, employees(*, profiles(id,full_name,email))").eq("project_id", id as string),
      supabase.from("employees").select("*, profiles(id,full_name,email)").order("created_at", { ascending: false }),
      supabase.from("project_tasks").select("*").eq("project_id", id as string).order("created_at", { ascending: false }),
      supabase.from("project_meetings").select("*").eq("project_id", id as string).order("start_time", { ascending: true }),
      supabase.from("chat_channels").select("*").eq("project_id", id as string).maybeSingle(),
    ]);
    setProject(projRes.data || null);
    const membersList = (memRes.data || []) as Member[];
    setMembers(membersList);
    setEmployees((empRes.data || []) as Employee[]);
    setTasks((taskRes.data || []) as Task[]);
    setEvents((evtRes.data || []) as Event[]);
    setChannel(chanRes.data || null);
    setLoading(false);
    if (chanRes.data) {
      await syncChannelParticipants(chanRes.data, membersList);
    }
  }, [id, syncChannelParticipants]);

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
      .maybeSingle();
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
      return;
    }
    if (created) {
      setChannel(created);
      await syncChannelParticipants(created, members);
      toast({ title: "Project chat created" });
    }
  }

  const availableEmployees = useMemo(() => {
    const memberIds = new Set(members.map(m => m.employee_id));
    return employees.filter(e => !memberIds.has(e.id));
  }, [members, employees]);

  useEffect(() => {
    fetchAll();
  }, [fetchAll]);

  async function addMember(e: React.FormEvent) {
    e.preventDefault();
    if (!id || !newMemberEmployeeId) return;
    
    // Check if already exists (double check)
    if (members.some(m => m.employee_id === newMemberEmployeeId)) {
      toast({ title: "Error", description: "Member already exists", variant: "destructive" });
      return;
    }

    const { error } = await supabase.from("project_members").insert([{ project_id: id, employee_id: newMemberEmployeeId }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Member added" });
      setDialogOpen(false);
      setNewMemberEmployeeId("");
      fetchAll();
    }
  }

  async function removeMember(memberId: string) {
    const { error } = await supabase.from("project_members").delete().eq("id", memberId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Member removed" });
      fetchAll();
    }
  }

  async function handleTaskSubmit(e: React.FormEvent) {
    e.preventDefault();
    const payload = {
      title: taskFormData.title,
      description: taskFormData.description,
      priority: taskFormData.priority,
      status: taskFormData.status,
      assigned_to: taskFormData.assigned_to || null,
      due_date: taskFormData.due_date || null,
      project_id: id as string,
    };

    if (editingTask) {
      const { error } = await supabase.from("project_tasks").update({
        title: payload.title,
        description: payload.description,
        priority: payload.priority,
        status: payload.status,
        assigned_to: payload.assigned_to,
        due_date: payload.due_date,
      }).eq("id", editingTask.id);

      if (error) {
        toast({ title: "Error", description: error.message, variant: "destructive" });
      } else {
        toast({ title: "Task updated" });
        setTaskDialogOpen(false);
        setEditingTask(null);
        setTaskFormData({ title: "", description: "", priority: "medium", status: "todo", assigned_to: "", due_date: "" });
        fetchAll();
      }
    } else {
      const { error } = await supabase.from("project_tasks").insert([payload]);
      if (error) {
        toast({ title: "Error", description: error.message, variant: "destructive" });
      } else {
        toast({ title: "Task created" });
        setTaskDialogOpen(false);
        setTaskFormData({ title: "", description: "", priority: "medium", status: "todo", assigned_to: "", due_date: "" });
        fetchAll();
      }
    }
  }

  async function updateTaskStatus(taskId: string, status: string) {
    const { error } = await supabase.from("project_tasks").update({ status }).eq("id", taskId);
    if (!error) fetchAll();
  }

  async function assignTask(taskId: string, userId: string) {
    const { error } = await supabase.from("project_tasks").update({ assigned_to: userId }).eq("id", taskId);
    if (!error) fetchAll();
  }

  async function deleteTask(taskId: string) {
    if (!confirm("Are you sure?")) return;
    const { error } = await supabase.from("project_tasks").delete().eq("id", taskId);
    if (!error) fetchAll();
  }

  async function toggleTaskStatus(task: Task) {
    const newStatus = task.status === "completed" ? "todo" : "completed";
    await updateTaskStatus(task.id, newStatus);
  }

  async function scheduleMeeting(e: React.FormEvent) {
    e.preventDefault();
    if (role !== "manager" && role !== "admin") {
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
                      <SelectContent>{availableEmployees.map((e) => <SelectItem key={e.id} value={e.id}>{e.profiles?.full_name || e.profiles?.email || e.employee_id}</SelectItem>)}</SelectContent>
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
              <div key={m.id} 
                className="flex items-center justify-between p-2 rounded-md border cursor-move hover:bg-muted/50 transition-colors"
                draggable
                onDragStart={(e) => {
                  if (m.employees?.profiles?.id) {
                    e.dataTransfer.setData("userId", m.employees.profiles.id);
                  }
                }}
              >
                <div className="flex items-center gap-2">
                  <Avatar className="h-6 w-6">
                    <AvatarFallback className="text-[10px]">{m.employees?.profiles?.full_name?.slice(0,2).toUpperCase() || "U"}</AvatarFallback>
                  </Avatar>
                  <div className="text-sm">{m.employees?.profiles?.full_name || m.employees?.profiles?.email || "Employee"}</div>
                </div>
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
            <Button onClick={ensureChannel}>Create Project Chat</Button>
          ) : (
            <div className="h-[60vh] border rounded-md">
              <ChatWindow channelId={channel.id} />
            </div>
          )}
        </TabsContent>
        <TabsContent value="tasks" className="mt-4">
          <div className="flex items-center justify-between mb-4">
             <div className="flex gap-4 flex-1">
               <div className="relative flex-1 max-w-sm">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input placeholder="Search tasks..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
               </div>
             </div>
             <Dialog open={taskDialogOpen} onOpenChange={setTaskDialogOpen}>
                <DialogTrigger asChild>
                  <Button onClick={() => {
                      setEditingTask(null);
                      setTaskFormData({ title: "", description: "", priority: "medium", status: "todo", assigned_to: "", due_date: "" });
                  }}>
                    <Plus className="h-4 w-4 mr-1" />New Task
                  </Button>
                </DialogTrigger>
                <DialogContent>
                  <DialogHeader><DialogTitle>{editingTask ? "Edit Task" : "New Task"}</DialogTitle></DialogHeader>
                  <form onSubmit={handleTaskSubmit} className="space-y-4">
                    <div><Label>Title</Label><Input value={taskFormData.title} onChange={(e) => setTaskFormData({...taskFormData, title: e.target.value})} required /></div>
                    <div><Label>Description</Label><Textarea value={taskFormData.description} onChange={(e) => setTaskFormData({...taskFormData, description: e.target.value})} /></div>
                    <div className="grid grid-cols-2 gap-4">
                      <div>
                        <Label>Priority</Label>
                        <Select value={taskFormData.priority} onValueChange={(v) => setTaskFormData({...taskFormData, priority: v})}>
                          <SelectTrigger><SelectValue /></SelectTrigger>
                          <SelectContent>
                            <SelectItem value="low">Low</SelectItem>
                            <SelectItem value="medium">Medium</SelectItem>
                            <SelectItem value="high">High</SelectItem>
                            <SelectItem value="urgent">Urgent</SelectItem>
                          </SelectContent>
                        </Select>
                      </div>
                      <div><Label>Due Date</Label><Input type="date" value={taskFormData.due_date} onChange={(e) => setTaskFormData({...taskFormData, due_date: e.target.value})} /></div>
                    </div>
                    <div>
                      <Label>Assign To</Label>
                      <Select value={taskFormData.assigned_to} onValueChange={(v) => setTaskFormData({...taskFormData, assigned_to: v})}>
                        <SelectTrigger><SelectValue placeholder="Unassigned" /></SelectTrigger>
                        <SelectContent>
                          {members.map((m) => (
                             <SelectItem key={m.employees?.profiles?.id} value={m.employees?.profiles?.id || ""}>
                               {m.employees?.profiles?.full_name || m.employees?.profiles?.email}
                             </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                    <Button type="submit" className="w-full">{editingTask ? "Update" : "Create"}</Button>
                  </form>
                </DialogContent>
             </Dialog>
          </div>

          <div className="flex gap-4 overflow-x-auto pb-4">
            {statusColumns.map((col) => {
              const colTasks = filteredTasks.filter((t) => t.status === col.id);
              return (
                <div key={col.id} className="w-80 flex-shrink-0 rounded-lg border bg-muted/30"
                  onDragOver={(e) => e.preventDefault()}
                  onDrop={(e) => {
                    const taskId = e.dataTransfer.getData("taskId");
                    if (taskId) updateTaskStatus(taskId, col.id);
                  }}
                >
                  <div className="sticky top-0 z-10 p-3 border-b bg-card/80 backdrop-blur flex items-center justify-between">
                    <span className="text-sm font-medium">{col.label}</span>
                    <Badge variant="secondary">{colTasks.length}</Badge>
                  </div>
                  <div className="p-2 space-y-2">
                    {colTasks.length === 0 ? (
                      <p className="text-xs text-muted-foreground text-center py-4">No tasks</p>
                    ) : (
                      colTasks.map((task) => {
                        const owner = members.find(m => m.employees?.profiles?.id === task.assigned_to)?.employees?.profiles;
                        const borderClass = priorityBorder[task.priority || "medium"];
                        return (
                          <Card
                            key={task.id}
                            className={`bg-card shadow-sm cursor-move hover:shadow-md transition-shadow border ${borderClass} group`}
                            draggable
                            onDragStart={(e) => e.dataTransfer.setData("taskId", task.id)}
                            onDragOver={(e) => e.preventDefault()}
                            onDrop={(e) => {
                                const uid = e.dataTransfer.getData("userId");
                                if (uid) {
                                  e.stopPropagation();
                                  assignTask(task.id, uid);
                                }
                            }}
                          >
                            <CardContent className="p-4">
                              <div className="flex items-center justify-between">
                                <div className="flex items-center gap-2">
                                  <Checkbox checked={task.status === "completed"} onCheckedChange={() => toggleTaskStatus(task)} />
                                  <Badge className={priorityColors[task.priority || "medium"]}>{task.priority}</Badge>
                                </div>
                              </div>
                              <h3 className="font-medium mt-2">{task.title}</h3>
                              <div className="mt-3 flex items-center justify-between gap-3">
                                <div className="inline-flex items-center gap-2 text-sm text-muted-foreground">
                                  <Calendar className="h-3 w-3" />
                                  {task.due_date ? new Date(task.due_date).toLocaleDateString() : "No date"}
                                </div>
                              </div>
                              <div className="mt-3 flex items-center justify-between gap-3">
                                <div className="text-sm">
                                  {task.assigned_to ? (
                                    <div className="flex items-center gap-1">
                                       <Avatar className="h-5 w-5">
                                          <AvatarFallback className="text-[9px]">{owner?.full_name?.slice(0,2).toUpperCase() || "U"}</AvatarFallback>
                                       </Avatar>
                                       <span className="text-xs text-muted-foreground">{owner?.full_name || "User"}</span>
                                    </div>
                                  ) : <span className="text-xs text-muted-foreground">Unassigned</span>}
                                </div>
                                <div className="flex items-center gap-1 justify-end">
                                   <Button variant="ghost" size="icon" className="h-6 w-6" onClick={() => setViewTask(task)}><Eye className="h-3 w-3" /></Button>
                                   <Button variant="ghost" size="icon" className="h-6 w-6" onClick={() => {
                                      setEditingTask(task);
                                      setTaskFormData({
                                        title: task.title,
                                        description: task.description || "",
                                        priority: task.priority || "medium",
                                        status: task.status || "todo",
                                        assigned_to: task.assigned_to || "",
                                        due_date: task.due_date ? task.due_date.split("T")[0] : "",
                                      });
                                      setTaskDialogOpen(true);
                                   }}><Pencil className="h-3 w-3" /></Button>
                                   <Button variant="ghost" size="icon" className="h-6 w-6 text-destructive" onClick={() => deleteTask(task.id)}><Trash2 className="h-3 w-3" /></Button>
                                </div>
                              </div>
                            </CardContent>
                          </Card>
                        );
                      })
                    )}
                  </div>
                </div>
              );
            })}
          </div>
          <TaskDetailsSheet task={viewTask as any} open={!!viewTask} onOpenChange={(open) => !open && setViewTask(null)} isProjectTask={true} />
        </TabsContent>
        <TabsContent value="meetings" className="mt-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <Card className="h-fit">
              <CardHeader>
                <CardTitle className="text-lg flex items-center gap-2">
                  <CalendarDays className="h-5 w-5" />
                  Schedule Meeting
                </CardTitle>
              </CardHeader>
              <CardContent>
                {(role === "manager" || role === "admin") ? (
                  <form onSubmit={scheduleMeeting} className="space-y-4">
                    <div className="space-y-2">
                      <Label>Title</Label>
                      <Input name="title" placeholder="Meeting title" required />
                    </div>
                    <div className="grid grid-cols-2 gap-2">
                      <div className="space-y-2">
                        <Label>Start</Label>
                        <Input type="datetime-local" name="start_time" required />
                      </div>
                      <div className="space-y-2">
                        <Label>End</Label>
                        <Input type="datetime-local" name="end_time" required />
                      </div>
                    </div>
                    <div className="space-y-2">
                      <Label>Meeting Link</Label>
                      <Input name="meeting_link" placeholder="https://..." required />
                    </div>
                    <Button type="submit" className="w-full">Schedule Meeting</Button>
                  </form>
                ) : (
                  <div className="text-center py-8 text-muted-foreground bg-muted/20 rounded-lg border border-dashed">
                    <p>Only project managers can schedule meetings.</p>
                  </div>
                )}
              </CardContent>
            </Card>

            <Card className="h-[calc(100vh-250px)] min-h-[500px] flex flex-col">
              <CardHeader>
                <CardTitle className="text-lg flex items-center gap-2">
                  <Clock className="h-5 w-5" />
                  Upcoming
                </CardTitle>
              </CardHeader>
              <CardContent className="flex-1 p-0">
                <ScrollArea className="h-full px-6 pb-6">
                  {events.filter(m => new Date(m.start_time as unknown as string) >= new Date()).length === 0 ? (
                    <p className="text-sm text-muted-foreground text-center py-8">No upcoming meetings</p>
                  ) : (
                    events.filter(m => new Date(m.start_time as unknown as string) >= new Date()).map((ev) => (
                      <Card key={ev.id} className="hover:shadow-md transition-shadow mb-4">
                        <CardContent className="p-4">
                          <div className="flex items-start justify-between">
                            <div className="flex-1">
                              <h3 className="font-semibold">{ev.title}</h3>
                              <div className="text-sm text-muted-foreground mt-1 flex items-center gap-1">
                                <Clock className="h-3 w-3" />
                                {new Date(ev.start_time as unknown as string).toLocaleString()}
                              </div>
                              {ev.meeting_link && (
                                <div className="mt-2 text-sm">
                                  <a href={ev.meeting_link} target="_blank" rel="noopener noreferrer" className="text-primary hover:underline flex items-center gap-1">
                                    <LinkIcon className="h-3 w-3" />
                                    Join Meeting
                                  </a>
                                </div>
                              )}
                            </div>
                          </div>
                        </CardContent>
                      </Card>
                    ))
                  )}
                </ScrollArea>
              </CardContent>
            </Card>

            <Card className="h-[calc(100vh-250px)] min-h-[500px] flex flex-col">
              <CardHeader>
                <CardTitle className="text-lg flex items-center gap-2">
                  <CheckCircle2 className="h-5 w-5" />
                  Completed
                </CardTitle>
              </CardHeader>
              <CardContent className="flex-1 p-0">
                <ScrollArea className="h-full px-6 pb-6">
                  {events.filter(m => new Date(m.start_time as unknown as string) < new Date()).length === 0 ? (
                    <p className="text-sm text-muted-foreground text-center py-8">No past meetings</p>
                  ) : (
                    events.filter(m => new Date(m.start_time as unknown as string) < new Date()).map((ev) => (
                      <Card key={ev.id} className="bg-muted/50 mb-4 opacity-75 hover:opacity-100 transition-opacity">
                        <CardContent className="p-4">
                          <h3 className="font-semibold">{ev.title}</h3>
                          <div className="text-sm text-muted-foreground mt-1 flex items-center gap-1">
                            <Clock className="h-3 w-3" />
                            {new Date(ev.start_time as unknown as string).toLocaleString()}
                          </div>
                        </CardContent>
                      </Card>
                    ))
                  )}
                </ScrollArea>
              </CardContent>
            </Card>
          </div>
        </TabsContent>
      </Tabs>
    </div>
  );
}
