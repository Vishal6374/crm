import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { User, Building2, Calendar, IndianRupee, Activity, Percent } from "lucide-react";
import { Tables } from "@/integrations/supabase/types";

interface DealDetailsSheetProps {
  deal: Tables<'deals'>;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function DealDetailsSheet({ deal, open, onOpenChange }: DealDetailsSheetProps) {
  if (!deal) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px]">
        <SheetHeader>
          <div className="flex items-center justify-between">
            <SheetTitle>{deal.title}</SheetTitle>
            <Badge variant="outline">{deal.stage.replace("_", " ")}</Badge>
          </div>
          <SheetDescription>
            Deal details and information
          </SheetDescription>
        </SheetHeader>
        
        <ScrollArea className="h-[calc(100vh-100px)] mt-6 pr-4">
          <div className="space-y-6">
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
          </div>
        </ScrollArea>
      </SheetContent>
    </Sheet>
  );
}
