import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Modal } from "@/components/ui/Modal";
import { Button, FieldError, Input, Label, Select } from "@/components/ui/Primitives";
import { rolesApi, usuariosApi } from "@/services/api";

const schema = z.object({
  usu_usuario: z.string().min(3, "Usuario mínimo 3 caracteres.").max(100),
  usu_email: z.string().email("Email inválido."),
  password: z.string().min(8, "Password mínimo 8 caracteres.").max(128),
  rol_id: z.string().optional().or(z.literal("")),
  usp_nombres: z.string().min(1, "Nombres obligatorios.").max(255),
});

type FormValues = z.infer<typeof schema>;

export function UsuarioFormModal({ open, onClose }: { open: boolean; onClose: () => void }) {
  const queryClient = useQueryClient();
  const { data: roles } = useQuery({
    queryKey: ["roles-usuarios"],
    queryFn: rolesApi.list,
    enabled: open,
  });

  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { usu_usuario: "", usu_email: "", password: "", rol_id: "", usp_nombres: "" },
  });

  useEffect(() => {
    if (open) reset({ usu_usuario: "", usu_email: "", password: "", rol_id: "", usp_nombres: "" });
  }, [open, reset]);

  const mutation = useMutation({
    mutationFn: (values: FormValues) =>
      usuariosApi.create({
        usu_usuario: values.usu_usuario.trim(),
        usu_email: values.usu_email.trim(),
        password: values.password,
        rol_id: values.rol_id || undefined,
        usp_nombres: values.usp_nombres.trim(),
      }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["usuarios"] });
      reset();
      onClose();
    },
  });

  return (
    <Modal open={open} onClose={onClose} title="Nuevo usuario">
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>usuario *</Label>
            <Input {...register("usu_usuario")} placeholder="ej. juan.perez" />
            <FieldError>{errors.usu_usuario?.message}</FieldError>
          </div>
          <div>
            <Label>email *</Label>
            <Input type="email" {...register("usu_email")} placeholder="correo@empresa.com" />
            <FieldError>{errors.usu_email?.message}</FieldError>
          </div>
        </div>
        <div>
          <Label>nombres *</Label>
          <Input {...register("usp_nombres")} placeholder="Nombres completos" />
          <FieldError>{errors.usp_nombres?.message}</FieldError>
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>rol</Label>
            <Select {...register("rol_id")} className="w-full">
              <option value="">Sin rol</option>
              {roles?.map((r) => (
                <option key={r.rol_id} value={r.rol_id}>
                  {r.rol_codigo} — {r.rol_nombre}
                </option>
              ))}
            </Select>
            <FieldError>{errors.rol_id?.message}</FieldError>
          </div>
          <div>
            <Label>password *</Label>
            <Input type="password" {...register("password")} placeholder="mín. 8 caracteres" />
            <FieldError>{errors.password?.message}</FieldError>
          </div>
        </div>
        {mutation.isError && <p className="text-[13px] text-risk-critical">{(mutation.error as Error)?.message ?? "No se pudo crear el usuario."}</p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button type="submit" disabled={mutation.isPending}>
            {mutation.isPending ? "Creando..." : "Crear usuario"}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
