import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Modal } from "@/components/ui/Modal";
import { Button, FieldError, Input, Label } from "@/components/ui/Primitives";
import { empresasApi } from "@/services/api";

const schema = z.object({
  emp_ruc: z.string().regex(/^\d{11}$/, "RUC debe tener 11 dígitos."),
  emp_razon_social: z.string().min(1, "Razón social obligatoria.").max(255),
  emp_nombre_comercial: z.string().min(1, "Nombre comercial obligatorio.").max(255),
  emp_email: z.string().email("Email inválido.").optional().or(z.literal("")),
  emp_direccion: z.string().max(255).optional().or(z.literal("")),
  emp_lema: z.string().max(255).optional().or(z.literal("")),
});

type FormValues = z.infer<typeof schema>;

export function EmpresaFormModal({ open, onClose, empresa }: { open: boolean; onClose: () => void; empresa?: any | null }) {
  const queryClient = useQueryClient();
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: { emp_ruc: "", emp_razon_social: "", emp_nombre_comercial: "", emp_email: "", emp_direccion: "", emp_lema: "" },
  });

  const isEditing = !!empresa;

  useEffect(() => {
    if (open) {
      if (empresa) {
        reset({
          emp_ruc: empresa.emp_ruc ?? "",
          emp_razon_social: empresa.emp_razon_social ?? "",
          emp_nombre_comercial: empresa.emp_nombre_comercial ?? "",
          emp_email: empresa.emp_email ?? "",
          emp_direccion: empresa.emp_direccion ?? "",
          emp_lema: empresa.emp_lema ?? "",
        });
      } else {
        reset({ emp_ruc: "", emp_razon_social: "", emp_nombre_comercial: "", emp_email: "", emp_direccion: "", emp_lema: "" });
      }
    }
  }, [open, empresa, reset]);

  const mutation = useMutation({
    mutationFn: (values: FormValues) => {
      const payload = {
        emp_ruc: values.emp_ruc.trim(),
        emp_razon_social: values.emp_razon_social.trim(),
        emp_nombre_comercial: values.emp_nombre_comercial.trim(),
        emp_email: values.emp_email || undefined,
        emp_direccion: values.emp_direccion || undefined,
        emp_lema: values.emp_lema || undefined,
      };
      if (isEditing) return empresasApi.update(empresa.emp_id, payload);
      return empresasApi.create(payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["empresas"] });
      queryClient.invalidateQueries({ queryKey: ["settings"] });
      reset();
      onClose();
    },
  });

  return (
    <Modal open={open} onClose={onClose} title={isEditing ? "Editar empresa" : "Nueva empresa"}>
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div>
          <Label>RUC (11 dígitos) *</Label>
          <Input {...register("emp_ruc")} maxLength={11} placeholder="20123456789" />
          <FieldError>{errors.emp_ruc?.message}</FieldError>
        </div>
        <div>
          <Label>Razón social *</Label>
          <Input {...register("emp_razon_social")} placeholder="Mi Empresa S.A.C." />
          <FieldError>{errors.emp_razon_social?.message}</FieldError>
        </div>
        <div>
          <Label>Nombre comercial *</Label>
          <Input {...register("emp_nombre_comercial")} placeholder="Mi Marca" />
          <FieldError>{errors.emp_nombre_comercial?.message}</FieldError>
        </div>
        <div>
          <Label>Email corporativo</Label>
          <Input type="email" {...register("emp_email")} placeholder="contacto@empresa.com" />
          <FieldError>{errors.emp_email?.message}</FieldError>
        </div>
        <div>
          <Label>Dirección</Label>
          <Input {...register("emp_direccion")} placeholder="Av. Ejemplo 123" />
          <FieldError>{errors.emp_direccion?.message}</FieldError>
        </div>
        <div>
          <Label>Lema</Label>
          <Input {...register("emp_lema")} placeholder="Tu lema comercial" />
          <FieldError>{errors.emp_lema?.message}</FieldError>
        </div>
        {mutation.isError && <p className="text-[13px] text-risk-critical">{(mutation.error as Error)?.message ?? (isEditing ? "No se pudo actualizar la empresa." : "No se pudo crear la empresa. Verifica RUC único.")}</p>}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button type="submit" disabled={mutation.isPending}>
            {mutation.isPending ? (isEditing ? "Guardando..." : "Creando...") : isEditing ? "Guardar cambios" : "Crear empresa"}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
