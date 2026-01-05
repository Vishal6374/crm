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
          full_name: string | null
          email: string | null
          phone: string | null
          website: string | null
          industry: string | null
          address: string | null
          city: string | null
          country: string | null
          organization_id: string
          created_by: string | null
          organization_id: string
        }
        Insert: {
          id: string
          full_name?: string | null
          email?: string | null
          phone?: string | null
          website?: string | null
          industry?: string | null
          address?: string | null
          city?: string | null
          country?: string | null
          organization_id?: string
          created_by?: string | null
          organization_id?: string
        }
        Update: {
          id?: string
          full_name?: string | null
          email?: string | null
          phone?: string | null
          website?: string | null
          industry?: string | null
          address?: string | null
          city?: string | null
          country?: string | null
          organization_id?: string
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
          address: string | null
          created_by: string | null
          organization_id: string
          city: string | null
          country: string | null
          created_at: string
          first_name?: string | null
          last_name?: string | null
          email?: string | null
          phone?: string | null
          notes?: string | null
          company_id?: string | null
          name: string
          created_by?: string | null
          organization_id?: string
          email?: string | null
          phone?: string | null
          website?: string | null
          first_name?: string | null
          last_name?: string | null
          email?: string | null
          phone?: string | null
          notes?: string | null
          company_id?: string | null
          created_by?: string | null
          created_by?: string | null
          organization_id?: string
          organization_id?: string
        }
      projects: {
          id?: string
          name?: string
          email?: string | null
          description: string | null
          owner_id: string | null
          created_at: string
          updated_at: string
          organization_id: string
          phone?: string | null
          website?: string | null
          industry?: string | null
          address?: string | null
          description?: string | null
          owner_id?: string | null
          created_at?: string
          updated_at?: string
          organization_id?: string
          city?: string | null
          country?: string | null
          created_at?: string
          created_by?: string | null
          description?: string | null
          owner_id?: string | null
          created_at?: string
          updated_at?: string
          organization_id?: string
          notes?: string | null
          company_id?: string | null
      project_tasks: {
          created_by?: string | null
          organization_id?: string
          project_id: string
          title: string
          description: string | null
          status: string
          priority: string
          id: string
          created_by: string | null
          name: string
          description: string | null
          owner_id: string | null
          created_at: string
          project_id: string
          title: string
          description?: string | null
          status?: string
          priority?: string
          id?: string
          created_by?: string | null
          name: string
          description?: string | null
          owner_id?: string | null
          created_at?: string
          project_id?: string
          title?: string
          description?: string | null
          status?: string
          priority?: string
          id?: string
          created_by?: string | null
          name?: string
          description?: string | null
          owner_id?: string | null
      project_meetings: {
          updated_at?: string
          organization_id?: string
          project_id: string
          title: string
          start_time: string
          end_time: string
          meeting_link: string | null
          created_by: string | null
          created_at: string
        Row: {
          id: string
          project_id: string
          project_id: string
          title: string
          start_time: string
          end_time: string
          meeting_link?: string | null
          created_by?: string | null
          created_at?: string
          priority: string
          assigned_to: string | null
          created_by: string | null
          project_id?: string
          title?: string
          start_time?: string
          end_time?: string
          meeting_link?: string | null
          created_by?: string | null
          created_at?: string
          id?: string
          project_id: string
      leads: {
          description?: string | null
          status?: string
          title: string | null
          company_name: string | null
          contact_name: string | null
          created_at?: string
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
        Update: {
          id?: string
          title?: string | null
          company_name?: string | null
          contact_name?: string | null
          status?: string
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
          priority?: string
          assigned_to?: string | null
          created_by?: string | null
          title?: string | null
          company_name?: string | null
          contact_name?: string | null
      project_meetings: {
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
        Row: {
          id: string
          project_id: string
          title: string
          start_time: string
          title: string
          description: string | null
        Insert: {
          stage: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          probability: number | null
          company_id: string | null
          contact_id: string | null
          expected_close_date: string | null
          id?: string
          created_by: string | null
          assigned_to: string | null
          organization_id: string
          project_id: string
          title: string
          start_time: string
          title: string
          description?: string | null
        Update: {
          stage?: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          probability?: number | null
          company_id?: string | null
          contact_id?: string | null
          expected_close_date?: string | null
          id?: string
          created_by?: string | null
          assigned_to?: string | null
          organization_id?: string
          project_id?: string
          title?: string
          start_time?: string
          title?: string
          description?: string | null
      }
          stage?: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          probability?: number | null
          company_id?: string | null
          contact_id?: string | null
          expected_close_date?: string | null
      leads: {
          created_by?: string | null
          assigned_to?: string | null
          organization_id?: string
        Row: {
          id: string
      tasks: {
          company_name: string | null
          contact_name: string | null
          title: string
          description: string | null
          priority: "low" | "medium" | "high" | "urgent"
          status: string | null
          due_date: string | null
          created_at: string
          status: string | null
          assigned_to: string | null
          lead_id: string | null
          deal_id: string | null
          project_id: string | null
          organization_id: string
          source: string | null
          created_at: string
          contact_id: string | null
          title: string
          description?: string | null
          priority?: "low" | "medium" | "high" | "urgent"
          status?: string | null
          due_date?: string | null
          created_at?: string
          description: string | null
          assigned_to?: string | null
          lead_id?: string | null
          deal_id?: string | null
          project_id?: string | null
          organization_id?: string
          notes: string | null
          user_id: string | null
          organization_id: string
          title?: string
          description?: string | null
          priority?: "low" | "medium" | "high" | "urgent"
          status?: string | null
          due_date?: string | null
          created_at?: string
          id?: string
          assigned_to?: string | null
          lead_id?: string | null
          deal_id?: string | null
          project_id?: string | null
          organization_id?: string
          title?: string | null
          company_name?: string | null
      employees: {
          email?: string | null
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
          source?: string | null
          created_at?: string
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
          value?: number | null
          description?: string | null
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
          id?: string
          title?: string | null
          name: string
          description: string | null
          organization_id: string
          status?: string | null
          source?: string | null
          created_at?: string
          name: string
          description?: string | null
          organization_id?: string
          notes?: string | null
          user_id?: string | null
          organization_id?: string
          name?: string
          description?: string | null
          organization_id?: string
          id: string
          title: string
      designations: {
          value: number | null
          stage: "prospecting" | "qualification" | "proposal" | "negotiation" | "closed_won" | "closed_lost"
          title: string
          description: string | null
          organization_id: string
          assigned_to: string | null
          organization_id: string
        }
          title: string
          description?: string | null
          organization_id?: string
          probability?: number | null
          company_id?: string | null
          contact_id?: string | null
          title?: string
          description?: string | null
          organization_id?: string
        Update: {
          id?: string
      activity_logs: {
          description?: string | null
          value?: number | null
          action: string | null
          entity_type: string | null
          contact_id?: string | null
          description: string | null
          user_id: string | null
          created_at: string
          organization_id: string
          expected_close_date?: string | null
          created_at?: string
          created_by?: string | null
          action?: string | null
          entity_type?: string | null
      }
          description?: string | null
          user_id?: string | null
          created_at?: string
          organization_id?: string
      tasks: {
        Row: {
          id: string
          action?: string | null
          entity_type?: string | null
          status: string | null
          description?: string | null
          user_id?: string | null
          created_at?: string
          organization_id?: string
          due_date: string | null
          created_at: string
      notifications: {
          assigned_to: string | null
          id: string
          deal_id: string | null
          type: string | null
          title: string | null
          body: string | null
          read: boolean
          entity_type: string | null
          entity_id: string | null
          project_id: string | null
          meeting_id: string | null
          created_at: string
          organization_id: string
          organization_id: string
        }
          id?: string
          id?: string
          type?: string | null
          title?: string | null
          body?: string | null
          read?: boolean
          entity_type?: string | null
          entity_id?: string | null
          project_id?: string | null
          meeting_id?: string | null
          created_at?: string
          organization_id?: string
          description?: string | null
          priority?: "low" | "medium" | "high" | "urgent"
          id?: string
          due_date?: string | null
          type?: string | null
          title?: string | null
          body?: string | null
          read?: boolean
          entity_type?: string | null
          entity_id?: string | null
          project_id?: string | null
          meeting_id?: string | null
          created_at?: string
          organization_id?: string
          created_by?: string | null
          assigned_to?: string | null
      events: {
          deal_id?: string | null
          project_id?: string | null
          title: string
          start_time: string
          end_time: string
          type: "task" | "meeting" | "leave"
          related_id: string | null
          id?: string
          updated_at: string
          title?: string
          description?: string | null
          priority?: "low" | "medium" | "high" | "urgent"
          title: string
          start_time: string
          end_time: string
          type: "task" | "meeting" | "leave"
          related_id?: string | null
          created_by?: string | null
          updated_at?: string
          assigned_to?: string | null
          lead_id?: string | null
          deal_id?: string | null
          title?: string
          start_time?: string
          end_time?: string
          type?: "task" | "meeting" | "leave"
          related_id?: string | null
      }
          updated_at?: string
      employees: {
        Row: {
      chat_messages: {
          employee_id: string
          id: string
          channel_id: string
          sender_id: string
          content: string
          created_at: string
          organization_id: string
          phone: string | null
          address: string | null
          id?: string
          channel_id: string
          sender_id: string
          content: string
          created_at?: string
          organization_id?: string
          created_at: string
          organization_id: string
          id?: string
          channel_id?: string
          sender_id?: string
          content?: string
          created_at?: string
          organization_id?: string
          employee_id: string
          user_id?: string | null
      chat_channels: {
          designation_id?: string | null
          phone?: string | null
          type: "direct" | "group"
          name: string | null
          created_by: string
          created_at: string
          project_id: string | null
          organization_id: string
          created_at?: string
          organization_id?: string
        }
          type: "direct" | "group"
          name?: string | null
          created_by: string
          created_at?: string
          project_id?: string | null
          organization_id?: string
          department_id?: string | null
          designation_id?: string | null
          phone?: string | null
          type?: "direct" | "group"
          name?: string | null
          created_by?: string
          created_at?: string
          project_id?: string | null
          organization_id?: string
          created_at?: string
          organization_id?: string
      project_members: {
      }
      departments: {
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
          id?: string
          name?: string
          description?: string | null
          project_id?: string
          employee_id?: string
          role?: string | null
          added_at?: string
          id: string
          title: string
      chat_participants: {
          organization_id: string
        }
          channel_id: string
          user_id: string
          organization_id: string
          organization_id?: string
        }
        Update: {
          channel_id: string
          user_id: string
          organization_id?: string
        }
      }
      activity_logs: {
          channel_id?: string
          user_id?: string
          organization_id?: string
          entity_id: string | null
          description: string | null
      leave_requests: {
          created_at: string
          organization_id: string
          employee_id: string
          type: string | null
          start_date: string
          end_date: string
          status: string | null
          entity_id?: string | null
          description?: string | null
          user_id?: string | null
          created_at?: string
          employee_id: string
          type?: string | null
          start_date: string
          end_date: string
          status?: string | null
          entity_type?: string | null
          entity_id?: string | null
          description?: string | null
          user_id?: string | null
          employee_id?: string
          type?: string | null
          start_date?: string
          end_date?: string
          status?: string | null
        Row: {
          id: string
          user_id: string
      messages: {
          meeting_id?: string | null
          created_at?: string
          entity_type: string | null
          entity_id: string | null
          author_id: string | null
          content: string | null
          mentions: string[] | null
          created_at: string
          id?: string
          user_id?: string
          type?: string | null
          entity_type?: string | null
          entity_id?: string | null
          author_id?: string | null
          content?: string | null
          mentions?: string[] | null
          created_at?: string
          entity_type?: string | null
          entity_id?: string | null
          project_id?: string | null
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
          end_time: string
          type: "task" | "meeting" | "leave"
          task_id: string
          user_id: string
        }
        Insert: {
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
export type Tables<T extends keyof Database["public"]["Tables"]> = Database["public"]["Tables"][T]["Row"]
export type TablesInsert<T extends keyof Database["public"]["Tables"]> = Database["public"]["Tables"][T]["Insert"]
export type TablesUpdate<T extends keyof Database["public"]["Tables"]> = Database["public"]["Tables"][T]["Update"]
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
