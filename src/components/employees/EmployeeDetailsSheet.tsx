import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetDescription } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { Mail, Phone, Building2, MapPin, Calendar, User, Briefcase, Shield } from "lucide-react";
import { Tables } from "@/integrations/supabase/types";
import { EmployeeWithDetails } from "@/types/app";

interface EmployeeDetailsSheetProps {
  employee: EmployeeWithDetails | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function EmployeeDetailsSheet({ employee, open, onOpenChange }: EmployeeDetailsSheetProps) {
  if (!employee) return null;

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent className="w-[400px] sm:w-[540px]">
        <SheetHeader>
          <div className="flex items-center gap-4">
             <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center text-lg font-bold text-primary">
                {employee.profiles?.full_name?.[0] || employee.employee_id[0]}
             </div>
             <div>
                <SheetTitle>{employee.profiles?.full_name || employee.employee_id}</SheetTitle>
                <SheetDescription>{employee.designations?.title || "No Designation"}</SheetDescription>
             </div>
          </div>
        </SheetHeader>
        
        <ScrollArea className="h-[calc(100vh-100px)] mt-6 pr-4">
          <div className="space-y-6">
            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Briefcase className="h-4 w-4" /> Employment
              </h3>
              <div className="grid grid-cols-2 gap-4 pl-6">
                <div>
                  <span className="text-xs text-muted-foreground block">Department</span>
                  <p className="text-sm font-medium">{employee.departments?.name || "N/A"}</p>
                </div>
                <div>
                  <span className="text-xs text-muted-foreground block">Status</span>
                  <Badge variant={employee.status === 'active' ? 'default' : 'secondary'} className="mt-1">
                    {employee.status}
                  </Badge>
                </div>
                <div>
                  <span className="text-xs text-muted-foreground block">Join Date</span>
                  <p className="text-sm">{employee.hire_date ? new Date(employee.hire_date).toLocaleDateString() : "N/A"}</p>
                </div>
                <div>
                  <span className="text-xs text-muted-foreground block">Salary</span>
                  <p className="text-sm">₹{employee.salary?.toLocaleString() || "0"}</p>
                </div>
              </div>
            </div>

            <Separator />

            <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <User className="h-4 w-4" /> Contact Info
              </h3>
              <div className="grid grid-cols-1 gap-3 pl-6">
                <div className="flex items-center gap-2">
                   <Mail className="h-4 w-4 text-muted-foreground" />
                   <span>{employee.profiles?.email || "No email"}</span>
                </div>
                {employee.phone && (
                    <div className="flex items-center gap-2">
                       <Phone className="h-4 w-4 text-muted-foreground" />
                       <span>{employee.phone}</span>
                    </div>
                )}
                {employee.address && (
                    <div className="flex items-center gap-2">
                       <MapPin className="h-4 w-4 text-muted-foreground" />
                       <span>{employee.address}</span>
                    </div>
                )}
              </div>
            </div>
            
            <Separator />
            
             <div className="space-y-4">
              <h3 className="font-medium flex items-center gap-2">
                <Shield className="h-4 w-4" /> System Info
              </h3>
              <div className="pl-6 space-y-2">
                 <div>
                    <span className="text-xs text-muted-foreground block">User ID</span>
                    <p className="text-xs font-mono">{employee.id}</p>
                 </div>
              </div>
            </div>
            
          </div>
        </ScrollArea>
      </SheetContent>
    </Sheet>
  );
}
