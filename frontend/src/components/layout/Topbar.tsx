import { useEffect, useRef, useState } from "react";
import { LogOut, User, Settings, ChevronDown } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "@/hooks/useAuth";

export function Topbar({ title, subtitle }: { title: string; subtitle?: string }) {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const [open, setOpen] = useState(false);
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    function onClickOutside(e: MouseEvent) {
      if (ref.current && !ref.current.contains(e.target as Node)) setOpen(false);
    }
    function onKey(e: KeyboardEvent) {
      if (e.key === "Escape") setOpen(false);
    }
    document.addEventListener("mousedown", onClickOutside);
    document.addEventListener("keydown", onKey);
    return () => {
      document.removeEventListener("mousedown", onClickOutside);
      document.removeEventListener("keydown", onKey);
    };
  }, []);

  function handleLogout() {
    setOpen(false);
    logout();
    navigate("/login");
  }

  return (
    <header className="sticky top-0 z-20 bg-surface border-b border-border px-8 py-2.5 flex items-center justify-between">
      <div>
        <h1 className="font-display font-semibold text-[20px] text-ink">{title}</h1>
        {subtitle && <p className="text-[13px] text-muted mt-0.5">{subtitle}</p>}
      </div>

      <div className="flex items-center gap-3">
        <div ref={ref} className="relative">
          <button
            onClick={() => setOpen((v) => !v)}
            aria-haspopup="menu"
            aria-expanded={open}
            className="flex items-center gap-2.5 pl-1.5 pr-2 py-1.5 rounded-full hover:bg-ink/[0.04] transition-colors focus:outline-none focus:ring-2 focus:ring-brand/20"
          >
            <span className="w-8 h-8 rounded-full bg-ink/[0.06] border border-border flex items-center justify-center shrink-0">
              <User size={16} className="text-ink/70" />
            </span>
            <span className="hidden sm:block text-left leading-tight pr-1">
              <span className="block text-[13px] font-medium text-ink leading-none">{user?.name ?? "Usuario"}</span>
              <span className="block text-[11px] text-muted leading-none mt-0.5 truncate max-w-[160px]">{user?.businessName ?? user?.email ?? ""}</span>
            </span>
            <ChevronDown size={14} className={`text-muted/70 transition-transform ${open ? "rotate-180" : ""}`} />
          </button>

          {open && (
            <div
              role="menu"
              className="absolute right-0 mt-2 w-56 bg-surface border border-border rounded-lg shadow-lg py-1.5 z-30 overflow-hidden"
            >
              <div className="px-3.5 py-2.5 border-b border-border">
                <p className="text-[13px] font-medium text-ink leading-tight truncate">{user?.name}</p>
                <p className="text-[12px] text-muted leading-tight truncate">{user?.email}</p>
                <p className="text-[11px] text-muted mt-1 truncate">{user?.businessName}</p>
              </div>
              <button
                role="menuitem"
                onClick={() => {
                  setOpen(false);
                  navigate("/configuracion");
                }}
                className="w-full flex items-center gap-2.5 px-3.5 py-2 text-[13px] text-ink hover:bg-ink/5 transition-colors text-left"
              >
                <User size={15} className="text-muted" /> Perfil
              </button>
              <button
                role="menuitem"
                onClick={() => {
                  setOpen(false);
                  navigate("/configuracion");
                }}
                className="w-full flex items-center gap-2.5 px-3.5 py-2 text-[13px] text-ink hover:bg-ink/5 transition-colors text-left"
              >
                <Settings size={15} className="text-muted" /> Configuración
              </button>
              <div className="my-1 border-t border-border" />
              <button
                role="menuitem"
                onClick={handleLogout}
                className="w-full flex items-center gap-2.5 px-3.5 py-2 text-[13px] text-risk-critical hover:bg-risk-critical/5 transition-colors text-left"
              >
                <LogOut size={15} /> Cerrar sesión
              </button>
            </div>
          )}
        </div>
      </div>
    </header>
  );
}
