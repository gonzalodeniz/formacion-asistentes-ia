# DN-003: Transiciones de estado de reserva

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | DN-003 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |

## Estados

| Estado | Descripción |
| --- | --- |
| confirmada | Reserva creada, pendiente de check-in. |
| checked_in | Empleado ha confirmado presencia. |
| completada | Franja finalizada con check-in realizado. |
| cancelada | Cancelada por el empleado. |
| liberada_auto | Cancelada por el sistema (no-show 30 min). |
| cancelada_admin | Cancelada por Facilities (bloqueo de puesto). |

## Diagrama de transiciones

```text
[confirmada]
    │       │          │
    │       │          ▼
    │       │    [cancelada]
    │       │
    │       ▼
    │  [liberada_auto]
    │
    ├───────────────────────┐
    │                       ▼
    ▼                 [cancelada_admin]
[checked_in]
    │       │
    │       ▼
    │  [cancelada]
    │
    ▼
[completada]
```

## Tabla de transiciones

| Origen | Destino | Desencadenante | Actor |
| --- | --- | --- | --- |
| confirmada | checked_in | Empleado hace check-in | Empleado |
| confirmada | cancelada | Empleado cancela | Empleado |
| confirmada | liberada_auto | 30 min sin check-in | Sistema |
| confirmada | cancelada_admin | Facilities bloquea puesto | Admin |
| checked_in | cancelada | Empleado cancela | Empleado |
| checked_in | completada | Fin de la franja horaria | Sistema |
| cancelada | (terminal) | — | — |
| liberada_auto | (terminal) | — | — |
| cancelada_admin | (terminal) | — | — |
| completada | (terminal) | — | — |

## Invariantes

- INV-5. Los estados cancelada, liberada_auto,
  cancelada_admin y completada son terminales. Una
  reserva en estos estados no puede cambiar.
- INV-6. Toda transición queda registrada con
  timestamp y actor.
- INV-7. Cuando una reserva sale del estado
  "confirmada" o "checked_in" (excepto a "completada"),
  el puesto vuelve a estado "libre" para esa franja.

## Dependencias

- FUNC-002: Reservar puesto (crea en estado "confirmada").
- FUNC-003: Cancelar reserva (transición a "cancelada").
- FUNC-004: Check-in y liberación automática.
- FUNC-005: Bloqueo por Facilities.
