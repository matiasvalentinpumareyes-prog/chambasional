import {
  ResponsiveContainer, LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid,
  Tooltip, PieChart, Pie, Cell,
} from "recharts";
import type { SeriesPoint } from "@/types";

const COLORS = ["#1F6F5C", "#E7A33E", "#B5442E", "#3C8361", "#C79A2A", "#164F42", "#D97706", "#5B6660"];

const tooltipStyle = {
  contentStyle: { borderRadius: 6, border: "1px solid #E1E4DC", fontSize: 12.5, fontFamily: "IBM Plex Sans" },
};

export function SimpleLineChart({ data, height = 220, color = "#1F6F5C" }: { data?: SeriesPoint[] | null; height?: number; color?: string }) {
  const safeData = data ?? [];
  if (safeData.length === 0) {
    return <div className="flex items-center justify-center text-sm text-muted" style={{ height }}>Sin datos suficientes</div>;
  }
  return (
    <ResponsiveContainer width="100%" height={height}>
      <LineChart data={safeData} margin={{ top: 4, right: 8, left: -18, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#E1E4DC" vertical={false} />
        <XAxis dataKey="label" tick={{ fontSize: 11, fill: "#5B6660" }} axisLine={{ stroke: "#E1E4DC" }} tickLine={false} />
        <YAxis tick={{ fontSize: 11, fill: "#5B6660" }} axisLine={false} tickLine={false} width={44} />
        <Tooltip {...tooltipStyle} />
        <Line type="monotone" dataKey="value" stroke={color} strokeWidth={2.2} dot={false} />
      </LineChart>
    </ResponsiveContainer>
  );
}

export function SimpleBarChart({ data, height = 220, color = "#1F6F5C", horizontal = false }: { data?: SeriesPoint[] | null; height?: number; color?: string; horizontal?: boolean }) {
  const safeData = data ?? [];
  if (safeData.length === 0) {
    return <div className="flex items-center justify-center text-sm text-muted" style={{ height }}>Sin datos suficientes</div>;
  }
  return (
    <ResponsiveContainer width="100%" height={height}>
      <BarChart data={safeData} layout={horizontal ? "vertical" : "horizontal"} margin={{ top: 4, right: 12, left: horizontal ? 8 : -18, bottom: 0 }}>
        <CartesianGrid strokeDasharray="3 3" stroke="#E1E4DC" horizontal={!horizontal} vertical={horizontal} />
        {horizontal ? (
          <>
            <XAxis type="number" tick={{ fontSize: 11, fill: "#5B6660" }} axisLine={false} tickLine={false} />
            <YAxis type="category" dataKey="label" tick={{ fontSize: 11, fill: "#5B6660" }} axisLine={false} tickLine={false} width={120} />
          </>
        ) : (
          <>
            <XAxis dataKey="label" tick={{ fontSize: 11, fill: "#5B6660" }} axisLine={{ stroke: "#E1E4DC" }} tickLine={false} />
            <YAxis tick={{ fontSize: 11, fill: "#5B6660" }} axisLine={false} tickLine={false} width={44} />
          </>
        )}
        <Tooltip {...tooltipStyle} />
        <Bar dataKey="value" fill={color} radius={[3, 3, 3, 3]} />
      </BarChart>
    </ResponsiveContainer>
  );
}

export function SimplePieChart({ data, height = 220 }: { data?: SeriesPoint[] | null; height?: number }) {
  const safeData = data ?? [];
  if (safeData.length === 0) {
    return <div className="flex items-center justify-center text-sm text-muted" style={{ height }}>Sin datos suficientes</div>;
  }
  return (
    <ResponsiveContainer width="100%" height={height}>
      <PieChart>
        <Pie data={safeData} dataKey="value" nameKey="label" innerRadius={55} outerRadius={85} paddingAngle={2}>
          {safeData.map((_, i) => (
            <Cell key={i} fill={COLORS[i % COLORS.length]} />
          ))}
        </Pie>
        <Tooltip {...tooltipStyle} />
      </PieChart>
    </ResponsiveContainer>
  );
}
