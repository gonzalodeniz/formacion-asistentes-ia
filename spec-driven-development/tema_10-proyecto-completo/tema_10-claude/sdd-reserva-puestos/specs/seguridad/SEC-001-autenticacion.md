# SEC-001: Autenticación y autorización

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | SEC-001 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |

## Autenticación

Toda interacción con el sistema requiere autenticación
SSO mediante Azure AD con protocolo OAuth 2.0 / OIDC.
No se crean cuentas locales en la aplicación.

El token JWT emitido por Azure AD contiene:

- ID del empleado.
- Email.
- Nombre.
- Grupos (usados para determinar el rol).
- Equipo (usado para la funcionalidad de responsable
  de equipo en Release 2).

## Roles y permisos

| Rol | Origen | Permisos |
| --- | --- | --- |
| empleado | Grupo AD "rp-empleados" | Consultar, reservar, cancelar, check-in sobre sus propias reservas. |
| admin_facilities | Grupo AD "rp-facilities" | Todo lo de empleado más: gestión de oficinas, salas, puestos, bloqueos, dashboard de ocupación. |

## Reglas

- Un usuario sin grupo "rp-empleados" ni
  "rp-facilities" no puede acceder al sistema.
  Pantalla: "No tienes acceso. Contacta con tu
  responsable."
- Un admin_facilities puede realizar reservas como
  empleado normal.
- Los tokens tienen expiración de 1 hora. La app
  renueva el token automáticamente con refresh token.

## Invariantes

- INV-SEC-1. Toda petición a la API incluye un token
  JWT válido. Las peticiones sin token reciben 401.
- INV-SEC-2. Un empleado solo puede ver y gestionar
  sus propias reservas. No puede ver las reservas de
  otros (solo ve el puesto como "reservado" sin nombre).
- INV-SEC-3. Solo admin_facilities puede bloquear
  puestos, gestionar configuración y ver el dashboard.

## Dependencias

- SPEC-0: RT-1.
- FUNC-002, FUNC-003, FUNC-004, FUNC-005.
