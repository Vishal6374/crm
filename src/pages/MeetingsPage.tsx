import { useEffect, useState, useCallback } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, CalendarDays } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Tables } from "@/integrations/supabase/types";
import { usePermissions } from "@/hooks/use-permissions";
import { useAuth } from "@/contexts/AuthContext";

type Meeting = Tables<"events">;
type Project = Tables<"projects">;
type Profile = Pick<Tables<"profiles">, "id" | "full_name" | "email">;

export default function MeetingsPage() {
  const { user } = useAuth();
  const { toast } = useToast();
  const { can, role, orgId } = usePermissions();
  const [meetings, setMeetings] = useState<Meeting[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [tab, setTab] = useState<"upcoming" | "past">("upcoming");
  const [upcoming, setUpcoming] = useState<Meeting[]>([]);
  const [past, setPast] = useState<Meeting[]>([]);
  const [pageUpcoming, setPageUpcoming] = useState(0);
  const [pagePast, setPagePast] = useState(0);
  const PAGE_SIZE = 20;

  const fetchMeetings = useCallback(async () => {
    if (!orgId) {
      setLoading(false);
      return;
    }
    setLoading(true);
    let orgProjectIds: string[] = [];
    if (orgId) {
      const { data: projRows } = await supabase.from("projects").select("id").eq("organization_id", orgId as string);
      orgProjectIds = (projRows || []).map((r) => (r as { id: string }).id);
    }
    let builder = supabase.from("events").select("*").eq("type", "meeting").order("start_time", { ascending: true });
    if (orgId) {
      builder = builder.in("related_id", orgProjectIds.length ? orgProjectIds : [""]);
    }
    const { data, error } = await builder;
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
    const now = new Date();
    const uAll = visible.filter(m => new Date(m.start_time as unknown as string) >= now);
    const pAll = visible.filter(m => new Date(m.end_time as unknown as string) < now);
    setUpcoming(uAll.slice(0, PAGE_SIZE));
    setPast(pAll.slice(0, PAGE_SIZE));
    setLoading(false);
  }, [role, user?.id, orgId]);

  const fetchProjects = useCallback(async () => {
    if (!orgId) return;
    let builder = supabase.from("projects").select("id, name").order("name");
    if (orgId) {
      builder = builder.eq("organization_id", orgId as string);
    }
    const { data } = await builder;
    if (data) setProjects(data);
  }, [orgId]);

  const fetchProfiles = useCallback(async () => {
    if (!orgId) return;
    let builder = supabase.from("profiles").select("id, full_name, email").order("full_name");
    if (orgId) {
      builder = builder.eq("organization_id", orgId as string);
    }
    const { data } = await builder;
    if (data) setProfiles(data as Profile[]);
  }, [orgId]);

  useEffect(() => {
    if (orgId) {
      fetchMeetings();
      fetchProjects();
      fetchProfiles();
    }
  }, [
    orgId,
    fetchMeetings,
    fetchProjects,
    fetchProfiles,
  ]);

  async function createMeeting(e: React.FormEvent) {
    e.preventDefault();
    if (!can("calendar", "can_create")) {
      toast({ title: "Not allowed", description: "You do not have permission to create meetings.", variant: "destructive" });
      return;
    }
    if (!orgId) {
      toast({ title: "Invalid context", description: "No organization selected.", variant: "destructive" });
      return;
    }
    const form = e.target as HTMLFormElement;
    const fd = new FormData(form);
    const { error } = await supabase.from("events").insert([{
      title: String(fd.get("title") || "Meeting"),
      start_time: String(fd.get("start_time") || ""),
      end_time: String(fd.get("end_time") || ""),
      type: "meeting",
      related_id: String(fd.get("project_id") || ""),
      organization_id: orgId as string,
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Meeting created" });
      setDialogOpen(false);
      fetchMeetings();
    }
  }

  const filteredUpcoming = upcoming.filter((m) => (m.title || "").toLowerCase().includes(search.toLowerCase()));
  const filteredPast = past.filter((m) => (m.title || "").toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Meetings</h1>
          <p className="page-description">Organization-wide meeting schedules</p>
        </div>
        {can("calendar", "can_create") && (
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Button onClick={() => setDialogOpen(true)}><Plus className="h-4 w-4 mr-1" />New Meeting</Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader><DialogTitle>Create Meeting</DialogTitle></DialogHeader>
              <form onSubmit={createMeeting} className="space-y-3">
                <div><Label>Title</Label><Input name="title" required /></div>
                <div className="grid grid-cols-2 gap-2">
                  <div><Label>Start</Label><Input type="datetime-local" name="start_time" required /></div>
                  <div><Label>End</Label><Input type="datetime-local" name="end_time" required /></div>
                </div>
                <div>
                  <Label>Project (optional)</Label>
                  <select name="project_id" required className="w-full border rounded-md h-10 px-3">
                    {projects.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
                  </select>
                </div>
                <Button type="submit" className="w-full">Create</Button>
              </form>
            </DialogContent>
          </Dialog>
        )}
      </div>

      <div className="flex items-center justify-between">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search meetings..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
        <div className="flex gap-2">
          <Button variant={tab === "upcoming" ? "default" : "secondary"} onClick={() => setTab("upcoming")}>Upcoming</Button>
          <Button variant={tab === "past" ? "default" : "secondary"} onClick={() => setTab("past")}>Past</Button>
        </div>
      </div>

      <div className="border rounded-md h-[60vh] overflow-y-auto" onScroll={(e) => {
        const el = e.currentTarget;
        if (tab === "upcoming") {
          if (el.scrollTop + el.clientHeight >= el.scrollHeight - 20) {
            const now = new Date();
            const all = meetings.filter(m => new Date(m.start_time as unknown as string) >= now);
            const nextPage = pageUpcoming + 1;
            const next = all.slice(0, (nextPage + 1) * PAGE_SIZE);
            if (next.length > upcoming.length) {
              setUpcoming(next);
              setPageUpcoming(nextPage);
            }
          }
        } else {
          if (el.scrollTop + el.clientHeight >= el.scrollHeight - 20) {
            const now = new Date();
            const all = meetings.filter(m => new Date(m.end_time as unknown as string) < now);
            const nextPage = pagePast + 1;
            const next = all.slice(0, (nextPage + 1) * PAGE_SIZE);
            if (next.length > past.length) {
              setPast(next);
              setPagePast(nextPage);
            }
          }
        }
      }}>
        {loading ? (
          <div className="text-muted-foreground p-4">Loading...</div>
        ) : (tab === "upcoming" ? filteredUpcoming : filteredPast).length === 0 ? (
          <div className="text-muted-foreground p-4">No meetings found</div>
        ) : (
          (tab === "upcoming" ? filteredUpcoming : filteredPast).map((m) => (
            <div key={m.id} className="p-3 border-b flex items-center justify-between">
              <div>
                <div className="flex items-center gap-2">
                  <CalendarDays className="h-4 w-4 text-muted-foreground" />
                  <span className="font-medium">{m.title}</span>
                </div>
                <div className="text-sm text-muted-foreground mt-1">
                  {new Date(m.start_time as unknown as string).toLocaleString()} - {new Date(m.end_time as unknown as string).toLocaleString()}
                </div>
              </div>
              {m.meeting_link && (
                <Button asChild variant="ghost" size="sm">
                  <a href={m.meeting_link} target="_blank" rel="noopener noreferrer">Join</a>
                </Button>
              )}
            </div>
          ))
        )}
      </div>
    </div>
  );
}
