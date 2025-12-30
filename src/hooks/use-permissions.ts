import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";

type CapabilityMap = Record<
  string,
  {
    can_view?: boolean;
    can_create?: boolean;
    can_edit?: boolean;
    can_approve?: boolean;
  }
>;

export function usePermissions() {
  const { user } = useAuth();
  const [role, setRole] = useState<"admin" | "manager" | "employee" | null>(null);
  const [orgId, setOrgId] = useState<string | null>(null);
  const [caps, setCaps] = useState<CapabilityMap>({});
  const [loading, setLoading] = useState(true);

  const refresh = useCallback(async () => {
    if (!user) return;
    setLoading(true);
    const { data: profile } = await supabase.from("profiles").select("organization_id").eq("id", user.id).maybeSingle();
    const organization_id = profile && typeof (profile as { organization_id?: string | null }).organization_id === "string"
      ? (profile as { organization_id?: string | null }).organization_id
      : null;
    setOrgId(organization_id);

    let userRole: "admin" | "manager" | "employee" | null = null;
    if (organization_id) {
      const { data: roles } = await supabase
        .from("user_roles")
        .select("role")
        .eq("user_id", user.id)
        .eq("organization_id", organization_id)
        .limit(1);
      const roleRow = Array.isArray(roles) ? roles[0] as { role?: string } : undefined;
      userRole = roleRow && (roleRow.role === "admin" || roleRow.role === "manager" || roleRow.role === "employee")
        ? (roleRow.role as "admin" | "manager" | "employee")
        : null;
      setRole(userRole);
    }

    if (organization_id && userRole) {
      const { data: rc } = await supabase
        .from("role_capabilities")
        .select("module, can_view, can_create, can_edit, can_approve")
        .eq("organization_id", organization_id)
        .eq("role", userRole);
      const map: CapabilityMap = {};
      const rows = Array.isArray(rc) ? rc as Array<{ module?: string; can_view?: boolean; can_create?: boolean; can_edit?: boolean; can_approve?: boolean }> : [];
      for (const r of rows) {
        if (typeof r.module === "string") {
          map[r.module] = {
            can_view: Boolean(r.can_view),
            can_create: Boolean(r.can_create),
            can_edit: Boolean(r.can_edit),
            can_approve: Boolean(r.can_approve),
          };
        }
      }
      setCaps(map);
    } else {
      setCaps({});
    }
    setLoading(false);
  }, [user]);

  useEffect(() => {
    refresh();
  }, [refresh]);

  const can = useCallback(
    (module: string, capability: keyof NonNullable<CapabilityMap[string]>) => {
      if (role === "admin") return true;
      const m = caps[module];
      if (!m) return false;
      return Boolean(m[capability]);
    },
    [caps, role],
  );

  return { loading, role, orgId, capabilities: caps, can, refresh };
}
