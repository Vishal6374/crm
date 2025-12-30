import { useEffect, useState } from "react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, CalendarDays } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Tables } from "@/integrations/supabase/types";

type Meeting = Tables<"events">;
type Project = Tables<"projects">;

export default function MeetingsPage() {
  const { toast } = useToast();
  const [meetings, setMeetings] = useState<Meeting[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);

  useEffect(() => {
    fetchMeetings();
    fetchProjects();
  }, []);

  async function fetchMeetings() {
    const { data, error } = await supabase
      .from("events")
      .select("*")
      .eq("type", "meeting")
      .order("start_time", { ascending: true });
    if (!error) setMeetings(data || []);
    setLoading(false);
  }

  async function fetchProjects() {
    const { data } = await supabase.from("projects").select("id, name").order("name");
    if (data) setProjects(data);
  }

  async function createMeeting(e: React.FormEvent) {
    e.preventDefault();
    const form = e.target as HTMLFormElement;
    const fd = new FormData(form);
    const { error } = await supabase.from("events").insert([{
      title: String(fd.get("title") || "Meeting"),
      start_time: String(fd.get("start_time") || ""),
      end_time: String(fd.get("end_time") || ""),
      type: "meeting",
      related_id: String(fd.get("project_id") || ""),
    }]);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Meeting created" });
      setDialogOpen(false);
      fetchMeetings();
      form.reset();
    }
  }

  const filtered = meetings.filter((m) => (m.title || "").toLowerCase().includes(search.toLowerCase()));

  return (
    <div className="space-y-6 animate-fade-in">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Meetings</h1>
          <p className="page-description">Organization-wide meeting schedules</p>
        </div>
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
                <select name="project_id" className="w-full border rounded-md h-10 px-3">
                  <option value="">None</option>
                  {projects.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
                </select>
              </div>
              <Button type="submit" className="w-full">Create</Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search meetings..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {loading ? (
          <p className="text-muted-foreground col-span-full text-center py-8">Loading...</p>
        ) : filtered.length === 0 ? (
          <p className="text-muted-foreground col-span-full text-center py-8">No meetings found</p>
        ) : (
          filtered.map((m) => (
            <Card key={m.id} className="hover:shadow-md transition-shadow">
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <CalendarDays className="h-4 w-4 text-muted-foreground" />
                      <h3 className="font-semibold">{m.title}</h3>
                    </div>
                    <div className="text-sm text-muted-foreground mt-1">
                      {new Date(m.start_time as unknown as string).toLocaleString()} - {new Date(m.end_time as unknown as string).toLocaleString()}
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))
        )}
      </div>
    </div>
  );
}
