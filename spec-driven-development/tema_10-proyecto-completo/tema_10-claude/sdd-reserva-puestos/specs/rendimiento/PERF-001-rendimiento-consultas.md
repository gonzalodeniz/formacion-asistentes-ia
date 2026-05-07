# PERF-001: Rendimiento de consultas de disponibilidad

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | PERF-001 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |

## Descripción

Las consultas de disponibilidad son la operación más
frecuente del sistema. Su rendimiento determina la
experiencia del usuario.

## Requisitos

| Operación | Objetivo p95 | Condiciones |
| --- | --- | --- |
| Listar salas con disponibilidad | < 300 ms | 3 oficinas, 15 salas, 180 puestos |
| Cargar mapa de sala | < 500 ms | Sala con hasta 30 puestos |
| Crear reserva | < 500 ms | Incluye validaciones y persistencia |
| Hacer check-in | < 300 ms | Operación simple |

## Condiciones de medición

- 50 usuarios concurrentes (pico estimado).
- Base de datos con 12 meses de datos históricos
  (~100.000 reservas).
- Infraestructura de producción (Azure, configuración
  estándar).

## Verificación

Prueba de carga con k6 o Artillery simulando 50
usuarios concurrentes durante 10 minutos con
distribución realista de operaciones (70% consulta,
20% reserva, 10% cancelación/check-in).

## Dependencias

- SPEC-0: RT-5, RT-6.
- FUNC-001, FUNC-002.
