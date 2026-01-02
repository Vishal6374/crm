import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { supabase } from "@/integrations/supabase/client";
import { useToast } from "@/hooks/use-toast";

export default function SetupSupabasePage() {
  const [url, setUrl] = useState("");
  const [key, setKey] = useState("");
  const [testing, setTesting] = useState(false);
  const navigate = useNavigate();
  const { toast } = useToast();

  useEffect(() => {
    const envUrl = import.meta.env.VITE_SUPABASE_URL || "";
    const envKey = import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY || "";
    const lsUrl = localStorage.getItem("SUPABASE_URL") || "";
    const lsKey = localStorage.getItem("SUPABASE_KEY") || "";
    setUrl(lsUrl || envUrl);
    setKey(lsKey || envKey);
  }, []);

  async function save() {
    localStorage.setItem("SUPABASE_URL", url.trim());
    localStorage.setItem("SUPABASE_KEY", key.trim());
    toast({ title: "Saved", description: "Supabase configuration saved locally." });
  }

  async function testConnection() {
    setTesting(true);
    try {
      const { error } = await supabase.auth.getSession();
      if (error) {
        toast({ title: "Connection failed", description: error.message, variant: "destructive" });
      } else {
        toast({ title: "Connection OK", description: "Client can communicate with Supabase." });
      }
    } catch (e) {
      const msg = e instanceof Error ? e.message : String(e);
      toast({ title: "Connection failed", description: msg, variant: "destructive" });
    } finally {
      setTesting(false);
    }
  }

  return (
    <div className="container mx-auto max-w-xl py-10">
      <Card>
        <CardHeader>
          <CardTitle>Supabase Setup</CardTitle>
          <CardDescription>Configure URL and public anon key. Values are stored in your browser.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          <div className="space-y-2">
            <Label>Supabase URL</Label>
            <Input value={url} onChange={(e) => setUrl(e.target.value)} placeholder="https://xxxx.supabase.co" />
          </div>
          <div className="space-y-2">
            <Label>Supabase Public Key</Label>
            <Input value={key} onChange={(e) => setKey(e.target.value)} placeholder="eyJhbGciOi..." />
          </div>
          <div className="flex gap-2">
            <Button onClick={save}>Save</Button>
            <Button variant="outline" onClick={testConnection} disabled={testing}>
              {testing ? "Testing..." : "Test Connection"}
            </Button>
            <Button variant="secondary" onClick={() => navigate("/auth")}>Go to Auth</Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
