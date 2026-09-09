import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { Sprout } from "lucide-react";
import { useAuth } from "@/hooks/useAuth";
import { Button, Input, Label, FieldError } from "@/components/ui/Primitives";

type FormErrors = Partial<Record<string, string>>;

export function RegisterPage() {
  const { register } = useAuth();
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [fieldErrors, setFieldErrors] = useState<FormErrors>({});

  const [form, setForm] = useState({
    emp_ruc: "",
    emp_razon_social: "",
    emp_nombre_comercial: "",
    emp_email: "",
    usp_nombres: "",
    usp_dni: "",
    usu_usuario: "",
    usu_email: "",
    password: "",
    confirmPassword: "",
  });

  function update(key: string, value: string) {
    setForm((prev) => ({ ...prev, [key]: value }));
  }

  function validate(): boolean {
    const e: FormErrors = {};
    if (!/^\d{11}$/.test(form.emp_ruc)) e.emp_ruc = "RUC debe tener 11 dígitos";
    if (form.emp_razon_social.trim().length < 2) e.emp_razon_social = "Mínimo 2 caracteres";
    if (form.emp_nombre_comercial.trim().length < 2) e.emp_nombre_comercial = "Mínimo 2 caracteres";
    if (form.emp_email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.emp_email)) e.emp_email = "Email inválido";
    if (form.usp_nombres.trim().length < 2) e.usp_nombres = "Mínimo 2 caracteres";
    if (form.usp_dni && !/^\d{8}$/.test(form.usp_dni)) e.usp_dni = "DNI debe tener 8 dígitos";
    if (form.usu_usuario.trim().length < 3) e.usu_usuario = "Mínimo 3 caracteres";
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.usu_email)) e.usu_email = "Email inválido";
    if (form.password.length < 8) e.password = "Mínimo 8 caracteres";
    if (form.password !== form.confirmPassword) e.confirmPassword = "Las contraseñas no coinciden";
    setFieldErrors(e);
    return Object.keys(e).length === 0;
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError(null);
    if (!validate()) return;
    setLoading(true);
    try {
      await register({
        emp_ruc: form.emp_ruc.trim(),
        emp_razon_social: form.emp_razon_social.trim(),
        emp_nombre_comercial: form.emp_nombre_comercial.trim(),
        emp_email: form.emp_email.trim() || undefined,
        usp_nombres: form.usp_nombres.trim(),
        usp_dni: form.usp_dni.trim() || undefined,
        usu_usuario: form.usu_usuario.trim(),
        usu_email: form.usu_email.trim(),
        password: form.password,
      });
      navigate("/");
    } catch (err: any) {
      const msg = err?.message ?? "No se pudo registrar. Intenta de nuevo.";
      // Mapear códigos backend a mensajes amigables
      if (msg.includes("RUC_ALREADY_REGISTERED")) setError("Ya existe una empresa con ese RUC.");
      else if (msg.includes("EMAIL_ALREADY_REGISTERED")) setError("Ya existe un usuario con ese correo en la empresa.");
      else setError(msg);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-bg flex items-center justify-center px-4 py-8">
      <div className="w-full max-w-2xl">
        <div className="flex items-center gap-2.5 justify-center mb-6">
          <div className="w-10 h-10 rounded bg-brand flex items-center justify-center text-white">
            <Sprout size={20} />
          </div>
          <div>
            <p className="font-display font-semibold text-ink leading-tight">Marketing Predictivo</p>
            <p className="text-[12px] text-muted leading-tight">Crea tu empresa</p>
          </div>
        </div>
        <div className="bg-surface border border-border rounded shadow-panel p-6">
          <h2 className="font-display font-semibold text-[17px] mb-1">Registro de empresa</h2>
          <p className="text-[13px] text-muted mb-5">Sin datos hardcodeados. Empiezas desde cero y mantienes el ID de tu empresa existente.</p>
          <form onSubmit={handleSubmit} className="space-y-5">
            {/* Empresa */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label>RUC (11 dígitos) *</Label>
                <Input value={form.emp_ruc} onChange={(e) => update("emp_ruc", e.target.value)} placeholder="20123456789" maxLength={11} />
                <FieldError>{fieldErrors.emp_ruc}</FieldError>
              </div>
              <div>
                <Label>Email empresa</Label>
                <Input type="email" value={form.emp_email} onChange={(e) => update("emp_email", e.target.value)} placeholder="empresa@negocio.com" />
                <FieldError>{fieldErrors.emp_email}</FieldError>
              </div>
            </div>
            <div>
              <Label>Razón social *</Label>
              <Input value={form.emp_razon_social} onChange={(e) => update("emp_razon_social", e.target.value)} placeholder="Mi Empresa S.A.C." />
              <FieldError>{fieldErrors.emp_razon_social}</FieldError>
            </div>
            <div>
              <Label>Nombre comercial *</Label>
              <Input value={form.emp_nombre_comercial} onChange={(e) => update("emp_nombre_comercial", e.target.value)} placeholder="Mi Marca" />
              <FieldError>{fieldErrors.emp_nombre_comercial}</FieldError>
            </div>

            <div className="border-t border-border pt-4 grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label>Nombres del administrador *</Label>
                <Input value={form.usp_nombres} onChange={(e) => update("usp_nombres", e.target.value)} placeholder="Juan Pérez" />
                <FieldError>{fieldErrors.usp_nombres}</FieldError>
              </div>
              <div>
                <Label>DNI (8 dígitos)</Label>
                <Input value={form.usp_dni} onChange={(e) => update("usp_dni", e.target.value)} placeholder="12345678" maxLength={8} />
                <FieldError>{fieldErrors.usp_dni}</FieldError>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label>Usuario (login) *</Label>
                <Input value={form.usu_usuario} onChange={(e) => update("usu_usuario", e.target.value)} placeholder="juan_admin" />
                <FieldError>{fieldErrors.usu_usuario}</FieldError>
              </div>
              <div>
                <Label>Correo usuario *</Label>
                <Input type="email" value={form.usu_email} onChange={(e) => update("usu_email", e.target.value)} placeholder="juan@negocio.com" />
                <FieldError>{fieldErrors.usu_email}</FieldError>
              </div>
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <Label>Contraseña *</Label>
                <Input type="password" value={form.password} onChange={(e) => update("password", e.target.value)} placeholder="••••••••" />
                <FieldError>{fieldErrors.password}</FieldError>
              </div>
              <div>
                <Label>Confirmar contraseña *</Label>
                <Input type="password" value={form.confirmPassword} onChange={(e) => update("confirmPassword", e.target.value)} placeholder="••••••••" />
                <FieldError>{fieldErrors.confirmPassword}</FieldError>
              </div>
            </div>

            {error && <p className="text-[13px] text-risk-critical">{error}</p>}
            <Button type="submit" disabled={loading} className="w-full justify-center">
              {loading ? "Registrando..." : "Crear empresa y acceder"}
            </Button>
          </form>
          <p className="text-[13px] text-center mt-4">
            <span className="text-muted">¿Ya tienes cuenta? </span>
            <Link to="/login" className="text-brand-dark font-medium hover:underline">Inicia sesión</Link>
          </p>
        </div>
      </div>
    </div>
  );
}
