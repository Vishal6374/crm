import { useEffect, useState } from "react";
import { useNavigate, useSearchParams } from "react-router-dom";
import { supabase } from "@/integrations/supabase/client";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { useToast } from "@/hooks/use-toast";
import { Loader2, CheckCircle2, XCircle } from "lucide-react";

export default function AcceptInvitePage() {
  const [searchParams] = useSearchParams();
  const token = searchParams.get("token");
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [status, setStatus] = useState<"loading" | "success" | "error" | "idle">("idle");
  const [message, setMessage] = useState("");

  useEffect(() => {
    async function run() {
      if (!token) {
        setStatus("error");
        setMessage("No invitation token provided.");
        return;
      }
      setStatus("loading");
      try {
        const { data: { session } } = await supabase.auth.getSession();
        if (!session) {
          const returnUrl = encodeURIComponent(window.location.pathname + window.location.search);
          navigate(`/auth?return_to=${returnUrl}`);
          return;
        }
        const { data, error } = await supabase.rpc("accept_invitation", { token_input: token });
        if (error) throw error;
        if (data && (data as { success?: boolean }).success) {
          const msg = (data as { message?: string }).message || "Invitation accepted.";
          setStatus("success");
          setMessage(msg);
          toast({ title: "Welcome!", description: msg });
          setTimeout(() => {
            navigate("/dashboard");
            window.location.reload();
          }, 2000);
        } else {
          const msg = (data as { message?: string })?.message || "Failed to accept invitation.";
          throw new Error(msg);
        }
      } catch (err) {
        const msg = err instanceof Error ? err.message : "An unexpected error occurred.";
        setStatus("error");
        setMessage(msg);
      }
    }
    run();
  }, [token, navigate, toast]);

  // acceptInvite handled inline in useEffect

  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4">
      <Card className="w-full max-w-md">
        <CardHeader>
          <CardTitle>Join Organization</CardTitle>
          <CardDescription>Processing your invitation...</CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col items-center gap-4 py-6">
          
          {status === "loading" && (
            <div className="flex flex-col items-center gap-2">
              <Loader2 className="h-12 w-12 animate-spin text-primary" />
              <p className="text-muted-foreground">Verifying invitation...</p>
            </div>
          )}

          {status === "success" && (
            <div className="flex flex-col items-center gap-2 text-center">
              <CheckCircle2 className="h-12 w-12 text-green-500" />
              <p className="text-lg font-medium">{message}</p>
              <p className="text-sm text-muted-foreground">Redirecting to dashboard...</p>
            </div>
          )}

          {status === "error" && (
            <div className="flex flex-col items-center gap-2 text-center">
              <XCircle className="h-12 w-12 text-destructive" />
              <p className="text-lg font-medium text-destructive">Error</p>
              <p className="text-muted-foreground">{message}</p>
              <Button onClick={() => navigate("/dashboard")} variant="outline" className="mt-4">
                Go to Dashboard
              </Button>
            </div>
          )}

          {status === "idle" && !token && (
             <div className="text-center">
                <p>Invalid link.</p>
                <Button onClick={() => navigate("/dashboard")} className="mt-4">Go Home</Button>
             </div>
          )}

        </CardContent>
      </Card>
    </div>
  );
}
