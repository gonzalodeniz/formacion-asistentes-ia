# TECH-002: Modelo de datos

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | TECH-002 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo desarrollo — 2025-05-07 |

## Contexto

Define el modelo de datos relacional que soporta todas
las especificaciones funcionales y de dominio del
sistema. El modelo se implementa en PostgreSQL 16 y se
gestiona con Prisma Migrate.

## Diagrama de entidades

```text
┌──────────────┐     ┌──────────────┐
│   oficina    │     │  empleado    │
│──────────────│     │──────────────│
│ id (PK)      │     │ id (PK)      │
│ codigo       │     │ azure_ad_id  │
│ nombre       │     │ email        │
│ direccion    │     │ nombre       │
│ activa       │     │ equipo       │
│ dias_apertura│     │ oficina_hab  │
│ created_at   │     │ rol          │
│ updated_at   │     │ activo       │
└──────┬───────┘     │ created_at   │
       │             └──────┬───────┘
       │ 1:N                │
       ▼                    │
┌──────────────┐            │
│    sala      │            │
│──────────────│            │
│ id (PK)      │            │
│ oficina_id(FK│            │
│ codigo       │            │
│ nombre       │            │
│ plano_svg    │            │
│ activa       │            │
│ created_at   │            │
│ updated_at   │            │
└──────┬───────┘            │
       │ 1:N                │
       ▼                    │
┌──────────────┐            │
│   puesto     │            │
│──────────────│            │
│ id (PK)      │            │
│ sala_id (FK) │            │
│ codigo       │            │
│ pos_x        │            │
│ pos_y        │            │
│ equipamiento │            │
│ estado       │            │
│ motivo_bloq  │            │
│ fecha_desbloq│            │
│ activo       │            │
│ created_at   │            │
│ updated_at   │            │
└──────┬───────┘            │
       │                    │
       │ 1:N          1:N   │
       ▼                    │
┌──────────────────────┐    │
│      reserva         │◄───┘
│──────────────────────│
│ id (PK)              │
│ codigo               │
│ puesto_id (FK)       │
│ empleado_id (FK)     │
│ fecha                │
│ franja               │
│ estado               │
│ checkin_at           │
│ cancelado_por        │
│ motivo_cancelacion   │
│ created_at           │
│ updated_at           │
└──────────────────────┘
       │
       │ 1:N
       ▼
┌──────────────────────┐
│  reserva_historial   │
│──────────────────────│
│ id (PK)              │
│ reserva_id (FK)      │
│ estado_anterior      │
│ estado_nuevo         │
│ actor                │
│ comentario           │
│ created_at           │
└──────────────────────┘
```

## Detalle de tablas

### oficina

| Columna | Tipo | Restricciones | Descripción |
| --- | --- | --- | --- |
| id | UUID | PK, default gen | Identificador único. |
| codigo | VARCHAR(10) | UNIQUE, NOT NULL | Código corto (MAD-C, MAD-N, BCN). |
| nombre | VARCHAR(100) | NOT NULL | Nombre visible ("Madrid Centro"). |
| direccion | TEXT | NOT NULL | Dirección postal completa. |
| activa | BOOLEAN | NOT NULL, default true | Si se puede usar. |
| dias_apertura | VARCHAR(7) | NOT NULL, default 'LMMJV--' | Máscara de días (L=lunes abierto, -=cerrado). |
| created_at | TIMESTAMPTZ | NOT NULL, default now | Fecha de creación. |
| updated_at | TIMESTAMPTZ | NOT NULL | Última modificación. |

### sala

| Columna | Tipo | Restricciones | Descripción |
| --- | --- | --- | --- |
| id | UUID | PK | Identificador único. |
| oficina_id | UUID | FK oficina, NOT NULL | Oficina a la que pertenece. |
| codigo | VARCHAR(20) | UNIQUE, NOT NULL | Código (MAD-C-TUR). |
| nombre | VARCHAR(100) | NOT NULL | Nombre visible ("Sala Turing"). |
| plano_svg | TEXT | NULL | SVG del plano de la sala. |
| activa | BOOLEAN | NOT NULL, default true | Si se puede usar. |
| created_at | TIMESTAMPTZ | NOT NULL | Fecha de creación. |
| updated_at | TIMESTAMPTZ | NOT NULL | Última modificación. |

### puesto

| Columna | Tipo | Restricciones | Descripción |
| --- | --- | --- | --- |
| id | UUID | PK | Identificador único. |
| sala_id | UUID | FK sala, NOT NULL | Sala a la que pertenece. |
| codigo | VARCHAR(20) | UNIQUE, NOT NULL | Código (MAD-C-TUR-05). |
| pos_x | INTEGER | NOT NULL | Posición X en el mapa SVG. |
| pos_y | INTEGER | NOT NULL | Posición Y en el mapa SVG. |
| equipamiento | JSONB | NOT NULL, default '{}' | Tipo de monitor, dock, periféricos. Ejemplo: `{"monitor": "ultrawide", "dock": true}`. |
| estado | VARCHAR(20) | NOT NULL, default 'activo' | activo o bloqueado. |
| motivo_bloq | TEXT | NULL | Motivo del bloqueo (si aplica). |
| fecha_desbloq | DATE | NULL | Fecha estimada de desbloqueo. |
| activo | BOOLEAN | NOT NULL, default true | Si el puesto existe (soft delete). |
| created_at | TIMESTAMPTZ | NOT NULL | Fecha de creación. |
| updated_at | TIMESTAMPTZ | NOT NULL | Última modificación. |

### empleado

| Columna | Tipo | Restricciones | Descripción |
| --- | --- | --- | --- |
| id | UUID | PK | Identificador interno. |
| azure_ad_id | VARCHAR(50) | UNIQUE, NOT NULL | ID del usuario en Azure AD. |
| email | VARCHAR(200) | UNIQUE, NOT NULL | Email corporativo. |
| nombre | VARCHAR(200) | NOT NULL | Nombre completo. |
| equipo | VARCHAR(100) | NULL | Equipo/departamento (de Azure AD). |
| oficina_hab | UUID | FK oficina, NULL | Oficina habitual del empleado. |
| rol | VARCHAR(20) | NOT NULL, default 'empleado' | empleado o admin_facilities. |
| activo | BOOLEAN | NOT NULL, default true | Si el empleado está activo. |
| created_at | TIMESTAMPTZ | NOT NULL | Primera autenticación. |

Nota: el registro de empleado se crea o actualiza
automáticamente en el primer login (upsert por
azure_ad_id). No se crean manualmente.

### reserva

| Columna | Tipo | Restricciones | Descripción |
| --- | --- | --- | --- |
| id | UUID | PK | Identificador único. |
| codigo | VARCHAR(20) | UNIQUE, NOT NULL | Código legible (RES-20250512-0001). |
| puesto_id | UUID | FK puesto, NOT NULL | Puesto reservado. |
| empleado_id | UUID | FK empleado, NOT NULL | Empleado que reserva. |
| fecha | DATE | NOT NULL | Fecha de la reserva. |
| franja | VARCHAR(2) | NOT NULL, CHECK (AM, PM, FD) | Franja horaria. |
| estado | VARCHAR(20) | NOT NULL | confirmada, checked_in, completada, cancelada, liberada_auto, cancelada_admin. |
| checkin_at | TIMESTAMPTZ | NULL | Momento del check-in. |
| cancelado_por | VARCHAR(20) | NULL | empleado, sistema, admin. |
| motivo_cancelacion | TEXT | NULL | Motivo (si cancelada por admin). |
| created_at | TIMESTAMPTZ | NOT NULL | Momento de creación. |
| updated_at | TIMESTAMPTZ | NOT NULL | Última modificación. |

Restricciones especiales:

```text
UNIQUE (puesto_id, fecha, franja)
  WHERE estado IN ('confirmada', 'checked_in')

  Garantiza que un puesto solo tiene una reserva
  activa por fecha y franja. Es la base del control
  de concurrencia (ver TECH-001, sección 3.2).

  Nota sobre franja FD: al reservar día completo,
  se crean internamente 2 filas (AM + PM) dentro de
  una transacción. Esto simplifica la constraint
  UNIQUE y evita lógica especial para comprobar
  solapamientos FD vs AM/PM.
```

### reserva_historial

| Columna | Tipo | Restricciones | Descripción |
| --- | --- | --- | --- |
| id | UUID | PK | Identificador. |
| reserva_id | UUID | FK reserva, NOT NULL | Reserva afectada. |
| estado_anterior | VARCHAR(20) | NOT NULL | Estado antes de la transición. |
| estado_nuevo | VARCHAR(20) | NOT NULL | Estado después. |
| actor | VARCHAR(200) | NOT NULL | Quién hizo el cambio (email o "sistema"). |
| comentario | TEXT | NULL | Motivo del cambio (si aplica). |
| created_at | TIMESTAMPTZ | NOT NULL | Momento de la transición. |

Esta tabla implementa el INV-6 de DN-003: toda
transición queda registrada con timestamp y actor.

## Índices recomendados

```text
idx_reserva_puesto_fecha:
  reserva(puesto_id, fecha)
  WHERE estado IN ('confirmada', 'checked_in')
  → Consultas de disponibilidad (FUNC-001).

idx_reserva_empleado_fecha:
  reserva(empleado_id, fecha)
  WHERE estado IN ('confirmada', 'checked_in')
  → Verificación de solapamiento (DN-002, RN-1).

idx_reserva_liberacion:
  reserva(fecha, franja, estado)
  WHERE estado = 'confirmada'
  → Job de liberación automática (FUNC-004).

idx_puesto_sala:
  puesto(sala_id)
  WHERE activo = true
  → Carga del mapa de sala.
```

## Política de retención (RGPD)

```text
Reservas con antigüedad > 12 meses:
  - empleado_id se reemplaza por
    SHA-256(empleado_id + salt) (irreversible).
  - El nombre del empleado se elimina del
    historial.
  - Los datos agregados (ocupación por sala y
    fecha) se conservan para estadísticas.

Job de anonimización: se ejecuta mensualmente
(primer domingo del mes, 03:00).
```

## Dependencias

- TECH-001: arquitectura y stack (Prisma, PostgreSQL).
- DN-001: franjas horarias (columna franja).
- DN-003: transiciones de estado (tabla historial).
- FUNC-001 a FUNC-005: todas las funcionalidades
  operan sobre este modelo.
- SEC-001: el campo rol determina los permisos.

## Historial de cambios

| Versión | Fecha | Autor | Cambio |
| --- | --- | --- | --- |
| 1.0 | 2025-05-07 | Equipo dev | Creación inicial |
