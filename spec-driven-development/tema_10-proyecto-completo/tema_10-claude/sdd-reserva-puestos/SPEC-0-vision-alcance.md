# SPEC-0: Visión y alcance — Sistema de reserva de puestos

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | SPEC-0 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo de análisis — 2025-05-01 |
| Aprobado por | Elena Rivas (Facilities), Pablo Durán (CTO) |

## 1. Problema que resolvemos

La empresa TechNova tiene 3 oficinas con un total de 180
puestos de trabajo equipados con ordenador. Tras adoptar
un modelo de trabajo híbrido (3 días en oficina, 2 en
remoto), los empleados acuden sin saber si encontrarán un
puesto libre.

Problemas detectados:

- El 30% de los empleados ha reportado llegar a la oficina
  y no encontrar puesto disponible en su sala habitual.
- No existe un sistema de reserva: se resuelve por orden
  de llegada, lo que genera conflictos y desplazamientos
  innecesarios entre salas.
- Facilities no tiene datos de ocupación real y no puede
  optimizar la distribución de recursos.
- Algunos puestos tienen equipamiento especial (monitor
  ultrawide, dock station, doble pantalla) y los empleados
  no saben cuáles están libres.
- Las salas de reunión sí tienen sistema de reserva
  (Google Calendar), pero los puestos individuales no.

Impacto estimado: 45 minutos/semana perdidos por empleado
buscando puesto, más la insatisfacción laboral asociada.
Con 120 empleados en modelo híbrido, supone unas 90
horas/semana de tiempo improductivo.

## 2. Visión del producto

Construir una aplicación web y móvil que permita a los
empleados de TechNova reservar puestos de trabajo con
ordenador en cualquiera de las 3 oficinas, seleccionando
fecha, franja horaria, sala y tipo de equipamiento. El
sistema muestra la disponibilidad en tiempo real y
proporciona a Facilities datos de ocupación para
optimizar recursos.

## 3. Actores y usuarios

| Actor | Descripción |
| --- | --- |
| Empleado | Reserva y cancela puestos para sí mismo. Consulta disponibilidad. |
| Responsable de equipo | Reserva puestos para los miembros de su equipo. Ve la ocupación del equipo. |
| Administrador Facilities | Configura oficinas, salas, puestos y equipamiento. Consulta informes de ocupación. Bloquea puestos por mantenimiento. |
| Sistema de directorio | Azure AD. Proporciona autenticación y datos de empleados (nombre, equipo, oficina habitual). |
| Sistema de calendario | Google Calendar. Origen de información sobre festivos y días de cierre de oficina. |

## 4. Alcance funcional

### 4.1. Incluido (Release 1 — MVP)

- Autenticación SSO con Azure AD.
- Consulta de disponibilidad por oficina, sala, fecha y
  franja.
- Mapa visual de cada sala con puestos y su estado
  (libre, reservado, bloqueado, propio).
- Reserva de puesto individual por el empleado (día y
  franja horaria).
- Cancelación de reserva por el empleado.
- Filtro por tipo de equipamiento (monitor estándar,
  ultrawide, doble pantalla, dock station).
- Check-in al llegar a la oficina (confirma la reserva).
- Liberación automática si no se hace check-in en 30
  minutos.
- Panel de Facilities con ocupación por oficina y sala.
- Bloqueo de puestos por mantenimiento.

### 4.2. Incluido (Release 2)

- Reserva recurrente (mismo puesto cada martes, etc.).
- Reserva por el responsable de equipo para sus miembros.
- Puesto favorito (preferencia que se sugiere al reservar).
- Informes avanzados de ocupación con exportación.
- Notificaciones push (recordatorio de check-in).

### 4.3. Fuera de alcance

- Reserva de salas de reunión (ya existe en Google
  Calendar).
- Control de acceso físico (tornos, cerraduras).
- Gestión de parking o taquillas.
- Reserva de equipamiento portátil (proyectores, cables).
- Integración con sistemas de climatización o iluminación.
- Facturación o cobro por uso de puestos.

## 5. Reglas de negocio fundamentales

- RN-1. Un empleado puede tener como máximo 1 reserva
  activa por franja horaria. No se permiten solapamientos.
- RN-2. Las reservas se pueden hacer con un máximo de 14
  días de antelación.
- RN-3. Si el empleado no hace check-in en los primeros
  30 minutos de su franja, la reserva se libera
  automáticamente y el puesto queda disponible.
- RN-4. Un puesto bloqueado por mantenimiento no puede
  reservarse hasta que Facilities lo desbloquee.
- RN-5. Las franjas horarias son: mañana (08:00-14:00),
  tarde (14:00-20:00) y día completo (08:00-20:00).
  Día completo consume ambas franjas.
- RN-6. Un empleado puede cancelar su reserva sin
  restricción de tiempo (incluso en el último momento).
- RN-7. Los responsables de equipo solo pueden reservar
  para miembros de su propio equipo (según Azure AD).

## 6. Restricciones técnicas

- RT-1. Autenticación obligatoria vía Azure AD (SSO con
  OAuth 2.0 / OIDC). No se crean cuentas locales.
- RT-2. La aplicación debe funcionar en navegador web
  (desktop y móvil responsive). No se requiere app
  nativa en el MVP.
- RT-3. Backend en Node.js o Python (tecnologías
  dominadas por el equipo). Base de datos PostgreSQL.
- RT-4. Despliegue en la infraestructura cloud existente
  de la empresa (Azure).
- RT-5. Volumetría: 120 empleados activos, 180 puestos,
  3 oficinas, estimación de 200-400 reservas/día.
- RT-6. Tiempo de respuesta: las consultas de
  disponibilidad deben responder en menos de 500 ms
  (p95).
- RT-7. Cumplimiento RGPD: los datos de reserva se
  conservan anonimizados durante 12 meses para
  estadísticas y se eliminan después.

## 7. Restricciones de proyecto

- RP-1. Equipo: 1 desarrollador backend, 1 desarrollador
  frontend, 1 analista/QA (a tiempo parcial).
- RP-2. Plazo: Release 1 en 8 semanas. Release 2 en 6
  semanas adicionales.
- RP-3. Sin presupuesto para herramientas de pago
  adicionales.

## 8. Criterios de éxito

- CE-1. El 80% de los empleados en modelo híbrido usan
  el sistema al menos 1 vez/semana tras 1 mes del
  lanzamiento.
- CE-2. Las incidencias de "no encontrar puesto" se
  reducen al 5% (desde el 30% actual).
- CE-3. Facilities puede generar un informe de ocupación
  semanal sin intervención manual.
- CE-4. La tasa de no-show (reserva sin check-in) es
  inferior al 10% tras el primer mes (gracias a la
  liberación automática).

## 9. Glosario inicial del dominio

| Término | Definición |
| --- | --- |
| Oficina | Sede física de la empresa (Madrid Centro, Madrid Norte, Barcelona). |
| Sala | Espacio dentro de una oficina que contiene puestos de trabajo. Ejemplo: "Sala Turing", "Sala Lovelace". |
| Puesto | Posición física con mesa, silla y ordenador dentro de una sala. Identificado por un código único (p. ej., MAD-C-TUR-05). |
| Equipamiento | Características adicionales de un puesto: tipo de monitor, dock station, periféricos especiales. |
| Reserva | Asignación de un puesto a un empleado para una fecha y franja horaria concretas. |
| Franja horaria | Bloque de tiempo reservable: mañana (08:00-14:00), tarde (14:00-20:00) o día completo (08:00-20:00). |
| Check-in | Confirmación presencial de que el empleado ha ocupado el puesto reservado. Se realiza desde la app al llegar. |
| Liberación automática | Cancelación de una reserva por el sistema cuando el empleado no hace check-in en los primeros 30 minutos. |
| Bloqueo | Estado de un puesto que lo hace no reservable, aplicado por Facilities (mantenimiento, avería, reubicación). |
| No-show | Reserva en la que el empleado no se presentó ni canceló. |

## 10. Relación con el ecosistema de especificaciones

```text
SPEC-0 (este documento)
  │
  ├──► Especificaciones funcionales (FUNC-NNN)
  │      derivadas de la sección 4
  │
  ├──► Reglas de dominio (DN-NNN)
  │      derivadas de la sección 5
  │
  ├──► Contratos de API (API-NNN)
  │      derivados de las funcionalidades
  │
  ├──► Especificaciones de seguridad (SEC-NNN)
  │      derivadas de RT-1 y RT-7
  │
  ├──► Especificaciones de rendimiento (PERF-NNN)
  │      derivadas de RT-5 y RT-6
  │
  └──► Glosario (GLOSARIO.md)
         derivado de la sección 9
```

## 11. Historial de cambios

| Versión | Fecha | Autor | Cambio |
| --- | --- | --- | --- |
| 0.1 | 2025-04-28 | Equipo análisis | Borrador inicial |
| 1.0 | 2025-05-01 | Equipo análisis | Aprobada por Elena y Pablo |
