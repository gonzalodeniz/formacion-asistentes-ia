# FUNC-001: Consultar disponibilidad de puestos

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | FUNC-001 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |
| Prioridad | Crítica |

## Contexto y motivación

Los empleados necesitan saber qué puestos están
disponibles antes de desplazarse a la oficina o al
planificar su semana. Actualmente no existe ningún
mecanismo y se resuelve por orden de llegada.

## Alcance

Cubre: consulta visual de disponibilidad por oficina,
sala, fecha, franja y tipo de equipamiento.

No cubre: la reserva en sí (ver FUNC-002), ni la
gestión de salas de reunión.

## Precondiciones

- PRE-1. El empleado está autenticado (SSO Azure AD).
- PRE-2. Existe al menos una oficina con salas y
  puestos configurados en el sistema.

## Descripción

1. El empleado accede a la pantalla principal.
2. El sistema muestra por defecto la oficina habitual
   del empleado (según su perfil en Azure AD), la fecha
   de hoy y la franja de mañana.
3. El empleado puede cambiar: oficina (desplegable con
   las 3 sedes), fecha (selector, hoy hasta +14 días),
   franja (mañana, tarde, día completo).
4. El sistema muestra la lista de salas de la oficina
   seleccionada. Para cada sala se indica el número de
   puestos libres / total.
5. El empleado selecciona una sala.
6. El sistema muestra el mapa visual de la sala con
   todos los puestos representados como iconos:
   - Verde: libre.
   - Azul: reservado por el propio empleado.
   - Gris: reservado por otro empleado.
   - Rojo: bloqueado (mantenimiento).
7. Al pasar el cursor sobre un puesto (o pulsar en
   móvil), se muestra un tooltip con: código del puesto,
   equipamiento, estado, y nombre del empleado si es la
   propia reserva.
8. El empleado puede filtrar por tipo de equipamiento.
   Los puestos que no cumplen el filtro se atenúan.

## Postcondiciones de éxito

- POST-1. Se muestra el estado real de todos los puestos
  para la selección indicada.
- POST-2. No se modifica ningún dato (solo lectura).

## Casos especiales y errores

| Caso | Comportamiento |
| --- | --- |
| Oficina sin salas configuradas | Mensaje: "Esta oficina no tiene salas configuradas." |
| Fecha en día festivo o cierre | Mensaje: "La oficina [nombre] está cerrada el [fecha]." |
| Todos los puestos ocupados | Sala aparece en la lista con "0 puestos libres" en rojo. El mapa muestra todos grises/rojos. |
| Pérdida de conexión | Se muestra la última información cargada con aviso: "Información puede no estar actualizada." |

## Criterios de verificación

- CV-1. Empleado consulta sala con 10 puestos, 3
  reservados, 1 bloqueado → mapa muestra 6 verdes, 3
  grises, 1 rojo.
- CV-2. Empleado filtra por "ultrawide" → solo los
  puestos con monitor ultrawide se muestran activos;
  el resto se atenúa.
- CV-3. Empleado consulta día festivo → mensaje de
  oficina cerrada.
- CV-4. Empleado cambia de oficina → las salas se
  actualizan a las de la nueva oficina.

## Dependencias

- SPEC-0: secciones 4.1 y 5 (RN-4, RN-5).
- DN-001: Franjas horarias y reglas de disponibilidad.
- SEC-001: Autenticación SSO.
