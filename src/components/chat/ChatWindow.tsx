import { useEffect, useState, useRef } from "react";
import { supabase } from "@/integrations/supabase/client";
import { useAuth } from "@/contexts/AuthContext";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Send, MoreVertical, Phone, Video, UserPlus, Plus } from "lucide-react";
import { format } from "date-fns";
import { useToast } from "@/hooks/use-toast";
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogDescription } from "@/components/ui/dialog";
import { Tables } from "@/integrations/supabase/types";

interface ChatWindowProps {
  channelId: string;
}

type MessageWithProfile = Tables<'chat_messages'> & {
  profiles: {
    full_name: string | null;
    avatar_url: string | null;
  } | null;
};

type ChannelWithName = Tables<'chat_channels'> & {
  name?: string;
};

type ParticipantWithProfile = {
  user_id: string;
  profiles: {
    full_name: string | null;
    email: string | null;
  } | null;
};

export function ChatWindow({ channelId }: ChatWindowProps) {
  const { user } = useAuth();
  const { toast } = useToast();
  const [messages, setMessages] = useState<MessageWithProfile[]>([]);
  const [newMessage, setNewMessage] = useState("");
  const [channel, setChannel] = useState<ChannelWithName | null>(null);
  const scrollRef = useRef<HTMLDivElement>(null);
  const [participants, setParticipants] = useState<ParticipantWithProfile[]>([]);
  
  // Add member state
  const [isAddMemberOpen, setIsAddMemberOpen] = useState(false);
  const [availableUsers, setAvailableUsers] = useState<Tables<'profiles'>[]>([]);
  const [search, setSearch] = useState("");

  const fetchChannelDetails = useCallback(async () => {
    if (!user) return;
    const { data } = await supabase.from('chat_channels').select('*').eq('id', channelId).single();
    if (data) {
       if (data.type === 'direct') {
          const { data: participants } = await supabase.from('chat_participants').select('user_id').eq('channel_id', channelId);
          const otherUserId = participants?.find((p) => p.user_id !== user.id)?.user_id;
          if (otherUserId) {
            const { data: profile } = await supabase.from('profiles').select('full_name').eq('id', otherUserId).single();
            data.name = profile?.full_name || "Unknown User";
          }
       }
       setChannel(data);
    }
  }, [channelId, user]);

  const fetchMessages = useCallback(async () => {
    const { data, error } = await supabase
      .from('chat_messages')
      .select(`
        *,
        profiles(full_name, avatar_url)
      `)
      .eq('channel_id', channelId)
      .order('created_at', { ascending: true });

    if (error) {
      console.error('Error fetching messages:', error);
    } else {
      setMessages(data || []);
    }
  }, [channelId]);

  const fetchParticipants = useCallback(async () => {
    const { data } = await supabase
      .from('chat_participants')
      .select('user_id, profiles(full_name, email)')
      .eq('channel_id', channelId);
    setParticipants(data || []);
  }, [channelId]);

  const fetchNewMessage = useCallback(async (messageId: string) => {
    const { data, error } = await supabase
      .from('chat_messages')
      .select(`
        *,
        profiles(full_name, avatar_url)
      `)
      .eq('id', messageId)
      .single();

    if (error) {
       console.error('Error fetching new message:', error);
       return;
    }

    if (data) {
      setMessages(prev => {
        // Prevent duplicates
        if (prev.some(m => m.id === data.id)) return prev;
        return [...prev, data];
      });
    }
  }, []);

  useEffect(() => {
    if (channelId) {
      fetchChannelDetails();
      fetchMessages();
      fetchParticipants();

      const channelSubscription = supabase
        .channel(`public:chat_messages:${channelId}`)
        .on('postgres_changes', {
          event: 'INSERT',
          schema: 'public',
          table: 'chat_messages',
          filter: `channel_id=eq.${channelId}`
        }, (payload) => {
          console.log('New message received:', payload);
          fetchNewMessage(payload.new.id);
        })
        .subscribe((status) => {
          if (status === 'SUBSCRIBED') {
            console.log('Subscribed to chat messages');
          } else if (status === 'CHANNEL_ERROR') {
             console.error('Error subscribing to chat messages');
             toast({ title: "Connection Error", description: "Failed to connect to chat server. Please refresh.", variant: "destructive" });
          }
        });

      return () => {
        supabase.removeChannel(channelSubscription);
      };
    }
  }, [channelId, fetchChannelDetails, fetchMessages, fetchParticipants, fetchNewMessage, toast]);

  const fetchAvailableUsers = useCallback(async () => {
    if (!user) return;
    // Fetch all users who are NOT in the current participants list
    const participantIds = participants.map(p => p.user_id);
    const { data } = await supabase
      .from('profiles')
      .select('id, full_name, email');

    if (data) {
      const filtered = data.filter(u => !participantIds.includes(u.id));
      setAvailableUsers(filtered);
    }
  }, [user, participants]);

  useEffect(() => {
    if (isAddMemberOpen) {
      fetchAvailableUsers();
    }
  }, [isAddMemberOpen, fetchAvailableUsers]);

  const addMember = useCallback(async (userId: string) => {
    const { error } = await supabase
      .from('chat_participants')
      .insert({ channel_id: channelId, user_id: userId });

    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      toast({ title: "Success", description: "Member added successfully" });
      setIsAddMemberOpen(false);
      fetchParticipants();
    }
  }, [channelId, toast, fetchParticipants]);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollIntoView({ behavior: 'smooth' });
    }
  }, [messages]);

  const sendMessage = useCallback(async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newMessage.trim() || !user) return;

    const { data, error } = await supabase
      .from('chat_messages')
      .insert({
        channel_id: channelId,
        sender_id: user.id,
        content: newMessage
      } as Database['public']['Tables']['chat_messages']['Insert'])
      .select(`
        *,
        profiles(full_name, avatar_url)
      `)
      .single();

    if (error) {
      toast({ title: "Error", description: error.message, variant: "destructive" });
    } else {
      setNewMessage("");
      // Manually add the message to the list immediately (Optimistic update)
      if (data) {
        setMessages(prev => {
          if (prev.some(m => m.id === data.id)) return prev;
          return [...prev, data];
        });
      }

      // Trigger update on channel timestamp
      await supabase.from('chat_channels').update({ updated_at: new Date().toISOString() }).eq('id', channelId);
    }
  }, [newMessage, user, channelId, toast]);

  const filteredAvailableUsers = availableUsers.filter(u => 
    (u.full_name?.toLowerCase() || "").includes(search.toLowerCase()) || 
    (u.email?.toLowerCase() || "").includes(search.toLowerCase())
  );

  if (!channel) return <div className="flex-1 flex items-center justify-center">Loading...</div>;

  return (
    <div className="flex-1 flex flex-col h-full bg-background">
      <div className="p-4 border-b border-border flex items-center justify-between shadow-sm">
        <div className="flex items-center gap-3">
          <Avatar>
            <AvatarFallback>{channel.name?.[0]}</AvatarFallback>
          </Avatar>
          <div>
            <h2 className="font-semibold">{channel.name}</h2>
            {channel.type === 'group' && <p className="text-xs text-muted-foreground">{participants.length} members</p>}
          </div>
        </div>
        <div className="flex items-center gap-2">
           {channel.type === 'group' && (
             <Button variant="ghost" size="icon" onClick={() => setIsAddMemberOpen(true)} title="Add Member">
               <UserPlus className="h-4 w-4" />
             </Button>
           )}
           <Button variant="ghost" size="icon"><Phone className="h-4 w-4" /></Button>
           <Button variant="ghost" size="icon"><Video className="h-4 w-4" /></Button>
           <Button variant="ghost" size="icon"><MoreVertical className="h-4 w-4" /></Button>
        </div>
      </div>
      
      <Dialog open={isAddMemberOpen} onOpenChange={setIsAddMemberOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Add Member</DialogTitle>
            <DialogDescription>Add a new member to this group.</DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
             <Input placeholder="Search users..." value={search} onChange={e => setSearch(e.target.value)} className="mb-2" />
             <ScrollArea className="h-48">
               {filteredAvailableUsers.length === 0 && <p className="text-center text-sm text-muted-foreground p-2">No users found</p>}
               {filteredAvailableUsers.map(u => (
                 <div key={u.id} className="flex items-center justify-between p-2 hover:bg-accent rounded-md cursor-pointer" onClick={() => addMember(u.id)}>
                    <div className="flex items-center gap-2">
                      <Avatar className="h-8 w-8">
                        <AvatarFallback>{u.full_name?.[0] || u.email?.[0]}</AvatarFallback>
                      </Avatar>
                      <div>
                        <p className="text-sm font-medium">{u.full_name || "Unknown"}</p>
                        <p className="text-xs text-muted-foreground">{u.email}</p>
                      </div>
                    </div>
                    <Button size="sm" variant="ghost"><Plus className="h-4 w-4" /></Button>
                 </div>
               ))}
             </ScrollArea>
          </div>
        </DialogContent>
      </Dialog>
      
      <ScrollArea className="flex-1 p-4">
        <div className="space-y-4">
          {messages.map((msg, index) => {
            const isMe = msg.sender_id === user?.id;
            const showAvatar = index === 0 || messages[index - 1].sender_id !== msg.sender_id;
            
            return (
              <div key={msg.id} className={`flex gap-3 ${isMe ? 'justify-end' : 'justify-start'}`}>
                {!isMe && showAvatar ? (
                  <Avatar className="h-8 w-8 mt-1">
                    <AvatarImage src={msg.profiles?.avatar_url} />
                    <AvatarFallback>{msg.profiles?.full_name?.[0]}</AvatarFallback>
                  </Avatar>
                ) : !isMe && <div className="w-8" />}
                
                <div className={`max-w-[70%] ${isMe ? 'bg-primary text-primary-foreground' : 'bg-muted'} p-3 rounded-lg`}>
                  {!isMe && showAvatar && <p className="text-xs font-semibold mb-1">{msg.profiles?.full_name}</p>}
                  <p className="text-sm whitespace-pre-wrap">{msg.content}</p>
                  <p className={`text-[10px] mt-1 ${isMe ? 'text-primary-foreground/70' : 'text-muted-foreground'}`}>
                    {format(new Date(msg.created_at), 'h:mm a')}
                  </p>
                </div>
              </div>
            );
          })}
          <div ref={scrollRef} />
        </div>
      </ScrollArea>
      
      <div className="p-4 border-t border-border">
        <form onSubmit={sendMessage} className="flex gap-2">
          <Input 
            value={newMessage} 
            onChange={e => setNewMessage(e.target.value)} 
            placeholder="Type a message..." 
            className="flex-1"
          />
          <Button type="submit" size="icon" disabled={!newMessage.trim()}>
            <Send className="h-4 w-4" />
          </Button>
        </form>
      </div>
    </div>
  );
}
