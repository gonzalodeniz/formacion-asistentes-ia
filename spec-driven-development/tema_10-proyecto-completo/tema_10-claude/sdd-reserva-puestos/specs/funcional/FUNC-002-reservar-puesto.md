# FUNC-002: Reservar puesto de trabajo

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | FUNC-002 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |
| Prioridad | Crítica |

## Contexto y motivación

La funcionalidad principal del sistema: permitir que un
empleado reserve un puesto concreto para una fecha y
franja, garantizando que nadie más pueda reservar ese
mismo puesto en la misma franja.

## Precondiciones

- PRE-1. El empleado está autenticado.
- PRE-2. El puesto seleccionado está en estado "libre"
  para la fecha y franja indicadas.
- PRE-3. El empleado no tiene otra reserva activa para
  la misma fecha y franja (RN-1).
- PRE-4. La fecha de la reserva es hoy o hasta 14 días
  en el futuro (RN-2).

## Descripción

1. Desde el mapa de sala (FUNC-001), el empleado pulsa
   sobre un puesto en estado "libre" (verde).
2. El sistema muestra un panel de confirmación con:
   oficina, sala, código del puesto, equipamiento,
   fecha y franja seleccionada.
3. El empleado pulsa "Reservar".
4. El sistema valida las precondiciones PRE-1 a PRE-4.
5. El sistema registra la reserva con estado
   "confirmada" y genera un código de reserva
   (formato: RES-AAAAMMDD-NNNN).
6. El mapa se actualiza: el puesto pasa de verde a azul
   (reserva propia).
7. El empleado recibe confirmación en pantalla y por
   email con los datos de la reserva y un recordatorio
   de hacer check-in al llegar.

## Postcondiciones de éxito

- POST-1. Existe una reserva con estado "confirmada"
  vinculada al empleado, puesto, fecha y franja.
- POST-2. El puesto aparece como "reservado" para esa
  fecha y franja para el resto de empleados.
- POST-3. El empleado ha recibido email de confirmación.

## Postcondiciones de fallo

- POST-F1. No se crea ninguna reserva.
- POST-F2. El puesto permanece en estado "libre".

## Casos especiales y errores

| Caso | Comportamiento |
| --- | --- |
| Puesto reservado por otro entre la consulta y la confirmación (concurrencia) | Error: "Este puesto acaba de ser reservado por otro empleado. Selecciona otro puesto." El mapa se refresca. |
| Empleado ya tiene reserva en esa franja | Error: "Ya tienes una reserva para el [fecha] en franja [franja]: puesto [código] en [sala]. Cancélala primero si quieres cambiar." |
| Fecha fuera de rango (+15 días o pasada) | Error: "Solo puedes reservar entre hoy y los próximos 14 días." |
| Puesto bloqueado entre consulta y reserva | Error: "Este puesto ha sido bloqueado por mantenimiento." |
| Reserva de "día completo" con una franja ya ocupada | Error: "No puedes reservar día completo: ya existe una reserva en la franja de [mañana/tarde]." |

## Criterios de verificación

- CV-1. Empleado reserva puesto libre → reserva creada,
  puesto azul en mapa, email recibido.
- CV-2. Empleado intenta reservar con reserva existente
  en misma franja → error con datos de la reserva
  existente.
- CV-3. Dos empleados reservan el mismo puesto
  simultáneamente → solo uno tiene éxito, el otro recibe
  error de concurrencia.
- CV-4. Reserva para dentro de 14 días → aceptada.
  Reserva para dentro de 15 días → rechazada.
- CV-5. Reserva de día completo con franja de mañana ya
  reservada por otro → rechazada.

## Dependencias

- FUNC-001: Consultar disponibilidad (origen del flujo).
- DN-001: Franjas horarias.
- DN-002: Reglas de reserva (máximo 1 por franja, 14 días).
- API-RES-001: Contrato de crear reserva.
