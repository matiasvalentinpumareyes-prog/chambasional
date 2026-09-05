import { NavLink } from "react-router-dom";
import {
  LayoutDashboard, Users, AlertTriangle, Sparkles, Package, Receipt, Megaphone,
  BarChart3, Cpu, UploadCloud, Settings, Sprout,
} from "lucide-react";
import { classNames } from "@/lib/format";

const NAV_ITEMS = [
  { to: "/", label: "Dashboard", icon: LayoutDashboard, end: true },
  { to: "/hoy", label: "Contactar hoy", icon: Sparkles },
  { to: "/clientes", label: "Clientes", icon: Users },
  { to: "/riesgo", label: "Clientes en riesgo", icon: AlertTriangle },
  { to: "/productos", label: "Productos", icon: Package },
  { to: "/ventas", label: "Ventas", icon: Receipt },
  { to: "/campanas", label: "Campañas", icon: Megaphone },
  { to: "/analitica", label: "Analítica", icon: BarChart3 },
  { to: "/modelos", label: "Modelos", icon: Cpu },
  { to: "/importaciones", label: "Importaciones", icon: UploadCloud },
  { to: "/configuracion", label: "Configuración", icon: Settings },
];

export function Sidebar() {
  return (
    <aside className="w-60 shrink-0 border-r border-border bg-surface flex flex-col h-screen sticky top-0">
      <div className="px-5 py-5 flex items-center gap-2 border-b border-border">
        <div className="w-8 h-8 rounded bg-brand flex items-center justify-center text-white">
          <Sprout size={18} />
        </div>
        <div>
          <p className="font-display font-semibold text-[14px] leading-tight text-ink">Marketing Predictivo</p>
          <p className="text-[11px] text-muted leading-tight">Panel de negocio</p>
        </div>
      </div>
      <nav className="flex-1 overflow-y-auto py-3 px-2.5 space-y-0.5">
        {NAV_ITEMS.map(({ to, label, icon: Icon, end }) => (
          <NavLink
            key={to}
            to={to}
            end={end}
            className={({ isActive }) =>
              classNames(
                "flex items-center gap-2.5 px-3 py-2 rounded text-[13.5px] font-medium transition-colors",
                isActive ? "bg-brand-light text-brand-dark" : "text-ink/75 hover:bg-ink/5"
              )
            }
          >
            <Icon size={16} strokeWidth={2} />
            {label}
          </NavLink>
        ))}
      </nav>
    </aside>
  );
}
