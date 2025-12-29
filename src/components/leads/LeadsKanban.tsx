import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Button } from "@/components/ui/button";
import { MoreHorizontal, Pencil, UserCheck, Trash2, Eye } from "lucide-react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { Tables } from "@/integrations/supabase/types";

const statusColumns = [
  { id: "new", label: "New", color: "bg-info/10 text-info" },
  { id: "contacted", label: "Contacted", color: "bg-warning/10 text-warning" },
  { id: "qualified", label: "Qualified", color: "bg-primary/10 text-primary" },
  { id: "proposal", label: "Proposal", color: "bg-chart-4/10 text-chart-4" },
  { id: "negotiation", label: "Negotiation", color: "bg-chart-5/10 text-chart-5" },
  { id: "won", label: "Won", color: "bg-success/10 text-success" },
  { id: "lost", label: "Lost", color: "bg-destructive/10 text-destructive" },
];

interface LeadsKanbanProps {
  leads: Tables<'leads'>[];
  onEdit: (lead: Tables<'leads'>) => void;
  onDelete: (id: string) => void;
  onConvert: (lead: Tables<'leads'>) => void;
  onView: (lead: Tables<'leads'>) => void;
  onUpdateStatus?: (leadId: string, status: string) => void;
}

export function LeadsKanban({ leads, onEdit, onDelete, onConvert, onView, onUpdateStatus }: LeadsKanbanProps) {
  return (
    <div className="flex gap-4 overflow-x-auto pb-4 h-[calc(100vh-250px)]">
      {statusColumns.map((column) => {
        const columnLeads = leads.filter((lead) => lead.status === column.id);
        
        return (
          <div
            key={column.id}
            className="min-w-[300px] flex flex-col h-full rounded-lg bg-muted/30 border"
            onDragOver={(e) => e.preventDefault()}
            onDrop={(e) => {
              const leadId = e.dataTransfer.getData("leadId");
              if (leadId && onUpdateStatus) onUpdateStatus(leadId, column.id);
            }}
          >
            <div className="p-3 border-b flex items-center justify-between bg-background/50 backdrop-blur sticky top-0 z-10">
              <div className="flex items-center gap-2">
                <Badge variant="secondary" className={column.color}>
                  {column.label}
                </Badge>
                <span className="text-xs text-muted-foreground">{columnLeads.length}</span>
              </div>
            </div>
            
            <ScrollArea className="flex-1 p-3">
              <div className="space-y-3">
                {columnLeads.map((lead) => (
                  <Card 
                    key={lead.id} 
                    className="cursor-pointer hover:shadow-md transition-shadow group"
                    draggable
                    onDragStart={(e) => e.dataTransfer.setData("leadId", lead.id)}
                  >
                    <CardContent className="p-4 space-y-3">
                      <div className="flex justify-between items-start">
                        <div className="space-y-1">
                          <h4 className="font-semibold text-sm">{lead.company_name || lead.title}</h4>
                          <p className="text-xs text-muted-foreground">{lead.contact_name}</p>
                          {lead.assigned_to_profile && (
                             <p className="text-xs text-primary flex items-center gap-1">
                               {lead.assigned_to_profile.full_name}
                             </p>
                          )}
                        </div>
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" className="h-6 w-6 p-0 opacity-0 group-hover:opacity-100 transition-opacity">
                              <MoreHorizontal className="h-3 w-3" />
                            </Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuItem onClick={() => onView(lead)}>
                              <Eye className="mr-2 h-4 w-4" /> View Details
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={() => onEdit(lead)}>
                              <Pencil className="mr-2 h-4 w-4" /> Edit
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={() => onConvert(lead)}>
                              <UserCheck className="mr-2 h-4 w-4" /> Convert
                            </DropdownMenuItem>
                            <DropdownMenuItem className="text-destructive" onClick={() => onDelete(lead.id)}>
                              <Trash2 className="mr-2 h-4 w-4" /> Delete
                            </DropdownMenuItem>
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </div>
                      
                      <div className="flex items-center justify-between text-xs text-muted-foreground">
                        <span>{lead.source || "No Source"}</span>
                        <span>${Number(lead.value || 0).toLocaleString()}</span>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </ScrollArea>
          </div>
        );
      })}
    </div>
  );
}
