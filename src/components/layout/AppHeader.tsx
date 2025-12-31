import { Bell, User, Check, Sun, Moon } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { useAuth } from "@/contexts/AuthContext";
import { useTheme } from "@/components/theme-provider";
import { useNavigate } from "react-router-dom";
import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";

import { Tables } from "@/integrations/supabase/types";

export function AppHeader() {
  const { user, signOut } = useAuth();
  const { theme, setTheme } = useTheme();
  const navigate = useNavigate();
  const [notifications, setNotifications] = useState<Tables<'notifications'>[]>([]);
  const unreadCount = notifications.filter((n) => !n.read).length;

  const userInitials = user?.email?.slice(0, 2).toUpperCase() || "U";

  const fetchNotifications = useCallback(async () => {
    if (!user?.id) return;
    const { data } = await supabase
      .from("notifications")
      .select("*")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(20);
    setNotifications(data || []);
  }, [user?.id]);

  async function markAllRead() {
    if (!user?.id) return;
    await supabase.from("notifications").update({ read: true }).eq("user_id", user.id).eq("read", false);
    fetchNotifications();
  }

  const handleNotificationClick = async (n: Tables<'notifications'>) => {
    // Mark as read if not already
    if (!n.read) {
      await supabase.from("notifications").update({ read: true }).eq("id", n.id);
      // Optimistic update
      setNotifications(prev => prev.map(notif => notif.id === n.id ? { ...notif, read: true } : notif));
    }

    // Navigate based on entity type
    if (n.entity_type === 'chat_channel' && n.entity_id) {
      navigate(`/chat?channelId=${n.entity_id}`);
    }
  };

  useEffect(() => {
    if (!user?.id) return;
    const channel = supabase
      .channel("notifications_changes")
      .on(
        "postgres_changes",
        { event: "*", schema: "public", table: "notifications", filter: `user_id=eq.${user.id}` },
        () => fetchNotifications()
      )
      .subscribe();
    fetchNotifications();
    return () => {
      supabase.removeChannel(channel);
    };
  }, [user?.id, fetchNotifications]);

  return (
    <header className="h-16 border-b border-border bg-card flex items-center justify-end px-6">
      <div className="flex items-center gap-3">
        <Button variant="ghost" size="icon" onClick={() => setTheme(theme === "dark" ? "light" : "dark")}>
          <Sun className="h-5 w-5 rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
          <Moon className="absolute h-5 w-5 rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
          <span className="sr-only">Toggle theme</span>
        </Button>
        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" size="icon" className="relative">
              <Bell className="h-5 w-5 text-muted-foreground" />
              {unreadCount > 0 && <span className="absolute top-1.5 right-1.5 h-2 w-2 rounded-full bg-destructive" />}
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-80">
            <div className="flex items-center justify-between px-2 py-1">
              <DropdownMenuLabel>Notifications</DropdownMenuLabel>
              <Button variant="ghost" size="sm" onClick={markAllRead} className="gap-1">
                <Check className="h-4 w-4" />Mark all read
              </Button>
            </div>
            <DropdownMenuSeparator />
            {notifications.length === 0 ? (
              <div className="px-2 py-4 text-sm text-muted-foreground">No notifications</div>
            ) : (
              notifications.map((n) => (
                <DropdownMenuItem key={n.id} className="flex flex-col items-start cursor-pointer" onClick={() => handleNotificationClick(n)}>
                  <div className="flex items-center justify-between w-full">
                    <span className="font-medium text-sm">{n.title || "Notification"}</span>
                    {!n.read && <span className="h-2 w-2 rounded-full bg-destructive" />}
                  </div>
                  {n.body && <span className="text-xs text-muted-foreground">{n.body}</span>}
                  <span className="text-[10px] text-muted-foreground mt-1">{new Date(n.created_at).toLocaleString()}</span>
                </DropdownMenuItem>
              ))
            )}
          </DropdownMenuContent>
        </DropdownMenu>

        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button variant="ghost" className="relative h-8 w-8 rounded-full">
              <Avatar className="h-8 w-8">
                <AvatarFallback>{userInitials}</AvatarFallback>
              </Avatar>
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end">
            <DropdownMenuLabel>My Account</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem onClick={() => navigate("/settings")}>
              <User className="mr-2 h-4 w-4" />
              Profile
            </DropdownMenuItem>
            <DropdownMenuItem onClick={() => signOut()}>
              Log out
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>
    </header>
  );
}
