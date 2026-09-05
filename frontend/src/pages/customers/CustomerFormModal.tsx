import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { useMutation, useQueryClient } from "@tanstack/react-query";
import { Modal } from "@/components/ui/Modal";
import { Button, FieldError, Input, Label, Select } from "@/components/ui/Primitives";
import { customersApi } from "@/services/api";
import type { Customer } from "@/types";

const schema = z.object({
  firstName: z.string().min(1, "El nombre es obligatorio."),
  lastName: z.string().min(1, "El apellido es obligatorio."),
  email: z.string().email("Email inválido.").optional().or(z.literal("")),
  phone: z.string().optional().or(z.literal("")),
  city: z.string().optional().or(z.literal("")),
  preferredChannel: z.enum(["email", "whatsapp", "sms", "internal"]),
  consent: z.boolean(),
});

type FormValues = z.infer<typeof schema>;

export function CustomerFormModal({ open, onClose, customer }: { open: boolean; onClose: () => void; customer?: Customer | null }) {
  const queryClient = useQueryClient();
  const {
    register,
    handleSubmit,
    reset,
    formState: { errors },
  } = useForm<FormValues>({
    resolver: zodResolver(schema),
    defaultValues: {
      firstName: customer?.firstName ?? "",
      lastName: customer?.lastName ?? "",
      email: customer?.email ?? "",
      phone: customer?.phone ?? "",
      city: customer?.city ?? "",
      preferredChannel: customer?.preferredChannel ?? "email",
      consent: customer?.consent ?? false,
    },
  });

  const mutation = useMutation({
    mutationFn: async (values: FormValues) => {
      const payload = { ...values, email: values.email || null, phone: values.phone || null, city: values.city || null };
      if (customer) return customersApi.update(customer.id, payload);
      return customersApi.create(payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["customers"] });
      reset();
      onClose();
    },
  });

  return (
    <Modal open={open} onClose={onClose} title={customer ? "Editar cliente" : "Nuevo cliente"}>
      <form onSubmit={handleSubmit((v) => mutation.mutate(v))} className="space-y-4">
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Nombre</Label>
            <Input {...register("firstName")} />
            <FieldError>{errors.firstName?.message}</FieldError>
          </div>
          <div>
            <Label>Apellido</Label>
            <Input {...register("lastName")} />
            <FieldError>{errors.lastName?.message}</FieldError>
          </div>
        </div>
        <div>
          <Label>Email</Label>
          <Input type="email" {...register("email")} placeholder="opcional" />
          <FieldError>{errors.email?.message}</FieldError>
        </div>
        <div className="grid grid-cols-2 gap-3">
          <div>
            <Label>Teléfono</Label>
            <Input {...register("phone")} placeholder="opcional" />
          </div>
          <div>
            <Label>Ciudad</Label>
            <Input {...register("city")} placeholder="opcional" />
          </div>
        </div>
        <div>
          <Label>Canal preferido</Label>
          <Select {...register("preferredChannel")} className="w-full">
            <option value="email">Email</option>
            <option value="whatsapp">WhatsApp</option>
            <option value="sms">SMS</option>
            <option value="internal">Notificación interna</option>
          </Select>
        </div>
        <label className="flex items-center gap-2 text-[13.5px]">
          <input type="checkbox" {...register("consent")} className="rounded border-border" />
          El cliente dio consentimiento para recibir comunicaciones de marketing.
        </label>
        {mutation.isError && <p className="text-[13px] text-risk-critical">No se pudo guardar el cliente. Intenta de nuevo.</p>}
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
