import { BrowserRouter, Routes, Route } from "react-router-dom";
import { AuthProvider } from "@/hooks/useAuth";
import { ProtectedRoute } from "@/components/layout/ProtectedRoute";
import { LoginPage } from "@/pages/LoginPage";
import { DashboardPage } from "@/pages/DashboardPage";
import { TodayActionsPage } from "@/pages/TodayActionsPage";
import { CustomersPage } from "@/pages/CustomersPage";
import { AtRiskPage } from "@/pages/AtRiskPage";
import { ProductsPage } from "@/pages/ProductsPage";
import { StockPage } from "@/pages/StockPage";
import { CategoriesPage, SubcategoriasPage } from "@/pages/CategoriesPage";
import { SalesPage } from "@/pages/SalesPage";
import { CampaignsPage } from "@/pages/CampaignsPage";
import { AnalyticsPage } from "@/pages/AnalyticsPage";
import { ModelsPage } from "@/pages/ModelsPage";
import { ImportsPage } from "@/pages/ImportsPage";
import { SettingsPage } from "@/pages/SettingsPage";

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
          <Route path="/hoy" element={<ProtectedRoute><TodayActionsPage /></ProtectedRoute>} />
          <Route path="/clientes" element={<ProtectedRoute><CustomersPage /></ProtectedRoute>} />
          <Route path="/riesgo" element={<ProtectedRoute><AtRiskPage /></ProtectedRoute>} />
          <Route path="/productos" element={<ProtectedRoute><ProductsPage /></ProtectedRoute>} />
          <Route path="/stock" element={<ProtectedRoute><StockPage /></ProtectedRoute>} />
          <Route path="/categorias" element={<ProtectedRoute><CategoriesPage /></ProtectedRoute>} />
          <Route path="/subcategorias" element={<ProtectedRoute><SubcategoriasPage /></ProtectedRoute>} />
          <Route path="/ventas" element={<ProtectedRoute><SalesPage /></ProtectedRoute>} />
          <Route path="/campanas" element={<ProtectedRoute><CampaignsPage /></ProtectedRoute>} />
          <Route path="/analitica" element={<ProtectedRoute><AnalyticsPage /></ProtectedRoute>} />
          <Route path="/modelos" element={<ProtectedRoute><ModelsPage /></ProtectedRoute>} />
          <Route path="/importaciones" element={<ProtectedRoute><ImportsPage /></ProtectedRoute>} />
          <Route path="/configuracion" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
          <Route path="/configuracion/empresa" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
          <Route path="/configuracion/usuarios" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
          <Route path="/configuracion/roles" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
          <Route path="/configuracion/perfil" element={<ProtectedRoute><SettingsPage /></ProtectedRoute>} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}
