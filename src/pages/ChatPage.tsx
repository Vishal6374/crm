import { useState, useEffect } from "react";
import { useSearchParams } from "react-router-dom";
import { ChatSidebar } from "@/components/chat/ChatSidebar";
import { ChatWindow } from "@/components/chat/ChatWindow";

export default function ChatPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const [selectedChannelId, setSelectedChannelId] = useState<string | null>(searchParams.get("channelId"));

  useEffect(() => {
    const channelId = searchParams.get("channelId");
    if (channelId) {
      setSelectedChannelId(channelId);
    }
  }, [searchParams]);

  const handleSelectChannel = (id: string) => {
    setSelectedChannelId(id);
    setSearchParams({ channelId: id });
  };

  return (
    <div className="flex h-[calc(100vh-4rem)] bg-background">
      <ChatSidebar 
        selectedChannelId={selectedChannelId} 
        onSelectChannel={handleSelectChannel} 
      />
      {selectedChannelId ? (
        <ChatWindow channelId={selectedChannelId} />
      ) : (
        <div className="flex-1 flex items-center justify-center flex-col gap-4 text-muted-foreground">
           <div className="p-6 rounded-full bg-accent/50">
             <svg
               xmlns="http://www.w3.org/2000/svg"
               width="48"
               height="48"
               viewBox="0 0 24 24"
               fill="none"
               stroke="currentColor"
               strokeWidth="2"
               strokeLinecap="round"
               strokeLinejoin="round"
             >
               <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z" />
             </svg>
           </div>
           <p className="text-lg font-medium">Select a chat to start messaging</p>
        </div>
      )}
    </div>
  );
}
