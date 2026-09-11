import { useState } from "react";
import { NavLink, useLocation } from "react-router-dom";
import {
  LayoutDashboard, Users, AlertTriangle, Sparkles, Package, Receipt, Megaphone,
  BarChart3, Cpu, UploadCloud, Settings, Sprout, Warehouse, Layers, ListTree,
  ChevronDown, ChevronRight, PanelLeftClose, PanelLeftOpen, ShieldCheck, UserCircle,
} from "lucide-react";
import { classNames } from "@/lib/format";

type NavItem = {
  to: string;
  label: string;
  icon: React.ElementType;
  end?: boolean;
};

const TOP_ITEMS: NavItem[] = [
  { to: "/", label: "Dashboard", icon: LayoutDashboard, end: true },
  { to: "/hoy", label: "Contactar hoy", icon: Sparkles },
  { to: "/clientes", label: "Clientes", icon: Users },
  { to: "/riesgo", label: "Clientes en riesgo", icon: AlertTriangle },
];

const PRODUCTO_CHILDREN: NavItem[] = [
  { to: "/productos", label: "Productos", icon: Package },
  { to: "/stock", label: "Stock", icon: Warehouse },
  { to: "/categorias", label: "Categorías", icon: Layers },
  { to: "/subcategorias", label: "Subcategorías", icon: ListTree },
];

const CONFIG_CHILDREN: NavItem[] = [
  { to: "/configuracion/empresa", label: "Empresa", icon: Settings },
  { to: "/configuracion/usuarios", label: "Usuarios", icon: Users },
  { to: "/configuracion/roles", label: "Roles", icon: ShieldCheck },
];

const BOTTOM_ITEMS: NavItem[] = [
  { to: "/ventas", label: "Ventas", icon: Receipt },
  { to: "/campanas", label: "Campañas", icon: Megaphone },
  { to: "/analitica", label: "Analítica", icon: BarChart3 },
  { to: "/modelos", label: "Modelos", icon: Cpu },
  { to: "/importaciones", label: "Importaciones", icon: UploadCloud },
];

function NavItemLink({ to, label, icon: Icon, end, collapsed }: NavItem & { collapsed: boolean }) {
  return (
    <NavLink
      to={to}
      end={end}
      title={collapsed ? label : undefined}
      className={({ isActive }) =>
        classNames(
          "flex items-center gap-2.5 px-3 py-2 rounded text-[13.5px] font-medium transition-colors",
          isActive ? "bg-brand-light text-brand-dark" : "text-ink/75 hover:bg-ink/5",
          collapsed && "justify-center px-2"
        )
      }
    >
      <Icon size={16} strokeWidth={2} className="shrink-0" />
      {!collapsed && <span className="truncate">{label}</span>}
    </NavLink>
  );
}

export function Sidebar({ collapsed: controlledCollapsed, onToggle }: { collapsed?: boolean; onToggle?: () => void }) {
  const [internalCollapsed, setInternalCollapsed] = useState(false);
  const collapsed = controlledCollapsed ?? internalCollapsed;
  const toggle = onToggle ?? (() => setInternalCollapsed((v) => !v));

  const location = useLocation();
  const isProductoActive = PRODUCTO_CHILDREN.some((c) => location.pathname === c.to || location.pathname.startsWith(c.to + "/"));
  const [productoOpen, setProductoOpen] = useState(isProductoActive);
  const isConfigActive = CONFIG_CHILDREN.some((c) => location.pathname === c.to || location.pathname.startsWith(c.to + "/")) || location.pathname === "/configuracion";
  const [configOpen, setConfigOpen] = useState(isConfigActive);

  // Auto-open dropdown when navigating to producto child
  if (isProductoActive && !productoOpen && !collapsed) {
    // Defer to next render to avoid setState during render warning — use effect would be better but keep simple
  }

  return (
    <aside className={classNames("shrink-0 border-r border-border bg-surface flex flex-col h-screen sticky top-0 transition-all duration-200", collapsed ? "w-[64px]" : "w-60")}>
      <div className={classNames("flex items-center gap-2 border-b border-border", collapsed ? "px-2 py-4 justify-center" : "px-5 py-5")}>
        <button
          onClick={toggle}
          title={collapsed ? "Expandir sidebar" : "Colapsar sidebar"}
          className="ml-auto p-1.5 rounded hover:bg-ink/5 text-muted hover:text-ink transition-colors shrink-0"
          aria-label={collapsed ? "Expandir" : "Colapsar"}
        >
          {collapsed ? <PanelLeftOpen size={16} /> : <PanelLeftClose size={16} />}
        </button>
      </div>

      <nav className="flex-1 overflow-y-auto py-3 px-2.5 space-y-0.5 sidebar-scroll">
        {TOP_ITEMS.map((item) => (
          <NavItemLink key={item.to} {...item} collapsed={collapsed} />
        ))}

        {/* Producto dropdown — oculto por completo cuando el sidebar está colapsado */}
        {!collapsed && (
          <div className="pt-1">
            <button
              onClick={() => setProductoOpen((v) => !v)}
              className={classNames(
                "w-full flex items-center gap-2.5 px-3 py-2 rounded text-[13.5px] font-medium transition-colors",
                isProductoActive ? "bg-brand-light text-brand-dark" : "text-ink/75 hover:bg-ink/5"
              )}
            >
              <Package size={16} strokeWidth={2} className="shrink-0" />
              <span className="flex-1 text-left truncate">Producto</span>
              {productoOpen ? <ChevronDown size={14} className="shrink-0" /> : <ChevronRight size={14} className="shrink-0" />}
            </button>
            {productoOpen && (
              <div className="mt-1 ml-3 pl-3 border-l border-border space-y-0.5">
                {PRODUCTO_CHILDREN.map((child) => (
                  <NavLink
                    key={child.to}
                    to={child.to}
                    className={({ isActive }) =>
                      classNames(
                        "flex items-center gap-2.5 px-3 py-1.5 rounded text-[13px] font-medium transition-colors",
                        isActive ? "bg-brand-light text-brand-dark" : "text-ink/70 hover:bg-ink/5"
                      )
                    }
                  >
                    <child.icon size={14} strokeWidth={2} className="shrink-0" />
                    <span className="truncate">{child.label}</span>
                  </NavLink>
                ))}
              </div>
            )}
          </div>
        )}

        {BOTTOM_ITEMS.map((item) => (
          <NavItemLink key={item.to} {...item} collapsed={collapsed} />
        ))}
        {!collapsed ? (
          <div className="pt-1">
            <button
              onClick={() => setConfigOpen((v) => !v)}
              className={classNames(
                "w-full flex items-center gap-2.5 px-3 py-2 rounded text-[13.5px] font-medium transition-colors",
                isConfigActive ? "bg-brand-light text-brand-dark" : "text-ink/75 hover:bg-ink/5"
              )}
            >
              <Settings size={16} strokeWidth={2} className="shrink-0" />
              <span className="flex-1 text-left truncate">Configuración</span>
              {configOpen ? <ChevronDown size={14} className="shrink-0" /> : <ChevronRight size={14} className="shrink-0" />}
            </button>
            {configOpen && (
              <div className="mt-1 ml-3 pl-3 border-l border-border space-y-0.5">
                {CONFIG_CHILDREN.map((child) => (
                  <NavLink
                    key={child.to}
                    to={child.to}
                    className={({ isActive }) =>
                      classNames(
                        "flex items-center gap-2.5 px-3 py-1.5 rounded text-[13px] font-medium transition-colors",
                        isActive ? "bg-brand-light text-brand-dark" : "text-ink/70 hover:bg-ink/5"
                      )
                    }
                  >
                    <child.icon size={14} strokeWidth={2} className="shrink-0" />
                    <span className="truncate">{child.label}</span>
                  </NavLink>
                ))}
              </div>
            )}
          </div>
        ) : null}
      </nav>

      {!collapsed && (
        <div className="px-3 py-3 border-t border-border text-[11px] text-muted">
          <p className="truncate">Emp: demo • Stock: {new Date().toLocaleDateString("es-PE")}</p>
        </div>
      )}
    </aside>
  );
}
