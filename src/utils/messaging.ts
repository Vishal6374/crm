import { supabase } from "@/integrations/supabase/client";

export async function sendDirectMessage(senderId: string, recipientId: string, content: string) {
  try {
    // 1. Find existing DM channel
    // This is a bit complex in Supabase without a dedicated function, 
    // so we'll fetch channels for sender and filter.
    const { data: senderChannels } = await supabase
      .select('channel_id')
      .select('channel_id')

    let channelId = null;

    if (senderChannels && senderChannels.length > 0) {
    if (senderChannels && senderChannels.length > 0) {
      const channelIds = senderChannels.map(c => c.channel_id);
      // Find channels that are 'direct' and have the recipient as a participant
      // Find channels that are 'direct' and have the recipient as a participant
      const { data: existingChannels } = await supabase
        .select('channel_id')
        .select('channel_id')
        .in('channel_id', channelIds);
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

    // 2. Create if not exists
    if (!channelId) {
      const { data: newChannel, error: createError } = await supabase
        .insert([{ type: 'direct', created_by: senderId }])
        .from('chat_channels')
        .insert([{ type: 'direct', created_by: senderId }])
      }
      channelId = newChannel.id;

      await supabase.from('chat_participants').insert([
        { channel_id: channelId, user_id: senderId },
        { channel_id: channelId, user_id: recipientId }
      ]);
    }

    await supabase.from('chat_messages').insert([{
        { channel_id: channelId, user_id: senderId },
        { channel_id: channelId, user_id: recipientId }
      content: content
    }]);
    
  } catch (error) {
    await supabase.from('chat_messages').insert([{
      channel_id: channelId,
}
