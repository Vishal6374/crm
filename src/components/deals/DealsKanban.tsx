import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { MoreHorizontal, Pencil, Trash2, CheckCircle, XCircle, MoveHorizontal, MessageSquare, DollarSign, User } from "lucide-react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger, DropdownMenuSub, DropdownMenuSubTrigger, DropdownMenuSubContent } from "@/components/ui/dropdown-menu";
import { Tables } from "@/integrations/supabase/types";

interface DealStage {
  value: string;
  label: string;
  deals: Tables<'deals'>[];
  total: number;
}

interface DealsKanbanProps {
  stages: DealStage[];
  employees?: Tables<'profiles'>[];
  onDragOver: (e: React.DragEvent) => void;
  onDrop: (e: React.DragEvent, stage: string) => void;
  onDragStart: (e: React.DragEvent, id: string) => void;
  onUpdateStage: (deal: Tables<'deals'>, stage: string) => void;
  onDelete: (id: string) => void;
  onComments: (id: string) => void;
  onAssign?: (dealId: string, userId: string) => void;
  onView: (deal: Tables<'deals'>) => void;
}

export function DealsKanban({ stages, employees = [], onDragOver, onDrop, onDragStart, onUpdateStage, onDelete, onComments, onAssign, onView }: DealsKanbanProps) {
  return (
    <div className="overflow-x-auto">
      <div className="flex gap-4 px-1 pb-2">
        {stages.map((stage) => (
          <div
            key={stage.value}
            className="w-72 flex-shrink-0 rounded-lg border bg-muted/30"
            onDragOver={onDragOver}
            onDrop={(e) => onDrop(e, stage.value)}
          >
            <div className="sticky top-0 z-10 p-3 border-b bg-card/80 backdrop-blur">
              <div className="flex items-center justify-between">
                <span className="text-sm font-medium">{stage.label}</span>
                <Badge variant="secondary">{stage.deals.length}</Badge>
              </div>
              <p className="text-xs text-muted-foreground flex items-center gap-1 mt-1">
                <DollarSign className="h-3 w-3" />{stage.total.toLocaleString()}
              </p>
            </div>
            <div className="p-2 space-y-2">
              {stage.deals.length === 0 ? (
                <p className="text-xs text-muted-foreground text-center py-4">No deals</p>
              ) : (
                stage.deals.map((deal: Tables<'deals'>) => (
                  <Card 
                    key={deal.id} 
                    className="bg-card shadow-sm cursor-pointer hover:shadow-md transition-shadow group" 
                    draggable 
                    onDragStart={(e) => onDragStart(e, deal.id)}
                    onClick={() => onView(deal)}
                  >
                    <CardContent className="p-3">
                      <div className="flex items-start justify-between gap-2">
                        <div className="min-w-0">
                          <h4 className="font-medium text-sm truncate">{deal.title}</h4>
                          <p className="text-xs text-muted-foreground">${Number(deal.value || 0).toLocaleString()}</p>
                          {deal.companies?.name && <p className="text-xs text-muted-foreground mt-1">{deal.companies.name}</p>}
                          {deal.assigned_to_profile && (
                             <p className="text-xs text-primary flex items-center gap-1 mt-1">
                               <User className="h-3 w-3" /> {deal.assigned_to_profile.full_name}
                             </p>
                          )}
                        </div>
                        <DropdownMenu>
                          <DropdownMenuTrigger asChild>
                            <Button variant="ghost" size="icon" onClick={(e) => e.stopPropagation()}><MoreHorizontal className="h-4 w-4" /></Button>
                          </DropdownMenuTrigger>
                          <DropdownMenuContent align="end">
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onView(deal); }}>
                                <DollarSign className="mr-2 h-4 w-4" /> View Details
                            </DropdownMenuItem>
                            {onAssign && (
                                <DropdownMenuSub>
                                  <DropdownMenuSubTrigger>
                                    <User className="mr-2 h-4 w-4" /> Assign
                                  </DropdownMenuSubTrigger>
                                  <DropdownMenuSubContent>
                                    {employees.map((emp: Tables<'profiles'>) => (
                                      <DropdownMenuItem key={emp.id} onClick={(e) => { e.stopPropagation(); onAssign(deal.id, emp.id); }}>
                                        {emp.full_name}
                                      </DropdownMenuItem>
                                    ))}
                                  </DropdownMenuSubContent>
                                </DropdownMenuSub>
                            )}
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onUpdateStage(deal, "qualification"); }}>
                              <MoveHorizontal className="mr-2 h-4 w-4" /> Move to Qualification
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onUpdateStage(deal, "proposal"); }}>
                              <MoveHorizontal className="mr-2 h-4 w-4" /> Move to Proposal
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onUpdateStage(deal, "negotiation"); }}>
                              <MoveHorizontal className="mr-2 h-4 w-4" /> Move to Negotiation
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onUpdateStage(deal, "closed_won"); }}>
                              <CheckCircle className="mr-2 h-4 w-4 text-success" /> Mark Won
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onUpdateStage(deal, "closed_lost"); }}>
                              <XCircle className="mr-2 h-4 w-4 text-destructive" /> Mark Lost
                            </DropdownMenuItem>
                            <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onDelete(deal.id); }}>
                              <Trash2 className="mr-2 h-4 w-4" /> Delete
                            </DropdownMenuItem>
                            {/* <DropdownMenuItem onClick={(e) => { e.stopPropagation(); onComments(deal.id); }}>
                              <MessageSquare className="mr-2 h-4 w-4" /> Comments
                            </DropdownMenuItem> */}
                          </DropdownMenuContent>
                        </DropdownMenu>
                      </div>
                    </CardContent>
                  </Card>
                ))
              )}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
