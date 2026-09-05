import type { ReactNode } from "react";
import { classNames } from "@/lib/format";

export function Panel({ children, className, title, action }: { children: ReactNode; className?: string; title?: string; action?: ReactNode }) {
  return (
    <div className={classNames("bg-surface border border-border rounded shadow-panel", className)}>
      {(title || action) && (
        <div className="flex items-center justify-between px-5 py-4 border-b border-border">
          {title && <h3 className="font-display font-semibold text-[15px] text-ink">{title}</h3>}
          {action}
        </div>
      )}
      <div className="p-5">{children}</div>
    </div>
  );
}

const BADGE_STYLES: Record<string, string> = {
  neutral: "bg-ink/5 text-ink",
  brand: "bg-brand-light text-brand-dark",
  urgent: "bg-urgent-light text-urgent-dark",
  low: "bg-success-light text-success",
  medium: "bg-[#FBF1D6] text-risk-medium",
  high: "bg-[#FBE7D3] text-risk-high",
  critical: "bg-[#F7DED9] text-risk-critical",
  success: "bg-success-light text-success",
};

export function Badge({ tone = "neutral", children }: { tone?: keyof typeof BADGE_STYLES; children: ReactNode }) {
  return (
    <span className={classNames("inline-flex items-center gap-1 px-2 py-0.5 rounded text-[12px] font-medium", BADGE_STYLES[tone])}>
      {children}
    </span>
  );
}

export function Button({
  children,
  variant = "primary",
  size = "md",
  className,
  ...props
}: {
  children: ReactNode;
  variant?: "primary" | "secondary" | "ghost" | "danger";
  size?: "sm" | "md";
} & React.ButtonHTMLAttributes<HTMLButtonElement>) {
  const variants: Record<string, string> = {
    primary: "bg-brand text-white hover:bg-brand-dark disabled:bg-brand/40",
    secondary: "bg-surface text-ink border border-border hover:bg-ink/5",
    ghost: "text-ink hover:bg-ink/5",
    danger: "bg-risk-critical text-white hover:bg-risk-critical/90",
  };
  const sizes: Record<string, string> = {
    sm: "text-[13px] px-2.5 py-1.5",
    md: "text-[14px] px-3.5 py-2",
  };
  return (
    <button
      className={classNames(
        "rounded font-medium transition-colors inline-flex items-center gap-1.5 disabled:cursor-not-allowed",
        variants[variant],
        sizes[size],
        className
      )}
      {...props}
    >
      {children}
    </button>
  );
}

export function StatCard({
  label,
  value,
  sub,
  tone,
}: {
  label: string;
  value: string;
  sub?: string;
  tone?: "brand" | "urgent" | "critical" | "success";
}) {
  const toneColor: Record<string, string> = {
    brand: "text-brand-dark",
    urgent: "text-urgent-dark",
    critical: "text-risk-critical",
    success: "text-success",
  };
  return (
    <div className="bg-surface border border-border rounded shadow-panel px-5 py-4">
      <p className="text-[13px] text-muted mb-1.5">{label}</p>
      <p className={classNames("font-display text-[28px] leading-none font-semibold", tone ? toneColor[tone] : "text-ink")}>{value}</p>
      {sub && <p className="text-[12px] text-muted mt-1.5">{sub}</p>}
    </div>
  );
}

export function EmptyState({ title, description }: { title: string; description?: string }) {
  return (
    <div className="text-center py-14 px-6">
      <p className="font-display font-medium text-ink">{title}</p>
      {description && <p className="text-[13px] text-muted mt-1.5 max-w-md mx-auto">{description}</p>}
    </div>
  );
}

export function Spinner({ className }: { className?: string }) {
  return (
    <div
      className={classNames("inline-block w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin", className)}
    />
  );
}

export function Input(props: React.InputHTMLAttributes<HTMLInputElement>) {
  return (
    <input
      {...props}
      className={classNames(
        "w-full px-3 py-2 text-[14px] border border-border rounded bg-surface text-ink placeholder:text-muted focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand",
        props.className
      )}
    />
  );
}

export function Select({ children, ...props }: React.SelectHTMLAttributes<HTMLSelectElement>) {
  return (
    <select
      {...props}
      className={classNames(
        "px-3 py-2 text-[14px] border border-border rounded bg-surface text-ink focus:outline-none focus:ring-2 focus:ring-brand/30 focus:border-brand",
        props.className
      )}
    >
      {children}
    </select>
  );
}

export function Label({ children }: { children: ReactNode }) {
  return <label className="block text-[13px] font-medium text-ink mb-1">{children}</label>;
}

export function FieldError({ children }: { children?: string }) {
  if (!children) return null;
  return <p className="text-[12px] text-risk-critical mt-1">{children}</p>;
}
