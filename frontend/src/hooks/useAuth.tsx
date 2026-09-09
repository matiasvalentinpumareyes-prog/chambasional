import { createContext, useContext, useEffect, useState, type ReactNode } from "react";
import { authApi } from "@/services/api";
import type { AuthUser } from "@/types";

interface AuthContextValue {
  user: AuthUser | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<void>;
  register: (payload: {
    emp_ruc: string;
    emp_razon_social: string;
    emp_nombre_comercial: string;
    emp_email?: string;
    usp_nombres: string;
    usp_dni?: string;
    usu_usuario: string;
    usu_email: string;
    password: string;
    rol_codigo?: string;
  }) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextValue | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<AuthUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const init = async () => {
      const cached = authApi.currentUser();
      const token = localStorage.getItem("auth_token");
      if (cached && token) {
        // Validar contra backend sin hardcodear: si token expiró, limpia sesión
        const validated = await authApi.me();
        if (validated) {
          setUser(validated);
        } else {
          // Token inválido: limpiar pero mantener UI sin error
          authApi.logout();
          setUser(null);
        }
      } else if (cached) {
        setUser(cached);
      }
      setIsLoading(false);
    };
    init();
  }, []);

  async function login(email: string, password: string) {
    const loggedUser = await authApi.login(email, password);
    setUser(loggedUser);
  }

  async function register(payload: {
    emp_ruc: string;
    emp_razon_social: string;
    emp_nombre_comercial: string;
    emp_email?: string;
    usp_nombres: string;
    usp_dni?: string;
    usu_usuario: string;
    usu_email: string;
    password: string;
    rol_codigo?: string;
  }) {
    const newUser = await authApi.register(payload);
    setUser(newUser);
  }

  function logout() {
    authApi.logout();
    setUser(null);
  }

  return <AuthContext.Provider value={{ user, isLoading, login, register, logout }}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth debe usarse dentro de <AuthProvider>");
  return ctx;
}
