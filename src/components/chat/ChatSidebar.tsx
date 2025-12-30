import { useEffect, useState, useCallback } from "react";
import { supabase } from "@/integrations/supabase/client";
// Refresh types  fff
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogDescription } from "@/components/ui/dialog";
import { Plus, Users, MessageSquare } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { Tables, Database } from "@/integrations/supabase/types";

interface ChatSidebarProps {
  onSelectChannel: (channelId: string) => void;
  selectedChannelId: string | null;
}

type ChannelParticipant = {
  user_id: string;
};

type ChannelWithParticipants = Tables<'chat_channels'> & {
  chat_participants: ChannelParticipant[];
  name?: string;
  otherUserId?: string;
};

type UserProfile = Tables<'profiles'>;

export function ChatSidebar({ onSelectChannel, selectedChannelId }: ChatSidebarProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const [channels, setChannels] = useState<ChannelWithParticipants[]>([]);
  const [users, setUsers] = useState<UserProfile[]>([]);
  const [search, setSearch] = useState("");
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [newChannelName, setNewChannelName] = useState("");

  const fetchChannels = useCallback(async () => {
    if (!user) return;
    // Fetch channels where current user is a participant
    const { data: participantData, error: participantError } = await supabase
      .from('chat_participants')
      .select('channel_id')
      .eq('user_id', user.id);

    if (participantError) {
      console.error('Error fetching participants:', participantError);
      toast({ title: "Error fetching chats", description: participantError.message, variant: "destructive" });
      return;
    }

    const channelIds = participantData?.map(p => p.channel_id) || [];

    if (channelIds.length === 0) {
      setChannels([]);
      return;
    }

    const { data, error } = await supabase
      .from('chat_channels')
      .select(`
        *,
        chat_participants(user_id)
      `)
      .in('id', channelIds)
      .order('updated_at', { ascending: false });

    if (error) {
      console.error('Error fetching channels:', error);
      toast({ title: "Error fetching channels", description: error.message, variant: "destructive" });
    } else if (data) {
      // For DMs, we need to fetch the other user's info to display name
      const enrichedChannels: ChannelWithParticipants[] = await Promise.all(data.map(async (channel) => {
        if (channel.type === 'direct') {
          const otherParticipant = channel.chat_participants?.find((p: ChannelParticipant) => p.user_id !== user.id);
          if (otherParticipant) {
             const { data: profile } = await supabase.from('profiles').select('full_name, email').eq('id', otherParticipant.user_id).single();
             return { ...channel, name: profile?.full_name || profile?.email || 'Unknown User', otherUserId: otherParticipant.user_id };
          } else {
             // Chat with self or broken data
             return { ...channel, name: 'Me', otherUserId: user.id };
          }
        }
        return channel;
      }));
      setChannels(enrichedChannels);
    }
  }, [user, toast]);

  const fetchUsers = useCallback(async () => {
    if (!user) return;
    const { data, error } = await supabase.from('profiles').select('id, full_name, email').neq('id', user.id);
    if (error) {
      console.error('Error fetching users:', error);
      toast({ title: "Error fetching users", description: error.message, variant: "destructive" });
    }
    setUsers(data || []);
  }, [user, toast]);

  useEffect(() => {
    if (user) {
      fetchChannels();
      fetchUsers();

      const channelSubscription = supabase
        .channel('public:chat_channels')
        .on('postgres_changes', { event: '*', schema: 'public', table: 'chat_channels' }, () => {
          fetchChannels();
        })
        .subscribe();

      return () => {
        supabase.removeChannel(channelSubscription);
      };
    }
  }, [user, fetchChannels, fetchUsers]);

  async function createGroupChannel() {
    if (!newChannelName.trim() || !user) return;

    const { data, error } = await supabase
      .from('chat_channels')
      .insert({ type: 'group', name: newChannelName, created_by: user.id } as Database['public']['Tables']['chat_channels']['Insert'])
      .select()
      .single();

    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else if (data) {
      setIsDialogOpen(false);
      setNewChannelName("");
      fetchChannels();
      onSelectChannel(data.id);
    }
  }

  async function startDM(otherUserId: string) {
    if (!user) return;
    // Check if DM already exists
    const existingChannel = channels.find(c => c.type === 'direct' && c.otherUserId === otherUserId);
    if (existingChannel) {
      onSelectChannel(existingChannel.id);
      setIsDialogOpen(false);
      return;
    }

    // Create new DM
    const { data, error } = await supabase
      .from('chat_channels')
      .insert({ type: 'direct', created_by: user.id } as Database['public']['Tables']['chat_channels']['Insert'])
      .select()
      .single();

    if (error) {
       toast({ title: "Error", description: error.message, variant: "destructive" });
       return;
    }

    if (data) {
      // Add participants (Creator is added by trigger, need to add the other user)
      await supabase.from('chat_participants').insert([
        { channel_id: data.id, user_id: otherUserId }
      ]);

      setIsDialogOpen(false);
      fetchChannels();
      onSelectChannel(data.id);
    }
  }

  const filteredUsers = users.filter(u => 
    (u.full_name?.toLowerCase() || "").includes(search.toLowerCase()) || 
    (u.email?.toLowerCase() || "").includes(search.toLowerCase())
  );

  return (
    <div className="w-80 border-r border-border bg-card flex flex-col h-full">
      <div className="p-4 border-b border-border flex items-center justify-between">
        <h2 className="font-semibold text-lg">Chats</h2>
        <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
          <DialogTrigger asChild>
            <Button size="icon" variant="ghost"><Plus className="h-5 w-5" /></Button>
          </DialogTrigger>
          <DialogContent>
            <DialogHeader>
              <DialogTitle>New Chat</DialogTitle>
              <DialogDescription>Start a new conversation with a team or individual.</DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <h3 className="mb-2 font-medium">Create Group</h3>
                <div className="flex gap-2">
                  <Input placeholder="Group Name" value={newChannelName} onChange={e => setNewChannelName(e.target.value)} />
                  <Button onClick={createGroupChannel}>Create</Button>
                </div>
              </div>
              <div className="relative">
                <div className="absolute inset-0 flex items-center"><span className="w-full border-t" /></div>
                <div className="relative flex justify-center text-xs uppercase"><span className="bg-background px-2 text-muted-foreground">Or start DM</span></div>
              </div>
              <div>
                 <Input placeholder="Search users..." value={search} onChange={e => setSearch(e.target.value)} className="mb-2" />
                 <ScrollArea className="h-48">
                   {filteredUsers.map(u => (
                     <div key={u.id} className="flex items-center justify-between p-2 hover:bg-accent rounded-md cursor-pointer" onClick={() => startDM(u.id)}>
                        <div className="flex items-center gap-2">
                          <Avatar className="h-8 w-8">
                            <AvatarFallback>{u.full_name?.[0] || u.email?.[0]}</AvatarFallback>
                          </Avatar>
                          <div>
                            <p className="text-sm font-medium">{u.full_name || "Unknown"}</p>
                            <p className="text-xs text-muted-foreground">{u.email}</p>
                          </div>
                        </div>
                     </div>
                   ))}
                 </ScrollArea>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>
      <ScrollArea className="flex-1">
        <div className="p-2 space-y-1">
          {channels.length === 0 && <p className="text-center text-muted-foreground py-4">No chats yet</p>}
          {channels.map(channel => (
            <div 
              key={channel.id} 
              className={`flex items-center gap-3 p-3 rounded-lg cursor-pointer transition-colors ${selectedChannelId === channel.id ? 'bg-accent' : 'hover:bg-accent/50'}`}
              onClick={() => onSelectChannel(channel.id)}
            >
              <Avatar>
                <AvatarFallback>
                  {channel.type === 'group' ? <Users className="h-4 w-4" /> : (channel.name?.[0] || <MessageSquare className="h-4 w-4" />)}
                </AvatarFallback>
              </Avatar>
              <div className="flex-1 overflow-hidden">
                <h3 className="font-medium truncate">{channel.name || "Chat"}</h3>
                <p className="text-xs text-muted-foreground truncate">
                   {channel.type === 'group' ? 'Group' : 'Direct Message'}
                </p>
              </div>
            </div>
          ))}
        </div>
      </ScrollArea>
    </div>
  );
}
