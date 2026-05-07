# TECH-001: Arquitectura y stack tecnológico

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | TECH-001 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Pablo Durán (CTO) — 2025-05-05 |
| Revisado por | Equipo de desarrollo — 2025-05-07 |
| Prioridad | Crítica |

## Contexto y motivación

Este documento define la arquitectura del sistema de
reserva de puestos, las tecnologías seleccionadas y las
razones detrás de cada decisión. Es la referencia para
todo el equipo de desarrollo durante la implementación
y para cualquier decisión técnica futura.

Las decisiones están condicionadas por las restricciones
del SPEC-0 (sección 6): Azure como cloud, equipo
reducido, sin presupuesto para herramientas de pago
adicionales y volumetría moderada (120 usuarios, 180
puestos, 200-400 reservas/día).

## 1. Visión general de la arquitectura

El sistema sigue una arquitectura de **aplicación web
monolítica modular** con separación clara entre frontend
y backend comunicados por API REST. Se descarta una
arquitectura de microservicios por el tamaño reducido
del equipo y la baja complejidad del dominio.

```text
┌─────────────────────────────────────────────┐
│              CLIENTE (Navegador)             │
│                                             │
│  ┌───────────────────────────────────────┐  │
│  │         Frontend (React SPA)          │  │
│  │  - Mapa de salas (SVG interactivo)    │  │
│  │  - Gestión de reservas                │  │
│  │  - Panel Facilities                   │  │
│  │  - Responsive (desktop + móvil)       │  │
│  └──────────────────┬────────────────────┘  │
└─────────────────────┼───────────────────────┘
                      │ HTTPS (API REST JSON)
                      ▼
┌─────────────────────────────────────────────┐
│            BACKEND (Node.js)                │
│                                             │
│  ┌────────────┐ ┌────────────┐ ┌────────┐  │
│  │ API Layer  │ │  Servicios │ │ Jobs   │  │
│  │ (Express)  │ │  de        │ │ (cron) │  │
│  │            │ │  dominio   │ │        │  │
│  │ - Auth     │ │            │ │ - Lib. │  │
│  │   middleware│ │ - Reserva  │ │   auto │  │
│  │ - Routing  │ │ - Check-in │ │ - Comp.│  │
│  │ - Validac. │ │ - Puesto   │ │   resv │  │
│  │ - Errors   │ │ - Sala     │ │        │  │
│  └──────┬─────┘ │ - Oficina  │ └───┬────┘  │
│         │       │ - Ocupación│     │        │
│         │       └──────┬─────┘     │        │
│         │              │           │        │
│  ┌──────┴──────────────┴───────────┴─────┐  │
│  │        Capa de persistencia           │  │
│  │        (Prisma ORM)                   │  │
│  └──────────────────┬────────────────────┘  │
└─────────────────────┼───────────────────────┘
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
┌──────────────────┐   ┌──────────────────┐
│   PostgreSQL     │   │   Azure AD       │
│   (Azure DB)     │   │   (OAuth 2.0 /   │
│                  │   │    OIDC)          │
│  - Oficinas      │   │                  │
│  - Salas         │   │  - Autenticación │
│  - Puestos       │   │  - Grupos/roles  │
│  - Reservas      │   │  - Datos empl.   │
│  - Auditoría     │   │                  │
└──────────────────┘   └──────────────────┘
```

## 2. Stack tecnológico

### 2.1. Frontend

| Componente | Tecnología | Versión | Justificación |
| --- | --- | --- | --- |
| Framework | React | 18.x | Dominado por el equipo, gran ecosistema. |
| Build tool | Vite | 5.x | Rápido en desarrollo, builds optimizados. |
| Lenguaje | TypeScript | 5.x | Tipado estático, reduce errores. |
| Estilos | Tailwind CSS | 3.x | Productividad, consistencia, responsive nativo. |
| Mapa de salas | SVG + React | — | SVG permite renderizar planos con interactividad sin librerías pesadas. |
| Estado | Zustand | 4.x | Ligero, simple, suficiente para la complejidad del proyecto. |
| HTTP client | Axios | 1.x | Interceptors para token refresh, manejo de errores. |
| Auth | MSAL.js (Microsoft) | 3.x | SDK oficial de Azure AD para SPA. |
| Routing | React Router | 6.x | Estándar para SPA con React. |
| Testing | Vitest + Testing Library | — | Unitarios y de componente. |

### 2.2. Backend

| Componente | Tecnología | Versión | Justificación |
| --- | --- | --- | --- |
| Runtime | Node.js | 20 LTS | Dominado por el equipo, rendimiento adecuado. |
| Framework | Express | 4.x | Maduro, flexible, ligero. |
| Lenguaje | TypeScript | 5.x | Coherencia con frontend, tipado. |
| ORM | Prisma | 5.x | Type-safe, migraciones, buena DX. |
| Validación | Zod | 3.x | Validación de esquemas con inferencia de tipos. |
| Auth | passport-azure-ad | 4.x | Middleware de validación de tokens JWT de Azure AD. |
| Jobs | node-cron | 3.x | Programación del job de liberación automática. Suficiente para la escala. |
| Email | Nodemailer + SendGrid | — | Envío de emails transaccionales. |
| Logging | Pino | 8.x | Estructurado, JSON, rápido. |
| Testing | Vitest + Supertest | — | Tests unitarios y de integración de API. |

### 2.3. Base de datos

| Componente | Tecnología | Justificación |
| --- | --- | --- |
| Motor | PostgreSQL 16 | Robusto, soporte de JSON, extensiones GIS si se necesitan planos en el futuro. |
| Hosting | Azure Database for PostgreSQL Flexible Server | Managed service en Azure, backup automático, escalado. |
| Migraciones | Prisma Migrate | Integrado con el ORM, versionado de esquema. |

### 2.4. Infraestructura y despliegue

| Componente | Tecnología | Justificación |
| --- | --- | --- |
| Hosting backend | Azure App Service (Linux) | PaaS, despliegue simple, escalado automático, sin gestión de contenedores para el MVP. |
| Hosting frontend | Azure Static Web Apps | Optimizado para SPA, CDN integrada, certificado TLS automático. |
| CI/CD | GitHub Actions | Repositorio en GitHub, integración nativa. |
| Monitorización | Azure Application Insights | Integrado con Azure, métricas, logs, alertas. |
| Secretos | Azure Key Vault | Credenciales de BD, API keys, certificados. |

Decisión descartada: se evaluó Azure Container Apps
(contenedores) pero se descartó por complejidad
innecesaria para el equipo y la escala del MVP. Se
reconsiderará si el sistema crece significativamente.

## 3. Patrones de diseño

### 3.1. Arquitectura del backend por capas

```text
Request HTTP
    │
    ▼
┌──────────────────────────────────────────┐
│ Middleware: auth, logging, error handler │
└──────────────────┬───────────────────────┘
                   ▼
┌──────────────────────────────────────────┐
│ Controller: validación de request con    │
│ Zod, invocación del servicio, respuesta  │
│ HTTP. NO contiene lógica de negocio.     │
└──────────────────┬───────────────────────┘
                   ▼
┌──────────────────────────────────────────┐
│ Service: lógica de negocio, reglas de    │
│ dominio, orquestación. Referencia las    │
│ specs DN-NNN en comentarios.             │
└──────────────────┬───────────────────────┘
                   ▼
┌──────────────────────────────────────────┐
│ Repository: acceso a datos via Prisma.   │
│ Queries, transacciones, filtros.         │
└──────────────────┬───────────────────────┘
                   ▼
              PostgreSQL
```

Regla: cada capa solo conoce a la capa
inmediatamente inferior. Un controller nunca accede
directamente a Prisma. Un service nunca genera una
respuesta HTTP.

### 3.2. Gestión de concurrencia en reservas

La reserva de puestos es la operación más sensible a
concurrencia (dos empleados reservando el mismo puesto
al mismo tiempo). Se usa **bloqueo optimista** con
una restricción UNIQUE en la base de datos:

```text
UNIQUE CONSTRAINT: (puesto_id, fecha, franja)
  donde estado IN ('confirmada', 'checked_in')

Flujo:
  1. El service verifica disponibilidad (SELECT).
  2. El service intenta INSERT de la reserva.
  3. Si el INSERT viola la constraint UNIQUE,
     PostgreSQL rechaza la operación.
  4. El service captura el error y devuelve
     409 PUESTO_NO_DISPONIBLE al controller.

Esta estrategia es más robusta que un SELECT FOR
UPDATE porque no depende de la duración de la
transacción y funciona correctamente con múltiples
instancias del backend.
```

### 3.3. Job de liberación automática

El job de liberación automática (FUNC-004) se
implementa como un cron dentro del proceso Node.js
que se ejecuta cada 5 minutos:

```text
Cada 5 minutos:
  1. SELECT reservas WHERE estado = 'confirmada'
     AND fecha = hoy
     AND hora_inicio_franja + 30min < ahora
  2. Para cada reserva encontrada:
     a. UPDATE estado = 'liberada_auto'
     b. Enviar notificación al empleado
  3. Registrar en log: N reservas liberadas
```

Decisión: se descartó un sistema de colas (Azure
Service Bus) por sobrecarga de infraestructura para
el MVP. El cron es suficiente para la escala actual.
Si el sistema escala a múltiples instancias del
backend, se migrará a Azure Functions con timer
trigger para evitar ejecuciones duplicadas.

### 3.4. Mapa de sala (frontend)

Los mapas de sala se representan como **SVG
parametrizado**. Cada sala tiene un fichero SVG base
(plano de la sala) y los puestos se superponen como
elementos interactivos:

```text
Flujo de renderizado:
  1. Frontend solicita GET /api/v1/salas/{id}/mapa
  2. Backend devuelve: SVG base + lista de puestos
     con coordenadas (x, y), equipamiento y estado.
  3. Frontend renderiza el SVG y superpone los
     puestos como círculos o rectángulos
     coloreados según estado.
  4. Click/tap en un puesto libre abre el panel
     de reserva.
```

Los SVG base se crean manualmente por Facilities
con una herramienta de dibujo (draw.io, Figma) y
se almacenan en la base de datos como texto.

## 4. Seguridad

### 4.1. Flujo de autenticación

```text
┌──────────┐     ┌───────────┐     ┌──────────┐
│ Frontend │────►│ Azure AD  │────►│ Frontend │
│ (MSAL.js)│     │ (login)   │     │ (token)  │
└──────────┘     └───────────┘     └────┬─────┘
                                        │
                 Token JWT en header     │
                 Authorization: Bearer   │
                                        ▼
                                  ┌──────────┐
                                  │ Backend  │
                                  │ (valida  │
                                  │  token)  │
                                  └──────────┘
```

El backend valida el token JWT en cada request
usando la clave pública de Azure AD (JWKS endpoint).
No almacena sesiones. Cada request es stateless.

### 4.2. Autorización

Los roles se determinan a partir de los grupos de
Azure AD presentes en el token:

```text
Grupo AD "rp-empleados"   → rol: empleado
Grupo AD "rp-facilities"  → rol: admin_facilities

El middleware de autorización verifica el rol en
cada endpoint:
  /api/v1/reservas/*       → empleado o admin
  /api/v1/admin/*          → solo admin_facilities
  /api/v1/salas/*/mapa     → empleado o admin
  /api/v1/ocupacion/*      → solo admin_facilities
```

### 4.3. Protección de datos (RGPD)

- Los datos de reserva se conservan 12 meses con
  el ID del empleado para estadísticas.
- Pasados 12 meses, se anonimizan: se reemplaza
  el empleado_id por un hash irreversible.
- Un empleado que deja la empresa: sus reservas
  futuras se cancelan automáticamente (evento de
  Azure AD). Las históricas se anonimizan.
- No se almacenan datos sensibles más allá de
  nombre, email y equipo (obtenidos del token,
  no persistidos salvo el ID).

## 5. Comunicaciones y notificaciones

| Evento | Canal | Contenido |
| --- | --- | --- |
| Reserva creada | Email | Puesto, sala, fecha, franja, código. |
| Reserva cancelada | Email | Confirmación de cancelación. |
| Liberación automática | Email | Aviso de no-show, puesto liberado. |
| Reserva cancelada por admin | Email | Motivo (bloqueo), sugerencia de buscar otro puesto. |
| Recordatorio de check-in (R2) | Push | 15 min antes del inicio de franja. |

El envío de emails se realiza de forma asíncrona:
el service encola el email en una tabla de la base
de datos y un job secundario (cada 1 minuto) los
envía vía SendGrid. Si el envío falla, se reintenta
hasta 3 veces.

## 6. Entornos

| Entorno | Uso | URL |
| --- | --- | --- |
| local | Desarrollo | localhost:3000 (front), localhost:4000 (back) |
| staging | QA y demos | staging-reservas.technova.com |
| producción | Usuarios reales | reservas.technova.com |

Los tres entornos comparten la misma arquitectura.
Staging usa una base de datos con datos de prueba
anonimizados. La promoción de staging a producción
se realiza vía GitHub Actions con aprobación manual.

## 7. Decisiones descartadas con justificación

| Alternativa evaluada | Descartada porque |
| --- | --- |
| Microservicios | Equipo de 2 devs, dominio simple, overhead de infra y comunicación entre servicios injustificable. |
| Contenedores (Docker/K8s) | Azure App Service cubre las necesidades sin la complejidad operativa de contenedores. Se reconsiderará si se necesitan múltiples instancias con configuraciones diferentes. |
| GraphQL | La API tiene pocos endpoints y las consultas son simples. REST es más que suficiente y más conocido por el equipo. |
| MongoDB | Los datos son relacionales (oficinas → salas → puestos → reservas). PostgreSQL es la elección natural. |
| Next.js (SSR) | No hay necesidad de SEO ni de renderizado del lado del servidor. Una SPA con React es más simple y el equipo tiene experiencia. |
| Redis para caché | Con 180 puestos y 120 usuarios, PostgreSQL responde sin caché. Se añadirá si PERF-001 lo requiere tras las pruebas de carga. |
| Azure Functions para jobs | Añade complejidad de despliegue y debugging para un cron de 5 líneas. Se migrará si se necesitan múltiples instancias. |

## 8. Evolución prevista

### Release 2

- Notificaciones push: añadir Firebase Cloud
  Messaging o Azure Notification Hubs.
- Reserva recurrente: nuevo servicio de dominio
  RecurrenciaService con job de generación.
- Informes exportables: generación de Excel con
  librería como ExcelJS.

### Futuro (si la escala lo requiere)

- Migración a contenedores si se superan los
  límites de Azure App Service.
- Caché Redis si las consultas de disponibilidad
  superan el objetivo de rendimiento.
- Separación del job de liberación a Azure Functions
  si se despliegan múltiples instancias del backend.

## 9. Dependencias

- SPEC-0: secciones 6 (restricciones técnicas) y 7
  (restricciones de proyecto).
- SEC-001: autenticación y autorización.
- PERF-001: objetivos de rendimiento.
- DN-003: transiciones de estado (implementadas en
  el service de dominio).
- API-RES-001: contrato de la API (implementado en
  el controller).

## 10. Historial de cambios

| Versión | Fecha | Autor | Cambio |
| --- | --- | --- | --- |
| 0.1 | 2025-05-03 | Pablo D. | Borrador inicial |
| 1.0 | 2025-05-07 | Pablo D. | Aprobada tras revisión con equipo |
