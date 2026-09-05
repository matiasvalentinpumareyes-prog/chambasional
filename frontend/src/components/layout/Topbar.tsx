import { LogOut, FlaskConical } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { IS_MOCK_MODE } from "@/services/api";

export function Topbar({ title, subtitle }: { title: string; subtitle?: string }) {
  const { user, logout } = useAuth();
  return (
    <header className="sticky top-0 z-10 bg-bg/95 backdrop-blur border-b border-border px-8 py-4 flex items-center justify-between">
      <div>
        <h1 className="font-display font-semibold text-[20px] text-ink">{title}</h1>
        {subtitle && <p className="text-[13px] text-muted mt-0.5">{subtitle}</p>}
      </div>
      <div className="flex items-center gap-4">
        {IS_MOCK_MODE && (
          <span className="hidden sm:inline-flex items-center gap-1.5 text-[12px] text-urgent-dark bg-urgent-light px-2.5 py-1 rounded">
            <FlaskConical size={13} /> Modo demo — datos sintéticos
          </span>
        )}
        <div className="text-right hidden sm:block">
          <p className="text-[13px] font-medium text-ink leading-tight">{user?.name}</p>
          <p className="text-[12px] text-muted leading-tight">{user?.businessName}</p>
        </div>
        <button
          onClick={logout}
          aria-label="Cerrar sesión"
          className="text-muted hover:text-ink p-2 rounded hover:bg-ink/5 focus:outline-none focus:ring-2 focus:ring-brand/30"
        >
          <LogOut size={17} />
        </button>
      </div>
    </header>
  );
}
