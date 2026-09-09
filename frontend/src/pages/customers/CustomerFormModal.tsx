import { useEffect } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { Modal } from "@/components/ui/Modal";
import { Button, FieldError, Input, Label, Select } from "@/components/ui/Primitives";
import { catalogsApi, customersApi } from "@/services/api";
import type { Customer } from "@/types";

const schema = z.object({
  firstName: z.string().min(1, "El nombre es obligatorio."),
  lastName: z.string().min(1, "El apellido es obligatorio."),
  email: z.string().email("Email inválido.").optional().or(z.literal("")),
  phone: z.string().optional().or(z.literal("")),
  doc_id: z.string().min(1, "Selecciona tipo de documento."),
  cli_ndocumento: z.string().min(1, "Número de documento obligatorio."),
}).superRefine((data, ctx) => {
  // Validación RUC/DNI en ambos lados será reforzada por backend, aquí solo formato básico
  if (data.cli_ndocumento && !/^\d+$/.test(data.cli_ndocumento)) {
    ctx.addIssue({ code: z.ZodIssueCode.custom, path: ["cli_ndocumento"], message: "Solo dígitos." });
  }
});

type FormValues = z.infer<typeof schema>;

export function CustomerFormModal({ open, onClose, customer }: { open: boolean; onClose: () => void; customer?: Customer | null }) {
  const queryClient = useQueryClient();
  const { data: documentos } = useQuery({
    queryKey: ["catalogos-documentos"],
    queryFn: catalogsApi.documentos,
    enabled: open,
  });

  const {
    register,
    handleSubmit,
    reset,
    watch,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      firstName: "",
      lastName: "",
      email: "",
      phone: "",
      doc_id: "",
      cli_ndocumento: "",
    },
  });

  const selectedDocId = watch("doc_id");
  const selectedDoc = documentos?.find((d) => d.doc_id === selectedDocId);
  const docTipo = selectedDoc?.doc_tipo ?? "";

  // Reset cuando abre o cambia customer — preserva emp_id vía token, no hardcode
  useEffect(() => {
    if (open) {
      reset({
        firstName: customer?.firstName && customer.firstName !== "—" ? customer.firstName : "",
        lastName: customer?.lastName && customer.lastName !== "—" ? customer.lastName : "",
        email: customer?.email ?? "",
        phone: customer?.phone ?? "",
        doc_id: (customer as any)?.doc_id ?? "",
        cli_ndocumento: (customer as any)?.cli_ndocumento ?? "",
      });
    }
  }, [open, customer, reset]);

  // Validar longitud según tipo seleccionado para mostrar mensaje inmediato
  function validateDocNumber(value: string): string | undefined {
    if (!docTipo) return undefined;
    if (docTipo === "DNI" && value && !/^\d{8}$/.test(value)) return "DNI debe tener 8 dígitos";
    if (docTipo === "RUC" && value && !/^\d{11}$/.test(value)) return "RUC debe tener 11 dígitos";
    return undefined;
  }

  const mutation = useMutation({
    mutationFn: async (values: FormValues) => {
      // Validación extra antes de enviar
      const docError = validateDocNumber(values.cli_ndocumento);
      if (docError) throw new Error(docError);
      const payload: any = {
        firstName: values.firstName.trim(),
        lastName: values.lastName.trim(),
        email: values.email || null,
        phone: values.phone || null,
        doc_id: values.doc_id,
        cli_ndocumento: values.cli_ndocumento.trim(),
      };
      if (customer) return customersApi.update(customer.id, payload);
      return customersApi.create(payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["customers"] });
      reset();
      onClose();
    },
  });

  const docErrorMsg = validateDocNumber(watch("cli_ndocumento"));

  return (
    <Modal open={open} onClose={onClose} title={customer ? "Editar cliente" : "Nuevo cliente"}>
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Nombre *</Label>
            <Input {...register("firstName")} />
            <FieldError>{errors.firstName?.message}</FieldError>
          </div>
          <div>
            <Label>Apellido *</Label>
            <Input {...register("lastName")} />
            <FieldError>{errors.lastName?.message}</FieldError>
          </div>
        </div>

        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Tipo documento *</Label>
            <Select {...register("doc_id")} className="w-full">
              <option value="">Selecciona</option>
              {documentos?.map((d) => (
                <option key={d.doc_id} value={d.doc_id}>
                  {d.doc_tipo} — {d.doc_descripcion ?? d.doc_tipo}
                </option>
              ))}
              {/* Fallback si aún no carga catálogo */}
              {!documentos && <option value="">Cargando...</option>}
            </Select>
            <FieldError>{errors.doc_id?.message}</FieldError>
          </div>
          <div>
            <Label>{docTipo === "RUC" ? "RUC (11 dígitos) *" : docTipo === "DNI" ? "DNI (8 dígitos) *" : "Nº documento *"}</Label>
            <Input {...register("cli_ndocumento")} placeholder={docTipo === "RUC" ? "20123456789" : docTipo === "DNI" ? "12345678" : "—"} maxLength={11} />
            <FieldError>{errors.cli_ndocumento?.message ?? docErrorMsg}</FieldError>
          </div>
        </div>

        <div>
          <Label>Email</Label>
          <Input type="email" {...register("email")} placeholder="opcional" />
          <FieldError>{errors.email?.message}</FieldError>
        </div>
        <div>
          <Label>Teléfono</Label>
          <Input {...register("phone")} placeholder="opcional" />
        </div>

        {mutation.isError && (
          <p className="text-[13px] text-risk-critical">
            {(mutation.error as Error)?.message ?? "No se pudo guardar el cliente. Verifica RUC/DNI único."}
          </p>
        )}
        <div className="flex justify-end gap-2 pt-2">
          <Button type="button" variant="secondary" onClick={onClose}>
            Cancelar
          </Button>
          <Button type="submit" disabled={mutation.isPending}>
            {mutation.isPending ? "Guardando..." : customer ? "Guardar cambios" : "Crear cliente"}
          </Button>
        </div>
      </form>
    </Modal>
  );
}
