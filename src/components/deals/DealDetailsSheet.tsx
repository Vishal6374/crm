import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { User, Building2, Calendar, IndianRupee, Activity, Percent, Clock, FileText } from "lucide-react";
import { Tables } from "@/integrations/supabase/types";
import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { format } from "date-fns";

interface DealDetailsSheetProps {
  deal: Tables<'deals'>;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function DealDetailsSheet({ deal, open, onOpenChange }: DealDetailsSheetProps) {
  const [activities, setActivities] = useState<Tables<'activity_logs'>[]>([]);
  const [loadingActivities, setLoadingActivities] = useState(false);

  const fetchActivities = useCallback(async () => {
    if (!deal) return;
    setLoadingActivities(true);
    const { data, error } = await supabase
      .from("activity_logs")
      .select("*")
      .eq("entity_type", "deals") // matches table name usually
      .eq("entity_id", deal.id)
      .order("created_at", { ascending: false });

    if (!error) {
      setActivities(data || []);
    }
    setLoadingActivities(false);
  }, [deal]);

  useEffect(() => {
    if (deal?.id && open) {
      fetchActivities();
    }
  }, [deal?.id, open, fetchActivities]);

  if (!deal) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px] overflow-y-auto">
        <SheetHeader>
          <div className="flex items-center justify-between">
            <SheetTitle>{deal.title}</SheetTitle>
            <Badge variant="outline">{deal.stage.replace("_", " ")}</Badge>
          </div>
          <SheetDescription>
            Deal details and information
          </SheetDescription>
        </SheetHeader>
        
        <Tabs defaultValue="details" className="w-full mt-6">
          <TabsList className="w-full">
            <TabsTrigger value="details" className="flex-1">Details</TabsTrigger>
            <TabsTrigger value="activity" className="flex-1">Activity Log</TabsTrigger>
          </TabsList>

          <TabsContent value="details" className="space-y-6 mt-6">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-1">
                <span className="text-sm text-muted-foreground flex items-center gap-2">
                  <IndianRupee className="h-4 w-4" /> Value
                </span>
                <p className="font-medium text-lg">₹{Number(deal.value || 0).toLocaleString()}</p>
              </div>
              <div className="space-y-1">
                <span className="text-sm text-muted-foreground flex items-center gap-2">
                  <Percent className="h-4 w-4" /> Probability
                </span>
                <p className="font-medium text-lg">{deal.probability}%</p>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Building2 className="h-4 w-4" /> Company & Contact
              </h3>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <span className="text-xs text-muted-foreground">Company</span>
                  <p>{deal.companies?.name || "N/A"}</p>
                </div>
                <div>
                  <span className="text-xs text-muted-foreground">Contact</span>
                  <p>{deal.contacts?.first_name ? `${deal.contacts.first_name} ${deal.contacts.last_name}` : "N/A"}</p>
                </div>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Activity className="h-4 w-4" /> Information
              </h3>
              <div className="space-y-3">
                <div>
                  <span className="text-xs text-muted-foreground block">Description</span>
                  <p className="text-sm mt-1">{deal.description || "No description provided."}</p>
                </div>
                <div className="grid grid-cols-2 gap-4">
                    <div>
                        <span className="text-xs text-muted-foreground block flex items-center gap-1"><Calendar className="h-3 w-3"/> Expected Close</span>
                        <p className="text-sm">{deal.expected_close_date ? new Date(deal.expected_close_date).toLocaleDateString() : "-"}</p>
                    </div>
                    <div>
                        <span className="text-xs text-muted-foreground block flex items-center gap-1"><User className="h-3 w-3"/> Assigned To</span>
                        <p className="text-sm">{deal.assigned_to_profile?.full_name || "Unassigned"}</p>
                    </div>
                </div>
              </div>
            </div>
            
            <Separator />
            
            <div className="text-xs text-muted-foreground">
              Created on {new Date(deal.created_at).toLocaleDateString()}
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
        </Tabs>
      </SheetContent>
    </Sheet>
  );
}
