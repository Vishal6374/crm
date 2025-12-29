import { supabase } from "@/integrations/supabase/client";

export async function sendDirectMessage(senderId: string, recipientId: string, content: string) {
  try {
    // 1. Find existing DM channel
    // This is a bit complex in Supabase without a dedicated function, 
    // so we'll fetch channels for sender and filter.
    const { data: senderChannels } = await supabase
      .from('chat_participants')
      .select('channel_id')
      .eq('user_id', senderId);

    let channelId = null;

    if (senderChannels && senderChannels.length > 0) {
      const channelIds = senderChannels.map(c => c.channel_id);
      
      // Find channels that are 'direct' and have the recipient as a participant
      const { data: existingChannels } = await supabase
        .from('chat_participants')
        .select('channel_id')
        .eq('user_id', recipientId)
        .in('channel_id', channelIds);
        
      if (existingChannels && existingChannels.length > 0) {
         // Verify type is direct
         for (const ec of existingChannels) {
            const { data: channel } = await supabase
               .from('chat_channels')
               .select('type')
               .eq('id', ec.channel_id)
               .single();
            if (channel && channel.type === 'direct') {
               channelId = ec.channel_id;
               break;
            }
         }
      }
    }

    // 2. Create if not exists
    if (!channelId) {
      const { data: newChannel, error: createError } = await supabase
        .from('chat_channels')
        .insert([{ type: 'direct', created_by: senderId }])
        .select()
        .single();
      
      if (createError || !newChannel) {
         console.error("Error creating channel:", createError);
         return;
      }
      channelId = newChannel.id;

      await supabase.from('chat_participants').insert([
        { channel_id: channelId, user_id: senderId },
        { channel_id: channelId, user_id: recipientId }
      ]);
    }

    // 3. Send message
    await supabase.from('chat_messages').insert([{
      channel_id: channelId,
      sender_id: senderId,
      content: content
    }]);
    
  } catch (error) {
    console.error("Error sending direct message:", error);
  }
}
