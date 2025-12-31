import { Tables } from "@/integrations/supabase/types";

export interface DealWithDetails extends Tables<'deals'> {
  companies?: { id: string; name: string };
  contacts?: { id: string; first_name: string | null; last_name: string | null };
  assigned_to_profile?: { id: string; full_name: string | null };
}

export interface EmployeeWithDetails extends Tables<'employees'> {
  departments?: { name: string } | null;
  designations?: { title: string } | null;
  profiles?: { full_name: string | null; email: string | null } | null;
}

export interface LeadWithDetails extends Tables<'leads'> {
  assigned_to_profile?: { id: string; full_name: string | null };
}
