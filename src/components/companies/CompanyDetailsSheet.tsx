import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Building2, Globe, StickyNote } from "lucide-react";
import { Tables } from "@/integrations/supabase/types";

interface CompanyDetailsSheetProps {
  company: Tables<'companies'>;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function CompanyDetailsSheet({ company, open, onOpenChange }: CompanyDetailsSheetProps) {
  if (!company) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px]">
        <SheetHeader>
          <div className="flex items-center gap-4">
             <div className="h-12 w-12 rounded bg-primary/10 flex items-center justify-center text-lg font-bold text-primary">
                <Building2 className="h-6 w-6" />
             </div>
             <div>
                <SheetTitle>{company.name}</SheetTitle>
                <SheetDescription>{company.industry}</SheetDescription>
             </div>
          </div>
        </SheetHeader>
        
        <ScrollArea className="h-[calc(100vh-100px)] mt-6 pr-4">
          <div className="space-y-6">
            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Globe className="h-4 w-4" /> Website
              </h3>
              <div className="pl-6">
                {company.website ? (
                  <a href={company.website} target="_blank" rel="noopener noreferrer" className="text-primary hover:underline">
                    {company.website}
                  </a>
                ) : (
                  <span className="text-muted-foreground">No website</span>
                )}
              </div>
            </div>

            <Separator />

            {company.notes && (
                <div className="space-y-4">
                  <h3 className="font-medium flex items-center gap-2">
                    <StickyNote className="h-4 w-4" /> Notes
                  </h3>
                  <p className="text-sm text-muted-foreground pl-6 whitespace-pre-wrap">
                    {company.notes}
                  </p>
                </div>
            )}
            
            <Separator />
            
            <div className="text-xs text-muted-foreground">
              Created on {new Date(company.created_at).toLocaleDateString()}
            </div>
          </div>
        </ScrollArea>
      </SheetContent>
    </Sheet>
  );
}
