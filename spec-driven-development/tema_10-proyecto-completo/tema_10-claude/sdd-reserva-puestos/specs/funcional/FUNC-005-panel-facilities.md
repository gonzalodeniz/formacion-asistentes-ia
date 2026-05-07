# FUNC-005: Panel de administración Facilities

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | FUNC-005 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |
| Prioridad | Alta |

## Contexto y motivación

Facilities necesita gestionar la configuración de oficinas,
salas y puestos, bloquear puestos por mantenimiento y
consultar la ocupación real para tomar decisiones de
distribución de recursos.

## Precondiciones

- PRE-1. El usuario tiene rol "admin_facilities" en
  Azure AD.

## Descripción

### Gestión de configuración

El administrador puede crear, editar y desactivar:

- Oficinas (nombre, código, dirección, días de
  apertura).
- Salas dentro de cada oficina (nombre, código,
  capacidad, plano/mapa).
- Puestos dentro de cada sala (código, posición en
  el mapa, equipamiento asociado).

### Bloqueo de puestos

1. El administrador selecciona uno o más puestos.
2. Indica el motivo (mantenimiento, avería, reubicación,
   evento) y la fecha de desbloqueo estimada (opcional).
3. El sistema bloquea los puestos. Las reservas futuras
   existentes para esos puestos se cancelan
   automáticamente y se notifica a los afectados.
4. El puesto aparece en rojo en el mapa para todos los
   usuarios.

### Panel de ocupación

El administrador ve un dashboard con:

- Ocupación actual por oficina (puestos ocupados /
  total, porcentaje).
- Ocupación por sala (gráfico de barras).
- Evolución de la ocupación últimos 30 días (gráfico
  de línea).
- Tasa de no-show por semana.
- Puestos más y menos reservados (top 10 / bottom 10).

## Postcondiciones de éxito

- POST-1. Los cambios de configuración se reflejan
  inmediatamente en el sistema.
- POST-2. Los bloqueos cancelan reservas futuras
  afectadas y notifican a los empleados.
- POST-3. El dashboard muestra datos actualizados.

## Criterios de verificación

- CV-1. Admin crea una sala con 10 puestos → los puestos
  aparecen en el mapa como libres.
- CV-2. Admin bloquea un puesto con reserva futura →
  reserva cancelada, empleado notificado, puesto en rojo.
- CV-3. Admin desbloquea un puesto → puesto vuelve a
  verde (libre).
- CV-4. Dashboard muestra ocupación del 60% si hay 6/10
  puestos reservados en una sala.

## Dependencias

- SPEC-0: sección 4.1 (bloqueo y panel).
- DN-003: Transiciones de estado de reserva (cancelación
  por bloqueo).
- SEC-001: Autenticación y roles.
