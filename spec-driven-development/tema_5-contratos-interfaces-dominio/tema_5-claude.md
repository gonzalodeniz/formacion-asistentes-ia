# Tema 5. Contratos, interfaces y reglas de dominio

## 5.1. Introducción

En los temas anteriores hemos trabajado cómo describir el
comportamiento del sistema desde el punto de vista del usuario
(casos de uso, escenarios, flujos). Pero un sistema software
no es un bloque monolítico: está compuesto por **módulos,
servicios, capas y componentes** que se comunican entre sí.

La calidad de esa comunicación interna determina en gran
medida la robustez, la mantenibilidad y la capacidad de
evolución del sistema. Cuando dos componentes se comunican
sin un acuerdo explícito sobre qué datos se intercambian,
qué condiciones deben cumplirse y qué garantías ofrece cada
parte, los errores de integración son inevitables.

En SDD, este acuerdo explícito se llama **contrato**. Un
contrato define la interfaz entre dos partes (productor y
consumidor) con la precisión suficiente para que cada parte
pueda desarrollarse, probarse y evolucionar de forma
independiente.

Este tema profundiza en tres niveles de especificación que
operan por debajo de los casos de uso:

- **Contratos de interfaz**: qué datos entran, qué datos
  salen, qué errores pueden ocurrir.
- **Precondiciones, postcondiciones e invariantes**: qué debe
  ser cierto antes, después y siempre.
- **Reglas de dominio**: la lógica de negocio formalizada que
  gobierna el comportamiento del sistema independientemente
  de la tecnología.

---

## 5.2. Contratos entre componentes

### 5.2.1. Qué es un contrato de software

Un contrato de software es un **acuerdo formal** entre un
componente que ofrece un servicio (proveedor) y uno o más
componentes que lo consumen (consumidores). El contrato
establece:

- Qué operaciones ofrece el proveedor.
- Qué datos espera recibir (entradas).
- Qué datos devuelve (salidas).
- Qué condiciones deben cumplirse para que la operación
  funcione (precondiciones).
- Qué garantías ofrece si las precondiciones se cumplen
  (postcondiciones).
- Qué ocurre si las precondiciones no se cumplen o si algo
  falla (errores).

El concepto proviene del "Design by Contract" formulado por
Bertrand Meyer, pero en SDD se aplica no solo a nivel de
clase o método, sino a **cualquier frontera de comunicación**:
APIs REST, colas de mensajes, llamadas entre microservicios,
interfaces entre capas de la arquitectura o contratos entre
equipos.

### 5.2.2. Por qué importan los contratos

Sin contratos explícitos, las integraciones funcionan por
**coincidencia**: el consumidor envía lo que cree que el
proveedor espera, y el proveedor devuelve lo que cree que el
consumidor necesita. Cuando ambas creencias coinciden, todo
funciona. Cuando no, aparecen errores que solo se descubren
en testing o en producción.

Los contratos explícitos aportan:

**Independencia de desarrollo**: si el contrato está definido,
el equipo del proveedor y el equipo del consumidor pueden
trabajar en paralelo. Cada uno implementa contra el contrato,
no contra la implementación del otro.

**Detección temprana de incompatibilidades**: si un cambio en
el proveedor modifica el contrato, se detecta antes de
integrar, no después.

**Documentación viva**: el contrato es la documentación más
precisa de la interfaz. Si está actualizado, no hace falta
leer el código del proveedor para saber cómo usarlo.

**Base para tests de integración**: los tests de contrato
verifican que proveedor y consumidor cumplen su parte del
acuerdo.

### 5.2.3. Tipos de contratos según la frontera

Los contratos se aplican en distintas fronteras del sistema,
con diferentes niveles de formalismo:

**Contrato de API REST/HTTP**: el más habitual en arquitecturas
modernas. Define endpoints, métodos, parámetros, cuerpos de
petición y respuesta, códigos de estado, cabeceras y
autenticación.

**Contrato de mensajería asíncrona**: define la estructura de
los mensajes que se publican en colas o topics (Kafka,
RabbitMQ, SQS). Incluye el esquema del mensaje, las garantías
de entrega y el comportamiento ante mensajes malformados.

**Contrato entre capas**: define la interfaz entre capas de la
arquitectura (presentación-servicio, servicio-repositorio).
Aunque suele ser interno al equipo, documentarlo previene
acoplamientos no deseados.

**Contrato entre equipos**: cuando dos equipos trabajan en
módulos que se integran, el contrato es tanto un artefacto
técnico como un acuerdo organizativo. Cambiar el contrato
requiere coordinación entre equipos.

---

## 5.3. Anatomía de un contrato de API REST

El contrato de API REST es el tipo más frecuente en proyectos
modernos. Su especificación completa incluye los siguientes
elementos.

### 5.3.1. Identificación del endpoint

Cada operación se identifica por la combinación de método HTTP
y ruta:

```text
POST   /api/v2/pedidos
GET    /api/v2/pedidos/{id}
PATCH  /api/v2/pedidos/{id}
DELETE /api/v2/pedidos/{id}
GET    /api/v2/pedidos?cliente_id={id}&estado={estado}
```

El versionado en la URL (v1, v2) permite evolucionar la API
sin romper consumidores existentes.

### 5.3.2. Parámetros de entrada

Los datos de entrada pueden viajar en distintos lugares:

- **Path parameters**: valores incrustados en la URL
  (`/pedidos/{id}`). Identifican un recurso concreto.
- **Query parameters**: filtros, paginación, ordenación
  (`?estado=pendiente&page=2&size=20`).
- **Request body**: datos complejos en el cuerpo de la
  petición (JSON, XML). Típico en POST y PUT/PATCH.
- **Headers**: metadatos como autenticación, idioma,
  versión del cliente.

Para cada parámetro, el contrato debe definir: nombre, tipo
de dato, si es obligatorio u opcional, valor por defecto (si
aplica), restricciones de formato y rango, y un ejemplo.

### 5.3.3. Respuestas

El contrato define las posibles respuestas, cada una con:

- **Código de estado HTTP**: 200, 201, 400, 401, 403, 404,
  409, 422, 500, etc.
- **Cuerpo de respuesta**: esquema JSON con tipos, campos
  obligatorios y opcionales.
- **Cabeceras de respuesta**: si aplica (Location, ETag,
  Rate-Limit).

### 5.3.4. Autenticación y autorización

El contrato indica qué mecanismo de autenticación se requiere
(Bearer token, API key, OAuth 2.0) y qué roles o permisos
son necesarios para cada operación.

### 5.3.5. Restricciones operativas

Límites de uso que el consumidor debe respetar:

- Rate limiting (p. ej., 100 peticiones por minuto).
- Tamaño máximo del body (p. ej., 5 MB).
- Timeout esperado (p. ej., 30 segundos).
- Paginación obligatoria para listados.

### 5.3.6. Ejemplo de contrato completo

```text
CONTRATO: API-PED-001
Título:   Crear pedido
Versión:  2.1
Estado:   Aprobado

ENDPOINT
  POST /api/v2/pedidos

AUTENTICACIÓN
  Bearer token (JWT). Requiere rol "cliente" o "admin".

REQUEST HEADERS
  Content-Type: application/json (obligatorio)
  Authorization: Bearer {token} (obligatorio)
  X-Idempotency-Key: {uuid} (obligatorio, para evitar
    pedidos duplicados por reintentos)

REQUEST BODY
  {
    "cliente_id": "uuid (obligatorio)",
    "lineas": [
      {
        "producto_id": "uuid (obligatorio)",
        "cantidad": "integer, 1-999 (obligatorio)"
      }
    ],
    "direccion_envio_id": "uuid (obligatorio)",
    "metodo_pago": "string, enum: [tarjeta, credito_30,
      credito_60] (obligatorio)",
    "notas": "string, max 500 chars (opcional)"
  }

  Restricciones:
  - "lineas" debe contener al menos 1 elemento y máximo 50.
  - "cliente_id" debe corresponder al usuario autenticado
    (o el usuario debe tener rol "admin").
  - "direccion_envio_id" debe pertenecer al cliente.

RESPUESTAS

  201 Created — Pedido creado con éxito
  {
    "pedido_id": "uuid",
    "referencia": "string (PED-2025-NNNNN)",
    "estado": "string (confirmado | pendiente_aprobacion)",
    "total": "decimal",
    "fecha_creacion": "ISO 8601",
    "lineas": [
      {
        "producto_id": "uuid",
        "nombre_producto": "string",
        "cantidad": "integer",
        "precio_unitario": "decimal",
        "descuento_aplicado": "decimal | null",
        "subtotal": "decimal"
      }
    ]
  }
  Header Location: /api/v2/pedidos/{pedido_id}

  400 Bad Request — Error de validación
  {
    "error": "VALIDATION_ERROR",
    "mensaje": "string",
    "detalles": [
      {
        "campo": "string",
        "codigo": "string",
        "mensaje": "string"
      }
    ]
  }
  Códigos de detalle:
  - REQUIRED: campo obligatorio ausente.
  - INVALID_FORMAT: formato incorrecto.
  - OUT_OF_RANGE: valor fuera de rango.
  - MAX_ITEMS_EXCEEDED: más de 50 líneas.

  401 Unauthorized — Token ausente o inválido
  {
    "error": "UNAUTHORIZED",
    "mensaje": "Token no válido o expirado"
  }

  403 Forbidden — Sin permisos
  {
    "error": "FORBIDDEN",
    "mensaje": "No tienes permisos para esta operación"
  }

  409 Conflict — Conflicto de estado
  {
    "error": "INSUFFICIENT_STOCK",
    "mensaje": "Stock insuficiente",
    "detalles": [
      {
        "producto_id": "uuid",
        "cantidad_solicitada": "integer",
        "stock_disponible": "integer"
      }
    ]
  }

  422 Unprocessable Entity — Error de negocio
  {
    "error": "CREDIT_EXCEEDED",
    "mensaje": "Crédito insuficiente",
    "credito_disponible": "decimal",
    "importe_pedido": "decimal"
  }

  429 Too Many Requests — Rate limit excedido
  Header Retry-After: {segundos}

  500 Internal Server Error — Error no controlado
  {
    "error": "INTERNAL_ERROR",
    "mensaje": "Error interno. Contacte con soporte.",
    "trace_id": "uuid (para seguimiento)"
  }

IDEMPOTENCIA
  Si se envía una petición con un X-Idempotency-Key ya
  utilizado en las últimas 24 horas, el sistema devuelve
  la misma respuesta que la primera petición sin crear
  un nuevo pedido.

RATE LIMITING
  100 peticiones por minuto por cliente autenticado.
  Headers de respuesta: X-RateLimit-Limit,
  X-RateLimit-Remaining, X-RateLimit-Reset.

NOTAS
  - Los precios se calculan en el momento de la creación,
    según el acuerdo comercial del cliente y los descuentos
    por volumen aplicables.
  - Si el cliente tiene flujo de aprobación activado, el
    estado será "pendiente_aprobacion" en lugar de
    "confirmado".

DEPENDENCIAS
  - DN-030: Descuento por volumen.
  - DN-020: Precios especiales por acuerdo comercial.
  - DN-022: Política de crédito.
  - FUNC-120: Flujo de aprobación de pedidos.
```

---

## 5.4. Precondiciones, postcondiciones e invariantes

### 5.4.1. Precondiciones

Una precondición es una **condición que debe ser cierta
antes** de que una operación se ejecute. Si la precondición
no se cumple, la operación no debe ejecutarse y el sistema
debe responder con un error claro.

Las precondiciones definen la **responsabilidad del
llamante**: es el consumidor quien debe asegurarse de que las
precondiciones se cumplen antes de invocar la operación.

Ejemplos de precondiciones:

```text
Operación: Cancelar pedido
Precondiciones:
  PRE-1. El pedido existe.
  PRE-2. El pedido está en estado "confirmado" o
         "en_preparacion".
  PRE-3. Han pasado menos de 2 horas desde la confirmación.
  PRE-4. El usuario autenticado es el titular del pedido
         o tiene rol "admin".
```

Tipos de precondiciones:

- **De existencia**: el recurso referenciado existe.
- **De estado**: el recurso está en un estado válido para la
  operación.
- **De autorización**: el actor tiene permisos suficientes.
- **De temporalidad**: se cumple una restricción de tiempo.
- **De integridad referencial**: los recursos relacionados
  existen y son válidos.

### 5.4.2. Postcondiciones

Una postcondición es una **condición que debe ser cierta
después** de que una operación se ejecute con éxito. Las
postcondiciones definen la **responsabilidad del proveedor**:
si las precondiciones se cumplieron, el proveedor garantiza
que las postcondiciones se cumplirán.

```text
Operación: Cancelar pedido
Postcondiciones (si éxito):
  POST-1. El pedido está en estado "cancelado".
  POST-2. El stock de cada producto se ha incrementado
          en la cantidad del pedido.
  POST-3. Si se realizó un cobro, se ha iniciado la
          devolución.
  POST-4. Se ha enviado un correo de confirmación al
          cliente.
  POST-5. Se ha registrado la cancelación en el log de
          auditoría con fecha, usuario y motivo.
```

Las postcondiciones son la base más directa para los tests:
cada postcondición es una aserción verificable.

### 5.4.3. Invariantes

Un invariante es una **condición que debe ser cierta
siempre**, independientemente de qué operaciones se ejecuten.
Los invariantes expresan restricciones fundamentales del
dominio que ninguna operación puede violar.

```text
Invariantes del dominio de pedidos:
  INV-1. El stock de un producto nunca es negativo.
  INV-2. Un pedido siempre tiene al menos una línea.
  INV-3. El total de un pedido es igual a la suma de
         los subtotales de sus líneas más los gastos
         de envío.
  INV-4. Un pedido en estado "cancelado" no puede
         cambiar a ningún otro estado.
  INV-5. El crédito utilizado de un cliente nunca supera
         su crédito aprobado.
```

Los invariantes son especialmente valiosos porque:

- Sirven como **reglas de validación** que el sistema debe
  comprobar en cada operación que pueda violarlos.
- Sirven como **tests de regresión**: si un invariante se
  viola, hay un bug.
- Documentan las **restricciones fundamentales** del dominio
  que todo desarrollador debe conocer.

### 5.4.4. Relación entre los tres conceptos

Los tres conceptos se complementan y forman un marco
completo para especificar el comportamiento de cualquier
operación:

```text
  Antes de la operación:
    ¿Se cumplen las PRECONDICIONES?
      No → Error (responsabilidad del llamante)
      Sí → Ejecutar operación

  Después de la operación:
    ¿Se cumplen las POSTCONDICIONES?
      No → Bug en el proveedor
      Sí → Operación correcta

  Siempre (antes, durante, después):
    ¿Se cumplen los INVARIANTES?
      No → Bug grave (corrupción de estado)
      Sí → Sistema consistente
```

---

## 5.5. Reglas de dominio

### 5.5.1. Qué es una regla de dominio

Una regla de dominio es una **restricción, cálculo o política
del negocio** que el sistema debe implementar. Las reglas de
dominio son independientes de la tecnología: aplican igual si
el sistema es una aplicación web, una API, una app móvil o
un proceso manual.

Las reglas de dominio son el corazón lógico del sistema. Si
los contratos definen "cómo se comunican las partes" y los
casos de uso definen "qué hace el usuario", las reglas de
dominio definen **"qué reglas rigen el negocio"**.

### 5.5.2. Tipos de reglas de dominio

**Reglas de cálculo**: definen cómo se computan valores.
Ejemplos: cálculo de descuentos, cálculo de impuestos,
cálculo de gastos de envío, cálculo de comisiones.

**Reglas de validación**: definen qué valores o estados son
válidos. Ejemplos: un email debe tener formato válido, un
pedido debe tener al menos una línea, la cantidad debe estar
entre 1 y 999.

**Reglas de transición de estado**: definen qué cambios de
estado son permitidos. Ejemplos: un pedido "confirmado" puede
pasar a "en_preparacion" o "cancelado", pero no directamente
a "entregado".

**Reglas de autorización**: definen quién puede hacer qué.
Ejemplos: solo un administrador puede modificar precios, un
empleado no puede aprobar su propio pedido.

**Reglas temporales**: definen restricciones basadas en el
tiempo. Ejemplos: un pedido solo se puede cancelar en las
primeras 2 horas, un enlace de activación caduca a las 48
horas.

**Reglas de prioridad y resolución de conflictos**: definen
qué ocurre cuando varias reglas se aplican simultáneamente.
Ejemplos: si hay descuento por volumen y precio especial, se
aplica el más favorable para el cliente.

### 5.5.3. Cómo especificar reglas de dominio

Una regla de dominio bien especificada incluye:

**Identificador**: código único (DN-NNN).

**Nombre**: descriptivo y conciso.

**Descripción narrativa**: explicación en lenguaje natural de
qué dice la regla y por qué existe.

**Formalización**: expresión precisa de la regla, idealmente
con fórmulas, tablas de decisión o diagramas de estado.

**Ejemplos numéricos**: al menos tres ejemplos concretos con
datos reales que ilustren la regla en acción.

**Casos límite**: qué ocurre en los extremos (valor cero,
valor máximo, frontera entre tramos).

**Excepciones**: situaciones en las que la regla no aplica o
se modifica.

**Dependencias**: otras reglas con las que interactúa.

### 5.5.4. Ejemplo: regla de transición de estados

```text
ID:     DN-040
Título: Transiciones de estado de un pedido

DESCRIPCIÓN
Un pedido sigue un ciclo de vida con estados definidos.
Solo se permiten las transiciones explícitamente indicadas.
Cualquier intento de transición no permitida debe rechazarse.

DIAGRAMA DE ESTADOS

  [borrador]
      │
      ▼
  [confirmado] ──────────► [cancelado]
      │                        ▲
      ▼                        │
  [en_preparacion] ───────────┘
      │
      ▼
  [enviado]
      │
      ▼
  [entregado]

TABLA DE TRANSICIONES

  Estado origen     Estado destino     Quién puede
  ─────────────     ──────────────     ───────────
  borrador          confirmado         cliente
  confirmado        en_preparacion     sistema/almacen
  confirmado        cancelado          cliente, admin
  en_preparacion    enviado            almacen
  en_preparacion    cancelado          admin (no cliente)
  enviado           entregado          sistema/logistica
  cancelado         (ninguno)          —
  entregado         (ninguno)          —

INVARIANTES ASOCIADOS
  INV-4. Un pedido en estado "cancelado" no puede cambiar
         a ningún otro estado.
  INV-6. Un pedido en estado "entregado" no puede cambiar
         a ningún otro estado.
  INV-7. La secuencia de estados siempre avanza hacia la
         derecha del diagrama, salvo la transición a
         "cancelado".

EXCEPCIONES
  - Un administrador puede forzar la transición de
    "enviado" a "cancelado" en casos excepcionales
    (producto retirado por seguridad). Esta transición
    requiere motivo obligatorio y genera alerta.
```

### 5.5.5. Ejemplo: regla de cálculo con tabla de decisión

```text
ID:     DN-045
Título: Cálculo de gastos de envío

DESCRIPCIÓN
Los gastos de envío se calculan según la zona geográfica
del destino y el peso total del pedido. Pedidos superiores
a 200 € (antes de gastos de envío) tienen envío gratuito.

TABLA DE CÁLCULO

  Zona         Hasta 5 kg   5-20 kg   Más de 20 kg
  ─────────    ──────────   ───────   ────────────
  Península    4,50 €       7,90 €    12,50 €
  Baleares     6,90 €       11,50 €   18,00 €
  Canarias     9,90 €       16,50 €   25,00 €

REGLA DE ENVÍO GRATUITO
  Si subtotal_pedido > 200,00 € → gastos_envio = 0,00 €
  (Aplica a todas las zonas)

EJEMPLOS

  Ejemplo 1:
    Zona: Península, Peso: 3 kg, Subtotal: 45,00 €
    Gastos de envío: 4,50 €
    Total: 49,50 €

  Ejemplo 2:
    Zona: Canarias, Peso: 12 kg, Subtotal: 89,00 €
    Gastos de envío: 16,50 €
    Total: 105,50 €

  Ejemplo 3:
    Zona: Baleares, Peso: 8 kg, Subtotal: 250,00 €
    Gastos de envío: 0,00 € (envío gratuito por
    subtotal > 200 €)
    Total: 250,00 €

CASOS LÍMITE
  - Peso exactamente 5 kg: se aplica el tramo "Hasta 5 kg".
  - Subtotal exactamente 200,00 €: NO tiene envío
    gratuito (la condición es estrictamente mayor).
  - Subtotal 200,01 €: SÍ tiene envío gratuito.
  - Pedido con 0 kg (producto digital): gastos de
    envío 0,00 € (no aplica la tabla).

DEPENDENCIAS
  - DN-020: Los precios especiales pueden hacer que
    un pedido cruce o no el umbral de 200 €.
  - DN-030: Los descuentos por volumen pueden reducir
    el subtotal por debajo de 200 €.
```

---

## 5.6. Consistencia entre dominio e implementación

### 5.6.1. El problema de la dispersión

Una de las causas más frecuentes de bugs en sistemas
complejos es la **dispersión de reglas de dominio** en el
código. La misma regla (por ejemplo, "el stock no puede ser
negativo") se implementa en múltiples lugares: en la
validación del formulario, en el servicio de negocio, en el
stored procedure, en el job nocturno de sincronización.
Cuando la regla cambia, hay que encontrar y actualizar todas
las implementaciones. Si se olvida una, aparece una
inconsistencia.

### 5.6.2. Estrategias de consistencia

**Centralizar las reglas en el dominio**: en arquitecturas
orientadas al dominio (DDD), las reglas se implementan en
las entidades y servicios de dominio, no en los controladores
ni en la capa de persistencia. La especificación SDD de la
regla se mapea directamente a una clase o función del dominio.

**Usar la especificación como referencia de implementación**:
el desarrollador implementa la regla siguiendo la
especificación, no su interpretación del requisito. El ID
de la regla se referencia en el código (comentario o
constante) para mantener la trazabilidad.

**Validar con tests derivados de la especificación**: los
ejemplos numéricos de la especificación de la regla se
convierten directamente en tests. Si la especificación dice
que 120 unidades a 0,50 € con 5% de descuento dan 57,60 €,
hay un test que verifica exactamente ese cálculo.

**Revisar la consistencia periódicamente**: incluir en las
revisiones de código la verificación de que la implementación
es fiel a la especificación de la regla de dominio
referenciada.

### 5.6.3. Señales de inconsistencia

Indicadores de que las reglas de dominio no están bien
alineadas con la implementación:

- Un bug que afecta a una funcionalidad pero no a otra que
  aplica la misma regla.
- Resultados diferentes al ejecutar la misma operación por
  distintos canales (web vs. API vs. job).
- Discrepancias entre lo que dice la documentación y lo que
  hace el sistema.
- Tests que pasan individualmente pero fallan en integración.

---

## 5.7. Contratos entre consumidor y proveedor

### 5.7.1. Perspectiva del consumidor vs. perspectiva del proveedor

Un contrato se puede definir desde dos perspectivas:

**Contrato definido por el proveedor** (*provider-driven*):
el equipo que desarrolla el servicio define el contrato y lo
publica. Los consumidores se adaptan. Es el modelo más
habitual en APIs públicas.

**Contrato definido por el consumidor** (*consumer-driven*):
los consumidores expresan qué necesitan del proveedor, y el
proveedor se compromete a satisfacer esas necesidades. Este
modelo es más ágil cuando hay múltiples consumidores con
necesidades diferentes.

En la práctica, el mejor enfoque es **colaborativo**: el
proveedor y los consumidores principales definen el contrato
juntos, asegurando que es viable para el proveedor y útil
para los consumidores.

### 5.7.2. Tests de contrato

Los tests de contrato verifican que proveedor y consumidor
cumplen su parte del acuerdo. Se dividen en dos tipos:

**Test del lado del proveedor**: verifica que el proveedor
devuelve respuestas conformes al contrato para todas las
peticiones válidas definidas.

**Test del lado del consumidor**: verifica que el consumidor
envía peticiones conformes al contrato y maneja correctamente
todas las respuestas definidas (incluyendo errores).

El flujo de trabajo es:

```text
  1. Se define el contrato (colaborativamente).
  2. El consumidor escribe tests contra un mock del
     proveedor basado en el contrato.
  3. El proveedor escribe tests que verifican que sus
     respuestas reales coinciden con el contrato.
  4. Ambos conjuntos de tests se ejecutan en CI/CD.
  5. Si un cambio rompe el contrato, el test falla
     antes de llegar a integración.
```

### 5.7.3. Evolución de contratos

Los contratos cambian a lo largo de la vida del proyecto.
Gestionar estos cambios sin romper consumidores existentes
requiere estrategias:

**Versionado**: cada versión mayor del contrato se publica
bajo una nueva URL o un nuevo número de versión. Los
consumidores migran a su ritmo.

**Compatibilidad hacia atrás**: los cambios aditivos (nuevos
campos opcionales, nuevos endpoints) son compatibles. Los
cambios destructivos (eliminar campos, cambiar tipos, renombrar
endpoints) no lo son y requieren nueva versión.

**Periodo de deprecación**: cuando se retira una versión del
contrato, se anuncia con antelación suficiente y se mantiene
operativa durante un periodo de transición.

**Regla práctica de compatibilidad**:

```text
  Compatible (no rompe consumidores):
  - Añadir campo opcional a la respuesta.
  - Añadir nuevo endpoint.
  - Añadir nuevo código de error.
  - Añadir parámetro opcional a la petición.

  Incompatible (rompe consumidores):
  - Eliminar o renombrar campo de la respuesta.
  - Cambiar el tipo de un campo existente.
  - Hacer obligatorio un parámetro que era opcional.
  - Cambiar la URL de un endpoint.
  - Cambiar la semántica de un código de error.
```

---

## 5.8. Resumen del tema

Los contratos, las precondiciones/postcondiciones/invariantes
y las reglas de dominio son los tres pilares de la
especificación a nivel de componente e integración en SDD.

Puntos clave:

- Un contrato es un acuerdo formal entre proveedor y
  consumidor que define entradas, salidas, errores y
  restricciones.
- Las precondiciones definen la responsabilidad del llamante;
  las postcondiciones, la garantía del proveedor; los
  invariantes, las restricciones que nunca se violan.
- Las reglas de dominio formalizan la lógica de negocio
  independientemente de la tecnología: cálculos,
  validaciones, transiciones de estado, autorizaciones y
  reglas temporales.
- La consistencia entre especificación e implementación se
  logra centralizando reglas, referenciando especificaciones
  en el código y derivando tests de los ejemplos.
- Los contratos evolucionan con versionado, compatibilidad
  hacia atrás y periodos de deprecación.
- Los tests de contrato (del lado del proveedor y del
  consumidor) son la herramienta clave para detectar
  roturas de integración antes de que lleguen a producción.

---

## Laboratorios del Tema 5

### Laboratorio 5.1: Definición de contratos para una API REST

#### Enunciado del laboratorio 5.1

**Objetivo**: diseñar contratos completos para los endpoints
de una API REST del proyecto de tienda online B2B, aplicando
la estructura y los criterios vistos en el tema.

**Contexto**: el equipo necesita especificar la API de
gestión de devoluciones para el proyecto B2B de distribución
de material de oficina. Se requieren los siguientes
endpoints:

1. Crear solicitud de devolución.
2. Consultar detalle de una solicitud de devolución.
3. Listar solicitudes de devolución de un cliente.
4. Aprobar o rechazar una solicitud (gestor comercial).

**Instrucciones**:

1. Escribe el contrato completo para los 4 endpoints,
   incluyendo: endpoint, autenticación, request, respuestas
   (éxito y todos los errores relevantes), restricciones.
2. Define las precondiciones y postcondiciones de cada
   operación.
3. Identifica al menos 2 invariantes del dominio de
   devoluciones.
4. Especifica las reglas de compatibilidad hacia atrás que
   aplicarían si el contrato evoluciona.

#### Solución del laboratorio 5.1

##### Endpoint 1: Crear solicitud de devolución

```text
CONTRATO: API-DEV-001
Título:   Crear solicitud de devolución
Versión:  1.0
Estado:   Borrador

ENDPOINT
  POST /api/v1/devoluciones

AUTENTICACIÓN
  Bearer token (JWT). Requiere rol "cliente".

REQUEST HEADERS
  Content-Type: application/json (obligatorio)
  Authorization: Bearer {token} (obligatorio)

REQUEST BODY
  {
    "pedido_id": "uuid (obligatorio)",
    "lineas": [
      {
        "producto_id": "uuid (obligatorio)",
        "cantidad": "integer, 1-N (obligatorio,
          max = cantidad pedida)",
        "motivo": "string, enum: [danado, incorrecto,
          no_necesario, error_cantidad, otro]
          (obligatorio)",
        "descripcion": "string, 20-500 chars
          (obligatorio si motivo = otro,
          opcional en los demás)"
      }
    ],
    "imagenes": [
      "string (URL de imagen subida previamente,
       opcional, max 5 elementos, formatos:
       jpg, png, max 5 MB cada una)"
    ]
  }

  Restricciones:
  - "lineas" debe contener entre 1 y 20 elementos.
  - "pedido_id" debe corresponder a un pedido del
    cliente autenticado.
  - La cantidad a devolver no puede superar la
    cantidad pedida menos las cantidades ya en
    devolución activa para el mismo producto.

PRECONDICIONES
  PRE-1. El pedido existe y pertenece al cliente.
  PRE-2. El pedido está en estado "entregado".
  PRE-3. Han pasado 15 días naturales o menos desde
         la fecha de entrega.
  PRE-4. No existe una solicitud activa (pendiente o
         en_proceso) para los mismos productos y
         cantidades del mismo pedido.

RESPUESTAS

  201 Created — Solicitud creada
  {
    "devolucion_id": "uuid",
    "referencia": "string (DEV-2025-NNNNN)",
    "estado": "pendiente_revision",
    "fecha_solicitud": "ISO 8601",
    "pedido_referencia": "string",
    "lineas": [
      {
        "producto_id": "uuid",
        "nombre_producto": "string",
        "cantidad": "integer",
        "motivo": "string",
        "descripcion": "string | null"
      }
    ],
    "gestor_asignado": "string (nombre)"
  }
  Header Location:
    /api/v1/devoluciones/{devolucion_id}

  400 Bad Request — Error de validación
  {
    "error": "VALIDATION_ERROR",
    "mensaje": "string",
    "detalles": [
      {
        "campo": "string",
        "codigo": "string",
        "mensaje": "string"
      }
    ]
  }
  Códigos de detalle:
  - REQUIRED: campo obligatorio ausente.
  - INVALID_FORMAT: formato incorrecto.
  - OUT_OF_RANGE: cantidad fuera de rango.
  - DESCRIPTION_REQUIRED: motivo "otro" sin
    descripción o con menos de 20 caracteres.
  - MAX_IMAGES_EXCEEDED: más de 5 imágenes.
  - MAX_LINES_EXCEEDED: más de 20 líneas.

  401 Unauthorized — Token ausente o inválido
  {
    "error": "UNAUTHORIZED",
    "mensaje": "Token no válido o expirado"
  }

  403 Forbidden — Pedido de otro cliente
  {
    "error": "FORBIDDEN",
    "mensaje": "No tienes acceso a este pedido"
  }

  404 Not Found — Pedido no encontrado
  {
    "error": "NOT_FOUND",
    "mensaje": "Pedido no encontrado"
  }

  409 Conflict — Conflicto de estado o duplicado
  {
    "error": "string (INVALID_ORDER_STATE |
      RETURN_WINDOW_EXPIRED |
      DUPLICATE_RETURN_REQUEST)",
    "mensaje": "string"
  }
  - INVALID_ORDER_STATE: el pedido no está en estado
    "entregado".
  - RETURN_WINDOW_EXPIRED: han pasado más de 15 días
    desde la entrega.
  - DUPLICATE_RETURN_REQUEST: ya existe solicitud
    activa para alguno de los productos indicados.

POSTCONDICIONES (si 201)
  POST-1. Existe una nueva solicitud de devolución
          con estado "pendiente_revision".
  POST-2. Se ha asignado un gestor comercial.
  POST-3. Se ha enviado notificación al gestor.
  POST-4. Se ha enviado correo de confirmación al
          cliente.

RATE LIMITING
  20 peticiones por minuto por cliente.
```

##### Endpoint 2: Consultar detalle de solicitud

```text
CONTRATO: API-DEV-002
Título:   Consultar detalle de solicitud de devolución
Versión:  1.0

ENDPOINT
  GET /api/v1/devoluciones/{devolucion_id}

AUTENTICACIÓN
  Bearer token (JWT). Requiere rol "cliente" (solo
  sus devoluciones) o "gestor" / "admin" (todas).

PATH PARAMETERS
  devolucion_id: uuid (obligatorio)

PRECONDICIONES
  PRE-1. La solicitud existe.
  PRE-2. El usuario tiene acceso (es el titular o
         tiene rol gestor/admin).

RESPUESTAS

  200 OK
  {
    "devolucion_id": "uuid",
    "referencia": "string",
    "estado": "string (pendiente_revision |
      info_solicitada | aprobada | rechazada |
      completada)",
    "fecha_solicitud": "ISO 8601",
    "fecha_resolucion": "ISO 8601 | null",
    "pedido_id": "uuid",
    "pedido_referencia": "string",
    "lineas": [
      {
        "producto_id": "uuid",
        "nombre_producto": "string",
        "cantidad": "integer",
        "precio_unitario": "decimal",
        "motivo": "string",
        "descripcion": "string | null"
      }
    ],
    "imagenes": ["string (URL)"],
    "importe_abono": "decimal | null",
    "gestor_asignado": "string",
    "historial": [
      {
        "fecha": "ISO 8601",
        "estado_anterior": "string",
        "estado_nuevo": "string",
        "comentario": "string | null",
        "autor": "string"
      }
    ]
  }

  401 Unauthorized
  403 Forbidden
  404 Not Found
  (misma estructura de error que API-DEV-001)

POSTCONDICIONES
  POST-1. No se modifica ningún dato (operación de
          solo lectura).
```

##### Endpoint 3: Listar solicitudes de devolución

```text
CONTRATO: API-DEV-003
Título:   Listar solicitudes de devolución
Versión:  1.0

ENDPOINT
  GET /api/v1/devoluciones

AUTENTICACIÓN
  Bearer token (JWT). Rol "cliente" ve solo las
  suyas. Roles "gestor" y "admin" ven todas (con
  filtros).

QUERY PARAMETERS
  estado: string, opcional (filtrar por estado)
  pedido_id: uuid, opcional (filtrar por pedido)
  fecha_desde: ISO 8601 date, opcional
  fecha_hasta: ISO 8601 date, opcional
  page: integer, default 1, min 1
  size: integer, default 20, min 1, max 100
  sort: string, default "fecha_solicitud_desc",
    enum: [fecha_solicitud_asc,
    fecha_solicitud_desc, estado]

PRECONDICIONES
  PRE-1. El usuario está autenticado.

RESPUESTAS

  200 OK
  {
    "datos": [
      {
        "devolucion_id": "uuid",
        "referencia": "string",
        "estado": "string",
        "fecha_solicitud": "ISO 8601",
        "pedido_referencia": "string",
        "num_productos": "integer",
        "importe_estimado": "decimal"
      }
    ],
    "paginacion": {
      "page": "integer",
      "size": "integer",
      "total_elementos": "integer",
      "total_paginas": "integer"
    }
  }

  400 Bad Request — Parámetros de filtro inválidos
  401 Unauthorized

POSTCONDICIONES
  POST-1. Solo lectura, sin modificaciones.
  POST-2. Un cliente solo ve sus propias solicitudes.
```

##### Endpoint 4: Aprobar o rechazar solicitud

```text
CONTRATO: API-DEV-004
Título:   Resolver solicitud de devolución
Versión:  1.0

ENDPOINT
  PATCH /api/v1/devoluciones/{devolucion_id}/resolucion

AUTENTICACIÓN
  Bearer token (JWT). Requiere rol "gestor" o "admin".

PATH PARAMETERS
  devolucion_id: uuid (obligatorio)

REQUEST BODY
  {
    "accion": "string, enum: [aprobar, rechazar,
      solicitar_info] (obligatorio)",
    "comentario": "string, 10-1000 chars
      (obligatorio si accion = rechazar o
      solicitar_info, opcional si aprobar)",
    "importe_abono": "decimal, > 0
      (obligatorio si accion = aprobar)"
  }

PRECONDICIONES
  PRE-1. La solicitud existe.
  PRE-2. La solicitud está en estado
         "pendiente_revision" o "info_solicitada"
         (para aprobar/rechazar) o en estado
         "pendiente_revision" (para solicitar_info).
  PRE-3. El usuario tiene rol "gestor" o "admin".
  PRE-4. Si accion = aprobar, importe_abono no
         supera el importe total de los productos
         de la devolución a precio del pedido
         original.

RESPUESTAS

  200 OK — Resolución aplicada
  {
    "devolucion_id": "uuid",
    "referencia": "string",
    "estado": "string (aprobada | rechazada |
      info_solicitada)",
    "fecha_resolucion": "ISO 8601 | null",
    "comentario": "string | null",
    "importe_abono": "decimal | null"
  }

  400 Bad Request — Validación
  {
    "error": "VALIDATION_ERROR",
    "detalles": [...]
  }
  Códigos:
  - COMMENT_REQUIRED: comentario obligatorio para
    rechazar o solicitar_info.
  - AMOUNT_REQUIRED: importe_abono obligatorio al
    aprobar.
  - AMOUNT_EXCEEDS_ORIGINAL: importe_abono supera
    el valor de los productos devueltos.

  401 Unauthorized
  403 Forbidden — Sin rol gestor/admin
  404 Not Found
  409 Conflict — Estado no permite esta acción
  {
    "error": "INVALID_STATE_TRANSITION",
    "mensaje": "La solicitud en estado
      '[estado_actual]' no permite la acción
      '[accion]'",
    "estado_actual": "string"
  }

POSTCONDICIONES (si 200)

  Si accion = aprobar:
    POST-1. Estado cambia a "aprobada".
    POST-2. Se registra el importe de abono.
    POST-3. Se notifica al cliente (email).
    POST-4. Se inicia el proceso de recogida
            (integración logística).

  Si accion = rechazar:
    POST-1. Estado cambia a "rechazada".
    POST-2. Se registra el comentario con el motivo.
    POST-3. Se notifica al cliente con el motivo.

  Si accion = solicitar_info:
    POST-1. Estado cambia a "info_solicitada".
    POST-2. Se notifica al cliente con la pregunta
            del gestor.
```

##### Invariantes del dominio de devoluciones

```text
INV-DEV-1. El importe de abono de una devolución
  aprobada nunca supera el importe total de los
  productos devueltos a precio del pedido original.

INV-DEV-2. Una solicitud de devolución en estado
  "completada" o "rechazada" no puede cambiar a
  ningún otro estado.

INV-DEV-3. La suma de cantidades en devolución
  (activas + completadas) para un producto de un
  pedido nunca supera la cantidad original pedida.

INV-DEV-4. Toda solicitud de devolución tiene
  asignado exactamente un gestor comercial.
```

##### Reglas de compatibilidad hacia atrás

Si el contrato evoluciona a v2:

```text
Cambios compatibles (se pueden hacer sin nueva versión):
- Añadir campo opcional a la respuesta (p. ej.,
  "fecha_estimada_recogida").
- Añadir nuevo valor al enum de motivos (p. ej.,
  "garantia").
- Añadir nuevo query parameter opcional al listado.
- Añadir nuevo estado al ciclo de vida (si los
  consumidores ignoran estados desconocidos).

Cambios incompatibles (requieren v2):
- Renombrar "importe_abono" a "importe_devolucion".
- Cambiar la estructura de "lineas" (p. ej., anidar
  dentro de un objeto "detalle").
- Hacer "imagenes" obligatorio.
- Eliminar el campo "gestor_asignado" de la respuesta.
- Cambiar el path de /devoluciones a /returns.

Estrategia:
- v1 se mantiene operativa durante 6 meses tras el
  lanzamiento de v2.
- Se envía header "Deprecation: true" en las
  respuestas de v1 durante el periodo de transición.
- Los consumidores deben migrar a v2 antes de la
  fecha de retirada de v1.
```

---

### Laboratorio 5.2: Especificación de reglas de negocio con invariantes

#### Enunciado del laboratorio 5.2

**Objetivo**: formalizar reglas de negocio complejas como
especificaciones de dominio con invariantes, tablas de
decisión, ejemplos numéricos y casos límite.

**Contexto**: el sistema B2B de distribución necesita las
siguientes reglas de negocio formalizadas:

1. Cálculo de crédito disponible para clientes con pago
   aplazado.
2. Política de descuentos acumulados por fidelidad (nuevo
   requisito del equipo comercial).
3. Transiciones de estado de una solicitud de devolución.

**Instrucciones**:

1. Para cada regla, escribe la especificación completa en
   formato de regla de dominio (DN-NNN).
2. Incluye al menos 3 ejemplos numéricos por regla de
   cálculo.
3. Define los invariantes asociados.
4. Identifica los casos límite.
5. Indica las dependencias con otras reglas y contratos.

#### Solución del laboratorio 5.2

##### Regla 1: Cálculo de crédito disponible

```text
ID:     DN-050
Título: Cálculo de crédito disponible para cliente
        con pago aplazado

DESCRIPCIÓN
Los clientes con crédito aprobado pueden realizar pedidos
sin pago inmediato. El sistema debe controlar en todo
momento cuánto crédito tiene disponible cada cliente para
evitar que se supere el límite aprobado.

FÓRMULA

  credito_disponible =
    credito_aprobado
    - sum(pedidos_pendientes_de_cobro)
    - sum(pedidos_en_preparacion_o_envio)

  Donde:
  - credito_aprobado: importe máximo aprobado por
    el departamento financiero para el cliente.
  - pedidos_pendientes_de_cobro: pedidos confirmados
    con método de pago "credito_30" o "credito_60"
    cuya factura aún no ha sido cobrada.
  - pedidos_en_preparacion_o_envio: pedidos en
    estados "confirmado", "en_preparacion" o
    "enviado" con pago a crédito.

EJEMPLOS

  Ejemplo 1 — Crédito amplio
    credito_aprobado: 10.000,00 €
    Pedidos pendientes de cobro:
      PED-001: 2.500,00 € (factura emitida, no cobrada)
      PED-002: 1.200,00 € (factura emitida, no cobrada)
    Pedidos en curso:
      PED-003: 800,00 € (en preparación)
    credito_disponible = 10.000 - 2.500 - 1.200 - 800
                       = 5.500,00 €
    El cliente puede hacer un pedido de hasta 5.500 €.

  Ejemplo 2 — Crédito justo
    credito_aprobado: 5.000,00 €
    Pedidos pendientes de cobro:
      PED-010: 3.000,00 €
    Pedidos en curso:
      PED-011: 1.800,00 €
    credito_disponible = 5.000 - 3.000 - 1.800
                       = 200,00 €
    El cliente puede hacer un pedido de hasta 200 €.
    Si intenta un pedido de 300 €, el sistema lo
    rechaza (ver FE en contrato API-PED-001, error
    422 CREDIT_EXCEEDED).

  Ejemplo 3 — Crédito agotado
    credito_aprobado: 3.000,00 €
    Pedidos pendientes de cobro:
      PED-020: 2.000,00 €
      PED-021: 1.000,00 €
    Pedidos en curso: ninguno.
    credito_disponible = 3.000 - 2.000 - 1.000
                       = 0,00 €
    El cliente no puede hacer pedidos a crédito.
    Debe pagar con tarjeta o esperar a que se cobren
    las facturas pendientes.

  Ejemplo 4 — Cobro libera crédito
    Continuación del ejemplo 3.
    Se cobra la factura de PED-020 (2.000 €).
    credito_disponible = 3.000 - 1.000 = 2.000,00 €
    El cliente puede hacer pedidos a crédito de nuevo.

CASOS LÍMITE
  - Cliente sin crédito aprobado (credito_aprobado = 0):
    no puede seleccionar pago a crédito. Solo tarjeta.
  - Pedido cancelado con pago a crédito: al cancelar,
    el importe del pedido se libera del crédito
    consumido inmediatamente.
  - Devolución aprobada con abono pendiente: el abono
    NO incrementa el crédito disponible hasta que se
    ejecute la nota de crédito contable.
  - Pedido pendiente de aprobación: SÍ consume crédito
    (reserva preventiva) para evitar que se aprueben
    pedidos sin crédito suficiente.

INVARIANTES
  INV-CR-1. credito_disponible >= 0 siempre.
            El sistema no permite crear pedidos a
            crédito que resulten en crédito negativo.
  INV-CR-2. credito_disponible <= credito_aprobado
            siempre.
  INV-CR-3. Si un pedido a crédito se cancela, el
            crédito disponible se incrementa en el
            importe del pedido cancelado.

DEPENDENCIAS
  - API-PED-001: Crear pedido (verifica crédito al
    confirmar).
  - DN-022: Política de crédito (define condiciones
    de aprobación).
  - DN-040: Transiciones de estado de pedido (la
    cancelación libera crédito).
```

##### Regla 2: Descuentos por fidelidad

```text
ID:     DN-055
Título: Descuento acumulado por fidelidad de cliente

DESCRIPCIÓN
El equipo comercial quiere premiar a los clientes según
su volumen de compra acumulado en los últimos 12 meses.
El descuento se aplica como un porcentaje adicional sobre
el total del pedido (después de aplicar otros descuentos
individuales por línea).

TABLA DE TRAMOS

  Compra acumulada (12 meses)   Descuento fidelidad
  ────────────────────────────  ───────────────────
  Menos de 5.000 €              0%
  5.000 € - 14.999,99 €         1%
  15.000 € - 49.999,99 €        2%
  50.000 € o más                3%

FÓRMULA

  compra_acumulada = sum(total de pedidos confirmados
    y entregados en los últimos 365 días naturales)

  descuento_fidelidad = subtotal_pedido *
    (porcentaje_tramo / 100)

  total_pedido = subtotal_pedido
    - descuento_fidelidad
    + gastos_envio

  Nota: el descuento de fidelidad se aplica DESPUÉS
  de los descuentos por volumen y precios especiales
  (que se aplican por línea), y ANTES de los gastos
  de envío.

INTERACCIÓN CON OTROS DESCUENTOS
  - El descuento por volumen (DN-030) se aplica por
    línea sobre el precio unitario.
  - El precio especial (DN-020) se aplica por línea.
  - El descuento de fidelidad (DN-055) se aplica
    sobre el subtotal resultante.
  - Son acumulables (no excluyentes).

  Orden de aplicación:
  1. Precio unitario = min(precio_base con descuento
     volumen, precio_especial) [por línea, DN-035]
  2. Subtotal = sum(precio_unitario * cantidad)
     [todas las líneas]
  3. Descuento fidelidad = subtotal * porcentaje
  4. Total = subtotal - descuento_fidelidad +
     gastos_envio

EJEMPLOS

  Ejemplo 1 — Cliente sin fidelidad
    Compra acumulada 12 meses: 3.200 €
    Tramo: menos de 5.000 € → 0%
    Subtotal del pedido actual: 450,00 €
    Descuento fidelidad: 0,00 €
    Total (sin gastos envío): 450,00 €

  Ejemplo 2 — Cliente con fidelidad media
    Compra acumulada 12 meses: 22.000 €
    Tramo: 15.000 - 49.999,99 € → 2%
    Subtotal del pedido actual: 1.200,00 €
    (ya con descuento por volumen aplicado por línea)
    Descuento fidelidad: 1.200 * 0,02 = 24,00 €
    Total (sin gastos envío): 1.176,00 €

  Ejemplo 3 — Cliente premium
    Compra acumulada 12 meses: 78.500 €
    Tramo: 50.000+ € → 3%
    Subtotal del pedido actual: 3.500,00 €
    Descuento fidelidad: 3.500 * 0,03 = 105,00 €
    Total (sin gastos envío): 3.395,00 €

  Ejemplo 4 — Interacción con envío gratuito
    Compra acumulada 12 meses: 55.000 € → 3%
    Subtotal pedido (con descuentos por línea): 210 €
    Descuento fidelidad: 210 * 0,03 = 6,30 €
    Subtotal final: 203,70 €
    ¿Envío gratuito? Sí (se evalúa sobre el subtotal
    ANTES del descuento de fidelidad: 210 > 200).
    Total: 203,70 € (envío gratuito)

CASOS LÍMITE
  - Compra acumulada exactamente 5.000,00 €: entra en
    el tramo del 1% (el límite inferior es inclusivo).
  - Compra acumulada exactamente 4.999,99 €: tramo 0%.
  - El pedido actual NO cuenta para la compra acumulada
    (se calcula sobre pedidos anteriores ya entregados).
  - Pedido cancelado: se descuenta de la compra
    acumulada si ya estaba contabilizado.
  - Devolución completada: el importe devuelto se resta
    de la compra acumulada.
  - Cliente nuevo (sin historial): compra acumulada 0,
    tramo 0%.
  - Evaluación del umbral de envío gratuito (DN-045):
    se evalúa sobre el subtotal ANTES de aplicar el
    descuento de fidelidad.

INVARIANTES
  INV-FID-1. El porcentaje de descuento de fidelidad
    es siempre 0%, 1%, 2% o 3%. No hay valores
    intermedios.
  INV-FID-2. La compra acumulada nunca incluye pedidos
    cancelados ni importes devueltos.
  INV-FID-3. El descuento de fidelidad se aplica
    siempre sobre el subtotal post-descuentos por
    línea, nunca sobre el precio base.

VISUALIZACIÓN EN CARRITO
  Si aplica descuento de fidelidad (> 0%):
  - Se muestra una línea antes del total:
    "Descuento fidelidad (X%): -Y,YY €"
  - Se muestra un badge junto al nombre del cliente:
    "Cliente [Bronce|Plata|Oro]" según el tramo.

DEPENDENCIAS
  - DN-030: Descuento por volumen (se aplica antes).
  - DN-020: Precios especiales (se aplica antes).
  - DN-035: Resolución de conflictos entre descuentos
    por línea.
  - DN-045: Gastos de envío (envío gratuito se evalúa
    antes del descuento de fidelidad).
```

##### Regla 3: Transiciones de estado de devolución

```text
ID:     DN-060
Título: Transiciones de estado de solicitud de
        devolución

DESCRIPCIÓN
Una solicitud de devolución sigue un ciclo de vida con
estados definidos. Solo se permiten las transiciones
explícitamente indicadas.

DIAGRAMA DE ESTADOS

  [pendiente_revision]
      │         │
      │         ▼
      │    [info_solicitada]
      │         │
      │         ▼
      │    [pendiente_revision] (vuelta)
      │
      ├────────────────────┐
      ▼                    ▼
  [aprobada]          [rechazada]
      │
      ▼
  [completada]

TABLA DE TRANSICIONES

  Origen               Destino              Quién
  ──────               ───────              ─────
  pendiente_revision   aprobada             gestor
  pendiente_revision   rechazada            gestor
  pendiente_revision   info_solicitada      gestor
  info_solicitada      pendiente_revision   cliente
  aprobada             completada           sistema
  rechazada            (ninguno)            —
  completada           (ninguno)            —

CONDICIONES POR TRANSICIÓN

  pendiente_revision → aprobada:
    - El gestor indica importe de abono.
    - El importe no supera el valor original.

  pendiente_revision → rechazada:
    - El gestor indica motivo (obligatorio, mínimo
      10 caracteres).

  pendiente_revision → info_solicitada:
    - El gestor escribe pregunta al cliente
      (obligatorio).

  info_solicitada → pendiente_revision:
    - El cliente responde (texto o imágenes).

  aprobada → completada:
    - Se ha recibido el material devuelto.
    - Se ha emitido la nota de abono.
    (Transición automática por el sistema)

INVARIANTES
  INV-DEV-2. Una solicitud en estado "completada" o
    "rechazada" no puede cambiar a ningún otro estado.
  INV-DEV-5. Toda transición queda registrada en el
    historial con fecha, autor y comentario.
  INV-DEV-6. Una solicitud solo puede pasar a
    "aprobada" si tiene importe de abono asignado.

DEPENDENCIAS
  - API-DEV-004: Contrato de resolución de devolución.
  - DN-050: Si la devolución se aprueba y el pedido
    fue a crédito, el abono puede afectar al crédito.
```

---

### Laboratorio 5.3: Validación de contratos entre consumidor y proveedor

#### Enunciado del laboratorio 5.3

**Objetivo**: practicar la detección de incompatibilidades
entre lo que un consumidor espera y lo que un proveedor
ofrece, aplicando la perspectiva de validación de contratos.

**Contexto**: dos equipos trabajan en el proyecto B2B. El
equipo A desarrolla el frontend (consumidor) y el equipo B
desarrolla la API de devoluciones (proveedor). Cada equipo
ha trabajado con su propia versión del contrato. A
continuación se presenta lo que cada equipo asume.

**Lo que el frontend (consumidor) espera**:

```text
POST /api/v1/devoluciones
Request:
{
  "order_id": "string",
  "items": [
    {
      "product_id": "string",
      "qty": "number",
      "reason": "string (texto libre)"
    }
  ],
  "photos": ["base64 encoded string"]
}

Response 200:
{
  "id": "string",
  "status": "pending",
  "created_at": "timestamp",
  "estimated_refund": "number"
}

Response 400:
{
  "message": "string"
}
```

**Lo que la API (proveedor) implementa**:

Se usa el contrato API-DEV-001 definido en el
Laboratorio 5.1.

**Instrucciones**:

1. Compara campo por campo lo que el consumidor espera
   con lo que el proveedor ofrece.
2. Clasifica cada diferencia como: incompatibilidad
   bloqueante (rompe la integración), incompatibilidad
   menor (funciona pero con pérdida de información),
   o diferencia cosmética (no afecta al funcionamiento).
3. Para cada incompatibilidad, propón la resolución:
   ¿quién debe cambiar? ¿El consumidor, el proveedor
   o ambos?
4. Escribe los tests de contrato que habrían detectado
   estas incompatibilidades antes de la integración.

#### Solución del laboratorio 5.3

##### Análisis campo por campo

###### Diferencias en el request

**Nombre del campo de pedido**:
Consumidor envía `order_id`; proveedor espera `pedido_id`.
Clasificación: bloqueante. La petición fallará con error
400 por campo obligatorio ausente, ya que el proveedor no
reconoce `order_id` y no recibe `pedido_id`.
Resolución: una de las partes debe cambiar. Se recomienda
que el consumidor se adapte al contrato del proveedor ya
que la API es el sistema de referencia. Si el frontend ya
está en producción con otra API que usa `order_id`, el
proveedor puede aceptar ambos nombres durante un periodo
de transición.

**Nombre del array de productos**:
Consumidor envía `items`; proveedor espera `lineas`.
Clasificación: bloqueante. Mismo problema que el anterior.
Resolución: el consumidor se adapta al contrato.

**Nombre del campo de cantidad**:
Consumidor envía `qty`; proveedor espera `cantidad`.
Clasificación: bloqueante. El proveedor ignorará `qty` y
dará error por `cantidad` ausente.
Resolución: el consumidor se adapta.

**Campo de motivo**:
Consumidor envía `reason` como texto libre; proveedor espera
`motivo` como enum con valor de una lista predefinida más un
campo separado `descripcion`.
Clasificación: bloqueante. El campo no solo tiene nombre
diferente, sino tipo y semántica diferentes. El consumidor
envía un texto libre; el proveedor espera un valor de enum.
Resolución: el consumidor debe implementar un selector con
los valores del enum y enviar `motivo` y `descripcion` como
campos separados. Requiere cambio en la interfaz de usuario.

**Campo de imágenes**:
Consumidor envía `photos` como array de strings base64; el
proveedor espera `imagenes` como array de URLs (las imágenes
se suben previamente a un servicio de almacenamiento).
Clasificación: bloqueante. El proveedor no acepta imágenes
codificadas en base64 en el body; espera URLs de imágenes
ya subidas. El consumidor necesita un paso previo de subida.
Resolución: el consumidor debe implementar un flujo de
subida de imágenes antes de crear la solicitud y enviar las
URLs resultantes.

###### Diferencias en la respuesta

**Código de respuesta de éxito**:
Consumidor espera 200 OK; proveedor devuelve 201 Created.
Clasificación: incompatibilidad menor. Muchos clientes HTTP
tratan 200 y 201 como éxito, pero si el frontend filtra
solo por `status === 200`, la respuesta 201 se interpretará
como error.
Resolución: el consumidor debe aceptar cualquier código 2xx
como éxito (buena práctica general).

**Nombre del campo de ID**:
Consumidor espera `id`; proveedor devuelve `devolucion_id`.
Clasificación: bloqueante. El frontend no encontrará el ID
de la solicitud en la respuesta.
Resolución: el consumidor se adapta al nombre del proveedor.

**Campo de estado**:
Consumidor espera `status: "pending"`; proveedor devuelve
`estado: "pendiente_revision"`.
Clasificación: bloqueante. Diferencia en nombre del campo
y en el valor del enum (inglés vs. español, valor diferente).
Resolución: el consumidor debe mapear los valores de estado
del proveedor a su representación interna.

**Campo de fecha**:
Consumidor espera `created_at` como timestamp; proveedor
devuelve `fecha_solicitud` en formato ISO 8601.
Clasificación: incompatibilidad menor. El nombre difiere
y el formato puede requerir parsing diferente, pero ISO
8601 es un formato estándar que la mayoría de parsers
manejan.
Resolución: el consumidor adapta el nombre del campo. El
formato ISO 8601 es más estándar que "timestamp" genérico.

**Campo de importe estimado**:
Consumidor espera `estimated_refund`; proveedor no devuelve
este campo en la respuesta de creación (se calcula al
aprobar).
Clasificación: incompatibilidad menor. El frontend mostrará
un valor vacío o un error si intenta leer un campo
inexistente. No rompe la integración pero degrada la
experiencia.
Resolución: el frontend muestra "Importe pendiente de
valoración" en lugar de un importe concreto. El campo se
obtendrá cuando la solicitud sea aprobada mediante
API-DEV-002.

**Estructura de errores**:
Consumidor espera `{ "message": "string" }`; proveedor
devuelve `{ "error": "CODE", "mensaje": "string",
"detalles": [...] }`.
Clasificación: incompatibilidad menor. El consumidor
buscará el campo `message` (en inglés) que no existe; el
proveedor usa `mensaje` (en español) y tiene estructura
más rica.
Resolución: el consumidor adapta su manejo de errores a
la estructura del proveedor, aprovechando el array de
detalles para mostrar errores por campo.

##### Resumen de incompatibilidades

```text
BLOQUEANTES (5):
  1. order_id vs pedido_id (nombre de campo)
  2. items vs lineas (nombre de campo)
  3. qty vs cantidad (nombre de campo)
  4. reason (texto libre) vs motivo (enum) +
     descripcion (semántica diferente)
  5. photos (base64) vs imagenes (URLs)
     (mecanismo diferente)

MENORES (4):
  6. Código 200 vs 201 (código de respuesta)
  7. id vs devolucion_id (nombre en respuesta)
  8. status/pending vs estado/pendiente_revision
     (nombre y valor en respuesta)
  9. estimated_refund ausente en respuesta

COSMÉTICAS (1):
  10. message vs mensaje + detalles (estructura
      de error más rica en proveedor)
```

##### Tests de contrato que habrían detectado los problemas

```text
TESTS DEL LADO DEL CONSUMIDOR
(verifican que el consumidor envía lo que el contrato
exige)

Test C-1: Nombres de campos en el request
  Dado el contrato API-DEV-001,
  Cuando el consumidor construye la petición de
    creación de devolución,
  Entonces el body contiene los campos "pedido_id",
    "lineas" (con "producto_id", "cantidad", "motivo")
    e "imagenes", y NO contiene "order_id", "items",
    "qty", "reason" ni "photos".

Test C-2: Motivo como enum
  Dado el contrato API-DEV-001,
  Cuando el consumidor envía una solicitud de
    devolución,
  Entonces el campo "motivo" contiene uno de los
    valores del enum definido (danado, incorrecto,
    no_necesario, error_cantidad, otro) y NO contiene
    texto libre.

Test C-3: Imágenes como URLs
  Dado el contrato API-DEV-001,
  Cuando el consumidor adjunta imágenes,
  Entonces el campo "imagenes" contiene URLs de
    imágenes previamente subidas, NO strings base64.

Test C-4: Manejo de respuesta 201
  Dado el contrato API-DEV-001,
  Cuando el proveedor responde con código 201,
  Entonces el consumidor lo interpreta como éxito
    y extrae "devolucion_id", "referencia", "estado"
    y "fecha_solicitud" de la respuesta.

Test C-5: Manejo de campo de estado
  Dado el contrato API-DEV-001,
  Cuando la respuesta contiene
    estado: "pendiente_revision",
  Entonces el consumidor lo mapea a su representación
    visual (p. ej., "Pendiente de revisión" en la UI).

TESTS DEL LADO DEL PROVEEDOR
(verifican que el proveedor responde según el contrato)

Test P-1: Respuesta 201 con estructura correcta
  Dado el contrato API-DEV-001,
  Cuando se recibe una petición válida,
  Entonces la respuesta tiene código 201 y contiene
    los campos "devolucion_id" (uuid), "referencia"
    (string), "estado" ("pendiente_revision"),
    "fecha_solicitud" (ISO 8601), "lineas" (array)
    y "gestor_asignado" (string).

Test P-2: Error 400 con estructura de detalles
  Dado el contrato API-DEV-001,
  Cuando se recibe una petición con campo obligatorio
    ausente,
  Entonces la respuesta tiene código 400 y contiene
    "error": "VALIDATION_ERROR", "mensaje" (string)
    y "detalles" (array con campo, codigo y mensaje).

Test P-3: Error 409 por estado inválido
  Dado un pedido en estado "confirmado" (no entregado),
  Cuando se recibe una solicitud de devolución para
    ese pedido,
  Entonces la respuesta tiene código 409 y contiene
    "error": "INVALID_ORDER_STATE".

Test P-4: Idempotencia de campos
  Dado el contrato API-DEV-001,
  Cuando la respuesta de creación se serializa a JSON,
  Entonces NO contiene campos no definidos en el
    contrato (no hay campos extra que puedan confundir
    al consumidor).
```

##### Lecciones aprendidas

Este ejercicio demuestra que la mayoría de las
incompatibilidades se deben a **ausencia de un contrato
único compartido**. Cada equipo trabajó con su propia
interpretación, lo que produjo divergencias en nombres de
campos, tipos de datos, enums, mecanismos de subida de
archivos y códigos de respuesta.

Las prácticas que habrían prevenido estos problemas son:

1. **Contrato único como fuente de verdad**: un documento
   o archivo OpenAPI compartido entre ambos equipos,
   versionado y accesible.
2. **Tests de contrato en CI/CD**: ejecutados en cada
   commit de ambos equipos. Si el consumidor cambia su
   modelo de datos o el proveedor modifica su respuesta,
   el test de contrato falla antes de que el cambio
   llegue a integración.
3. **Reunión de alineación inicial**: 30 minutos entre
   ambos equipos para revisar el contrato antes de
   empezar a implementar. Los 5 problemas bloqueantes
   se habrían detectado en esta reunión.
4. **Generación de código a partir del contrato**: si
   ambos equipos generan sus modelos de datos a partir
   del mismo archivo OpenAPI, las incompatibilidades de
   nombres y tipos son imposibles por construcción.
