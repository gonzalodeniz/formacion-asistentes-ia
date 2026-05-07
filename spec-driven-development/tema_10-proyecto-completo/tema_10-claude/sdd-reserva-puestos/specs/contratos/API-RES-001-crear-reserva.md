# API-RES-001: Crear reserva

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | API-RES-001 |
| Versión | 1.0 |
| Estado | Aprobada |

## Endpoint

`POST /api/v1/reservas`

## Autenticación

Bearer token (JWT de Azure AD). Requiere rol "empleado".

## Request body

```text
{
  "puesto_id":  "string (uuid, obligatorio)",
  "fecha":      "string (YYYY-MM-DD, obligatorio)",
  "franja":     "string (enum: AM|PM|FD, obligatorio)"
}
```

## Precondiciones

- PRE-1. El puesto existe y está activo.
- PRE-2. El puesto no está bloqueado.
- PRE-3. El puesto está libre para la fecha y franja.
- PRE-4. El empleado no tiene reserva activa en esa
  fecha y franja.
- PRE-5. La fecha está entre hoy y hoy + 14 días.
- PRE-6. La oficina no está cerrada en esa fecha.

## Respuestas

### 201 Created

```text
{
  "reserva_id":  "uuid",
  "codigo":      "string (RES-AAAAMMDD-NNNN)",
  "puesto_id":   "uuid",
  "puesto_codigo": "string (MAD-C-TUR-05)",
  "sala":        "string",
  "oficina":     "string",
  "fecha":       "YYYY-MM-DD",
  "franja":      "string (AM|PM|FD)",
  "estado":      "confirmada",
  "empleado_id": "uuid",
  "created_at":  "ISO 8601"
}
```

### 400 Bad Request (validación)

```text
{
  "error": "VALIDATION_ERROR",
  "detalles": [
    { "campo": "string", "mensaje": "string" }
  ]
}
```

### 409 Conflict

```text
{
  "error": "string (PUESTO_NO_DISPONIBLE |
    RESERVA_EXISTENTE | PUESTO_BLOQUEADO |
    OFICINA_CERRADA)",
  "mensaje": "string"
}
```

### 401 Unauthorized / 404 Not Found

Estructura estándar de error.

## Postcondiciones (si 201)

- POST-1. Reserva creada con estado "confirmada".
- POST-2. Email de confirmación enviado al empleado.

## Idempotencia

No se implementa clave de idempotencia en el MVP. Un
retry puede generar error 409 RESERVA_EXISTENTE si la
primera petición tuvo éxito.

## Rate limiting

50 peticiones por minuto por empleado.

## Dependencias

- FUNC-002: Reservar puesto.
- DN-001: Franjas horarias.
- DN-002: Reglas de reserva.
