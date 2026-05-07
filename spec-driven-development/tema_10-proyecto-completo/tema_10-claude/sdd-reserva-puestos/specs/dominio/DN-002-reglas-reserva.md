# DN-002: Reglas de reserva

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | DN-002 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |

## Descripción

Reglas que gobiernan la creación de reservas.

## Reglas

### Máximo una reserva por franja (RN-1)

Un empleado no puede tener más de una reserva activa
(estado "confirmada" o "checked_in") para la misma
fecha y franja horaria. Si quiere cambiar de puesto,
debe cancelar la reserva anterior primero.

### Antelación máxima de 14 días (RN-2)

Las reservas se pueden crear para fechas entre hoy
(inclusive) y hoy + 14 días naturales (inclusive).
No se pueden reservar puestos más allá de ese rango.

### Puestos bloqueados no reservables (RN-4)

Un puesto en estado "bloqueado" no aparece como
opción de reserva. Si un puesto se bloquea con
reservas futuras, esas reservas se cancelan
automáticamente (ver FUNC-005).

### Días de cierre

No se pueden reservar puestos en días en que la
oficina está cerrada (festivos, fines de semana u
otros días configurados por Facilities).

## Ejemplos

```text
Ejemplo 1 — Solapamiento rechazado:
  Empleado tiene reserva para lunes 12/05, AM,
  puesto MAD-C-TUR-03.
  Intenta reservar lunes 12/05, AM, puesto
  MAD-C-TUR-07.
  → Rechazada: ya tiene reserva en esa franja.

Ejemplo 2 — Misma fecha, franjas distintas:
  Empleado tiene reserva para lunes 12/05, AM.
  Intenta reservar lunes 12/05, PM, otro puesto.
  → Aceptada: son franjas distintas.

Ejemplo 3 — Día completo con AM existente:
  Empleado tiene reserva AM en un puesto.
  Intenta reservar FD en otro puesto.
  → Rechazada: FD incluye AM y ya tiene AM.

Ejemplo 4 — Antelación:
  Hoy es 7 de mayo.
  Reserva para 21 de mayo (14 días después)
  → Aceptada.
  Reserva para 22 de mayo (15 días)
  → Rechazada.
```

## Invariantes

- INV-3. Un empleado tiene como máximo 1 reserva activa
  por fecha + franja AM y 1 por fecha + franja PM.
- INV-4. No existen reservas para fechas en que la
  oficina está cerrada.

## Dependencias

- SPEC-0: RN-1, RN-2, RN-4.
- DN-001: Franjas horarias.
- FUNC-002: Reservar puesto.
