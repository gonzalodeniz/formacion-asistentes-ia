# FUNC-004: Check-in y liberación automática

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | FUNC-004 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |
| Prioridad | Alta |

## Contexto y motivación

El check-in confirma que el empleado ha llegado y ocupa
el puesto. Sin esta confirmación, los puestos reservados
pero no utilizados (no-shows) desperdician recursos. La
liberación automática tras 30 minutos devuelve el puesto
al pool de disponibles.

## Precondiciones (check-in)

- PRE-1. El empleado está autenticado.
- PRE-2. Tiene una reserva en estado "confirmada" para
  hoy y la franja actual (o que comienza en los próximos
  30 minutos).
- PRE-3. No han pasado más de 30 minutos desde el inicio
  de la franja.

## Descripción del check-in

1. El empleado accede a la app y ve un banner destacado:
   "Tienes una reserva hoy en [sala] - puesto [código].
   ¿Ya estás aquí? [Hacer check-in]"
2. El empleado pulsa "Hacer check-in".
3. El sistema cambia el estado de la reserva de
   "confirmada" a "checked_in".
4. El banner cambia a: "Check-in completado. Disfruta
   tu puesto en [sala]."

## Descripción de la liberación automática

1. Un proceso automático (job) se ejecuta cada 5
   minutos.
2. Para cada reserva en estado "confirmada" cuya franja
   comenzó hace más de 30 minutos y no tiene check-in:
3. El sistema cambia el estado de la reserva a
   "liberada_auto".
4. El puesto vuelve a estado "libre".
5. Se envía notificación al empleado: "Tu reserva del
   puesto [código] ha sido liberada porque no hiciste
   check-in. El puesto está disponible para otros."

## Postcondiciones de éxito (check-in)

- POST-1. La reserva está en estado "checked_in".
- POST-2. El puesto se muestra como "ocupado (propio)"
  en el mapa.

## Postcondiciones de éxito (liberación automática)

- POST-1. La reserva está en estado "liberada_auto".
- POST-2. El puesto está disponible para reserva.
- POST-3. Se ha notificado al empleado.

## Casos especiales y errores

| Caso | Comportamiento |
| --- | --- |
| Check-in antes de que comience la franja (> 30 min antes) | No se muestra la opción de check-in. Mensaje: "El check-in estará disponible desde las [hora inicio - 30 min]." |
| Check-in a las 08:31 para franja de mañana (08:00) | Aceptado (dentro de los 30 minutos). |
| Check-in a las 08:31 si la reserva ya fue liberada | Error: "Tu reserva fue liberada automáticamente. El puesto ya no está asignado." |
| Empleado hace check-in y luego se va sin cancelar | La reserva permanece en "checked_in" hasta el fin de la franja. No hay check-out automático en el MVP. |
| Franja de día completo: ¿un check-in o dos? | Un solo check-in al inicio del día es suficiente para todo el día completo. |

## Criterios de verificación

- CV-1. Reserva para franja de mañana (08:00), check-in
  a las 08:15 → estado cambia a "checked_in".
- CV-2. Reserva para franja de mañana (08:00), sin
  check-in a las 08:31 → estado cambia a "liberada_auto",
  puesto libre, email enviado.
- CV-3. Reserva de día completo, check-in a las 08:10 →
  check-in válido para todo el día, no se vuelve a pedir.
- CV-4. Intento de check-in a las 07:00 para franja de
  08:00 → opción no disponible.

## Dependencias

- FUNC-002: Reservar puesto (genera la reserva).
- DN-001: Franjas horarias.
- DN-003: Transiciones de estado de reserva.
