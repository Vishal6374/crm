import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { User, Calendar, Activity, Clock, FileText } from "lucide-react";
import { Tables } from "@/integrations/supabase/types";
import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { format } from "date-fns";

interface TaskDetailsSheetProps {
  task: Tables<'tasks'> | Tables<'project_tasks'> | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  isProjectTask?: boolean;
}

const priorityColors: Record<string, string> = {
  low: "bg-muted text-muted-foreground",
  medium: "bg-info/10 text-info",
  high: "bg-warning/10 text-warning",
  urgent: "bg-destructive/10 text-destructive",
};

export function TaskDetailsSheet({ task, open, onOpenChange, isProjectTask = false }: TaskDetailsSheetProps) {
  const [activities, setActivities] = useState<Tables<'activity_logs'>[]>([]);
  const [loadingActivities, setLoadingActivities] = useState(false);
  const [assignedTo, setAssignedTo] = useState<string>("");
  const [leadName, setLeadName] = useState<string>("");
  const [dealTitle, setDealTitle] = useState<string>("");
  const [projectName, setProjectName] = useState<string>("");
  const [comments, setComments] = useState<Array<{ id: string; content: string; created_at: string; author_id: string }>>([]);

  const fetchActivities = useCallback(async () => {
    if (!task) return;
    setLoadingActivities(true);
    const { data, error } = await supabase
      .from("activity_logs")
      .select("*")
      .eq("entity_type", isProjectTask ? "project_task" : "task")
      .eq("entity_id", task.id)
      .order("created_at", { ascending: false });

    if (!error) {
      setActivities(data || []);
    }
    setLoadingActivities(false);
  }, [task, isProjectTask]);

  const fetchDetails = useCallback(async () => {
    if (!task) return;
    
    // Fetch assigned user profile
    if (task.assigned_to) {
        const { data } = await supabase.from("profiles").select("full_name").eq("id", task.assigned_to).single();
        if (data) setAssignedTo(data.full_name || "");
    } else {
        setAssignedTo("Unassigned");
    }

    // Fetch related entities if they exist
    // Only check lead/deal if it's NOT a project task, or check if property exists
    if (!isProjectTask && 'lead_id' in task && task.lead_id) {
        const { data } = await supabase.from("leads").select("title, company_name").eq("id", task.lead_id).single();
        if (data) setLeadName(data.title || data.company_name || "");
    }
    if (!isProjectTask && 'deal_id' in task && task.deal_id) {
        const { data } = await supabase.from("deals").select("title").eq("id", task.deal_id).single();
        if (data) setDealTitle(data.title || "");
    }
    if (task.project_id) {
        const { data } = await supabase.from("projects").select("name").eq("id", task.project_id).single();
        if (data) setProjectName(data.name || "");
    }

    // Fetch comments
    const { data: commentsData } = await supabase
      .from("messages")
      .select("id, content, created_at, author_id")
      .eq("entity_type", isProjectTask ? "project_task" : "task")
      .eq("entity_id", task.id)
      .order("created_at", { ascending: false });
    setComments(commentsData || []);

  }, [task, isProjectTask]);

  useEffect(() => {
    if (task?.id && open) {
      fetchActivities();
      fetchDetails();
    }
  }, [task?.id, open, fetchActivities, fetchDetails]);

  if (!task) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px] overflow-y-auto">
        <SheetHeader>
          <div className="flex items-center justify-between">
            <SheetTitle className="text-xl">{task.title}</SheetTitle>
            <Badge className={priorityColors[task.priority || "medium"] || "bg-muted"}>{task.priority}</Badge>
          </div>
          <SheetDescription>
            <div className="flex items-center gap-2 mt-1">
                <Badge variant="outline">{task.status.replace("_", " ")}</Badge>
                {task.due_date && (
                    <span className="text-xs flex items-center gap-1 text-muted-foreground">
                        <Calendar className="h-3 w-3" /> Due {new Date(task.due_date).toLocaleDateString()}
                    </span>
                )}
            </div>
          </SheetDescription>
        </SheetHeader>
        
        <Tabs defaultValue="details" className="w-full mt-6">
          <TabsList className="w-full">
            <TabsTrigger value="details" className="flex-1">Details</TabsTrigger>
            <TabsTrigger value="activity" className="flex-1">Activity Log</TabsTrigger>
            <TabsTrigger value="comments" className="flex-1">Comments</TabsTrigger>
          </TabsList>

          <TabsContent value="details" className="space-y-6 mt-6">
            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <FileText className="h-4 w-4" /> Description
              </h3>
              <p className="text-sm text-muted-foreground whitespace-pre-wrap p-3 bg-muted/30 rounded-md">
                {task.description || "No description provided."}
              </p>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Activity className="h-4 w-4" /> Context
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <span className="text-xs text-muted-foreground flex items-center gap-1"><User className="h-3 w-3"/> Assigned To</span>
                  <p className="text-sm font-medium">{assignedTo}</p>
                </div>
                {leadName && (
                    <div>
                        <span className="text-xs text-muted-foreground">Lead</span>
                        <p className="text-sm">{leadName}</p>
                    </div>
                )}
                {dealTitle && (
                    <div>
                        <span className="text-xs text-muted-foreground">Deal</span>
                        <p className="text-sm">{dealTitle}</p>
                    </div>
                )}
                {projectName && (
                    <div>
                        <span className="text-xs text-muted-foreground">Project</span>
                        <p className="text-sm">{projectName}</p>
                    </div>
                )}
              </div>
            </div>

            <Separator />
            
            <div className="text-xs text-muted-foreground">
              Created on {new Date(task.created_at).toLocaleDateString()}
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
            <ScrollArea className="h-[calc(100vh-300px)] pr-4">
              {comments.length === 0 ? (
                <div className="text-center py-8 text-muted-foreground">No comments yet.</div>
              ) : (
                 <div className="space-y-4">
                   {comments.map((comment) => (
                     <div key={comment.id} className="p-3 rounded-lg bg-muted/50 text-sm">
                       <p>{comment.content}</p>
                       <p className="text-xs text-muted-foreground mt-2 text-right">
                         {format(new Date(comment.created_at), "MMM d, h:mm a")}
                       </p>
                     </div>
                   ))}
                 </div>
              )}
            </ScrollArea>
          </TabsContent>
        </Tabs>
      </SheetContent>
    </Sheet>
  );
}