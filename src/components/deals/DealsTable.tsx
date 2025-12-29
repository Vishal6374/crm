import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { MoreHorizontal, Pencil, Trash2, Eye, User } from "lucide-react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger, DropdownMenuSub, DropdownMenuSubTrigger, DropdownMenuSubContent } from "@/components/ui/dropdown-menu";
import { Tables } from "@/integrations/supabase/types";

const stageColors: Record<string, string> = {
  prospecting: "bg-muted text-muted-foreground",
  qualification: "bg-info/10 text-info",
  proposal: "bg-warning/10 text-warning",
  negotiation: "bg-primary/10 text-primary",
  closed_won: "bg-success/10 text-success",
  closed_lost: "bg-destructive/10 text-destructive",
};

interface DealsTableProps {
  deals: Tables<'deals'>[];
  employees?: Tables<'profiles'>[];
  onEdit: (deal: Tables<'deals'>) => void;
  onDelete: (id: string) => void;
  onView: (deal: Tables<'deals'>) => void;
  onAssign?: (dealId: string, userId: string) => void;
}

export function DealsTable({ deals, employees = [], onEdit, onDelete, onView, onAssign }: DealsTableProps) {
  return (
    <div className="rounded-md border">
      <Table>
        <TableHeader>
          <TableRow>
            <TableHead>Title</TableHead>
            <TableHead>Company</TableHead>
            <TableHead>Contact</TableHead>
            <TableHead>Stage</TableHead>
            <TableHead>Value</TableHead>
            <TableHead>Assigned</TableHead>
            <TableHead>Created</TableHead>
            <TableHead className="text-right">Actions</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {deals.length === 0 ? (
            <TableRow>
              <TableCell colSpan={8} className="text-center h-24 text-muted-foreground">
                No deals found.
              </TableCell>
            </TableRow>
          ) : (
            deals.map((deal) => (
              <TableRow key={deal.id}>
                <TableCell className="font-medium">{deal.title}</TableCell>
                <TableCell>{deal.companies?.name || "-"}</TableCell>
                <TableCell>{deal.contacts?.first_name ? `${deal.contacts.first_name} ${deal.contacts.last_name}` : "-"}</TableCell>
                <TableCell>
                  <Badge className={stageColors[deal.stage] || "bg-muted"}>
                    {deal.stage.replace("_", " ").replace(/\b\w/g, l => l.toUpperCase())}
                  </Badge>
                </TableCell>
                <TableCell>${Number(deal.value || 0).toLocaleString()}</TableCell>
                <TableCell>
                  {deal.assigned_to_profile?.full_name || "-"}
                </TableCell>
                <TableCell>{new Date(deal.created_at).toLocaleDateString()}</TableCell>
                <TableCell className="text-right">
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" className="h-8 w-8 p-0">
                        <span className="sr-only">Open menu</span>
                        <MoreHorizontal className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => onView(deal)}>
                        <Eye className="mr-2 h-4 w-4" /> View Details
                      </DropdownMenuItem>
                      {onAssign && (
                        <DropdownMenuSub>
                          <DropdownMenuSubTrigger>
                            <User className="mr-2 h-4 w-4" /> Assign
                          </DropdownMenuSubTrigger>
                          <DropdownMenuSubContent>
                            {employees.map((emp) => (
                              <DropdownMenuItem key={emp.id} onClick={() => onAssign(deal.id, emp.id)}>
                                {emp.full_name}
                              </DropdownMenuItem>
                            ))}
                          </DropdownMenuSubContent>
                        </DropdownMenuSub>
                      )}
                      <DropdownMenuItem onClick={() => onEdit(deal)}>
                        <Pencil className="mr-2 h-4 w-4" /> Edit
                      </DropdownMenuItem>
                      <DropdownMenuItem className="text-destructive" onClick={() => onDelete(deal.id)}>
                        <Trash2 className="mr-2 h-4 w-4" /> Delete
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </TableCell>
              </TableRow>
            ))
          )}
        </TableBody>
      </Table>
    </div>
  );
}
