import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Search, Folder, Trash2, Pencil } from "lucide-react";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Tables } from "@/integrations/supabase/types";
import { usePermissions } from "@/hooks/use-permissions";
import { useAuth } from "@/contexts/AuthContext";

export default function ProjectsPage() {
  const { toast } = useToast();
  const navigate = useNavigate();
  const { can } = usePermissions();
  const { user } = useAuth();
  const [projects, setProjects] = useState<Tables<'projects'>[]>([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [dialogOpen, setDialogOpen] = useState(false);
  const [formData, setFormData] = useState({ name: "", description: "" });
  const [editingId, setEditingId] = useState<string | null>(null);

  useEffect(() => {
    fetchProjects();
  }, []);

  async function fetchProjects() {
    const { data, error } = await supabase
      .from("projects")
      .select("*")
      .order("name");
    if (!error) setProjects(data || []);
    setLoading(false);
  }

  async function createProject(e: React.FormEvent) {
    e.preventDefault();
    if (!can("projects", "can_create")) {
      toast({ title: "Not allowed", description: "You do not have permission to create projects.", variant: "destructive" });
      return;
    }
    const { data: created, error } = await supabase.from("projects").insert([{
      name: formData.name,
      description: formData.description || null,
      owner_id: user?.id || null
    }]).select().maybeSingle();
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      if (created?.id && user?.id) {
        const { data: emp } = await supabase
          .from("employees")
          .select("id, user_id")
          .eq("user_id", user.id)
          .maybeSingle();
        const employeeId = emp?.id;
        if (employeeId) {
          await supabase.from("project_members").insert([{ project_id: created.id, employee_id: employeeId }]);
        }
      }
      toast({ title: "Project created successfully" });
      setDialogOpen(false);
      setFormData({ name: "", description: "" });
      setEditingId(null);
      fetchProjects();
    }
  }

  async function updateProject(e: React.FormEvent) {
    e.preventDefault();
    if (!editingId) return;
    if (!can("projects", "can_edit")) {
      toast({ title: "Not allowed", description: "You do not have permission to edit projects.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("projects")
      .update({ name: formData.name, description: formData.description || null })
      .eq("id", editingId);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Project updated successfully" });
      setDialogOpen(false);
      setFormData({ name: "", description: "" });
      setEditingId(null);
      fetchProjects();
    }
  }

  async function deleteProject(id: string) {
    if (!can("projects", "can_edit")) {
      toast({ title: "Not allowed", description: "You do not have permission to delete projects.", variant: "destructive" });
      return;
    }
    const { error } = await supabase.from("projects").delete().eq("id", id);
    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Project deleted" });
      fetchProjects();
    }
  }

  const filteredProjects = projects.filter((p) =>
    (p.name || "").toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="space-y-6 animate-fade-in">
      {!can("projects", "can_view") ? (
        <div className="text-sm text-muted-foreground">You do not have permission to view projects.</div>
      ) : (
      <>
      <div className="flex items-center justify-between">
        <div>
          <h1 className="page-title">Projects</h1>
          <p className="page-description">Organize work by projects</p>
        </div>
        <Dialog
          open={dialogOpen}
          onOpenChange={(open) => {
            setDialogOpen(open);
            if (!open) {
              setEditingId(null);
              setFormData({ name: "", description: "" });
            }
          }}
        >
          <DialogTrigger asChild>
            {can("projects", "can_create") && <Button
              onClick={() => {
                setEditingId(null);
                setFormData({ name: "", description: "" });
              }}
            >
              <Plus className="mr-2 h-4 w-4" />
              New Project
            </Button>}
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>{editingId ? "Edit Project" : "Create Project"}</DialogTitle>
            </DialogHeader>
            <form onSubmit={editingId ? updateProject : createProject} className="space-y-4">
              <div><Label>Name</Label><Input value={formData.name} onChange={(e) => setFormData({ ...formData, name: e.target.value })} required /></div>
              <div><Label>Description</Label><Textarea value={formData.description} onChange={(e) => setFormData({ ...formData, description: e.target.value })} /></div>
              <Button type="submit" className="w-full">{editingId ? "Update Project" : "Create Project"}</Button>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <div className="flex gap-4">
        <div className="relative flex-1 max-w-sm">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
          <Input placeholder="Search projects..." value={search} onChange={(e) => setSearch(e.target.value)} className="pl-9" />
        </div>
      </div>

      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
        {loading ? (
          <p className="text-muted-foreground col-span-full text-center py-8">Loading...</p>
        ) : filteredProjects.length === 0 ? (
          <p className="text-muted-foreground col-span-full text-center py-8">No projects found</p>
        ) : (
          filteredProjects.map((p) => (
            <Card 
              key={p.id} 
              className="hover:shadow-md transition-shadow cursor-pointer"
              onClick={() => navigate(`/projects/${p.id}`)}
            >
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center gap-2">
                      <Folder className="h-4 w-4 text-muted-foreground" />
                      <h3 className="font-semibold">{p.name}</h3>
                    </div>
                    {p.description && <p className="text-sm text-muted-foreground mt-1">{p.description}</p>}
                  </div>
                  <div className="flex items-center gap-1">
                    {can("projects", "can_edit") && (
                      <Button
                        variant="ghost"
                        size="icon"
                        onClick={(e) => {
                          e.stopPropagation();
                          setEditingId(p.id);
                          setFormData({ name: p.name || "", description: p.description || "" });
                          setDialogOpen(true);
                        }}
                      >
                        <Pencil className="h-4 w-4" />
                      </Button>
                    )}
                    {can("projects", "can_edit") && (
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        className="text-destructive" 
                        onClick={(e) => { e.stopPropagation(); deleteProject(p.id); }}
                      >
                        <Trash2 className="h-4 w-4" />
                      </Button>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))
        )}
      </div>
      </>
      )}
    </div>
  );
}
