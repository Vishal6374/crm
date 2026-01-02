import { useEffect, useState, useCallback } from "react";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Search, CalendarDays, Clock, CheckCircle2, X } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Label } from "@/components/ui/label";
import { Tables } from "@/integrations/supabase/types";
import { usePermissions } from "@/hooks/use-permissions";
import { useAuth } from "@/contexts/AuthContext";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Badge } from "@/components/ui/badge";

type Meeting = Tables<"events">;
type Project = Tables<"projects">;
type Profile = Pick<Tables<"profiles">, "id" | "full_name" | "email">;

export default function MeetingsPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const { can, role } = usePermissions();
  const [meetings, setMeetings] = useState<Meeting[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [selectedAttendees, setSelectedAttendees] = useState<string[]>([]);
  const [attendeesMap, setAttendeesMap] = useState<Record<string, Profile[]>>({});
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  
  // Form state
  const [title, setTitle] = useState("");
  const [startTime, setStartTime] = useState("");
  const [endTime, setEndTime] = useState("");
  const [projectId, setProjectId] = useState("");

  const fetchMeetings = useCallback(async () => {
    const { data, error } = await supabase
      .from("events")
      .select("*")
      .eq("type", "meeting")
      .order("start_time", { ascending: true });
    if (error) {
      setMeetings([]);
      setLoading(false);
      return;
    }
    let visible = (data || []) as Meeting[];
    if (role === "employee" && user?.id) {
      const { data: empRow } = await supabase.from("employees").select("id, user_id").eq("user_id", user.id).maybeSingle();
      if (empRow?.id) {
        const { data: mems } = await supabase.from("project_members").select("project_id, employee_id").eq("employee_id", empRow.id);
        const allowedProjectIds = (mems || []).map((m) => (m as { project_id: string }).project_id);
        visible = visible.filter((m) => !m.related_id || allowedProjectIds.includes(m.related_id as string));
      } else {
        visible = visible.filter((m) => !m.related_id);
      }
    }
    setMeetings(visible);
    // Build attendees map
    const ids = visible.map((m) => m.id as string);
    if (ids.length > 0) {
      const { data: rows } = await supabase
        .from("event_attendees")
        .select("event_id, user_id")
        .in("event_id", ids);
      const profIndex = new Map<string, Profile>();
      profiles.forEach((p) => profIndex.set(p.id as string, p));
      const map: Record<string, Profile[]> = {};
      (rows || []).forEach((r) => {
        const eid = (r as { event_id: string }).event_id;
        const uid = (r as { user_id: string }).user_id;
        const p = profIndex.get(uid);
        if (p) {
          if (!map[eid]) map[eid] = [];
          map[eid].push(p);
        }
      });
      setAttendeesMap(map);
    } else {
      setAttendeesMap({});
    }
    setLoading(false);
  }, [role, user?.id, profiles]);

  async function fetchProjects() {
    const { data } = await supabase.from("projects").select("id, name").order("name");
    if (data) setProjects(data);
  }

  async function fetchProfiles() {
    const { data } = await supabase.from("profiles").select("id, full_name, email").order("full_name");
    if (data) setProfiles(data as Profile[]);
  }

  useEffect(() => {
    fetchMeetings();
    fetchProjects();
    fetchProfiles();
  }, [fetchMeetings]);

  async function createMeeting(e: React.FormEvent) {
    e.preventDefault();
    if (!can("calendar", "can_create") && role !== "tenant_admin") {
      toast({ title: "Not allowed", description: "You do not have permission to create meetings.", variant: "destructive" });
      return;
    }
    
    const insertRes = await supabase.from("events").insert([{
      title: title || "Meeting",
      start_time: startTime,
      end_time: endTime,
      type: "meeting",
      related_id: projectId || null,
      created_by: user?.id || null,
    }]).select().maybeSingle();

    if (insertRes.error) {
      toast({ title: "Error", description: insertRes.error.message, variant: "destructive" });
    } else {
      const ev = insertRes.data as Meeting | null;
      if (ev?.id && selectedAttendees.length > 0) {
        const rows = selectedAttendees.map((uid) => ({ event_id: ev.id as string, user_id: uid }));
        const { error: attErr } = await supabase.from("event_attendees").insert(rows);
        if (attErr) {
          toast({ title: "Error", description: attErr.message, variant: "destructive" });
        }
      }
      toast({ title: "Meeting created" });
      fetchMeetings();
      // Reset form
      setTitle("");
      setStartTime("");
      setEndTime("");
      setProjectId("");
      setSelectedAttendees([]);
    }
  }

  async function removeAttendee(eventId: string, userId: string) {
    const ev = meetings.find((m) => m.id === eventId);
    const isCreator = ev?.created_by && ev.created_by === user?.id;
    if (!isCreator && role !== "tenant_admin") {
      toast({ title: "Not allowed", description: "Only creator or tenant admin can remove attendees.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("event_attendees").delete().eq("event_id", eventId).eq("user_id", userId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      const next = { ...(attendeesMap || {}) };
      next[eventId] = (next[eventId] || []).filter((p) => (p.id as string) !== userId);
      setAttendeesMap(next);
      toast({ title: "Attendee removed" });
    }
  }

  const filtered = meetings.filter((m) => (m.title || "").toLowerCase().includes(search.toLowerCase()));
  const now = new Date();
  const upcoming = filtered.filter(m => new Date(m.start_time) >= now);
  const completed = filtered.filter(m => new Date(m.start_time) < now);

  const MeetingCard = ({ m }: { m: Meeting }) => (
    <Card className="hover:shadow-md transition-shadow mb-4">
      <CardContent className="p-4">
        <div className="flex items-start justify-between">
          <div className="flex-1">
            <div className="flex items-center gap-2">
              <CalendarDays className="h-4 w-4 text-muted-foreground" />
              <h3 className="font-semibold">{m.title}</h3>
            </div>
            <div className="text-sm text-muted-foreground mt-1 flex items-center gap-1">
              <Clock className="h-3 w-3" />
              {new Date(m.start_time as unknown as string).toLocaleString()}
            </div>
            <div className="mt-3">
              <div className="text-xs text-muted-foreground mb-1">Attendees</div>
              <div className="flex flex-wrap gap-2">
                {(attendeesMap[m.id as string] || []).map((p) => (
                  <Badge key={p.id} variant="secondary" className="text-xs flex items-center gap-1 font-normal">
                    {p.full_name || p.email}
                    {(role === "tenant_admin" || (m.created_by && m.created_by === user?.id)) && (
                      <button
                        className="text-muted-foreground hover:text-destructive ml-1"
                        onClick={() => removeAttendee(m.id as string, p.id as string)}
                      >
                        <X className="h-3 w-3" />
                      </button>
                    )}
                  </Badge>
                ))}
                {!attendeesMap[m.id as string]?.length && <span className="text-xs text-muted-foreground">None</span>}
              </div>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  );

  return (
    <div className="space-y-6 animate-fade-in h-[calc(100vh-4rem)] flex flex-col">
      <div className="flex items-center justify-between shrink-0">
        <div>
          <h1 className="page-title">Meetings</h1>
          <p className="page-description">Organization-wide meeting schedules</p>
        </div>
        <div className="relative w-64">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search meetings..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 flex-1 min-h-0">
        {/* Column 1: Create Meeting */}
        <div className="flex flex-col gap-4">
            {(can("calendar", "can_create") || role === "tenant_admin") && (
            <Card className="h-full overflow-hidden flex flex-col">
                <CardHeader className="pb-3 bg-muted/30">
                    <CardTitle className="text-lg flex items-center gap-2">
                        <CalendarDays className="h-5 w-5" />
                        Schedule Meeting
                    </CardTitle>
                </CardHeader>
                <CardContent className="flex-1 overflow-y-auto p-4">
                    <form onSubmit={createMeeting} className="space-y-4">
                        <div>
                            <Label>Title</Label>
                            <Input value={title} onChange={e => setTitle(e.target.value)} required placeholder="Meeting title" />
                        </div>
                        <div className="grid grid-cols-1 gap-2">
                            <div><Label>Start</Label><Input type="datetime-local" value={startTime} onChange={e => setStartTime(e.target.value)} required /></div>
                            <div><Label>End</Label><Input type="datetime-local" value={endTime} onChange={e => setEndTime(e.target.value)} required /></div>
                        </div>
                        <div>
                            <Label>Project (optional)</Label>
                            <select value={projectId} onChange={e => setProjectId(e.target.value)} className="w-full border rounded-md h-10 px-3 bg-background text-sm">
                                <option value="">None</option>
                                {projects.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
                            </select>
                        </div>
                        <div>
                            <Label>Attendees</Label>
                            <ScrollArea className="h-40 border rounded-md p-2 mt-1.5">
                                <div className="space-y-2">
                                {profiles.map((p) => {
                                    const checked = selectedAttendees.includes(p.id as string);
                                    return (
                                    <label key={p.id} className="flex items-center gap-2 text-sm cursor-pointer hover:bg-muted/50 p-1 rounded">
                                        <input
                                        type="checkbox"
                                        checked={checked}
                                        className="rounded border-gray-300"
                                        onChange={(e) => {
                                            const uid = p.id as string;
                                            if (e.target.checked) {
                                            setSelectedAttendees((prev) => [...prev, uid]);
                                            } else {
                                            setSelectedAttendees((prev) => prev.filter((x) => x !== uid));
                                            }
                                        }}
                                        />
                                        <span className="truncate">{p.full_name || p.email}</span>
                                    </label>
                                    );
                                })}
                                </div>
                            </ScrollArea>
                        </div>
                        <Button type="submit" className="w-full">Create Meeting</Button>
                    </form>
                </CardContent>
            </Card>
            )}
        </div>

        {/* Column 2: Upcoming */}
        <div className="flex flex-col h-full overflow-hidden">
            <div className="flex items-center gap-2 mb-3 px-1">
                <CalendarDays className="h-5 w-5 text-primary" />
                <h2 className="font-semibold text-lg">Upcoming</h2>
                <Badge variant="outline" className="ml-auto">{upcoming.length}</Badge>
            </div>
            <ScrollArea className="flex-1 pr-4">
                {loading ? <p className="text-muted-foreground text-center py-4">Loading...</p> : 
                 upcoming.length === 0 ? <p className="text-muted-foreground text-center py-8 border rounded-lg border-dashed">No upcoming meetings</p> :
                 upcoming.map(m => <MeetingCard key={m.id} m={m} />)
                }
            </ScrollArea>
        </div>

        {/* Column 3: Completed */}
        <div className="flex flex-col h-full overflow-hidden">
            <div className="flex items-center gap-2 mb-3 px-1">
                <CheckCircle2 className="h-5 w-5 text-muted-foreground" />
                <h2 className="font-semibold text-lg text-muted-foreground">Completed</h2>
                <Badge variant="outline" className="ml-auto">{completed.length}</Badge>
            </div>
            <ScrollArea className="flex-1 pr-4">
                {loading ? <p className="text-muted-foreground text-center py-4">Loading...</p> :
                 completed.length === 0 ? <p className="text-muted-foreground text-center py-8 border rounded-lg border-dashed">No completed meetings</p> :
                 completed.map(m => <MeetingCard key={m.id} m={m} />)
                }
            </ScrollArea>
        </div>
      </div>
    </div>
  );
}
