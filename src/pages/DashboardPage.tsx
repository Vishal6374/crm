import { useEffect, useState } from "react";
import { startOfWeek, endOfWeek, subMonths, format, eachDayOfInterval, isSameDay } from "date-fns";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { supabase } from "@/integrations/supabase/client";
import { Tables } from "@/integrations/supabase/types";
import { useAuth } from "@/contexts/AuthContext";
import {
  Target,
  Briefcase,
  Users,
  ClipboardList,
  TrendingUp,
  TrendingDown,
  Plus,
  ArrowRight,
} from "lucide-react";
import { Link } from "react-router-dom";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
} from "recharts";

interface StatCardProps {
  title: string;
  value: string | number;
  change?: string;
  trend?: "up" | "down" | "neutral";
  icon: React.ReactNode;
}

function StatCard({ title, value, change, trend, icon }: StatCardProps) {
  return (
    <Card className="stat-card">
      <div className="flex items-start justify-between">
        <div>
          <p className="text-sm font-medium text-muted-foreground">{title}</p>
          <p className="text-3xl font-bold mt-2">{value}</p>
          {change && (
            <div className="flex items-center gap-1 mt-2">
              {trend === "up" && <TrendingUp className="h-4 w-4 text-success" />}
              {trend === "down" && <TrendingDown className="h-4 w-4 text-destructive" />}
              <span
                className={`text-sm ${
                  trend === "up" ? "text-success" : trend === "down" ? "text-destructive" : "text-muted-foreground"
                }`}
              >
                {change}
              </span>
            </div>
          )}
        </div>
        <div className="h-12 w-12 rounded-lg bg-primary/10 flex items-center justify-center">
          {icon}
        </div>
      </div>
    </Card>
  );
}

export default function DashboardPage() {
  const { user } = useAuth();
  const [stats, setStats] = useState({
    leads: 0,
    deals: 0,
    employees: 0,
    tasks: 0,
  });
  const [loading, setLoading] = useState(true);
  const [revenueData, setRevenueData] = useState<{ month: string; value: number }[]>([]);
  const [dealStageData, setDealStageData] = useState<{ name: string; value: number; color: string }[]>([]);
  const [taskData, setTaskData] = useState<{ name: string; completed: number; pending: number }[]>([]);

  useEffect(() => {
    async function fetchStats() {
      try {
        const today = new Date();
        const startOfCurrentWeek = startOfWeek(today, { weekStartsOn: 1 });
        const endOfCurrentWeek = endOfWeek(today, { weekStartsOn: 1 });
        const sixMonthsAgo = subMonths(today, 6);

        const [leadsRes, dealsRes, employeesRes, tasksRes, revenueDealsRes, weekTasksRes] = await Promise.all([
          supabase.from("leads").select("id", { count: "exact", head: true }),
          supabase.from("deals").select("id, stage, value", { count: "exact" }),
          supabase.from("employees").select("id", { count: "exact", head: true }),
          supabase.from("tasks").select("id", { count: "exact", head: true }).neq("status", "completed"),
          supabase.from("deals").select("value, created_at").eq("stage", "closed_won").gte("created_at", sixMonthsAgo.toISOString()),
          supabase.from("tasks").select("status, due_date").gte("due_date", startOfCurrentWeek.toISOString()).lte("due_date", endOfCurrentWeek.toISOString())
        ]);

        setStats({
          leads: leadsRes.count || 0,
          deals: dealsRes.count || 0,
          employees: employeesRes.count || 0,
          tasks: tasksRes.count || 0,
        });

        // Process Deal Stages
        if (dealsRes.data) {
          const stageColors: Record<string, string> = {
            prospecting: "hsl(217, 91%, 60%)",
            qualification: "hsl(142, 76%, 36%)",
            proposal: "hsl(38, 92%, 50%)",
            negotiation: "hsl(280, 87%, 65%)",
            closed_won: "hsl(142, 76%, 46%)",
            closed_lost: "hsl(0, 84%, 60%)",
          };

          const stages = ["prospecting", "qualification", "proposal", "negotiation", "closed_won"];
          const dealsData = (dealsRes.data || []) as Tables<'deals'>[];
          const pipeline = stages.map(stage => ({
            name: stage.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' '),
            value: dealsData.filter((d) => d.stage === stage).length,
            color: stageColors[stage] || "hsl(0, 0%, 50%)"
          })).filter(d => d.value > 0);
          setDealStageData(pipeline);
        }

        // Process Revenue
        if (revenueDealsRes.data) {
          const last6Months = Array.from({ length: 6 }, (_, i) => {
            const date = subMonths(today, 5 - i);
            return {
              month: format(date, "MMM"),
              year: date.getFullYear(),
              monthIndex: date.getMonth(),
              value: 0
            };
          });

          const revenueDeals = (revenueDealsRes.data || []) as Tables<'deals'>[];
          revenueDeals.forEach((deal) => {
            const date = new Date(deal.created_at);
            const monthEntry = last6Months.find(m => m.monthIndex === date.getMonth() && m.year === date.getFullYear());
            if (monthEntry) {
              monthEntry.value += Number(deal.value) || 0;
            }
          });

          setRevenueData(last6Months.map(({ month, value }) => ({ month, value })));
        }

        // Process Weekly Tasks
        if (weekTasksRes.data) {
          const weekDays = eachDayOfInterval({ start: startOfCurrentWeek, end: endOfCurrentWeek });
          const tasksWeek = (weekTasksRes.data || []) as Tables<'tasks'>[];
          const weekly = weekDays.map(day => {
            const dayTasks = tasksWeek.filter((t) => t.due_date && isSameDay(new Date(t.due_date), day));
            return {
              name: format(day, "EEE"),
              completed: dayTasks.filter((t) => t.status === "completed").length,
              pending: dayTasks.filter((t) => t.status !== "completed").length
            };
          });
          setTaskData(weekly);
        }

      } catch (error) {
        console.error("Error fetching stats:", error);
      } finally {
        setLoading(false);
      }
    }

    fetchStats();
  }, []);

  const greeting = () => {
    const hour = new Date().getHours();
    if (hour < 12) return "Good morning";
    if (hour < 18) return "Good afternoon";
    return "Good evening";
  };

  return (
    <div className="space-y-8 animate-fade-in">
      {/* Header */}
      <div className="page-header">
        <h1 className="page-title">{greeting()}, {user?.email?.split("@")[0]}!</h1>
        <p className="page-description">Here's what's happening with your business today.</p>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="Total Leads"
          value={stats.leads}
          change="+12% from last month"
          trend="up"
          icon={<Target className="h-6 w-6 text-primary" />}
        />
        <StatCard
          title="Active Deals"
          value={stats.deals}
          change="+8% from last month"
          trend="up"
          icon={<Briefcase className="h-6 w-6 text-primary" />}
        />
        <StatCard
          title="Employees"
          value={stats.employees}
          change="No change"
          trend="neutral"
          icon={<Users className="h-6 w-6 text-primary" />}
        />
        <StatCard
          title="Open Tasks"
          value={stats.tasks}
          change="-5% from last week"
          trend="down"
          icon={<ClipboardList className="h-6 w-6 text-primary" />}
        />
      </div>

      {/* Charts Row */}
      <div className="grid gap-6 lg:grid-cols-2">
        {/* Revenue Chart */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle>Revenue Overview</CardTitle>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/reports">
                View all <ArrowRight className="ml-1 h-4 w-4" />
              </Link>
            </Button>
          </CardHeader>
          <CardContent>
            <div className="h-[300px]">
              <ResponsiveContainer width="100%" height="100%">
                <LineChart data={revenueData}>
                  <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
                  <XAxis dataKey="month" className="text-xs" />
                  <YAxis className="text-xs" />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: "hsl(var(--card))",
                      border: "1px solid hsl(var(--border))",
                      borderRadius: "8px",
                    }}
                  />
                  <Line
                    type="monotone"
                    dataKey="value"
                    stroke="hsl(var(--primary))"
                    strokeWidth={2}
                    dot={{ fill: "hsl(var(--primary))" }}
                  />
                </LineChart>
              </ResponsiveContainer>
            </div>
          </CardContent>
        </Card>

        {/* Deal Pipeline */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle>Deal Pipeline</CardTitle>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/deals">
                View all <ArrowRight className="ml-1 h-4 w-4" />
              </Link>
            </Button>
          </CardHeader>
          <CardContent>
            <div className="h-[300px] flex items-center justify-center">
              <ResponsiveContainer width="100%" height="100%">
                <PieChart>
                  <Pie
                    data={dealStageData}
                    cx="50%"
                    cy="50%"
                    innerRadius={60}
                    outerRadius={100}
                    paddingAngle={4}
                    dataKey="value"
                  >
                    {dealStageData.map((entry, index) => (
                      <Cell key={`cell-${index}`} fill={entry.color} />
                    ))}
                  </Pie>
                  <Tooltip
                    contentStyle={{
                      backgroundColor: "hsl(var(--card))",
                      border: "1px solid hsl(var(--border))",
                      borderRadius: "8px",
                    }}
                  />
                </PieChart>
              </ResponsiveContainer>
            </div>
            <div className="flex flex-wrap gap-4 justify-center mt-4">
              {dealStageData.map((item) => (
                <div key={item.name} className="flex items-center gap-2">
                  <div
                    className="h-3 w-3 rounded-full"
                    style={{ backgroundColor: item.color }}
                  />
                  <span className="text-sm text-muted-foreground">{item.name}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Tasks Chart */}
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle>Weekly Task Overview</CardTitle>
          <Button variant="ghost" size="sm" asChild>
            <Link to="/tasks">
              View all <ArrowRight className="ml-1 h-4 w-4" />
            </Link>
          </Button>
        </CardHeader>
        <CardContent>
          <div className="h-[250px]">
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={taskData}>
                <CartesianGrid strokeDasharray="3 3" className="stroke-muted" />
                <XAxis dataKey="name" className="text-xs" />
                <YAxis className="text-xs" />
                <Tooltip
                  contentStyle={{
                    backgroundColor: "hsl(var(--card))",
                    border: "1px solid hsl(var(--border))",
                    borderRadius: "8px",
                  }}
                />
                <Bar dataKey="completed" fill="hsl(var(--chart-2))" radius={[4, 4, 0, 0]} />
                <Bar dataKey="pending" fill="hsl(var(--chart-3))" radius={[4, 4, 0, 0]} />
              </BarChart>
            </ResponsiveContainer>
          </div>
        </CardContent>
      </Card>

      {/* Quick Actions */}
      <Card>
        <CardHeader>
          <CardTitle>Quick Actions</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
            <Button asChild className="justify-start">
              <Link to="/leads">
                <Plus className="mr-2 h-4 w-4" /> New Lead
              </Link>
            </Button>
            <Button asChild variant="secondary" className="justify-start">
              <Link to="/deals">
                <Plus className="mr-2 h-4 w-4" /> New Deal
              </Link>
            </Button>
            <Button asChild variant="secondary" className="justify-start">
              <Link to="/tasks">
                <Plus className="mr-2 h-4 w-4" /> New Task
              </Link>
            </Button>
            <Button asChild variant="secondary" className="justify-start">
              <Link to="/contacts">
                <Plus className="mr-2 h-4 w-4" /> New Contact
              </Link>
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
