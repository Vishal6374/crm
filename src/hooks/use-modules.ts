import { useEffect, useState } from "react";
import { supabase } from "@/integrations/supabase/client";

export function useModules() {
  const [enabled, setEnabled] = useState<Record<string, boolean>>({});
  useEffect(() => {
    let active = true;
    supabase
      .from("tenant_modules")
      .select("module, enabled")
      .then(({ data }) => {
        if (!active) return;
        const map: Record<string, boolean> = {};
        (data || []).forEach((row: { module: string; enabled: boolean }) => {
          map[row.module] = !!row.enabled;
        });
        setEnabled(map);
      });
    return () => {
      active = false;
    };
  }, []);
  const isEnabled = (module: string) => {
    if (enabled[module] === false) return false;
    return true;
  };
  return { enabled, isEnabled };
}
