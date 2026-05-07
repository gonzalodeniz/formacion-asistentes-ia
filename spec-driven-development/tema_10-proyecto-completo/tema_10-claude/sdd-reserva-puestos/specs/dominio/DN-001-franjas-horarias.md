# DN-001: Franjas horarias

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | DN-001 |
| Versión | 1.0 |
| Estado | Aprobada |
| Autor | Equipo análisis — 2025-05-03 |

## Descripción

Las reservas se realizan por franjas horarias
predefinidas, no por horas sueltas. Esto simplifica
la gestión y evita fragmentación de la disponibilidad.

## Franjas definidas

| Código | Nombre | Inicio | Fin | Duración |
| --- | --- | --- | --- | --- |
| AM | Mañana | 08:00 | 14:00 | 6 horas |
| PM | Tarde | 14:00 | 20:00 | 6 horas |
| FD | Día completo | 08:00 | 20:00 | 12 horas |

## Reglas

- Una reserva de "día completo" (FD) consume las
  franjas AM y PM simultáneamente. No se puede
  reservar FD si AM o PM ya están reservadas.
- Inversamente, si existe una reserva FD, no se puede
  reservar AM ni PM por separado.
- Las franjas son fijas e iguales para todas las
  oficinas.

## Ejemplos

```text
Caso 1: puesto libre todo el día
  Franjas disponibles: AM, PM, FD
  Empleado reserva AM → quedan: PM
  (FD ya no está disponible porque AM está ocupada)

Caso 2: puesto con AM reservada
  Franjas disponibles: PM
  Otro empleado reserva PM → puesto completo

Caso 3: puesto con FD reservada
  Franjas disponibles: ninguna
```

## Invariantes

- INV-1. Un puesto no puede tener más de 2 reservas
  activas por día (una AM + una PM, o una FD sola).
- INV-2. Si existe reserva FD, no pueden existir
  reservas AM ni PM para el mismo puesto y fecha.

## Dependencias

- SPEC-0: RN-5.
- FUNC-002: Reservar puesto (valida disponibilidad
  de franja).
