export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          full_name: string | null
          email: string | null
          organization_id: string
        }
        Insert: {
          id: string
          full_name?: string | null
          email?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          full_name?: string | null
          email?: string | null
          organization_id?: string
        }
      }
      companies: {
        Row: {
          id: string
          name: string
          email: string | null
          phone: string | null
          website: string | null
          industry: string | null
          address: string | null
          city: string | null
          country: string | null
          created_at: string
          created_by: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          name: string
          email?: string | null
          phone?: string | null
          website?: string | null
          industry?: string | null
          address?: string | null
          city?: string | null
          country?: string | null
          created_at?: string
          created_by?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          name?: string
          email?: string | null
          phone?: string | null
          website?: string | null
          industry?: string | null
          address?: string | null
          city?: string | null
          country?: string | null
          created_at?: string
          created_by?: string | null
          organization_id?: string
        }
      }
      contacts: {
        Row: {
          id: string
          first_name: string | null
          last_name: string | null
          email: string | null
          phone: string | null
          notes: string | null
          company_id: string | null
          created_at: string
          created_by: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          first_name?: string | null
          last_name?: string | null
          email?: string | null
          phone?: string | null
          notes?: string | null
          company_id?: string | null
          created_at?: string
          created_by?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          first_name?: string | null
          last_name?: string | null
          email?: string | null
          phone?: string | null
          notes?: string | null
          company_id?: string | null
          created_at?: string
          created_by?: string | null
          organization_id?: string
        }
      }
      projects: {
        Row: {
          id: string
          name: string
          description: string | null
          owner_id: string | null
          created_at: string
          updated_at: string
          organization_id: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          owner_id?: string | null
          created_at?: string
          updated_at?: string
          organization_id?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          owner_id?: string | null
          created_at?: string
          updated_at?: string
          organization_id?: string
        }
      }
      leads: {
        Row: {
          id: string
          title: string | null
          company_name: string | null
          contact_name: string | null
          email: string | null
          phone: string | null
          status: string | null
          source: string | null
          created_at: string
          contact_id: string | null
          assigned_to: string | null
          value: number | null
          description: string | null
          notes: string | null
          user_id: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          title?: string | null
          company_name?: string | null
          contact_name?: string | null
          email?: string | null
          phone?: string | null
          status?: string | null
          source?: string | null
          created_at?: string
          contact_id?: string | null
          assigned_to?: string | null
          value?: number | null
          description?: string | null
          notes?: string | null
          user_id?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          title?: string | null
          company_name?: string | null
          contact_name?: string | null
          email?: string | null
          phone?: string | null
          status?: string | null
          source?: string | null
          created_at?: string
          contact_id?: string | null
          assigned_to?: string | null
          value?: number | null
          description?: string | null
          notes?: string | null
          user_id?: string | null
          organization_id?: string
        }
      }
      deals: {
        Row: {
          id: string
          title: string
          description: string | null
          value: number | null
          stage: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          probability: number | null
          company_id: string | null
          contact_id: string | null
          expected_close_date: string | null
          created_at: string
          created_by: string | null
          assigned_to: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          title: string
          description?: string | null
          value?: number | null
          stage?: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          probability?: number | null
          company_id?: string | null
          contact_id?: string | null
          expected_close_date?: string | null
          created_at?: string
          created_by?: string | null
          assigned_to?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          title?: string
          description?: string | null
          value?: number | null
          stage?: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          probability?: number | null
          company_id?: string | null
          contact_id?: string | null
          expected_close_date?: string | null
          created_at?: string
          created_by?: string | null
          assigned_to?: string | null
          organization_id?: string
        }
      }
      tasks: {
        Row: {
          id: string
          title: string
          description: string | null
          priority: "low" | "medium" | "high" | "urgent"
          status: string | null
          due_date: string | null
          created_at: string
          created_by: string | null
          assigned_to: string | null
          lead_id: string | null
          deal_id: string | null
          project_id: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          title: string
          description?: string | null
          priority?: "low" | "medium" | "high" | "urgent"
          status?: string | null
          due_date?: string | null
          created_at?: string
          created_by?: string | null
          assigned_to?: string | null
          lead_id?: string | null
          deal_id?: string | null
          project_id?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          title?: string
          description?: string | null
          priority?: "low" | "medium" | "high" | "urgent"
          status?: string | null
          due_date?: string | null
          created_at?: string
          created_by?: string | null
          assigned_to?: string | null
          lead_id?: string | null
          deal_id?: string | null
          project_id?: string | null
          organization_id?: string
        }
      }
      employees: {
        Row: {
          id: string
          employee_id: string
          user_id: string | null
          department_id: string | null
          designation_id: string | null
          phone: string | null
          address: string | null
          salary: number | null
          hire_date: string | null
          status: "active" | "inactive" | "terminated"
          created_at: string
          organization_id: string
        }
        Insert: {
          id?: string
          employee_id: string
          user_id?: string | null
          department_id?: string | null
          designation_id?: string | null
          phone?: string | null
          address?: string | null
          salary?: number | null
          hire_date?: string | null
          status?: "active" | "inactive" | "terminated"
          created_at?: string
          organization_id?: string
        }
        Update: {
          id?: string
          employee_id?: string
          user_id?: string | null
          department_id?: string | null
          designation_id?: string | null
          phone?: string | null
          address?: string | null
          salary?: number | null
          hire_date?: string | null
          status?: "active" | "inactive" | "terminated"
          created_at?: string
          organization_id?: string
        }
      }
      departments: {
        Row: {
          id: string
          name: string
          description: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          organization_id?: string
        }
      }
      designations: {
        Row: {
          id: string
          title: string
          description: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          title: string
          description?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          title?: string
          description?: string | null
          organization_id?: string
        }
      }
      activity_logs: {
        Row: {
          id: string
          action: string | null
          entity_type: string | null
          entity_id: string | null
          description: string | null
          user_id: string | null
          created_at: string
          organization_id: string
        }
        Insert: {
          id?: string
          action?: string | null
          entity_type?: string | null
          entity_id?: string | null
          description?: string | null
          user_id?: string | null
          created_at?: string
          organization_id?: string
        }
        Update: {
          id?: string
          action?: string | null
          entity_type?: string | null
          entity_id?: string | null
          description?: string | null
          user_id?: string | null
          created_at?: string
          organization_id?: string
        }
      }
      notifications: {
        Row: {
          id: string
          user_id: string
          title: string | null
          body: string | null
          read: boolean
          entity_type: string | null
          entity_id: string | null
          project_id: string | null
          meeting_id: string | null
          created_at: string
          organization_id: string
        }
        Insert: {
          id?: string
          user_id: string
          title?: string | null
          body?: string | null
          read?: boolean
          entity_type?: string | null
          entity_id?: string | null
          project_id?: string | null
          meeting_id?: string | null
          created_at?: string
          organization_id?: string
        }
        Update: {
          id?: string
          user_id?: string
          title?: string | null
          body?: string | null
          read?: boolean
          entity_type?: string | null
          entity_id?: string | null
          project_id?: string | null
          meeting_id?: string | null
          created_at?: string
          organization_id?: string
        }
      }
      chat_messages: {
        Row: {
          id: string
          channel_id: string
          sender_id: string
          content: string
          created_at: string
          organization_id: string
        }
        Insert: {
          id?: string
          channel_id: string
          sender_id: string
          content: string
          created_at?: string
          organization_id?: string
        }
        Update: {
          id?: string
          channel_id?: string
          sender_id?: string
          content?: string
          created_at?: string
          organization_id?: string
        }
      }
      chat_channels: {
        Row: {
          id: string
          type: "direct" | "group"
          name: string | null
          created_by: string
          created_at: string
          project_id: string | null
          organization_id: string
        }
        Insert: {
          id?: string
          type: "direct" | "group"
          name?: string | null
          created_by: string
          created_at?: string
          project_id?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          type?: "direct" | "group"
          name?: string | null
          created_by?: string
          created_at?: string
          project_id?: string | null
          organization_id?: string
        }
      }
      project_members: {
        Row: {
          id: string
          project_id: string
          employee_id: string
          role: string | null
          added_at: string
        }
        Insert: {
          id?: string
          project_id: string
          employee_id: string
          role?: string | null
          added_at?: string
        }
        Update: {
          id?: string
          project_id?: string
          employee_id?: string
          role?: string | null
          added_at?: string
        }
      }
      chat_participants: {
        Row: {
          id: string
          channel_id: string
          user_id: string
          organization_id: string
        }
        Insert: {
          id?: string
          channel_id: string
          user_id: string
          organization_id?: string
        }
        Update: {
          id?: string
          channel_id?: string
          user_id?: string
          organization_id?: string
        }
      }
      leave_requests: {
        Row: {
          id: string
          employee_id: string
          type: string | null
          start_date: string
          end_date: string
          status: string | null
          created_at: string
        }
        Insert: {
          id?: string
          employee_id: string
          type?: string | null
          start_date: string
          end_date: string
          status?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          employee_id?: string
          type?: string | null
          start_date?: string
          end_date?: string
          status?: string | null
          created_at?: string
        }
      }
      messages: {
        Row: {
          id: string
          entity_type: string | null
          entity_id: string | null
          author_id: string | null
          content: string | null
          mentions: string[] | null
          created_at: string
        }
        Insert: {
          id?: string
          entity_type?: string | null
          entity_id?: string | null
          author_id?: string | null
          content?: string | null
          mentions?: string[] | null
          created_at?: string
        }
        Update: {
          id?: string
          entity_type?: string | null
          entity_id?: string | null
          author_id?: string | null
          content?: string | null
          mentions?: string[] | null
          created_at?: string
        }
      }
      task_collaborators: {
        Row: {
          task_id: string
          user_id: string
        }
        Insert: {
          task_id: string
          user_id: string
        }
        Update: {
          task_id?: string
          user_id?: string
        }
      }
    }
    TablesExtra: {
      organizations: {
        Row: { id: string; name: string; created_at: string; updated_at: string }
        Insert: { id?: string; name: string; created_at?: string; updated_at?: string }
        Update: { id?: string; name?: string; created_at?: string; updated_at?: string }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

export type Tables<T extends keyof Database["public"]["Tables"]> = Database["public"]["Tables"][T]["Row"]
export type TablesInsert<T extends keyof Database["public"]["Tables"]> = Database["public"]["Tables"][T]["Insert"]
export type TablesUpdate<T extends keyof Database["public"]["Tables"]> = Database["public"]["Tables"][T]["Update"]
