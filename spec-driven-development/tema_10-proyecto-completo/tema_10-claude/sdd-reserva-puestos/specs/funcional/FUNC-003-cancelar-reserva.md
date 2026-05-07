# FUNC-003: Cancelar reserva

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | FUNC-003 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |
| Prioridad | Alta |

## Contexto y motivación

Los empleados necesitan poder liberar puestos que ya no
van a utilizar para que otros puedan reservarlos. La
cancelación es libre y sin restricción temporal (RN-6).

## Precondiciones

- PRE-1. El empleado está autenticado.
- PRE-2. La reserva existe y pertenece al empleado.
- PRE-3. La reserva está en estado "confirmada" o
  "checked_in".

## Descripción

1. El empleado accede a "Mis reservas".
2. El sistema muestra la lista de reservas activas
   (confirmadas y checked-in), ordenadas por fecha.
3. El empleado selecciona una reserva y pulsa "Cancelar".
4. El sistema solicita confirmación: "¿Cancelar la reserva
   del puesto [código] para el [fecha] ([franja])?"
5. El empleado confirma.
6. El sistema cambia el estado de la reserva a "cancelada".
7. El puesto vuelve a estado "libre" para esa fecha y
   franja.
8. Se envía email de confirmación de cancelación.

## Postcondiciones de éxito

- POST-1. La reserva está en estado "cancelada".
- POST-2. El puesto está disponible para otros empleados.
- POST-3. Email de confirmación enviado.

## Casos especiales y errores

| Caso | Comportamiento |
| --- | --- |
| Cancelar reserva ya pasada (fecha anterior a hoy) | La reserva no aparece en la lista de activas. No se puede cancelar. |
| Cancelar reserva con check-in hecho | Se permite. El puesto se libera inmediatamente. |

## Criterios de verificación

- CV-1. Cancelar reserva confirmada → estado "cancelada",
  puesto libre, email recibido.
- CV-2. Tras cancelación, otro empleado puede reservar el
  mismo puesto en la misma franja.
- CV-3. Cancelar reserva con check-in → puesto se libera.

## Dependencias

- FUNC-002: Reservar puesto (genera la reserva).
- DN-003: Transiciones de estado de reserva.
