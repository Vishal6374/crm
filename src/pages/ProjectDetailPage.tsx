import { useEffect, useMemo, useState, useCallback } from "react";
import { useParams } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, Users, ClipboardList, CalendarDays } from "lucide-react";
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

type Project = Tables<"projects">;
type Employee = Tables<"employees"> & { profiles: Pick<Tables<"profiles">, "id" | "full_name" | "email"> | null };
type Member = Tables<"project_members"> & { employees: Employee | null };
type Task = Tables<"project_tasks">;
type Event = Tables<"project_meetings">;
type Channel = Tables<"chat_channels">;

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

  useEffect(() => {
    fetchAll();
  }, [fetchAll]);
  async function addMember(e: React.FormEvent) {
    e.preventDefault();
    if (!id || !newMemberEmployeeId) return;
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

  async function createTask(e: React.FormEvent) {
    e.preventDefault();
    const form = e.target as HTMLFormElement;
    const formDataObj = Object.fromEntries(new FormData(form));
    const { error } = await supabase.from("project_tasks").insert([{
      title: String(formDataObj.title || ""),
      description: String(formDataObj.description || ""),
      priority: "medium",
      status: "todo",
      project_id: id as string,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Task created" });
      fetchAll();
      form.reset();
    }
  }

  async function scheduleMeeting(e: React.FormEvent) {
    e.preventDefault();
    if (role !== "manager") {
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
            <Button onClick={ensureChannel}>Create Project Chat</Button>
          ) : (
            <div className="h-[60vh] border rounded-md">
              <ChatWindow channelId={channel.id} />
            </div>
          )}
        </TabsContent>
        <TabsContent value="tasks" className="mt-4">
          <Card>
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <h2 className="font-semibold flex items-center gap-2"><ClipboardList className="h-4 w-4" />Tasks</h2>
              </div>
              <div className="mt-3 flex gap-2">
                <div className="relative flex-1">
                  <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                  <Input placeholder="Search tasks..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
                </div>
              </div>
              <div className="mt-4 space-y-2">
                {filteredTasks.length === 0 ? (
                  <p className="text-sm text-muted-foreground">No tasks</p>
                ) : filteredTasks.map((t) => (
                  <div key={t.id} className="p-2 rounded-md border text-sm">{t.title}</div>
                ))}
              </div>
              <div className="mt-4">
                <form onSubmit={createTask} className="space-y-2">
                  <Input name="title" placeholder="New task title" required />
                  <Textarea name="description" placeholder="Description" />
                  <Button type="submit" className="w-full"><Plus className="h-4 w-4 mr-1" />Add Task</Button>
                </form>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
        <TabsContent value="meetings" className="mt-4">
          <Card>
            <CardContent className="p-4">
              <div className="flex items-center justify-between">
                <h2 className="font-semibold flex items-center gap-2"><CalendarDays className="h-4 w-4" />Meetings</h2>
              </div>
              <div className="mt-4 space-y-2">
                {events.length === 0 ? (
                  <p className="text-sm text-muted-foreground">No meetings scheduled</p>
                ) : events.map((ev) => (
                  <div key={ev.id} className="p-2 rounded-md border text-sm">
                    <div className="font-medium">{ev.title}</div>
                    <div className="text-xs text-muted-foreground">
                      {new Date(ev.start_time as unknown as string).toLocaleString()} - {new Date(ev.end_time as unknown as string).toLocaleString()}
                    </div>
                  </div>
                ))}
              </div>
              <div className="mt-4">
                {role === "manager" ? (
                  <form onSubmit={scheduleMeeting} className="space-y-2">
                    <Input name="title" placeholder="Meeting title" required />
                    <div className="grid grid-cols-2 gap-2">
                      <Input type="datetime-local" name="start_time" required />
                      <Input type="datetime-local" name="end_time" required />
                    </div>
                    <Input name="meeting_link" placeholder="Meeting link" required />
                    <Button type="submit" className="w-full"><Plus className="h-4 w-4 mr-1" />Schedule Meeting</Button>
                  </form>
                ) : (
                  <p className="text-sm text-muted-foreground">Only project managers can schedule meetings.</p>
                )}
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
