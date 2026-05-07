# Proyecto SDD completo: Reserva de puestos con ordenador en salas de oficina

A continuación tienes un **proyecto SDD completo** para una aplicación de **reserva de puestos con ordenador en salas de oficinas**. Lo estructuro como un repositorio de especificación/diseño, desde el primer fichero hasta el último.

Asumo la siguiente convención:

```text
sdd-reserva-puestos/
├── 00-meta/
├── 01-negocio/
├── 02-requisitos/
├── 03-modelo/
├── 04-interfaz/
├── 05-arquitectura/
├── 06-api/
├── 07-datos/
├── 08-seguridad/
├── 09-pruebas/
├── 10-operacion/
└── 99-anexos/
```

---

# 00-meta/00-portada.md

```md
# SDD - Sistema de Reserva de Puestos con Ordenador

## Nombre del proyecto

Sistema de Reserva de Puestos con Ordenador en Salas de Oficina.

## Versión

1.0.0

## Estado

Borrador validable.

## Fecha

2026-05-07

## Propósito

Definir de forma completa el análisis, requisitos, diseño funcional, diseño técnico, modelo de datos, API, seguridad, pruebas y operación de una aplicación para reservar puestos de ordenador en salas de oficinas.

## Alcance resumido

La aplicación permitirá a empleados de una organización reservar puestos con ordenador en salas de oficina, consultar disponibilidad, cancelar reservas, recibir confirmaciones y permitir a administradores gestionar salas, puestos, horarios, bloqueos y usuarios.

## Audiencia

- Equipo de producto.
- Equipo de desarrollo.
- Equipo de QA.
- Equipo de operaciones.
- Responsables de oficina.
- Seguridad y cumplimiento.
```

---

# 00-meta/01-control-versiones.md

```md
# Control de versiones

| Versión | Fecha | Autor | Cambios |
|---|---:|---|---|
| 0.1.0 | 2026-05-07 | Equipo SDD | Primera estructura del documento |
| 1.0.0 | 2026-05-07 | Equipo SDD | Versión completa inicial |

## Criterios de versionado

Se utiliza versionado semántico documental:

- MAJOR: cambios incompatibles en requisitos o arquitectura.
- MINOR: nuevas funcionalidades o ampliaciones compatibles.
- PATCH: correcciones menores, aclaraciones o mejoras editoriales.
```

---

# 00-meta/02-indice.md

```md
# Índice del SDD

## 00-meta

- 00-portada.md
- 01-control-versiones.md
- 02-indice.md
- 03-convenciones.md

## 01-negocio

- 00-vision.md
- 01-contexto.md
- 02-objetivos.md
- 03-stakeholders.md
- 04-glosario.md
- 05-supuestos-restricciones.md

## 02-requisitos

- 00-alcance.md
- 01-actores.md
- 02-historias-usuario.md
- 03-casos-uso.md
- 04-requisitos-funcionales.md
- 05-requisitos-no-funcionales.md
- 06-reglas-negocio.md
- 07-matriz-trazabilidad.md

## 03-modelo

- 00-modelo-dominio.md
- 01-estados-reserva.md
- 02-diagramas-textuales.md
- 03-eventos-dominio.md

## 04-interfaz

- 00-mapa-navegacion.md
- 01-pantallas.md
- 02-flujos-ui.md
- 03-textos-validaciones.md

## 05-arquitectura

- 00-vision-arquitectura.md
- 01-componentes.md
- 02-flujos-sistema.md
- 03-decisiones-adr.md
- 04-integraciones.md

## 06-api

- 00-principios-api.md
- 01-endpoints.md
- 02-contratos-json.md
- 03-errores-api.md

## 07-datos

- 00-modelo-relacional.md
- 01-ddl.sql
- 02-datos-semilla.sql
- 03-politicas-retencion.md

## 08-seguridad

- 00-autenticacion-autorizacion.md
- 01-permisos.md
- 02-amenazas-controles.md
- 03-auditoria.md

## 09-pruebas

- 00-estrategia-pruebas.md
- 01-casos-prueba-funcionales.md
- 02-casos-prueba-api.md
- 03-casos-prueba-seguridad.md
- 04-datos-prueba.md

## 10-operacion

- 00-despliegue.md
- 01-configuracion.md
- 02-observabilidad.md
- 03-runbook.md

## 99-anexos

- 00-preguntas-abiertas.md
- 01-checklist-entrega.md
```

---

# 00-meta/03-convenciones.md

```md
# Convenciones

## Identificadores

Los identificadores se nombran de la siguiente forma:

- RF-XXX: requisito funcional.
- RNF-XXX: requisito no funcional.
- RN-XXX: regla de negocio.
- CU-XXX: caso de uso.
- HU-XXX: historia de usuario.
- API-XXX: endpoint o contrato API.
- CP-XXX: caso de prueba.
- ADR-XXX: decisión arquitectónica.

## Prioridades

- Must: obligatorio para la primera versión.
- Should: deseable para una versión temprana.
- Could: opcional o mejora futura.
- Won't: fuera de alcance actual.

## Estados de requisitos

- Propuesto.
- Aprobado.
- Implementado.
- Validado.
- Rechazado.

## Lenguaje

El término “puesto” se refiere a una mesa o ubicación física equipada con ordenador.
El término “sala” se refiere a una estancia de oficina que contiene uno o más puestos.
```

---

# 01-negocio/00-vision.md

```md
# Visión del producto

## Problema

En oficinas compartidas o con puestos limitados, los empleados necesitan saber si hay ordenadores disponibles antes de desplazarse o planificar su jornada. Actualmente, esta gestión suele realizarse por correo, hojas compartidas o comunicación informal, lo que provoca conflictos, sobreocupación y falta de trazabilidad.

## Solución

Construir una aplicación web que permita consultar la disponibilidad de puestos con ordenador, reservarlos por franjas horarias y gestionar salas, puestos y bloqueos administrativos.

## Usuarios principales

- Empleado que necesita reservar un ordenador.
- Responsable de oficina que administra espacios.
- Administrador del sistema que configura usuarios, salas y políticas.
- Personal de soporte que consulta incidencias o reservas.

## Resultado esperado

Un sistema fiable, sencillo y auditable para gestionar reservas de puestos, evitando solapamientos y facilitando la planificación de uso de recursos físicos.
```

---

# 01-negocio/01-contexto.md

```md
# Contexto

## Organización

La organización dispone de varias oficinas. Cada oficina puede tener una o más salas. Cada sala contiene varios puestos con ordenador.

## Necesidad

Los empleados no siempre tienen un ordenador asignado. En determinados días necesitan reservar un puesto disponible para realizar tareas presenciales.

## Situación actual

- Reservas manuales.
- Dificultad para saber disponibilidad real.
- Conflictos por uso simultáneo del mismo puesto.
- Ausencia de historial.
- Falta de métricas de ocupación.

## Sistema propuesto

Una aplicación centralizada con:

- Consulta de disponibilidad por oficina, sala, fecha y hora.
- Reserva de puesto.
- Cancelación de reserva.
- Bloqueo de puestos por mantenimiento.
- Gestión de salas y puestos.
- Registro de auditoría.
- Notificaciones básicas.
```

---

# 01-negocio/02-objetivos.md

```md
# Objetivos

## Objetivo general

Permitir la reserva controlada de puestos con ordenador en salas de oficina.

## Objetivos específicos

OBJ-001. Reducir conflictos por doble reserva.

OBJ-002. Permitir a los empleados consultar disponibilidad en tiempo real.

OBJ-003. Facilitar la gestión de salas, puestos y horarios por parte de responsables autorizados.

OBJ-004. Registrar acciones relevantes para auditoría.

OBJ-005. Proporcionar métricas de ocupación.

OBJ-006. Permitir bloqueos por mantenimiento o indisponibilidad.

OBJ-007. Mantener una experiencia de usuario simple y accesible.

## Indicadores de éxito

- Menos de 1 conflicto de reserva por cada 1.000 reservas.
- Tiempo medio de reserva inferior a 60 segundos.
- Disponibilidad del sistema superior al 99,5 % mensual.
- Al menos 80 % de reservas realizadas sin intervención administrativa.
```

---

# 01-negocio/03-stakeholders.md

```md
# Stakeholders

| Stakeholder | Interés | Responsabilidad |
|---|---|---|
| Empleado | Reservar puestos disponibles | Usar la aplicación correctamente |
| Responsable de oficina | Gestionar salas y ocupación | Mantener configuración de espacios |
| Administrador del sistema | Configurar usuarios, roles y parámetros | Operación funcional del sistema |
| Soporte IT | Resolver incidencias | Consultar trazas y estado |
| Seguridad | Controlar acceso y auditoría | Validar controles |
| Dirección | Obtener métricas de uso | Toma de decisiones sobre espacios |
| Equipo de desarrollo | Construir y mantener la aplicación | Implementación técnica |
| Equipo QA | Validar el sistema | Pruebas funcionales y no funcionales |
```

---

# 01-negocio/04-glosario.md

```md
# Glosario

## Oficina

Ubicación física de la organización.

## Sala

Espacio dentro de una oficina que contiene puestos con ordenador.

## Puesto

Mesa o ubicación física equipada con ordenador reservable.

## Reserva

Asignación temporal de un puesto a un usuario.

## Bloqueo

Periodo en el que un puesto, sala u oficina no puede reservarse por mantenimiento, evento o decisión administrativa.

## Franja horaria

Intervalo de tiempo con hora de inicio y hora de fin.

## Solapamiento

Situación en la que dos reservas o bloqueos coinciden total o parcialmente sobre el mismo recurso.

## Usuario

Persona registrada en el sistema.

## Rol

Conjunto de permisos asignado a un usuario.

## Administrador

Usuario con permisos globales de configuración.

## Responsable de oficina

Usuario con permisos administrativos sobre una o varias oficinas.

## Auditoría

Registro de acciones relevantes realizadas en el sistema.
```

---

# 01-negocio/05-supuestos-restricciones.md

```md
# Supuestos y restricciones

## Supuestos

SUP-001. Todos los usuarios acceden con cuenta corporativa.

SUP-002. Cada puesto pertenece a una única sala.

SUP-003. Cada sala pertenece a una única oficina.

SUP-004. Una reserva corresponde a un único puesto.

SUP-005. Las reservas tienen fecha y hora de inicio y fin.

SUP-006. La aplicación se usará inicialmente desde navegador web.

SUP-007. El sistema tiene una zona horaria principal configurable.

## Restricciones

RES-001. No se permite doble reserva sobre el mismo puesto en franjas solapadas.

RES-002. No se permite reservar puestos bloqueados.

RES-003. No se permite reservar en fechas anteriores a la fecha actual.

RES-004. El usuario no puede modificar reservas de otros usuarios salvo que tenga rol administrativo.

RES-005. El sistema debe mantener trazabilidad de creación, modificación y cancelación.

RES-006. La primera versión no incluye integración con cerraduras físicas, tornos ni sensores IoT.

RES-007. La primera versión no incluye pagos, facturación ni control económico.
```

---

# 02-requisitos/00-alcance.md

```md
# Alcance

## Dentro del alcance

IN-001. Inicio de sesión con identidad corporativa.

IN-002. Consulta de oficinas, salas y puestos.

IN-003. Consulta de disponibilidad por fecha y franja horaria.

IN-004. Creación de reservas.

IN-005. Cancelación de reservas propias.

IN-006. Gestión administrativa de oficinas.

IN-007. Gestión administrativa de salas.

IN-008. Gestión administrativa de puestos.

IN-009. Bloqueo de puestos por mantenimiento.

IN-010. Bloqueo de salas completas.

IN-011. Historial de reservas del usuario.

IN-012. Panel administrativo de reservas.

IN-013. Registro de auditoría.

IN-014. Notificaciones por correo o notificación interna.

IN-015. Métricas básicas de ocupación.

## Fuera del alcance

OUT-001. Reserva de plazas de parking.

OUT-002. Reserva de salas de reuniones.

OUT-003. Integración con sensores físicos.

OUT-004. Asignación automática por inteligencia artificial.

OUT-005. Aplicación móvil nativa.

OUT-006. Sincronización bidireccional con calendarios externos.

OUT-007. Control físico de acceso.
```

---

# 02-requisitos/01-actores.md

```md
# Actores

## ACT-001 Empleado

Usuario autenticado que puede consultar disponibilidad, reservar y cancelar sus propias reservas.

## ACT-002 Responsable de oficina

Usuario que puede gestionar salas, puestos, bloqueos y consultar reservas de las oficinas bajo su responsabilidad.

## ACT-003 Administrador

Usuario con permisos globales sobre el sistema.

## ACT-004 Soporte

Usuario con permisos de consulta técnica y acceso limitado a registros de auditoría.

## ACT-005 Sistema de identidad

Sistema externo que autentica al usuario.

## ACT-006 Sistema de notificaciones

Servicio que envía correos o notificaciones internas.
```

---

# 02-requisitos/02-historias-usuario.md

```md
# Historias de usuario

## HU-001 Consultar disponibilidad

Como empleado,
quiero consultar los puestos disponibles en una oficina, sala, fecha y horario,
para elegir dónde trabajar.

Criterios de aceptación:

- El usuario puede filtrar por oficina.
- El usuario puede filtrar por sala.
- El usuario puede seleccionar fecha, hora de inicio y hora de fin.
- El sistema muestra únicamente puestos disponibles.
- El sistema diferencia puestos libres, ocupados y bloqueados.

Prioridad: Must.

## HU-002 Crear reserva

Como empleado,
quiero reservar un puesto disponible,
para asegurarme de poder usarlo en la franja elegida.

Criterios de aceptación:

- Solo se puede reservar un puesto disponible.
- La reserva queda asociada al usuario autenticado.
- El sistema muestra confirmación.
- El usuario recibe notificación.
- La reserva queda registrada en auditoría.

Prioridad: Must.

## HU-003 Cancelar reserva propia

Como empleado,
quiero cancelar una reserva mía,
para liberar el puesto si no voy a usarlo.

Criterios de aceptación:

- El usuario puede cancelar reservas futuras.
- El sistema impide cancelar reservas ya finalizadas.
- El puesto vuelve a estar disponible.
- El sistema registra la cancelación.

Prioridad: Must.

## HU-004 Ver mis reservas

Como empleado,
quiero ver mis próximas reservas y mi historial,
para organizar mi asistencia a la oficina.

Criterios de aceptación:

- El sistema muestra próximas reservas.
- El sistema muestra reservas pasadas.
- Se indica estado de cada reserva.
- Se permite cancelar reservas futuras activas.

Prioridad: Must.

## HU-005 Gestionar salas

Como responsable de oficina,
quiero crear, editar y desactivar salas,
para mantener actualizada la estructura de la oficina.

Criterios de aceptación:

- El responsable puede gestionar salas de sus oficinas.
- Las salas desactivadas no aparecen como reservables.
- No se eliminan físicamente salas con reservas históricas.

Prioridad: Must.

## HU-006 Gestionar puestos

Como responsable de oficina,
quiero crear, editar, activar y desactivar puestos,
para reflejar la disponibilidad real de ordenadores.

Criterios de aceptación:

- Cada puesto pertenece a una sala.
- Cada puesto tiene código único dentro de su sala.
- Un puesto desactivado no puede reservarse.
- El histórico se conserva.

Prioridad: Must.

## HU-007 Bloquear puesto

Como responsable de oficina,
quiero bloquear un puesto por mantenimiento,
para evitar que los empleados lo reserven.

Criterios de aceptación:

- El bloqueo tiene inicio, fin y motivo.
- El sistema impide solapamientos con reservas activas salvo cancelación administrativa.
- El bloqueo aparece en la consulta de disponibilidad.

Prioridad: Should.

## HU-008 Cancelación administrativa

Como administrador,
quiero cancelar una reserva de cualquier usuario,
para resolver incidencias o cambios operativos.

Criterios de aceptación:

- Solo usuarios autorizados pueden hacerlo.
- Se registra quién cancela y el motivo.
- El usuario afectado recibe notificación.

Prioridad: Should.

## HU-009 Métricas de ocupación

Como responsable de oficina,
quiero ver métricas de ocupación,
para tomar decisiones sobre espacios.

Criterios de aceptación:

- Se puede consultar ocupación por oficina.
- Se puede consultar ocupación por sala.
- Se puede consultar ocupación por rango de fechas.
- Se muestran reservas totales, canceladas y porcentaje de uso.

Prioridad: Could.
```

---

# 02-requisitos/03-casos-uso.md

```md
# Casos de uso

## CU-001 Iniciar sesión

Actor principal: Empleado.

Precondiciones:

- El usuario tiene cuenta corporativa activa.

Flujo principal:

1. El usuario accede a la aplicación.
2. El sistema redirige al proveedor de identidad.
3. El usuario se autentica.
4. El sistema obtiene identidad y roles.
5. El sistema crea sesión.
6. El usuario accede al panel principal.

Flujos alternativos:

- 4A. Si el usuario no está autorizado, se muestra error de acceso.

Postcondiciones:

- El usuario queda autenticado.

Requisitos relacionados:

- RF-001
- RNF-004
- RNF-005

## CU-002 Consultar disponibilidad

Actor principal: Empleado.

Precondiciones:

- Usuario autenticado.

Flujo principal:

1. El usuario accede a “Reservar puesto”.
2. Selecciona oficina.
3. Selecciona sala o deja “todas”.
4. Selecciona fecha.
5. Selecciona hora de inicio y hora de fin.
6. El sistema valida la franja.
7. El sistema consulta reservas y bloqueos.
8. El sistema muestra puestos disponibles, ocupados y bloqueados.

Flujos alternativos:

- 6A. Si la franja es inválida, se muestra mensaje de error.
- 7A. Si no existen puestos, se muestra estado vacío.

Postcondiciones:

- No se modifica información persistente.

Requisitos relacionados:

- RF-004
- RF-005
- RF-006

## CU-003 Crear reserva

Actor principal: Empleado.

Precondiciones:

- Usuario autenticado.
- Puesto activo.
- Puesto disponible en la franja solicitada.

Flujo principal:

1. El usuario selecciona un puesto disponible.
2. El sistema muestra resumen de reserva.
3. El usuario confirma.
4. El sistema valida disponibilidad en transacción.
5. El sistema crea la reserva.
6. El sistema registra auditoría.
7. El sistema envía notificación.
8. El sistema muestra confirmación.

Flujos alternativos:

- 4A. Si otro usuario reservó antes el mismo puesto, se informa indisponibilidad.
- 7A. Si falla la notificación, la reserva se mantiene y se registra aviso técnico.

Postcondiciones:

- Existe una reserva activa.

Requisitos relacionados:

- RF-007
- RF-008
- RN-001
- RN-002

## CU-004 Cancelar reserva propia

Actor principal: Empleado.

Precondiciones:

- Usuario autenticado.
- Reserva activa y futura.
- Reserva pertenece al usuario.

Flujo principal:

1. El usuario accede a “Mis reservas”.
2. Selecciona una reserva activa futura.
3. Pulsa cancelar.
4. El sistema solicita confirmación.
5. El usuario confirma.
6. El sistema cambia estado a cancelada.
7. El sistema registra auditoría.
8. El sistema envía notificación.

Flujos alternativos:

- 3A. Si la reserva ya empezó, no se muestra acción de cancelar.
- 6A. Si la reserva ya fue cancelada, se informa estado actualizado.

Postcondiciones:

- La reserva queda cancelada.

Requisitos relacionados:

- RF-009
- RF-010
- RN-006

## CU-005 Gestionar puesto

Actor principal: Responsable de oficina.

Precondiciones:

- Usuario autenticado.
- Usuario con rol responsable o administrador.

Flujo principal:

1. El responsable accede a administración.
2. Selecciona una oficina.
3. Selecciona una sala.
4. Crea o edita un puesto.
5. El sistema valida código único.
6. El sistema guarda cambios.
7. El sistema registra auditoría.

Flujos alternativos:

- 5A. Si el código ya existe, se muestra error.
- 6A. Si se desactiva un puesto con reservas futuras, el sistema solicita decisión administrativa.

Postcondiciones:

- El catálogo de puestos queda actualizado.

Requisitos relacionados:

- RF-015
- RF-016
- RN-008
```

---

# 02-requisitos/04-requisitos-funcionales.md

```md
# Requisitos funcionales

## Autenticación y usuarios

RF-001. El sistema debe permitir inicio de sesión mediante identidad corporativa.

RF-002. El sistema debe cargar el perfil del usuario autenticado.

RF-003. El sistema debe asignar permisos según roles.

## Consulta de disponibilidad

RF-004. El sistema debe permitir consultar oficinas activas.

RF-005. El sistema debe permitir consultar salas activas de una oficina.

RF-006. El sistema debe permitir consultar puestos disponibles en una fecha y franja horaria.

RF-007. El sistema debe indicar el estado de cada puesto: disponible, reservado, bloqueado o inactivo.

## Reservas

RF-008. El sistema debe permitir crear reservas sobre puestos disponibles.

RF-009. El sistema debe validar disponibilidad en el momento exacto de creación.

RF-010. El sistema debe permitir cancelar reservas propias futuras.

RF-011. El sistema debe permitir consultar reservas propias.

RF-012. El sistema debe permitir consultar detalle de una reserva propia.

RF-013. El sistema debe impedir reservas en fechas pasadas.

RF-014. El sistema debe impedir reservas con hora de fin menor o igual que hora de inicio.

## Administración

RF-015. El sistema debe permitir crear, editar, activar y desactivar oficinas.

RF-016. El sistema debe permitir crear, editar, activar y desactivar salas.

RF-017. El sistema debe permitir crear, editar, activar y desactivar puestos.

RF-018. El sistema debe permitir bloquear puestos por rango temporal.

RF-019. El sistema debe permitir bloquear salas completas por rango temporal.

RF-020. El sistema debe permitir a administradores cancelar reservas de cualquier usuario.

RF-021. El sistema debe permitir introducir motivo en cancelaciones administrativas.

## Notificaciones

RF-022. El sistema debe enviar confirmación cuando se cree una reserva.

RF-023. El sistema debe enviar aviso cuando se cancele una reserva.

RF-024. El sistema debe enviar aviso cuando una reserva sea cancelada administrativamente.

## Auditoría

RF-025. El sistema debe registrar creación de reserva.

RF-026. El sistema debe registrar cancelación de reserva.

RF-027. El sistema debe registrar cambios administrativos sobre oficinas, salas y puestos.

RF-028. El sistema debe registrar creación y eliminación lógica de bloqueos.

## Métricas

RF-029. El sistema debe calcular número de reservas por oficina y rango de fechas.

RF-030. El sistema debe calcular porcentaje de ocupación por sala.

RF-031. El sistema debe exportar métricas básicas en CSV para administradores.
```

---

# 02-requisitos/05-requisitos-no-funcionales.md

```md
# Requisitos no funcionales

## Rendimiento

RNF-001. La consulta de disponibilidad debe responder en menos de 2 segundos para el percentil 95.

RNF-002. La creación de reserva debe responder en menos de 2 segundos para el percentil 95.

RNF-003. El sistema debe soportar al menos 500 usuarios concurrentes en la primera versión.

## Seguridad

RNF-004. Todas las peticiones autenticadas deben requerir sesión válida o token válido.

RNF-005. El sistema debe aplicar autorización por rol y ámbito de oficina.

RNF-006. El sistema debe registrar acciones administrativas relevantes.

RNF-007. Las comunicaciones deben realizarse mediante HTTPS.

RNF-008. No se deben exponer datos personales innecesarios.

## Disponibilidad

RNF-009. El sistema debe tener una disponibilidad mensual mínima del 99,5 %.

RNF-010. La aplicación debe poder recuperarse tras reinicio sin pérdida de reservas confirmadas.

## Usabilidad

RNF-011. El proceso de reserva debe completarse en un máximo de 5 pasos.

RNF-012. La interfaz debe ser usable en escritorio y tablet.

RNF-013. La aplicación debe mostrar mensajes claros ante errores de validación.

## Accesibilidad

RNF-014. La interfaz debe cumplir criterios básicos WCAG 2.1 AA.

RNF-015. Todos los controles principales deben poder usarse con teclado.

## Mantenibilidad

RNF-016. El sistema debe separar lógica de presentación, negocio y persistencia.

RNF-017. La API debe estar documentada.

RNF-018. El código debe cubrir al menos el 70 % de lógica de dominio con pruebas automatizadas.

## Observabilidad

RNF-019. El sistema debe emitir logs estructurados.

RNF-020. El sistema debe exponer métricas técnicas de disponibilidad, latencia y errores.

RNF-021. Los errores no controlados deben generar alerta operativa.
```

---

# 02-requisitos/06-reglas-negocio.md

```md
# Reglas de negocio

RN-001. Un puesto no puede tener dos reservas activas solapadas.

RN-002. Un puesto bloqueado no puede reservarse durante el intervalo de bloqueo.

RN-003. Una sala bloqueada hace que todos sus puestos queden no reservables durante el intervalo de bloqueo.

RN-004. Una oficina inactiva no puede contener nuevas reservas.

RN-005. Una sala inactiva no puede contener nuevas reservas.

RN-006. Un empleado solo puede cancelar sus propias reservas.

RN-007. Un administrador puede cancelar cualquier reserva futura o activa.

RN-008. El código de puesto debe ser único dentro de una misma sala.

RN-009. El código de sala debe ser único dentro de una misma oficina.

RN-010. Las reservas deben tener hora de inicio anterior a hora de fin.

RN-011. No se puede crear una reserva en el pasado.

RN-012. La duración mínima de una reserva es de 30 minutos.

RN-013. La duración máxima de una reserva es de 8 horas.

RN-014. Un usuario no puede tener dos reservas activas solapadas, aunque sean en puestos distintos.

RN-015. Una reserva cancelada no bloquea disponibilidad.

RN-016. Una reserva finalizada no puede cancelarse por el usuario.

RN-017. La desactivación de un puesto no elimina reservas históricas.

RN-018. Toda cancelación administrativa debe incluir motivo.

RN-019. Todo bloqueo debe incluir motivo.

RN-020. Los horarios se interpretan en la zona horaria configurada para la oficina.
```

---

# 02-requisitos/07-matriz-trazabilidad.md

```md
# Matriz de trazabilidad

| Objetivo | Historia | Caso de uso | Requisito | Prueba |
|---|---|---|---|---|
| OBJ-001 | HU-002 | CU-003 | RF-008, RF-009, RN-001 | CP-F-001, CP-API-003 |
| OBJ-002 | HU-001 | CU-002 | RF-004, RF-005, RF-006 | CP-F-002 |
| OBJ-003 | HU-005, HU-006 | CU-005 | RF-015, RF-016, RF-017 | CP-F-006 |
| OBJ-004 | HU-002, HU-003 | CU-003, CU-004 | RF-025, RF-026, RF-027 | CP-F-008 |
| OBJ-005 | HU-009 | N/A | RF-029, RF-030, RF-031 | CP-F-009 |
| OBJ-006 | HU-007 | N/A | RF-018, RF-019, RN-002, RN-003 | CP-F-007 |
| OBJ-007 | HU-001, HU-002 | CU-002, CU-003 | RNF-011, RNF-013 | CP-F-010 |
```

---

# 03-modelo/00-modelo-dominio.md

```md
# Modelo de dominio

## Entidades principales

## Usuario

Representa a una persona que accede al sistema.

Atributos:

- id
- nombre
- email
- rol
- activo
- fechaCreacion
- fechaActualizacion

Relaciones:

- Un usuario puede tener muchas reservas.
- Un usuario puede realizar muchas acciones auditadas.

## Oficina

Representa una sede física.

Atributos:

- id
- codigo
- nombre
- direccion
- zonaHoraria
- activa

Relaciones:

- Una oficina tiene muchas salas.
- Una oficina puede tener responsables.

## Sala

Representa una sala dentro de una oficina.

Atributos:

- id
- oficinaId
- codigo
- nombre
- planta
- activa

Relaciones:

- Una sala pertenece a una oficina.
- Una sala tiene muchos puestos.
- Una sala puede tener bloqueos.

## Puesto

Representa un puesto físico con ordenador.

Atributos:

- id
- salaId
- codigo
- descripcion
- tipoEquipo
- monitorDoble
- activo

Relaciones:

- Un puesto pertenece a una sala.
- Un puesto puede tener muchas reservas.
- Un puesto puede tener bloqueos.

## Reserva

Representa la ocupación temporal de un puesto por un usuario.

Atributos:

- id
- usuarioId
- puestoId
- inicio
- fin
- estado
- motivoCancelacion
- canceladaPor
- fechaCreacion
- fechaActualizacion

Relaciones:

- Una reserva pertenece a un usuario.
- Una reserva pertenece a un puesto.

## Bloqueo

Representa la indisponibilidad temporal de un recurso.

Atributos:

- id
- tipoRecurso
- recursoId
- inicio
- fin
- motivo
- creadoPor
- activo

Tipos de recurso:

- OFICINA
- SALA
- PUESTO

## Auditoria

Representa una acción relevante.

Atributos:

- id
- actorUsuarioId
- accion
- entidadTipo
- entidadId
- fecha
- datosAntes
- datosDespues
- ip
- userAgent
```

---

# 03-modelo/01-estados-reserva.md

````md
# Estados de reserva

## Estados

```text
BORRADOR
CONFIRMADA
CANCELADA_POR_USUARIO
CANCELADA_POR_ADMIN
FINALIZADA
NO_PRESENTADO
````

## Descripción

| Estado                | Descripción                                     |
| --------------------- | ----------------------------------------------- |
| BORRADOR              | Estado temporal no persistente o de preparación |
| CONFIRMADA            | Reserva activa y válida                         |
| CANCELADA_POR_USUARIO | Reserva cancelada por su propietario            |
| CANCELADA_POR_ADMIN   | Reserva cancelada por usuario autorizado        |
| FINALIZADA            | Reserva cuya hora de fin ya pasó                |
| NO_PRESENTADO         | Reserva marcada como no utilizada               |

## Transiciones permitidas

```text
BORRADOR -> CONFIRMADA
CONFIRMADA -> CANCELADA_POR_USUARIO
CONFIRMADA -> CANCELADA_POR_ADMIN
CONFIRMADA -> FINALIZADA
CONFIRMADA -> NO_PRESENTADO
```

## Transiciones prohibidas

```text
CANCELADA_POR_USUARIO -> CONFIRMADA
CANCELADA_POR_ADMIN -> CONFIRMADA
FINALIZADA -> CANCELADA_POR_USUARIO
FINALIZADA -> CANCELADA_POR_ADMIN
NO_PRESENTADO -> CONFIRMADA
```

## Reglas

* Solo las reservas CONFIRMADAS bloquean disponibilidad.
* Las reservas CANCELADAS no bloquean disponibilidad.
* FINALIZADA puede calcularse dinámicamente a partir de la fecha de fin.

````

---

# 03-modelo/02-diagramas-textuales.md

```md
# Diagramas textuales

## Diagrama de contexto

```text
+-------------------+          +--------------------------+
| Empleado          |          | Responsable de oficina   |
+---------+---------+          +------------+-------------+
          |                                 |
          v                                 v
+---------------------------------------------------------+
| Aplicación Reserva de Puestos                           |
| - Consulta disponibilidad                               |
| - Gestión reservas                                      |
| - Administración de oficinas, salas y puestos           |
+------------------+------------------+-------------------+
                   |                  |
                   v                  v
        +------------------+   +----------------------+
        | Sistema identidad|   | Sistema notificación |
        +------------------+   +----------------------+
````

## Diagrama entidad-relación simplificado

```text
USUARIO 1---N RESERVA N---1 PUESTO N---1 SALA N---1 OFICINA

USUARIO 1---N AUDITORIA

OFICINA 1---N BLOQUEO
SALA    1---N BLOQUEO
PUESTO  1---N BLOQUEO
```

## Flujo de creación de reserva

```text
Usuario
  |
  | Selecciona oficina, sala, fecha y hora
  v
Frontend
  |
  | GET /availability
  v
Backend
  |
  | Consulta puestos, reservas y bloqueos
  v
Base de datos
  |
  | Devuelve disponibilidad
  v
Frontend
  |
  | Usuario confirma puesto
  v
Backend
  |
  | Transacción:
  | - valida solapamientos
  | - crea reserva
  | - registra auditoría
  v
Sistema notificaciones
```

````

---

# 03-modelo/03-eventos-dominio.md

```md
# Eventos de dominio

## ReservaCreada

Se emite cuando una reserva queda confirmada.

Payload:

```json
{
  "eventType": "ReservaCreada",
  "reservaId": "uuid",
  "usuarioId": "uuid",
  "puestoId": "uuid",
  "inicio": "2026-05-08T09:00:00+01:00",
  "fin": "2026-05-08T13:00:00+01:00"
}
````

Usos:

* Enviar notificación.
* Actualizar métricas.
* Registrar auditoría.

## ReservaCancelada

Se emite cuando una reserva se cancela.

Payload:

```json
{
  "eventType": "ReservaCancelada",
  "reservaId": "uuid",
  "canceladaPor": "uuid",
  "tipoCancelacion": "USUARIO",
  "motivo": "No asistiré a la oficina"
}
```

Usos:

* Enviar notificación.
* Liberar disponibilidad.
* Registrar auditoría.

## PuestoBloqueado

Se emite cuando se crea un bloqueo sobre un puesto.

Payload:

```json
{
  "eventType": "PuestoBloqueado",
  "bloqueoId": "uuid",
  "puestoId": "uuid",
  "inicio": "2026-05-10T08:00:00+01:00",
  "fin": "2026-05-10T18:00:00+01:00",
  "motivo": "Mantenimiento"
}
```

````

---

# 04-interfaz/00-mapa-navegacion.md

```md
# Mapa de navegación

```text
/login
  |
  v
/app
  |
  +-- /app/reservar
  |     |
  |     +-- /app/reservar/disponibilidad
  |     +-- /app/reservar/confirmacion
  |
  +-- /app/mis-reservas
  |     |
  |     +-- /app/mis-reservas/:id
  |
  +-- /app/admin
        |
        +-- /app/admin/oficinas
        +-- /app/admin/salas
        +-- /app/admin/puestos
        +-- /app/admin/bloqueos
        +-- /app/admin/reservas
        +-- /app/admin/metricas
        +-- /app/admin/auditoria
````

## Navegación por rol

Empleado:

* Reservar puesto.
* Mis reservas.
* Perfil.

Responsable de oficina:

* Todo lo anterior.
* Administración de sus oficinas.
* Métricas de sus oficinas.

Administrador:

* Acceso completo.

````

---

# 04-interfaz/01-pantallas.md

```md
# Pantallas

## Pantalla: Inicio de sesión

Ruta: /login

Elementos:

- Logo de la organización.
- Botón “Entrar con cuenta corporativa”.
- Mensaje legal breve.
- Enlace a soporte.

Acciones:

- Iniciar autenticación.

## Pantalla: Panel principal

Ruta: /app

Elementos:

- Saludo al usuario.
- Próxima reserva destacada.
- Botón “Reservar puesto”.
- Resumen de ocupación si el usuario es responsable.
- Menú principal.

## Pantalla: Reservar puesto

Ruta: /app/reservar

Elementos:

- Selector de oficina.
- Selector de sala.
- Selector de fecha.
- Selector de hora de inicio.
- Selector de hora de fin.
- Botón “Buscar disponibilidad”.

Validaciones:

- Fecha obligatoria.
- Hora inicio obligatoria.
- Hora fin obligatoria.
- Hora fin posterior a hora inicio.
- Fecha no anterior a hoy.

## Pantalla: Disponibilidad

Ruta: /app/reservar/disponibilidad

Elementos:

- Resumen de búsqueda.
- Plano o listado de puestos.
- Estados visuales:
  - Disponible.
  - Reservado.
  - Bloqueado.
  - Inactivo.
- Botón “Reservar” en puestos disponibles.

## Pantalla: Confirmación de reserva

Ruta: /app/reservar/confirmacion

Elementos:

- Oficina.
- Sala.
- Puesto.
- Fecha.
- Hora de inicio.
- Hora de fin.
- Botón “Confirmar reserva”.
- Botón “Volver”.

## Pantalla: Mis reservas

Ruta: /app/mis-reservas

Elementos:

- Pestaña “Próximas”.
- Pestaña “Historial”.
- Listado de reservas.
- Acción cancelar para reservas futuras confirmadas.

## Pantalla: Administración de oficinas

Ruta: /app/admin/oficinas

Elementos:

- Tabla de oficinas.
- Botón crear oficina.
- Acciones editar, activar y desactivar.

## Pantalla: Administración de salas

Ruta: /app/admin/salas

Elementos:

- Filtro por oficina.
- Tabla de salas.
- Botón crear sala.
- Acciones editar, activar y desactivar.

## Pantalla: Administración de puestos

Ruta: /app/admin/puestos

Elementos:

- Filtro por oficina.
- Filtro por sala.
- Tabla de puestos.
- Botón crear puesto.
- Acciones editar, activar, desactivar y bloquear.

## Pantalla: Administración de bloqueos

Ruta: /app/admin/bloqueos

Elementos:

- Listado de bloqueos activos y futuros.
- Crear bloqueo.
- Cancelar bloqueo.
- Filtros por oficina, sala y puesto.

## Pantalla: Métricas

Ruta: /app/admin/metricas

Elementos:

- Filtro por oficina.
- Filtro por sala.
- Rango de fechas.
- Indicadores:
  - Total reservas.
  - Reservas canceladas.
  - Horas reservadas.
  - Ocupación estimada.
- Exportar CSV.

## Pantalla: Auditoría

Ruta: /app/admin/auditoria

Elementos:

- Filtro por actor.
- Filtro por acción.
- Filtro por entidad.
- Rango de fechas.
- Tabla de eventos auditados.
````

---

# 04-interfaz/02-flujos-ui.md

```md
# Flujos UI

## Flujo: reservar puesto

1. Usuario entra en “Reservar puesto”.
2. Selecciona oficina.
3. El sistema carga salas.
4. Selecciona sala o todas las salas.
5. Selecciona fecha.
6. Selecciona hora de inicio.
7. Selecciona hora de fin.
8. Pulsa “Buscar disponibilidad”.
9. El sistema muestra puestos.
10. Usuario pulsa “Reservar” sobre un puesto disponible.
11. El sistema muestra resumen.
12. Usuario confirma.
13. El sistema muestra confirmación final.

## Flujo: cancelar reserva

1. Usuario entra en “Mis reservas”.
2. Selecciona una reserva futura.
3. Pulsa “Cancelar”.
4. El sistema muestra modal de confirmación.
5. Usuario confirma.
6. El sistema marca la reserva como cancelada.
7. Se actualiza el listado.

## Flujo: bloquear puesto

1. Responsable entra en administración de puestos.
2. Busca puesto.
3. Pulsa “Bloquear”.
4. Introduce inicio, fin y motivo.
5. El sistema valida solapamientos.
6. Se crea bloqueo.
7. El puesto aparece bloqueado en disponibilidad.

## Flujo: crear sala

1. Responsable entra en administración de salas.
2. Pulsa “Nueva sala”.
3. Introduce oficina, código, nombre y planta.
4. Guarda.
5. El sistema valida unicidad de código.
6. La sala aparece en listados.
```

---

# 04-interfaz/03-textos-validaciones.md

```md
# Textos y validaciones

## Mensajes de éxito

RESERVA_CREADA:

“Reserva confirmada. Te hemos asignado el puesto {puesto} en la sala {sala} el día {fecha} de {inicio} a {fin}.”

RESERVA_CANCELADA:

“La reserva ha sido cancelada correctamente.”

PUESTO_CREADO:

“El puesto se ha creado correctamente.”

BLOQUEO_CREADO:

“El bloqueo se ha creado correctamente.”

## Mensajes de error

ERROR_FRANJA_INVALIDA:

“La hora de fin debe ser posterior a la hora de inicio.”

ERROR_FECHA_PASADA:

“No se pueden realizar reservas en fechas pasadas.”

ERROR_PUESTO_NO_DISPONIBLE:

“El puesto ya no está disponible en la franja seleccionada.”

ERROR_SIN_PERMISOS:

“No tienes permisos para realizar esta acción.”

ERROR_CODIGO_DUPLICADO:

“Ya existe un elemento con ese código.”

ERROR_DURACION_MINIMA:

“La reserva debe durar al menos 30 minutos.”

ERROR_DURACION_MAXIMA:

“La reserva no puede superar las 8 horas.”

ERROR_SOLAPAMIENTO_USUARIO:

“Ya tienes otra reserva en esa franja horaria.”

## Validaciones de formulario

Reserva:

- oficina: obligatoria.
- fecha: obligatoria, hoy o futuro.
- inicio: obligatorio.
- fin: obligatorio, posterior a inicio.
- duración: mínimo 30 minutos, máximo 8 horas.

Oficina:

- código: obligatorio, único, máximo 20 caracteres.
- nombre: obligatorio, máximo 120 caracteres.
- zonaHoraria: obligatoria.

Sala:

- oficina: obligatoria.
- código: obligatorio, único dentro de oficina.
- nombre: obligatorio.
- planta: opcional.

Puesto:

- sala: obligatoria.
- código: obligatorio, único dentro de sala.
- tipoEquipo: opcional.
- monitorDoble: booleano.

Bloqueo:

- recurso: obligatorio.
- inicio: obligatorio.
- fin: obligatorio, posterior a inicio.
- motivo: obligatorio, máximo 500 caracteres.
```

---

# 05-arquitectura/00-vision-arquitectura.md

````md
# Visión de arquitectura

## Estilo arquitectónico

Arquitectura web por capas con API REST.

```text
Frontend Web
   |
   v
API Backend
   |
   +-- Servicio de dominio
   +-- Servicio de disponibilidad
   +-- Servicio de reservas
   +-- Servicio de administración
   +-- Servicio de auditoría
   +-- Servicio de notificaciones
   |
   v
Base de datos relacional
````

## Capas

## Presentación

Responsable de interfaz web, formularios, navegación y consumo de API.

## API

Expone endpoints REST para operaciones de usuario y administración.

## Dominio

Contiene reglas de negocio sobre reservas, disponibilidad, bloqueos y permisos.

## Persistencia

Gestiona acceso a base de datos.

## Infraestructura

Incluye autenticación externa, notificaciones, logs, métricas y despliegue.

## Justificación

La aplicación tiene reglas transaccionales claras, especialmente evitar solapamientos. Una base de datos relacional permite integridad, restricciones, consultas por rangos y auditoría fiable.

````

---

# 05-arquitectura/01-componentes.md

```md
# Componentes

## Frontend Web

Responsabilidades:

- Renderizar pantallas.
- Gestionar formularios.
- Consumir API.
- Mostrar mensajes.
- Aplicar navegación según rol.

Tecnologías sugeridas:

- React, Angular o Vue.
- Cliente HTTP.
- Gestión de sesión.
- Componentes accesibles.

## Backend API

Responsabilidades:

- Validar entrada.
- Aplicar autorización.
- Ejecutar casos de uso.
- Exponer endpoints REST.
- Emitir eventos de dominio.

Tecnologías sugeridas:

- Java Spring Boot, .NET, Node.js o Python FastAPI.
- ORM o acceso SQL controlado.
- OpenAPI.

## Servicio de disponibilidad

Responsabilidades:

- Calcular disponibilidad.
- Resolver estados por puesto.
- Consultar reservas activas y bloqueos.

## Servicio de reservas

Responsabilidades:

- Crear reservas.
- Cancelar reservas.
- Validar solapamientos.
- Gestionar estados.

## Servicio de administración

Responsabilidades:

- Gestionar oficinas.
- Gestionar salas.
- Gestionar puestos.
- Gestionar bloqueos.

## Servicio de auditoría

Responsabilidades:

- Registrar acciones.
- Permitir consulta autorizada.
- Almacenar datos relevantes antes y después.

## Servicio de notificaciones

Responsabilidades:

- Enviar confirmaciones.
- Enviar cancelaciones.
- Tolerar fallos sin romper la operación principal.

## Base de datos

Responsabilidades:

- Persistir entidades.
- Proteger integridad.
- Soportar consultas de disponibilidad.
- Mantener histórico.
````

---

# 05-arquitectura/02-flujos-sistema.md

```md
# Flujos de sistema

## Flujo técnico: consultar disponibilidad

1. Frontend llama a GET /api/v1/availability.
2. API valida token.
3. API valida parámetros.
4. Servicio de disponibilidad obtiene puestos activos.
5. Servicio consulta reservas confirmadas solapadas.
6. Servicio consulta bloqueos activos solapados.
7. Servicio compone estado de cada puesto.
8. API devuelve respuesta JSON.

## Flujo técnico: crear reserva

1. Frontend llama a POST /api/v1/reservations.
2. API valida token.
3. API valida cuerpo.
4. Servicio de reservas abre transacción.
5. Servicio bloquea o consulta el puesto de forma consistente.
6. Servicio verifica:
   - puesto activo.
   - sala activa.
   - oficina activa.
   - ausencia de reserva solapada del puesto.
   - ausencia de reserva solapada del usuario.
   - ausencia de bloqueo solapado.
7. Servicio inserta reserva confirmada.
8. Servicio inserta auditoría.
9. Transacción confirma.
10. Se emite evento ReservaCreada.
11. Servicio de notificaciones envía aviso.

## Flujo técnico: cancelar reserva

1. Frontend llama a POST /api/v1/reservations/{id}/cancel.
2. API valida token.
3. Servicio obtiene reserva.
4. Servicio verifica permisos.
5. Servicio verifica estado.
6. Servicio cambia estado a cancelada.
7. Servicio registra auditoría.
8. Se emite evento ReservaCancelada.
9. Servicio de notificaciones envía aviso.

## Flujo técnico: crear bloqueo

1. Frontend llama a POST /api/v1/admin/blocks.
2. API valida rol.
3. Servicio valida recurso.
4. Servicio valida intervalo.
5. Servicio comprueba reservas solapadas.
6. Si existen reservas, requiere política administrativa:
   - rechazar bloqueo.
   - o cancelar reservas afectadas con motivo.
7. Servicio crea bloqueo.
8. Servicio registra auditoría.
```

---

# 05-arquitectura/03-decisiones-adr.md

```md
# Decisiones arquitectónicas

## ADR-001 Usar base de datos relacional

Estado: Aprobada.

Contexto:

El sistema requiere evitar solapamientos de reservas, mantener integridad referencial y consultar disponibilidad por rangos de tiempo.

Decisión:

Usar una base de datos relacional.

Consecuencias:

- Mayor facilidad para transacciones.
- Mayor consistencia.
- Consultas de disponibilidad optimizables con índices.

## ADR-002 API REST versionada

Estado: Aprobada.

Contexto:

La primera versión será consumida por una aplicación web.

Decisión:

Exponer API REST bajo /api/v1.

Consecuencias:

- Contratos sencillos.
- Fácil documentación OpenAPI.
- Posibilidad de evolucionar con /api/v2.

## ADR-003 Cancelación lógica de reservas

Estado: Aprobada.

Contexto:

Las reservas canceladas deben conservarse para auditoría y métricas.

Decisión:

No borrar reservas. Cambiar estado.

Consecuencias:

- Histórico completo.
- Consultas deben filtrar estados activos.

## ADR-004 Bloqueos como entidad común

Estado: Aprobada.

Contexto:

Se necesitan bloqueos de oficina, sala y puesto.

Decisión:

Crear entidad bloqueo con tipoRecurso y recursoId.

Consecuencias:

- Modelo flexible.
- Validaciones de integridad requieren lógica de aplicación.

## ADR-005 Notificaciones asíncronas tolerantes a fallo

Estado: Aprobada.

Contexto:

Una reserva no debe fallar si el envío de correo falla.

Decisión:

Separar confirmación de reserva del envío de notificación.

Consecuencias:

- Mejor resiliencia.
- Se requiere registro de fallos de notificación.
```

---

# 05-arquitectura/04-integraciones.md

```md
# Integraciones

## Sistema de identidad corporativa

Tipo: OIDC/OAuth2 o SAML.

Uso:

- Autenticación.
- Obtención de identidad.
- Obtención de grupos o roles si aplica.

Datos esperados:

- subject/id.
- email.
- nombre.
- grupos.

## Sistema de notificaciones

Tipo: SMTP, API de correo o sistema interno.

Uso:

- Confirmación de reserva.
- Cancelación de reserva.
- Avisos administrativos.

Plantillas:

- reserva-confirmada.
- reserva-cancelada.
- reserva-cancelada-admin.

## Sistema de observabilidad

Tipo: logs, métricas y trazas.

Uso:

- Diagnóstico.
- Alertas.
- Análisis de errores.

Eventos mínimos:

- request HTTP.
- error no controlado.
- reserva creada.
- reserva cancelada.
- fallo de notificación.
```

---

# 06-api/00-principios-api.md

````md
# Principios de API

## Estilo

API REST sobre HTTPS.

## Versionado

Todos los endpoints se exponen bajo:

```text
/api/v1
````

## Autenticación

Todas las rutas, salvo healthcheck público si existe, requieren token o sesión autenticada.

## Formato

Entrada y salida en JSON.

## Fechas

Las fechas se expresan en ISO 8601 con zona horaria.

Ejemplo:

```text
2026-05-08T09:00:00+01:00
```

## Paginación

Listados administrativos deben soportar:

* page
* size
* sort

## Errores

Los errores usan un formato común:

```json
{
  "code": "ERROR_CODE",
  "message": "Mensaje legible",
  "details": {}
}
```

````

---

# 06-api/01-endpoints.md

```md
# Endpoints

## Sesión

### GET /api/v1/me

Descripción:

Devuelve información del usuario autenticado.

Permisos:

- Usuario autenticado.

Respuesta 200:

```json
{
  "id": "usr_123",
  "name": "Ana García",
  "email": "ana.garcia@empresa.com",
  "roles": ["EMPLOYEE"]
}
````

## Oficinas

### GET /api/v1/offices

Descripción:

Lista oficinas activas visibles para el usuario.

Permisos:

* Usuario autenticado.

Respuesta 200:

```json
[
  {
    "id": "off_001",
    "code": "MAD",
    "name": "Madrid",
    "timezone": "Europe/Madrid"
  }
]
```

## Salas

### GET /api/v1/offices/{officeId}/rooms

Descripción:

Lista salas activas de una oficina.

Permisos:

* Usuario autenticado.

Respuesta 200:

```json
[
  {
    "id": "room_001",
    "code": "SALA-A",
    "name": "Sala A",
    "floor": "2"
  }
]
```

## Disponibilidad

### GET /api/v1/availability

Parámetros:

* officeId
* roomId opcional
* start
* end

Ejemplo:

```text
GET /api/v1/availability?officeId=off_001&roomId=room_001&start=2026-05-08T09:00:00+01:00&end=2026-05-08T13:00:00+01:00
```

Respuesta 200:

```json
{
  "officeId": "off_001",
  "roomId": "room_001",
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00",
  "desks": [
    {
      "id": "desk_001",
      "code": "PC-01",
      "roomName": "Sala A",
      "status": "AVAILABLE",
      "features": {
        "equipmentType": "Windows",
        "dualMonitor": true
      }
    },
    {
      "id": "desk_002",
      "code": "PC-02",
      "roomName": "Sala A",
      "status": "RESERVED"
    }
  ]
}
```

## Reservas

### POST /api/v1/reservations

Descripción:

Crea una reserva.

Permisos:

* Usuario autenticado.

Cuerpo:

```json
{
  "deskId": "desk_001",
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00"
}
```

Respuesta 201:

```json
{
  "id": "res_001",
  "status": "CONFIRMED",
  "desk": {
    "id": "desk_001",
    "code": "PC-01"
  },
  "room": {
    "id": "room_001",
    "name": "Sala A"
  },
  "office": {
    "id": "off_001",
    "name": "Madrid"
  },
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00"
}
```

### GET /api/v1/reservations/my

Descripción:

Lista reservas del usuario autenticado.

Parámetros:

* status opcional.
* from opcional.
* to opcional.

Respuesta 200:

```json
[
  {
    "id": "res_001",
    "status": "CONFIRMED",
    "deskCode": "PC-01",
    "roomName": "Sala A",
    "officeName": "Madrid",
    "start": "2026-05-08T09:00:00+01:00",
    "end": "2026-05-08T13:00:00+01:00"
  }
]
```

### GET /api/v1/reservations/{reservationId}

Descripción:

Devuelve detalle de reserva.

Permisos:

* Propietario de la reserva.
* Responsable autorizado.
* Administrador.

Respuesta 200:

```json
{
  "id": "res_001",
  "status": "CONFIRMED",
  "user": {
    "id": "usr_123",
    "name": "Ana García"
  },
  "desk": {
    "id": "desk_001",
    "code": "PC-01"
  },
  "room": {
    "id": "room_001",
    "name": "Sala A"
  },
  "office": {
    "id": "off_001",
    "name": "Madrid"
  },
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00",
  "createdAt": "2026-05-07T10:00:00+01:00"
}
```

### POST /api/v1/reservations/{reservationId}/cancel

Descripción:

Cancela una reserva.

Cuerpo:

```json
{
  "reason": "No asistiré a la oficina"
}
```

Respuesta 200:

```json
{
  "id": "res_001",
  "status": "CANCELLED_BY_USER"
}
```

## Administración: oficinas

### GET /api/v1/admin/offices

Permisos:

* ADMIN.
* OFFICE_MANAGER.

### POST /api/v1/admin/offices

Permisos:

* ADMIN.

Cuerpo:

```json
{
  "code": "MAD",
  "name": "Madrid",
  "address": "Calle Ejemplo 1",
  "timezone": "Europe/Madrid"
}
```

### PATCH /api/v1/admin/offices/{officeId}

Permisos:

* ADMIN.

## Administración: salas

### GET /api/v1/admin/rooms

Parámetros:

* officeId opcional.

### POST /api/v1/admin/rooms

Cuerpo:

```json
{
  "officeId": "off_001",
  "code": "SALA-A",
  "name": "Sala A",
  "floor": "2"
}
```

### PATCH /api/v1/admin/rooms/{roomId}

## Administración: puestos

### GET /api/v1/admin/desks

Parámetros:

* officeId opcional.
* roomId opcional.

### POST /api/v1/admin/desks

Cuerpo:

```json
{
  "roomId": "room_001",
  "code": "PC-01",
  "description": "Puesto junto a la ventana",
  "equipmentType": "Windows",
  "dualMonitor": true
}
```

### PATCH /api/v1/admin/desks/{deskId}

## Administración: bloqueos

### POST /api/v1/admin/blocks

Cuerpo:

```json
{
  "resourceType": "DESK",
  "resourceId": "desk_001",
  "start": "2026-05-10T08:00:00+01:00",
  "end": "2026-05-10T18:00:00+01:00",
  "reason": "Mantenimiento"
}
```

### DELETE /api/v1/admin/blocks/{blockId}

Descripción:

Cancela lógicamente un bloqueo.

## Administración: métricas

### GET /api/v1/admin/metrics/occupancy

Parámetros:

* officeId
* roomId opcional
* from
* to

Respuesta 200:

```json
{
  "officeId": "off_001",
  "from": "2026-05-01",
  "to": "2026-05-31",
  "totalReservations": 120,
  "cancelledReservations": 15,
  "reservedHours": 420,
  "occupancyPercentage": 68.4
}
```

## Auditoría

### GET /api/v1/admin/audit

Parámetros:

* actorUserId opcional.
* action opcional.
* entityType opcional.
* from opcional.
* to opcional.

Permisos:

* ADMIN.
* SUPPORT.

````

---

# 06-api/02-contratos-json.md

```md
# Contratos JSON

## UserDto

```json
{
  "id": "usr_123",
  "name": "Ana García",
  "email": "ana.garcia@empresa.com",
  "roles": ["EMPLOYEE"]
}
````

## OfficeDto

```json
{
  "id": "off_001",
  "code": "MAD",
  "name": "Madrid",
  "address": "Calle Ejemplo 1",
  "timezone": "Europe/Madrid",
  "active": true
}
```

## RoomDto

```json
{
  "id": "room_001",
  "officeId": "off_001",
  "code": "SALA-A",
  "name": "Sala A",
  "floor": "2",
  "active": true
}
```

## DeskDto

```json
{
  "id": "desk_001",
  "roomId": "room_001",
  "code": "PC-01",
  "description": "Puesto junto a la ventana",
  "equipmentType": "Windows",
  "dualMonitor": true,
  "active": true
}
```

## AvailabilityDeskDto

```json
{
  "id": "desk_001",
  "code": "PC-01",
  "roomId": "room_001",
  "roomName": "Sala A",
  "status": "AVAILABLE",
  "features": {
    "equipmentType": "Windows",
    "dualMonitor": true
  }
}
```

Valores de status:

```text
AVAILABLE
RESERVED
BLOCKED
INACTIVE
```

## ReservationDto

```json
{
  "id": "res_001",
  "status": "CONFIRMED",
  "userId": "usr_123",
  "deskId": "desk_001",
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00",
  "createdAt": "2026-05-07T10:00:00+01:00",
  "updatedAt": "2026-05-07T10:00:00+01:00"
}
```

## CreateReservationRequest

```json
{
  "deskId": "desk_001",
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00"
}
```

## CancelReservationRequest

```json
{
  "reason": "No asistiré a la oficina"
}
```

## BlockDto

```json
{
  "id": "blk_001",
  "resourceType": "DESK",
  "resourceId": "desk_001",
  "start": "2026-05-10T08:00:00+01:00",
  "end": "2026-05-10T18:00:00+01:00",
  "reason": "Mantenimiento",
  "active": true
}
```

## ErrorResponse

```json
{
  "code": "DESK_NOT_AVAILABLE",
  "message": "El puesto ya no está disponible en la franja seleccionada.",
  "details": {
    "deskId": "desk_001"
  }
}
```

````

---

# 06-api/03-errores-api.md

```md
# Errores API

## Catálogo

| Código | HTTP | Descripción |
|---|---:|---|
| UNAUTHENTICATED | 401 | Usuario no autenticado |
| FORBIDDEN | 403 | Usuario sin permisos |
| VALIDATION_ERROR | 400 | Error de validación |
| OFFICE_NOT_FOUND | 404 | Oficina no encontrada |
| ROOM_NOT_FOUND | 404 | Sala no encontrada |
| DESK_NOT_FOUND | 404 | Puesto no encontrado |
| RESERVATION_NOT_FOUND | 404 | Reserva no encontrada |
| DESK_NOT_AVAILABLE | 409 | Puesto no disponible |
| USER_HAS_OVERLAPPING_RESERVATION | 409 | Usuario con reserva solapada |
| RESOURCE_BLOCKED | 409 | Recurso bloqueado |
| DUPLICATED_CODE | 409 | Código duplicado |
| INVALID_TIME_RANGE | 400 | Rango horario inválido |
| PAST_RESERVATION_NOT_ALLOWED | 400 | Reserva en el pasado |
| INTERNAL_ERROR | 500 | Error interno |

## Ejemplo: validación

```json
{
  "code": "VALIDATION_ERROR",
  "message": "La solicitud contiene errores de validación.",
  "details": {
    "end": "La hora de fin debe ser posterior a la hora de inicio."
  }
}
````

## Ejemplo: conflicto de reserva

```json
{
  "code": "DESK_NOT_AVAILABLE",
  "message": "El puesto ya no está disponible en la franja seleccionada.",
  "details": {
    "deskId": "desk_001",
    "start": "2026-05-08T09:00:00+01:00",
    "end": "2026-05-08T13:00:00+01:00"
  }
}
```

````

---

# 07-datos/00-modelo-relacional.md

```md
# Modelo relacional

## Tablas

- users
- offices
- rooms
- desks
- reservations
- blocks
- audit_log
- office_managers
- notification_outbox

## Relaciones

- offices 1:N rooms
- rooms 1:N desks
- users 1:N reservations
- desks 1:N reservations
- users 1:N audit_log
- offices N:M users mediante office_managers

## Índices relevantes

- reservations(desk_id, start_at, end_at, status)
- reservations(user_id, start_at, end_at, status)
- blocks(resource_type, resource_id, start_at, end_at, active)
- rooms(office_id, code)
- desks(room_id, code)

## Estrategia de borrado

No se eliminan físicamente oficinas, salas, puestos ni reservas con histórico. Se usa campo active o estado.
````

---

# 07-datos/01-ddl.sql

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    external_id VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role VARCHAR(50) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE offices (
    id UUID PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    address VARCHAR(255),
    timezone VARCHAR(80) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE TABLE rooms (
    id UUID PRIMARY KEY,
    office_id UUID NOT NULL REFERENCES offices(id),
    code VARCHAR(20) NOT NULL,
    name VARCHAR(120) NOT NULL,
    floor VARCHAR(30),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT uq_rooms_office_code UNIQUE (office_id, code)
);

CREATE TABLE desks (
    id UUID PRIMARY KEY,
    room_id UUID NOT NULL REFERENCES rooms(id),
    code VARCHAR(20) NOT NULL,
    description VARCHAR(255),
    equipment_type VARCHAR(80),
    dual_monitor BOOLEAN NOT NULL DEFAULT FALSE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT uq_desks_room_code UNIQUE (room_id, code)
);

CREATE TABLE reservations (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES users(id),
    desk_id UUID NOT NULL REFERENCES desks(id),
    start_at TIMESTAMP WITH TIME ZONE NOT NULL,
    end_at TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(50) NOT NULL,
    cancellation_reason VARCHAR(500),
    cancelled_by UUID REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT chk_reservation_range CHECK (end_at > start_at)
);

CREATE INDEX idx_reservations_desk_time
ON reservations (desk_id, start_at, end_at, status);

CREATE INDEX idx_reservations_user_time
ON reservations (user_id, start_at, end_at, status);

CREATE TABLE blocks (
    id UUID PRIMARY KEY,
    resource_type VARCHAR(30) NOT NULL,
    resource_id UUID NOT NULL,
    start_at TIMESTAMP WITH TIME ZONE NOT NULL,
    end_at TIMESTAMP WITH TIME ZONE NOT NULL,
    reason VARCHAR(500) NOT NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    CONSTRAINT chk_block_range CHECK (end_at > start_at),
    CONSTRAINT chk_block_resource_type CHECK (resource_type IN ('OFFICE', 'ROOM', 'DESK'))
);

CREATE INDEX idx_blocks_resource_time
ON blocks (resource_type, resource_id, start_at, end_at, active);

CREATE TABLE audit_log (
    id UUID PRIMARY KEY,
    actor_user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(80) NOT NULL,
    entity_id UUID,
    occurred_at TIMESTAMP WITH TIME ZONE NOT NULL,
    before_data JSONB,
    after_data JSONB,
    ip_address VARCHAR(80),
    user_agent VARCHAR(500)
);

CREATE INDEX idx_audit_log_actor_time
ON audit_log (actor_user_id, occurred_at);

CREATE INDEX idx_audit_log_entity
ON audit_log (entity_type, entity_id);

CREATE TABLE office_managers (
    office_id UUID NOT NULL REFERENCES offices(id),
    user_id UUID NOT NULL REFERENCES users(id),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    PRIMARY KEY (office_id, user_id)
);

CREATE TABLE notification_outbox (
    id UUID PRIMARY KEY,
    event_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    status VARCHAR(50) NOT NULL,
    attempts INTEGER NOT NULL DEFAULT 0,
    next_attempt_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL
);

CREATE INDEX idx_notification_outbox_status
ON notification_outbox (status, next_attempt_at);
```

---

# 07-datos/02-datos-semilla.sql

```sql
INSERT INTO offices (
    id,
    code,
    name,
    address,
    timezone,
    active,
    created_at,
    updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000001',
    'MAD',
    'Oficina Madrid',
    'Calle Ejemplo 1, Madrid',
    'Europe/Madrid',
    TRUE,
    NOW(),
    NOW()
);

INSERT INTO rooms (
    id,
    office_id,
    code,
    name,
    floor,
    active,
    created_at,
    updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000101',
    '00000000-0000-0000-0000-000000000001',
    'SALA-A',
    'Sala A',
    '2',
    TRUE,
    NOW(),
    NOW()
);

INSERT INTO desks (
    id,
    room_id,
    code,
    description,
    equipment_type,
    dual_monitor,
    active,
    created_at,
    updated_at
) VALUES
(
    '00000000-0000-0000-0000-000000001001',
    '00000000-0000-0000-0000-000000000101',
    'PC-01',
    'Puesto junto a la ventana',
    'Windows',
    TRUE,
    TRUE,
    NOW(),
    NOW()
),
(
    '00000000-0000-0000-0000-000000001002',
    '00000000-0000-0000-0000-000000000101',
    'PC-02',
    'Puesto central',
    'Linux',
    FALSE,
    TRUE,
    NOW(),
    NOW()
),
(
    '00000000-0000-0000-0000-000000001003',
    '00000000-0000-0000-0000-000000000101',
    'PC-03',
    'Puesto junto a la puerta',
    'Windows',
    TRUE,
    TRUE,
    NOW(),
    NOW()
);
```

---

# 07-datos/03-politicas-retencion.md

```md
# Políticas de retención

## Reservas

Las reservas se conservan durante 5 años por motivos operativos y de auditoría interna.

## Auditoría

Los registros de auditoría se conservan durante 5 años.

## Notificaciones

Los registros de notificación se conservan durante 1 año.

## Usuarios

Los usuarios inactivos se conservan mientras existan reservas o auditorías asociadas.

## Datos personales

Se debe minimizar la exposición de datos personales en listados administrativos.

## Anonimización

Tras superar el periodo de retención, las reservas antiguas pueden anonimizar el usuario manteniendo métricas agregadas.
```

---

# 08-seguridad/00-autenticacion-autorizacion.md

```md
# Autenticación y autorización

## Autenticación

El sistema delega la autenticación en el proveedor corporativo.

Mecanismos admitidos:

- OIDC/OAuth2.
- SAML si la organización lo requiere.

## Sesión

La sesión debe:

- Expirar tras periodo de inactividad.
- Renovarse de forma segura.
- Invalidarse en cierre de sesión.
- No exponer tokens en URLs.

## Autorización

La autorización se basa en:

- Rol del usuario.
- Ámbito de oficina.
- Propiedad del recurso.

## Roles

- EMPLOYEE.
- OFFICE_MANAGER.
- ADMIN.
- SUPPORT.

## Reglas

- EMPLOYEE puede gestionar sus propias reservas.
- OFFICE_MANAGER puede administrar oficinas asignadas.
- ADMIN puede administrar todo el sistema.
- SUPPORT puede consultar información técnica y auditoría limitada.
```

---

# 08-seguridad/01-permisos.md

```md
# Matriz de permisos

| Acción | EMPLOYEE | OFFICE_MANAGER | ADMIN | SUPPORT |
|---|---:|---:|---:|---:|
| Ver oficinas activas | Sí | Sí | Sí | Sí |
| Ver salas activas | Sí | Sí | Sí | Sí |
| Consultar disponibilidad | Sí | Sí | Sí | Sí |
| Crear reserva propia | Sí | Sí | Sí | No |
| Cancelar reserva propia | Sí | Sí | Sí | No |
| Ver reservas propias | Sí | Sí | Sí | No |
| Ver reservas de oficina | No | Sí | Sí | Consulta |
| Cancelar reserva ajena | No | Sí, de su oficina | Sí | No |
| Crear oficina | No | No | Sí | No |
| Editar oficina | No | No | Sí | No |
| Crear sala | No | Sí, de su oficina | Sí | No |
| Editar sala | No | Sí, de su oficina | Sí | No |
| Crear puesto | No | Sí, de su oficina | Sí | No |
| Editar puesto | No | Sí, de su oficina | Sí | No |
| Crear bloqueo | No | Sí, de su oficina | Sí | No |
| Ver métricas | No | Sí, de su oficina | Sí | No |
| Ver auditoría | No | Limitado | Sí | Limitado |
```

---

# 08-seguridad/02-amenazas-controles.md

```md
# Amenazas y controles

## Amenaza: reserva doble por carrera concurrente

Riesgo:

Dos usuarios intentan reservar el mismo puesto al mismo tiempo.

Controles:

- Validación transaccional.
- Bloqueo optimista o pesimista.
- Índices por puesto y rango.
- Reintento controlado o error 409.

## Amenaza: acceso a reservas de otros usuarios

Riesgo:

Un empleado consulta datos de otro empleado.

Controles:

- Comprobación de propietario.
- Autorización por rol.
- Pruebas de acceso horizontal.

## Amenaza: modificación administrativa indebida

Riesgo:

Responsable modifica recursos fuera de su oficina.

Controles:

- Ámbito de oficina.
- Matriz de permisos.
- Auditoría obligatoria.

## Amenaza: exposición de datos personales

Riesgo:

Listados muestran más datos de los necesarios.

Controles:

- Minimización de campos.
- Enmascarado si procede.
- Acceso restringido.

## Amenaza: manipulación de parámetros

Riesgo:

Usuario cambia IDs en peticiones.

Controles:

- Validación de autorización en backend.
- No confiar en restricciones del frontend.

## Amenaza: inyección SQL

Riesgo:

Entrada de usuario ejecuta consultas no deseadas.

Controles:

- Consultas parametrizadas.
- ORM seguro.
- Validación de entradas.

## Amenaza: pérdida de trazabilidad

Riesgo:

No se sabe quién creó o canceló una reserva.

Controles:

- Auditoría inmutable desde aplicación.
- Registro de actor, fecha, IP y entidad.
```

---

# 08-seguridad/03-auditoria.md

```md
# Auditoría

## Acciones auditables

- LOGIN_SUCCESS.
- LOGIN_FAILURE.
- RESERVATION_CREATED.
- RESERVATION_CANCELLED_BY_USER.
- RESERVATION_CANCELLED_BY_ADMIN.
- OFFICE_CREATED.
- OFFICE_UPDATED.
- OFFICE_DEACTIVATED.
- ROOM_CREATED.
- ROOM_UPDATED.
- ROOM_DEACTIVATED.
- DESK_CREATED.
- DESK_UPDATED.
- DESK_DEACTIVATED.
- BLOCK_CREATED.
- BLOCK_CANCELLED.
- PERMISSION_DENIED.

## Datos mínimos

- actor_user_id.
- action.
- entity_type.
- entity_id.
- occurred_at.
- before_data.
- after_data.
- ip_address.
- user_agent.

## Restricciones

- Los registros de auditoría no deben ser modificables desde la interfaz.
- Solo perfiles autorizados pueden consultarlos.
- Deben poder filtrarse por fecha, actor y entidad.
```

---

# 09-pruebas/00-estrategia-pruebas.md

```md
# Estrategia de pruebas

## Objetivo

Validar que el sistema cumple los requisitos funcionales, no funcionales y de seguridad definidos.

## Niveles

## Pruebas unitarias

Cubren:

- Validación de rangos horarios.
- Detección de solapamientos.
- Estados de reserva.
- Permisos por rol.

## Pruebas de integración

Cubren:

- API con base de datos.
- Creación de reserva transaccional.
- Cancelación de reserva.
- Consulta de disponibilidad.
- Auditoría.

## Pruebas end-to-end

Cubren:

- Flujo completo de reserva.
- Flujo completo de cancelación.
- Administración de puesto.
- Bloqueo de puesto.

## Pruebas de seguridad

Cubren:

- Acceso horizontal.
- Acceso vertical.
- Peticiones sin autenticación.
- Validación de permisos administrativos.

## Pruebas de rendimiento

Cubren:

- Consulta de disponibilidad con alta concurrencia.
- Creación simultánea de reservas sobre un mismo puesto.
- Listados administrativos paginados.
```

---

# 09-pruebas/01-casos-prueba-funcionales.md

```md
# Casos de prueba funcionales

## CP-F-001 Crear reserva correctamente

Precondiciones:

- Usuario autenticado.
- Puesto activo y disponible.
- Franja futura válida.

Pasos:

1. Seleccionar oficina.
2. Seleccionar sala.
3. Seleccionar fecha futura.
4. Seleccionar hora inicio y fin.
5. Buscar disponibilidad.
6. Seleccionar puesto disponible.
7. Confirmar reserva.

Resultado esperado:

- Se crea reserva CONFIRMADA.
- El puesto aparece reservado en esa franja.
- Se registra auditoría.
- Se genera notificación.

## CP-F-002 Consultar disponibilidad

Precondiciones:

- Existen puestos activos en una sala.

Pasos:

1. Acceder a reservar.
2. Seleccionar oficina y sala.
3. Introducir franja válida.
4. Buscar.

Resultado esperado:

- Se muestra listado de puestos.
- Cada puesto tiene estado correcto.

## CP-F-003 Impedir reserva en puesto ocupado

Precondiciones:

- Puesto ya reservado de 09:00 a 13:00.

Pasos:

1. Intentar reservar el mismo puesto de 10:00 a 12:00.

Resultado esperado:

- El sistema rechaza la reserva.
- Devuelve error de puesto no disponible.

## CP-F-004 Cancelar reserva propia

Precondiciones:

- Usuario tiene reserva futura confirmada.

Pasos:

1. Acceder a Mis reservas.
2. Pulsar cancelar.
3. Confirmar.

Resultado esperado:

- La reserva queda CANCELADA_POR_USUARIO.
- El puesto queda disponible.
- Se registra auditoría.

## CP-F-005 Impedir cancelar reserva de otro usuario

Precondiciones:

- Usuario A tiene reserva.
- Usuario B autenticado sin rol admin.

Pasos:

1. Usuario B intenta cancelar reserva de usuario A.

Resultado esperado:

- El sistema devuelve error de permisos.

## CP-F-006 Crear puesto

Precondiciones:

- Responsable autenticado.
- Sala activa.

Pasos:

1. Ir a administración de puestos.
2. Crear puesto con código nuevo.
3. Guardar.

Resultado esperado:

- El puesto se crea activo.
- Aparece en disponibilidad.

## CP-F-007 Bloquear puesto

Precondiciones:

- Responsable autenticado.
- Puesto activo.

Pasos:

1. Crear bloqueo sobre puesto.
2. Consultar disponibilidad en franja bloqueada.

Resultado esperado:

- El puesto aparece como bloqueado.
- No puede reservarse.

## CP-F-008 Auditoría de reserva

Precondiciones:

- Usuario autenticado.

Pasos:

1. Crear reserva.
2. Consultar auditoría como administrador.

Resultado esperado:

- Existe evento RESERVATION_CREATED con actor y entidad.

## CP-F-009 Métricas de ocupación

Precondiciones:

- Existen reservas en el periodo.

Pasos:

1. Acceder a métricas.
2. Filtrar por oficina y rango.

Resultado esperado:

- Se muestran totales coherentes.

## CP-F-010 Validación de duración máxima

Precondiciones:

- Usuario autenticado.

Pasos:

1. Intentar reservar un puesto durante 10 horas.

Resultado esperado:

- El sistema rechaza la operación.
- Muestra mensaje de duración máxima.
```

---

# 09-pruebas/02-casos-prueba-api.md

````md
# Casos de prueba API

## CP-API-001 GET /api/v1/me

Entrada:

- Token válido.

Resultado esperado:

- HTTP 200.
- Devuelve id, name, email y roles.

## CP-API-002 GET /api/v1/availability

Entrada:

```text
officeId=off_001
roomId=room_001
start=2026-05-08T09:00:00+01:00
end=2026-05-08T13:00:00+01:00
````

Resultado esperado:

* HTTP 200.
* Devuelve lista de puestos con estado.

## CP-API-003 POST /api/v1/reservations

Entrada:

```json
{
  "deskId": "desk_001",
  "start": "2026-05-08T09:00:00+01:00",
  "end": "2026-05-08T13:00:00+01:00"
}
```

Resultado esperado:

* HTTP 201.
* Reserva CONFIRMED.

## CP-API-004 POST /api/v1/reservations con solapamiento

Precondiciones:

* Existe reserva confirmada del mismo puesto de 09:00 a 13:00.

Entrada:

```json
{
  "deskId": "desk_001",
  "start": "2026-05-08T10:00:00+01:00",
  "end": "2026-05-08T12:00:00+01:00"
}
```

Resultado esperado:

* HTTP 409.
* code = DESK_NOT_AVAILABLE.

## CP-API-005 POST cancel reserva propia

Entrada:

```json
{
  "reason": "Cambio de planificación"
}
```

Resultado esperado:

* HTTP 200.
* status = CANCELLED_BY_USER.

## CP-API-006 POST reserva sin autenticación

Entrada:

* Sin token.

Resultado esperado:

* HTTP 401.
* code = UNAUTHENTICATED.

## CP-API-007 Crear puesto con código duplicado

Precondiciones:

* Existe PC-01 en la sala.

Entrada:

```json
{
  "roomId": "room_001",
  "code": "PC-01"
}
```

Resultado esperado:

* HTTP 409.
* code = DUPLICATED_CODE.

````

---

# 09-pruebas/03-casos-prueba-seguridad.md

```md
# Casos de prueba de seguridad

## CP-S-001 Acceso sin autenticación

Objetivo:

Verificar que endpoints protegidos rechazan usuarios no autenticados.

Pasos:

1. Llamar a GET /api/v1/reservations/my sin token.

Resultado esperado:

- HTTP 401.

## CP-S-002 Acceso horizontal a reserva ajena

Objetivo:

Evitar que un empleado consulte reserva de otro.

Pasos:

1. Usuario A crea reserva.
2. Usuario B llama a GET /api/v1/reservations/{id}.

Resultado esperado:

- HTTP 403 o 404 controlado.

## CP-S-003 Escalada vertical

Objetivo:

Evitar que empleado cree puestos.

Pasos:

1. Usuario EMPLOYEE llama a POST /api/v1/admin/desks.

Resultado esperado:

- HTTP 403.

## CP-S-004 Responsable fuera de ámbito

Objetivo:

Evitar que un responsable modifique oficinas no asignadas.

Pasos:

1. Responsable de oficina A intenta crear puesto en oficina B.

Resultado esperado:

- HTTP 403.

## CP-S-005 Validación de entrada

Objetivo:

Evitar payloads malformados o peligrosos.

Pasos:

1. Enviar código de puesto con caracteres inesperados.
2. Enviar fechas inválidas.
3. Enviar motivo excesivamente largo.

Resultado esperado:

- HTTP 400.
- No se persiste información inválida.

## CP-S-006 Auditoría de denegación

Objetivo:

Registrar intentos relevantes de acceso no permitido.

Pasos:

1. Usuario intenta operación administrativa sin permiso.

Resultado esperado:

- HTTP 403.
- Evento PERMISSION_DENIED en auditoría.
````

---

# 09-pruebas/04-datos-prueba.md

```md
# Datos de prueba

## Usuarios

| ID | Nombre | Email | Rol |
|---|---|---|---|
| usr_emp_001 | Ana García | ana.garcia@empresa.com | EMPLOYEE |
| usr_emp_002 | Luis Pérez | luis.perez@empresa.com | EMPLOYEE |
| usr_mgr_001 | Marta López | marta.lopez@empresa.com | OFFICE_MANAGER |
| usr_adm_001 | Admin Sistema | admin@empresa.com | ADMIN |
| usr_sup_001 | Soporte IT | soporte@empresa.com | SUPPORT |

## Oficinas

| ID | Código | Nombre |
|---|---|---|
| off_001 | MAD | Oficina Madrid |
| off_002 | BCN | Oficina Barcelona |

## Salas

| ID | Oficina | Código | Nombre |
|---|---|---|---|
| room_001 | MAD | SALA-A | Sala A |
| room_002 | MAD | SALA-B | Sala B |
| room_003 | BCN | SALA-1 | Sala 1 |

## Puestos

| ID | Sala | Código | Equipo | Doble monitor |
|---|---|---|---|---|
| desk_001 | SALA-A | PC-01 | Windows | Sí |
| desk_002 | SALA-A | PC-02 | Linux | No |
| desk_003 | SALA-A | PC-03 | Windows | Sí |
| desk_004 | SALA-B | PC-04 | Windows | No |
| desk_005 | SALA-1 | PC-01 | Mac | Sí |

## Reservas iniciales

| ID | Usuario | Puesto | Inicio | Fin | Estado |
|---|---|---|---|---|---|
| res_001 | Ana | PC-01 | 2026-05-08 09:00 | 2026-05-08 13:00 | CONFIRMED |
| res_002 | Luis | PC-02 | 2026-05-08 10:00 | 2026-05-08 12:00 | CONFIRMED |

## Bloqueos iniciales

| ID | Recurso | Inicio | Fin | Motivo |
|---|---|---|---|---|
| blk_001 | desk_003 | 2026-05-08 08:00 | 2026-05-08 18:00 | Mantenimiento |
```

---

# 10-operacion/00-despliegue.md

```md
# Despliegue

## Entornos

- local.
- desarrollo.
- integración.
- preproducción.
- producción.

## Componentes desplegables

- frontend-web.
- backend-api.
- base de datos.
- worker de notificaciones.
- sistema de observabilidad.

## Estrategia

1. Ejecutar migraciones de base de datos.
2. Desplegar backend.
3. Desplegar worker.
4. Desplegar frontend.
5. Ejecutar pruebas smoke.
6. Habilitar tráfico.

## Smoke tests

- GET /health.
- GET /api/v1/me con token válido.
- GET /api/v1/offices.
- GET /api/v1/availability con datos conocidos.
```

---

# 10-operacion/01-configuracion.md

````md
# Configuración

## Variables de entorno

```text
APP_ENV=production
APP_BASE_URL=https://reservas.empresa.com
DATABASE_URL=postgres://user:password@host:5432/reservas
OIDC_ISSUER=https://identity.empresa.com
OIDC_CLIENT_ID=reserva-puestos
OIDC_CLIENT_SECRET=********
SMTP_HOST=smtp.empresa.com
SMTP_PORT=587
SMTP_USER=reservas@empresa.com
SMTP_PASSWORD=********
DEFAULT_TIMEZONE=Europe/Madrid
MAX_RESERVATION_HOURS=8
MIN_RESERVATION_MINUTES=30
LOG_LEVEL=INFO
````

## Parámetros funcionales

| Parámetro                        | Valor inicial |
| -------------------------------- | ------------- |
| Duración mínima de reserva       | 30 minutos    |
| Duración máxima de reserva       | 8 horas       |
| Antelación máxima                | 60 días       |
| Zona horaria por defecto         | Europe/Madrid |
| Notificación al crear reserva    | Activada      |
| Notificación al cancelar reserva | Activada      |

````

---

# 10-operacion/02-observabilidad.md

```md
# Observabilidad

## Logs

Los logs deben ser estructurados e incluir:

- timestamp.
- level.
- traceId.
- userId si aplica.
- action.
- endpoint.
- status.
- durationMs.
- errorCode si aplica.

## Métricas técnicas

- http_requests_total.
- http_request_duration_seconds.
- reservation_create_total.
- reservation_cancel_total.
- reservation_conflict_total.
- availability_query_total.
- notification_success_total.
- notification_failure_total.

## Alertas

AL-001. Tasa de errores 5xx superior al 2 % durante 5 minutos.

AL-002. Latencia p95 superior a 2 segundos durante 10 minutos.

AL-003. Fallos de notificación acumulados superiores a 50.

AL-004. Base de datos no disponible.

AL-005. Error repetido en creación de reservas.

## Trazas

Debe propagarse traceId desde frontend a backend cuando sea posible.
````

---

# 10-operacion/03-runbook.md

```md
# Runbook

## Incidencia: usuarios no pueden iniciar sesión

Comprobaciones:

1. Verificar disponibilidad del proveedor de identidad.
2. Verificar configuración OIDC.
3. Revisar logs de autenticación.
4. Confirmar que el certificado no ha caducado.

Acciones:

- Si falla proveedor externo, comunicar degradación.
- Si falla configuración, restaurar última configuración válida.

## Incidencia: no se pueden crear reservas

Comprobaciones:

1. Revisar errores 409 para conflictos reales.
2. Revisar errores 500.
3. Verificar conexión con base de datos.
4. Verificar migraciones recientes.

Acciones:

- Si la base de datos está caída, activar procedimiento de recuperación.
- Si hay bug de validación, escalar a desarrollo.

## Incidencia: reservas duplicadas

Comprobaciones:

1. Consultar reservas del puesto afectado.
2. Verificar solapamientos.
3. Revisar logs de transacción.
4. Revisar versión desplegada.

Acciones:

- Cancelar reserva incorrecta administrativamente.
- Notificar usuarios afectados.
- Abrir incidencia crítica.
- Revisar controles transaccionales.

## Incidencia: no llegan notificaciones

Comprobaciones:

1. Revisar notification_outbox.
2. Revisar logs del worker.
3. Verificar SMTP o API de notificación.
4. Revisar credenciales.

Acciones:

- Reintentar notificaciones pendientes.
- Restaurar credenciales si procede.
- Confirmar que la reserva no depende del envío.
```

---

# 99-anexos/00-preguntas-abiertas.md

```md
# Preguntas abiertas

PA-001. ¿Debe permitirse reserva recurrente?

Estado: Pendiente.

PA-002. ¿Debe integrarse con calendario corporativo?

Estado: Fuera de alcance inicial.

PA-003. ¿Debe registrarse check-in de asistencia real?

Estado: Pendiente.

PA-004. ¿Debe penalizarse a usuarios que no acuden?

Estado: Pendiente.

PA-005. ¿Debe existir plano visual de sala o basta listado?

Estado: Pendiente de UX.

PA-006. ¿Debe permitirse reservar por media jornada o jornada completa mediante accesos rápidos?

Estado: Recomendado para mejora.

PA-007. ¿Debe existir límite de reservas futuras por usuario?

Estado: Pendiente de política interna.

PA-008. ¿Debe contemplarse equipamiento especial, por ejemplo Mac, Linux, doble monitor o accesibilidad?

Estado: Parcialmente contemplado mediante atributos de puesto.

PA-009. ¿Debe existir aprobación administrativa para determinados puestos?

Estado: Fuera de alcance inicial.
```

---

# 99-anexos/01-checklist-entrega.md

```md
# Checklist de entrega SDD

## Negocio

- [x] Visión definida.
- [x] Contexto definido.
- [x] Objetivos definidos.
- [x] Stakeholders identificados.
- [x] Glosario completado.
- [x] Supuestos y restricciones definidos.

## Requisitos

- [x] Alcance definido.
- [x] Actores definidos.
- [x] Historias de usuario definidas.
- [x] Casos de uso definidos.
- [x] Requisitos funcionales definidos.
- [x] Requisitos no funcionales definidos.
- [x] Reglas de negocio definidas.
- [x] Matriz de trazabilidad definida.

## Modelo

- [x] Modelo de dominio definido.
- [x] Estados de reserva definidos.
- [x] Diagramas textuales incluidos.
- [x] Eventos de dominio definidos.

## Interfaz

- [x] Mapa de navegación definido.
- [x] Pantallas definidas.
- [x] Flujos UI definidos.
- [x] Textos y validaciones definidos.

## Arquitectura

- [x] Visión de arquitectura definida.
- [x] Componentes definidos.
- [x] Flujos técnicos definidos.
- [x] ADRs definidos.
- [x] Integraciones definidas.

## API

- [x] Principios API definidos.
- [x] Endpoints definidos.
- [x] Contratos JSON definidos.
- [x] Errores API definidos.

## Datos

- [x] Modelo relacional definido.
- [x] DDL inicial definido.
- [x] Datos semilla definidos.
- [x] Política de retención definida.

## Seguridad

- [x] Autenticación definida.
- [x] Autorización definida.
- [x] Matriz de permisos definida.
- [x] Amenazas y controles definidos.
- [x] Auditoría definida.

## Pruebas

- [x] Estrategia de pruebas definida.
- [x] Casos funcionales definidos.
- [x] Casos API definidos.
- [x] Casos de seguridad definidos.
- [x] Datos de prueba definidos.

## Operación

- [x] Despliegue definido.
- [x] Configuración definida.
- [x] Observabilidad definida.
- [x] Runbook definido.
```

---

## Resumen final de ficheros

```text
sdd-reserva-puestos/
├── 00-meta/
│   ├── 00-portada.md
│   ├── 01-control-versiones.md
│   ├── 02-indice.md
│   └── 03-convenciones.md
├── 01-negocio/
│   ├── 00-vision.md
│   ├── 01-contexto.md
│   ├── 02-objetivos.md
│   ├── 03-stakeholders.md
│   ├── 04-glosario.md
│   └── 05-supuestos-restricciones.md
├── 02-requisitos/
│   ├── 00-alcance.md
│   ├── 01-actores.md
│   ├── 02-historias-usuario.md
│   ├── 03-casos-uso.md
│   ├── 04-requisitos-funcionales.md
│   ├── 05-requisitos-no-funcionales.md
│   ├── 06-reglas-negocio.md
│   └── 07-matriz-trazabilidad.md
├── 03-modelo/
│   ├── 00-modelo-dominio.md
│   ├── 01-estados-reserva.md
│   ├── 02-diagramas-textuales.md
│   └── 03-eventos-dominio.md
├── 04-interfaz/
│   ├── 00-mapa-navegacion.md
│   ├── 01-pantallas.md
│   ├── 02-flujos-ui.md
│   └── 03-textos-validaciones.md
├── 05-arquitectura/
│   ├── 00-vision-arquitectura.md
│   ├── 01-componentes.md
│   ├── 02-flujos-sistema.md
│   ├── 03-decisiones-adr.md
│   └── 04-integraciones.md
├── 06-api/
│   ├── 00-principios-api.md
│   ├── 01-endpoints.md
│   ├── 02-contratos-json.md
│   └── 03-errores-api.md
├── 07-datos/
│   ├── 00-modelo-relacional.md
│   ├── 01-ddl.sql
│   ├── 02-datos-semilla.sql
│   └── 03-politicas-retencion.md
├── 08-seguridad/
│   ├── 00-autenticacion-autorizacion.md
│   ├── 01-permisos.md
│   ├── 02-amenazas-controles.md
│   └── 03-auditoria.md
├── 09-pruebas/
│   ├── 00-estrategia-pruebas.md
│   ├── 01-casos-prueba-funcionales.md
│   ├── 02-casos-prueba-api.md
│   ├── 03-casos-prueba-seguridad.md
│   └── 04-datos-prueba.md
├── 10-operacion/
│   ├── 00-despliegue.md
│   ├── 01-configuracion.md
│   ├── 02-observabilidad.md
│   └── 03-runbook.md
└── 99-anexos/
    ├── 00-preguntas-abiertas.md
    └── 01-checklist-entrega.md
```
