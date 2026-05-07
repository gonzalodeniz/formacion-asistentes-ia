Construir un proyecto completo de Spec Driven Development (SDD) implica crear una cadena de trazabilidad perfecta. Para que el tamaño sea manejable y útil, voy a desarrollar el **"Vertical Core" (el núcleo central)** del sistema: **El motor de reservas**.

A continuación, te presento la estructura de carpetas y el contenido de los ficheros que conforman este ecosistema, desde la visión inicial hasta el contrato técnico de la API, demostrando cómo una necesidad de negocio baja hasta el código.

### Estructura del Repositorio SDD

```text
reserva-puestos-sdd/
├── docs/
│   ├── 00-SPEC-0-vision-y-alcance.md     (Alineación y negocio)
│   ├── 01-GLOSARIO.md                    (Lenguaje ubicuo)
│   ├── dominio/
│   │   └── DN-001-reglas-reserva.md      (Invariantes del sistema)
│   ├── funcional/
│   │   └── FUNC-001-crear-reserva.md     (Comportamiento e interfaz)
│   ├── tecnica/
│   │   └── TECH-001-api-reservas.md      (Contratos de software)
│   └── seguridad/
│       └── SEC-001-autenticacion.md      (Políticas de acceso)
```

---

### 1. El origen: Visión y Alcance
**(Archivo ya validado en nuestra conversación anterior, lo incluyo referenciado para mantener la cadena)**

**Fichero:** `docs/00-SPEC-0-vision-y-alcance.md`
*(Contiene el documento SPEC-0 en su versión 0.2 que consolidamos previamente, definiendo el MVP, los actores y el alcance).*

---

### 2. El Lenguaje Ubicuo
En SDD, el glosario se extrae a su propio fichero para que sea la única fuente de verdad terminológica.

**Fichero:** `docs/01-GLOSARIO.md`
```markdown
# Glosario del Dominio (Lenguaje Ubicuo)

| Término | Definición |
|---|---|
| Oficina | Ubicación o sede física de la empresa que contiene una o varias salas. |
| Sala | Espacio físico delimitado dentro de una oficina que contiene puestos de ordenador. |
| Puesto | Ordenador o estación de trabajo individual que puede ser reservado o asignado. |
| Reserva | Asignación temporal de un puesto a un empleado para uno o varios días completos. |
| Puesto Fijo | Estado de un puesto que ha sido asignado permanentemente a un único usuario corporativo. Se considera ocupado y no admite reservas de terceros. |
| Bloqueo | Estado temporal o indefinido de un puesto por avería, mantenimiento u otras causas. Impide su reserva. Incluye una nota informativa del administrador. |
| Disponible | Estado de un puesto que no es fijo, no está bloqueado y no tiene reservas para la fecha consultada. |
| Reservado | Estado de un puesto que ya tiene una reserva activa para la fecha consultada. |
| Solapamiento | Conflicto lógico donde se intenta crear una reserva sobre un puesto en un día que ya se encuentra reservado, fijo o bloqueado. |
```

---

### 3. Las Reglas de Dominio (Invariantes)
Aquí definimos las matemáticas del negocio que el backend deberá respetar a nivel transaccional.

**Fichero:** `docs/dominio/DN-001-reglas-reserva.md`
```markdown
# DN-001 — Reglas e Invariantes de Reserva

## Metadatos
* **Épica origen:** [SPEC-0](../00-SPEC-0-vision-y-alcance.md)
* **Estado:** Aprobado

## 1. Contexto
Este documento especifica las leyes inquebrantables que gobiernan la creación, estado y cancelación de las reservas de puestos.

## 2. Invariantes del Sistema

* **INV-RES-01 (Unidad de tiempo):** El sistema transaccional solo admite fechas completas (YYYY-MM-DD). La hora se ignorará en el cálculo de disponibilidad.
* **INV-RES-02 (Prevención de Solapamiento Físico):** La consulta `COUNT(reservas) WHERE puesto_id = X AND fecha = Y` debe ser estrictamente `0` antes de confirmar una nueva reserva.
* **INV-RES-03 (Prevención de Solapamiento Lógico):** Si un `puesto_id` tiene estado `FIJO` o `BLOQUEADO`, su disponibilidad calculada para cualquier fecha es siempre `FALSE`.
* **INV-RES-04 (Límite de Usuario):** Un `usuario_id` no puede tener más de un registro de reserva activo para la misma `fecha`.
* **INV-RES-05 (Inmutabilidad del Pasado):** Ninguna transacción puede crear, modificar o cancelar una reserva donde la `fecha` sea inferior a la fecha actual del sistema (UTC).

## 3. Resolución de Cancelaciones
* **CANC-01:** La cancelación es un "soft-delete". El registro original cambia su estado a `CANCELADA` para mantener el histórico, liberando inmediatamente el `puesto_id` para nuevas consultas de disponibilidad.
```

---

### 4. La Especificación Funcional (Comportamiento y QA)
Este documento es la guía para el desarrollador Frontend y para el equipo de Calidad (QA).

**Fichero:** `docs/funcional/FUNC-001-crear-reserva.md`
```markdown
# FUNC-001 — Flujo de Creación de Reserva

## Metadatos
* **Épica origen:** [SPEC-0](../00-SPEC-0-vision-y-alcance.md)
* **Reglas asociadas:** [DN-001](../dominio/DN-001-reglas-reserva.md)
* **Estado:** Aprobado

## 1. Precondiciones
* El usuario ha iniciado sesión correctamente.
* El usuario se encuentra en la vista de "Detalle de Puesto" (que muestra un Puesto en estado `Disponible`).

## 2. Flujo Principal (Happy Path)
1. El usuario selecciona uno o varios días en el calendario del puesto.
2. El usuario hace clic en el botón "Confirmar Reserva".
3. El sistema valida la disponibilidad en tiempo real contra el backend.
4. El sistema registra la reserva.
5. La interfaz muestra un modal de éxito: "Reserva confirmada correctamente".
6. El usuario es redirigido a la vista "Mis Reservas".

## 3. Criterios de Aceptación (Especificación Ejecutable)

```gherkin
Feature: Reserva de puesto de trabajo por días

  Scenario: Un usuario reserva un puesto disponible con éxito
    Given que el puesto "P-01" en la sala "S-01" está "Disponible" para el día "2026-06-10"
    And el usuario no tiene otras reservas para ese día
    When el usuario solicita reservar el puesto "P-01" para el día "2026-06-10"
    Then el sistema confirma la reserva
    And el estado del puesto para ese día cambia a "Reservado"

  Scenario: Un usuario intenta reservar cuando ya tiene otro puesto ese mismo día
    Given que el usuario ya tiene una reserva confirmada para el día "2026-06-10"
    When el usuario intenta reservar un segundo puesto para el día "2026-06-10"
    Then el sistema deniega la acción
    And muestra el error "Ya tienes una reserva activa para esta fecha."

  Scenario: El puesto cambia a bloqueado justo antes de la reserva (Condición de carrera)
    Given que el puesto "P-01" aparece como "Disponible" en la pantalla del usuario
    But un administrador cambia el estado del puesto "P-01" a "Bloqueado"
    When el usuario solicita reservar el puesto "P-01"
    Then el sistema deniega la acción
    And muestra el error "Este puesto acaba de ser bloqueado o reservado por otro usuario."
```
```

---

### 5. El Contrato Técnico (API)
Aquí cerramos el cerco. El backend debe programarse estrictamente para cumplir este contrato.

**Fichero:** `docs/tecnica/TECH-001-api-reservas.md`
```markdown
# TECH-001 — Contrato de API: Creación de Reserva

## Metadatos
* **Funcionalidad:** [FUNC-001](../funcional/FUNC-001-crear-reserva.md)
* **Estado:** Aprobado

## 1. Especificación del Endpoint

* **URL:** `/api/v1/reservations`
* **Método:** `POST`
* **Autenticación:** Requiere cabecera `Authorization: Bearer <JWT>`

## 2. Esquema de Petición (Request)

```json
{
  "seat_id": "uuid",          // Requerido. ID único del puesto.
  "reservation_dates": [      // Requerido. Array de fechas. Min: 1, Max: 14.
    "YYYY-MM-DD"
  ]
}
```

## 3. Esquemas de Respuesta (Response)

**Éxito (HTTP 201 Created)**
```json
{
  "status": "success",
  "data": {
    "reservation_group_id": "uuid",
    "confirmed_dates": ["2026-06-10", "2026-06-11"]
  }
}
```

**Error de Regla de Negocio (HTTP 409 Conflict)**
Se lanza si se rompe la invariante `INV-RES-02`, `INV-RES-03` o `INV-RES-04`.
```json
{
  "status": "error",
  "error_code": "DATE_CONFLICT",
  "message": "La fecha 2026-06-10 ya está ocupada o tienes otra reserva activa."
}
```

**Error de Validación (HTTP 400 Bad Request)**
Se lanza si se intenta reservar en el pasado (`INV-RES-05`).
```json
{
  "status": "error",
  "error_code": "INVALID_DATE",
  "message": "No se pueden crear reservas en fechas pasadas."
}
```
```

---

### 6. Políticas de Seguridad (Restricción del MVP)
Especificación técnica para cumplir con el alcance del MVP (autenticación local).

**Fichero:** `docs/seguridad/SEC-001-autenticacion.md`
```markdown
# SEC-001 — Política de Autenticación Local (MVP)

## Metadatos
* **Épica origen:** [SPEC-0](../00-SPEC-0-vision-y-alcance.md) (Restricción RT-2)
* **Estado:** Aprobado

## 1. Contrato de Seguridad Local

Al no existir integración con LDAP en la Release 1, el sistema propio debe garantizar los siguientes estándares:

* **Almacenamiento:** Ninguna contraseña se almacenará en texto plano en la base de datos. Se utilizará el algoritmo **Bcrypt** con un *work factor* (cost) mínimo de `12`.
* **Política de Contraseñas:** * Longitud mínima: 12 caracteres.
  * Obligatorio: Al menos un número y un carácter especial.
* **Gestión de Sesión:** El inicio de sesión exitoso devolverá un JSON Web Token (JWT) firmado con algoritmo `HS256`. 
* **Caducidad:** El token JWT tendrá un `exp` (expiration time) de exactamente 12 horas desde su emisión, forzando un re-login diario.
```

---

Este es un ecosistema SDD completo y coherente. Fíjate en cómo la trazabilidad fluye de forma natural: el error `DATE_CONFLICT` del `TECH-001` existe *únicamente* porque el Gherkin del `FUNC-001` lo exige, el cual existe porque la regla `INV-RES-04` del `DN-001` lo definió, que a su vez nace de la Regla de Negocio 2 (RN-2) de nuestra Visión Global (`SPEC-0`).