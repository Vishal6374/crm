import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Mail, Phone, Building2, MapPin, Calendar, StickyNote } from "lucide-react";
import { Tables } from "@/integrations/supabase/types";

interface ContactDetailsSheetProps {
  contact: Tables<'contacts'>;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function ContactDetailsSheet({ contact, open, onOpenChange }: ContactDetailsSheetProps) {
  if (!contact) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px]">
        <SheetHeader>
          <div className="flex items-center gap-4">
             <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center text-lg font-bold text-primary">
                {contact.first_name?.[0]}{contact.last_name?.[0]}
             </div>
             <div>
                <SheetTitle>{contact.first_name} {contact.last_name}</SheetTitle>
                <SheetDescription>{contact.email}</SheetDescription>
             </div>
          </div>
        </SheetHeader>
        
        <ScrollArea className="h-[calc(100vh-100px)] mt-6 pr-4">
          <div className="space-y-6">
            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Building2 className="h-4 w-4" /> Company
              </h3>
              <div className="pl-6">
                <p className="font-medium">{contact.companies?.name || "No Company"}</p>
                {contact.companies?.industry && <p className="text-sm text-muted-foreground">{contact.companies.industry}</p>}
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <StickyNote className="h-4 w-4" /> Contact Info
              </h3>
              <div className="grid grid-cols-1 gap-3 pl-6">
                <div className="flex items-center gap-2">
                   <Mail className="h-4 w-4 text-muted-foreground" />
                   <span>{contact.email}</span>
                </div>
                {contact.phone && (
                    <div className="flex items-center gap-2">
                       <Phone className="h-4 w-4 text-muted-foreground" />
                       <span>{contact.phone}</span>
                    </div>
                )}
              </div>
            </div>

            <Separator />

            {contact.notes && (
                <div className="space-y-4">
                  <h3 className="font-medium flex items-center gap-2">
                    <StickyNote className="h-4 w-4" /> Notes
                  </h3>
                  <p className="text-sm text-muted-foreground pl-6 whitespace-pre-wrap">
                    {contact.notes}
                  </p>
                </div>
            )}
            
            <Separator />
            
            <div className="text-xs text-muted-foreground">
              Created on {new Date(contact.created_at).toLocaleDateString()}
            </div>
          </div>
        </ScrollArea>
      </SheetContent>
    </Sheet>
  );
}
