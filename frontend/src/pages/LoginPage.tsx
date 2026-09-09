import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Sprout } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { Button, Input, Label } from "@/components/ui/Primitives";

export function LoginPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    setLoading(true);
    try {
      await login(email, password);
      navigate("/");
    } catch (err: any) {
      setError(err?.message ?? "No pudimos iniciar sesión. Verifica tus credenciales.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-bg flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        <div className="flex items-center gap-2.5 justify-center mb-8">
          <div className="w-10 h-10 rounded bg-brand flex items-center justify-center text-white">
            <Sprout size={20} />
          </div>
          <div>
            <p className="font-display font-semibold text-ink leading-tight">Marketing Predictivo</p>
            <p className="text-[12px] text-muted leading-tight">Panel de negocio</p>
          </div>
        </div>
        <div className="bg-surface border border-border rounded shadow-panel p-6">
          <h2 className="font-display font-semibold text-[17px] mb-1">Inicia sesión</h2>
          <p className="text-[13px] text-muted mb-5">Accede con tu cuenta registrada.</p>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <Label>Correo electrónico</Label>
              <Input type="email" required value={email} onChange={(e) => setEmail(e.target.value)} placeholder="tucorreo@negocio.com" />
            </div>
            <div>
              <Label>Contraseña</Label>
              <Input type="password" required value={password} onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" />
            </div>
            {error && <p className="text-[13px] text-risk-critical">{error}</p>}
            <Button type="submit" disabled={loading} className="w-full justify-center">
              {loading ? "Ingresando..." : "Ingresar"}
            </Button>
          </form>
          <p className="text-[13px] text-center mt-4">
            <span className="text-muted">¿No tienes cuenta? </span>
            <a href="/register" className="text-brand-dark font-medium hover:underline">Regístrate</a>
          </p>
        </div>
        <p className="text-[12px] text-muted text-center mt-5">
          Sistema de Marketing Predictivo y Recuperación Automática de Clientes
        </p>
      </div>
    </div>
  );
}
