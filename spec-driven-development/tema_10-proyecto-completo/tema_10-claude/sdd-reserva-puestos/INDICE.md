# Índice de especificaciones

## Documento de visión

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| SPEC-0 | Visión y alcance del proyecto | v1.0 | Aprobada |

## Especificaciones funcionales

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| FUNC-001 | Consultar disponibilidad | v1.0 | Aprobada |
| FUNC-002 | Reservar puesto | v1.0 | Aprobada |
| FUNC-003 | Cancelar reserva | v1.0 | Aprobada |
| FUNC-004 | Check-in y liberación automática | v1.0 | Aprobada |
| FUNC-005 | Panel administración Facilities | v1.0 | Aprobada |

## Reglas de dominio

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| DN-001 | Franjas horarias | v1.0 | Aprobada |
| DN-002 | Reglas de reserva | v1.0 | Aprobada |
| DN-003 | Transiciones de estado de reserva | v1.0 | Aprobada |

## Contratos de API

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| API-RES-001 | Crear reserva | v1.0 | Aprobada |

## Especificaciones técnicas

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| TECH-001 | Arquitectura y stack tecnológico | v1.0 | Aprobada |
| TECH-002 | Modelo de datos | v1.0 | Aprobada |

## Seguridad

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| SEC-001 | Autenticación y autorización | v1.0 | Aprobada |

## Rendimiento

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| PERF-001 | Rendimiento de consultas | v1.0 | Aprobada |

## Criterios de aceptación ejecutables

| Archivo | Escenarios | Cobertura |
| --- | --- | --- |
| reserva-puesto.feature | 8 | FUNC-002, DN-001, DN-002, FUNC-005 |
| checkin-liberacion.feature | 4 | FUNC-004 |
