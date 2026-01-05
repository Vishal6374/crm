import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
import { usePermissions } from "@/hooks/use-permissions";

export function useModules() {
  const [enabled, setEnabled] = useState<Record<string, boolean>>({});
  const [loading, setLoading] = useState(true);
  const { orgId, role } = usePermissions();

  useEffect(() => {
    let active = true;

    const fetchModules = async () => {
      try {
        if (!orgId || role === "super_admin") {
          if (active) {
            setEnabled({});
            setLoading(false);
          }
          return;
        }

        const { data, error } = await supabase
          .from("tenant_modules")
          .select("module_name, enabled")
          .eq("organization_id", orgId);
        
        if (error) {
          console.error("Error fetching modules:", error);
          return;
        }

        if (active && data) {
          const map: Record<string, boolean> = {};
          const rows: Array<{ module_name?: string; enabled?: boolean }> = Array.isArray(data) ? (data as Array<{ module_name?: string; enabled?: boolean }>) : [];
          rows.forEach((row) => {
            if (typeof row.module_name === "string") {
              map[row.module_name] = Boolean(row.enabled);
            }
          });
          setEnabled(map);
        }
      } catch (err) {
        console.error("Failed to fetch modules:", err);
      } finally {
        if (active) setLoading(false);
      }
    };

    fetchModules();

    return () => {
      active = false;
    };
  }, [orgId, role]);

  const isEnabled = useCallback((module: string) => {
    if (Object.prototype.hasOwnProperty.call(enabled, module)) {
      return !!enabled[module];
    }
    return true;
  }, [enabled]);

  return { enabled, isEnabled, loading };
}
