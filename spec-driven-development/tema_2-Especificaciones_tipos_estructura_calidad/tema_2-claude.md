# Tema 2. Especificaciones: tipos, estructura y calidad

---

## 2.1. Introducción

En el Tema 1 establecimos que la especificación es el artefacto central de SDD: la fuente de verdad compartida que guía el diseño, la implementación y la validación. Pero decir "hay que especificar" no es suficiente. La diferencia entre un proyecto que funciona bien con SDD y uno que lo abandona a las pocas semanas está en **la calidad de las especificaciones que produce**.

Este tema aborda las preguntas prácticas que surgen cuando un equipo decide adoptar SDD:

- ¿Qué tipos de especificaciones existen y cuándo se usa cada uno?
- ¿Cómo se estructura una especificación para que sea útil, no solo completa?
- ¿Qué hace que una especificación sea buena y cómo se detecta una mala?
- ¿Qué criterios de calidad aplicar para evaluar y mejorar las especificaciones del equipo?

---

## 2.2. Tipos de especificaciones en un proyecto software

No todas las especificaciones son iguales ni sirven para lo mismo. Un proyecto software genera distintos tipos de especificaciones según la fase del ciclo de vida, el nivel de abstracción y el público al que van dirigidas.

### 2.2.1. Especificación funcional

**Qué describe**: el comportamiento del sistema desde el punto de vista del usuario o del negocio. Responde a la pregunta: *¿qué hace el sistema?*

**Contenido típico**:
- Funcionalidades que ofrece el sistema.
- Flujos de interacción entre el usuario y el sistema.
- Reglas de negocio que rigen el comportamiento.
- Restricciones funcionales (qué se permite, qué no).

**Ejemplo**:
> Cuando un cliente añade un producto al carrito y la cantidad solicitada supera el stock disponible, el sistema ajusta automáticamente la cantidad al máximo disponible y muestra un aviso: "Solo quedan X unidades disponibles. Hemos ajustado la cantidad."

**Quién la produce**: analista de negocio, product owner, en colaboración con desarrollo y QA.

**Quién la consume**: todo el equipo (desarrollo, QA, diseño UX, operaciones).

**Riesgo si falta**: el equipo implementa según su interpretación, que puede no coincidir con la del negocio. Los bugs funcionales se descubren tarde.

### 2.2.2. Especificación técnica

**Qué describe**: las decisiones de diseño y arquitectura del sistema. Responde a la pregunta: *¿cómo está construido el sistema?*

**Contenido típico**:
- Arquitectura del sistema (componentes, capas, servicios).
- Tecnologías seleccionadas y justificación.
- Modelos de datos (entidades, relaciones, esquemas).
- Patrones de diseño aplicados.
- Decisiones de infraestructura relevantes.

**Ejemplo**:
> El servicio de notificaciones se implementa como un microservicio independiente que consume eventos de un broker Kafka (topic `pedidos.confirmados`). Utiliza un patrón de reintentos con backoff exponencial (máximo 5 reintentos, base 2 segundos) para el envío de correos a través de la API de SendGrid.

**Quién la produce**: arquitecto, tech lead, desarrolladores senior.

**Quién la consume**: equipo de desarrollo, operaciones, futuros mantenedores.

**Riesgo si falta**: las decisiones de arquitectura quedan en la cabeza de quien las tomó. Cuando esa persona se va, el equipo hereda un sistema que no entiende. Las decisiones se repiten o se contradicen.

### 2.2.3. Especificación de interfaz (UI/UX)

**Qué describe**: cómo interactúa el usuario con el sistema. Responde a la pregunta: *¿cómo se ve y se usa?*

**Contenido típico**:
- Wireframes o mockups de las pantallas.
- Flujos de navegación entre pantallas.
- Comportamiento de los componentes de interfaz (estados, transiciones, validaciones en cliente).
- Criterios de accesibilidad.
- Textos, mensajes de error y microcopy.

**Ejemplo**:
> El formulario de búsqueda avanzada se despliega al pulsar "Filtros" bajo la barra de búsqueda principal. Contiene tres campos: Tipo de documento (desplegable múltiple), Fecha (selector de rango) y Autor (autocompletado con debounce de 300 ms). Al aplicar filtros, la URL se actualiza con los parámetros de búsqueda para permitir compartir el enlace.

**Quién la produce**: diseñador UX/UI, en colaboración con analista y desarrollo frontend.

**Quién la consume**: desarrollo frontend, QA, analista.

**Riesgo si falta**: el frontend se implementa con decisiones de UX improvisadas. La experiencia de usuario es inconsistente entre pantallas. Los detalles de interacción (estados de carga, mensajes de error, comportamiento responsive) se resuelven en el momento, generando deuda de UX.

### 2.2.4. Especificación de contrato (API / integración)

**Qué describe**: la interfaz de comunicación entre componentes, servicios o sistemas. Responde a la pregunta: *¿cómo se comunican las partes del sistema entre sí?*

**Contenido típico**:
- Endpoints (URL, método HTTP, parámetros).
- Formato de entrada y salida (esquemas JSON, XML, protobuf).
- Códigos de respuesta y su significado.
- Autenticación y autorización requeridas.
- Límites de uso (rate limiting, tamaños máximos).
- Versionado de la API.

**Ejemplo**:
> `POST /api/v2/pedidos`
>
> **Request body**:
> ```json
> {
>   "cliente_id": "string (UUID, obligatorio)",
>   "lineas": [
>     {
>       "producto_id": "string (UUID, obligatorio)",
>       "cantidad": "integer (1-999, obligatorio)"
>     }
>   ],
>   "direccion_envio_id": "string (UUID, obligatorio)"
> }
> ```
>
> **Respuestas**:
> - `201 Created`: pedido creado. Body: `{ "pedido_id": "UUID", "estado": "pendiente", "total": "decimal" }`
> - `400 Bad Request`: error de validación. Body: `{ "errores": [{ "campo": "string", "mensaje": "string" }] }`
> - `409 Conflict`: stock insuficiente para una o más líneas. Body incluye detalle de productos afectados.
> - `401 Unauthorized`: token ausente o inválido.

**Quién la produce**: desarrollo backend, arquitecto, en colaboración con los equipos consumidores.

**Quién la consume**: desarrollo frontend, desarrollo de otros servicios, QA, integradores externos.

**Riesgo si falta**: los equipos que consumen la API implementan contra suposiciones. Los errores de integración aparecen en testing o en producción. Cada cambio en la API rompe consumidores que nadie avisó.

### 2.2.5. Especificación de aceptación

**Qué describe**: las condiciones que debe cumplir el sistema para que una funcionalidad se considere terminada. Responde a la pregunta: *¿cómo sabemos que esto está hecho y funciona?*

**Contenido típico**:
- Criterios de aceptación expresados como condiciones verificables.
- Escenarios de prueba concretos (con datos de entrada y resultado esperado).
- Precondiciones necesarias para ejecutar la validación.
- Criterios no funcionales asociados (rendimiento, accesibilidad, seguridad).

**Ejemplo**:
> **Funcionalidad**: Cancelación de pedido por el cliente.
>
> **Criterios de aceptación**:
> 1. Un cliente puede cancelar un pedido en estado "pendiente" o "en preparación" desde la pantalla de detalle del pedido.
> 2. Al cancelar, el sistema solicita confirmación con el mensaje: "¿Seguro que deseas cancelar este pedido?"
> 3. Tras confirmar, el estado del pedido pasa a "cancelado" y se restaura el stock de los productos.
> 4. El cliente recibe un correo de confirmación de cancelación en un plazo máximo de 5 minutos.
> 5. Un pedido en estado "enviado" o "entregado" no puede cancelarse. El botón de cancelación no aparece.

**Quién la produce**: analista de negocio + QA + desarrollo, colaborativamente.

**Quién la consume**: QA (para validar), desarrollo (para saber cuándo ha terminado), product owner (para aceptar la entrega).

**Riesgo si falta**: nadie sabe cuándo una funcionalidad está "terminada". Los debates sobre si algo es un bug o una feature se multiplican. La aceptación se convierte en un proceso subjetivo y conflictivo.

### 2.2.6. Especificación de dominio (reglas de negocio)

**Qué describe**: las reglas, restricciones y lógica propias del dominio de negocio, independientes de la interfaz o la tecnología. Responde a la pregunta: *¿qué reglas rigen este negocio?*

**Contenido típico**:
- Reglas de cálculo (precios, descuentos, impuestos, comisiones).
- Restricciones de estado (transiciones permitidas, invariantes).
- Políticas de negocio (plazos, límites, condiciones).
- Glosario de términos del dominio.

**Ejemplo**:
> **Regla DN-014**: Descuento por volumen.
>
> Si un pedido contiene más de 100 unidades del mismo producto, se aplica un descuento del 5% sobre el precio unitario de ese producto. El descuento se aplica por línea de pedido, no sobre el total. No es acumulable con el descuento por código promocional. En caso de conflicto, se aplica el descuento mayor.

**Quién la produce**: analista de negocio, experto de dominio, en colaboración con desarrollo.

**Quién la consume**: desarrollo (para implementar la lógica), QA (para validar los cálculos), negocio (para verificar que la regla está correctamente recogida).

**Riesgo si falta**: las reglas de negocio se implementan de forma dispersa en el código, sin documentación. Cuando cambia una regla, nadie sabe todos los lugares donde está implementada. Los tests no cubren los casos límite porque nadie los definió explícitamente.

### 2.2.7. Cuadro resumen de tipos

| Tipo | Pregunta clave | Nivel de abstracción | Audiencia principal |
|---|---|---|---|
| Funcional | ¿Qué hace el sistema? | Alto (negocio) | Todos |
| Técnica | ¿Cómo está construido? | Medio-bajo (técnico) | Desarrollo, operaciones |
| De interfaz | ¿Cómo se ve y se usa? | Medio (interacción) | Frontend, UX, QA |
| De contrato | ¿Cómo se comunican las partes? | Medio-bajo (integración) | Desarrollo, integradores |
| De aceptación | ¿Cómo se valida? | Medio (verificación) | QA, PO, desarrollo |
| De dominio | ¿Qué reglas rigen el negocio? | Alto (dominio) | Desarrollo, negocio, QA |

---

## 2.3. Estructura de una buena especificación

Una especificación puede ser de cualquier tipo, pero para que sea útil necesita una estructura consistente. No se trata de imponer una plantilla rígida, sino de garantizar que toda especificación contenga la información mínima para ser comprensible, localizable y verificable.

### 2.3.1. Elementos estructurales esenciales

Toda especificación, independientemente de su tipo, debería incluir:

**Identificador único**: un código que permita referenciarla sin ambigüedad. Puede ser un ID numérico, un código alfanumérico o una clave legible (p. ej., `FUNC-042`, `API-PEDIDOS-003`, `DN-014`). Lo importante es que sea único dentro del proyecto y estable en el tiempo.

**Título descriptivo**: una frase corta que permita identificar la especificación sin leerla entera. Debe ser lo bastante específica para distinguirla de otras. "Gestión de pedidos" es demasiado genérico. "Cancelación de pedido por el cliente antes del envío" es útil.

**Contexto y motivación**: por qué existe esta especificación. ¿Qué necesidad de negocio resuelve? ¿Qué problema aborda? Este campo es el que más se omite y el que más falta hace cuando alguien necesita entender una especificación meses después de redactarla.

**Descripción del comportamiento o diseño**: el cuerpo de la especificación. Según el tipo, puede ser una descripción funcional, un contrato de API, un diagrama de arquitectura, un conjunto de reglas de negocio, etc. Es la parte que responde a la pregunta central de la especificación.

**Precondiciones**: qué debe ser cierto antes de que aplique esta especificación. Por ejemplo: "El usuario está autenticado", "El pedido está en estado pendiente", "El servicio de notificaciones está disponible".

**Postcondiciones**: qué debe ser cierto después de ejecutar lo especificado. Por ejemplo: "El pedido queda en estado cancelado", "El stock se ha restaurado", "Se ha enviado un correo de confirmación".

**Criterios de verificación**: cómo se comprueba que la implementación cumple la especificación. Puede ser una referencia a tests concretos, una descripción de la prueba manual necesaria o una métrica observable.

**Estado y versión**: en qué estado se encuentra la especificación (borrador, en revisión, aprobada, implementada, obsoleta) y qué versión es. Esto es especialmente importante cuando la especificación evoluciona a lo largo del proyecto.

**Autor y fecha**: quién la redactó y cuándo. Parece trivial, pero es esencial para saber a quién preguntar dudas y para evaluar si la información puede estar desactualizada.

**Relaciones y dependencias**: qué otras especificaciones se relacionan con esta. ¿De cuál depende? ¿Cuáles dependen de ella? Esto es la base de la trazabilidad que veremos en el Tema 7.

### 2.3.2. Ejemplo de especificación estructurada

```
ID:          FUNC-027
Título:      Cancelación de pedido por el cliente
Estado:      Aprobada (v1.2)
Autor:       María López — 2025-03-15
Última mod.: Carlos Ruiz — 2025-04-02 (v1.2: añadido límite temporal)

CONTEXTO
El cliente necesita poder cancelar pedidos que aún no se han enviado.
Actualmente no existe esta funcionalidad y el cliente debe llamar
a atención al cliente, lo que genera carga operativa innecesaria.

DESCRIPCIÓN
El sistema permite al cliente cancelar un pedido desde la pantalla
de detalle del pedido, siempre que se cumplan las precondiciones.

PRECONDICIONES
- El usuario está autenticado como el titular del pedido.
- El pedido está en estado "pendiente" o "en preparación".
- Han pasado menos de 2 horas desde la confirmación del pedido.

COMPORTAMIENTO
1. El cliente pulsa "Cancelar pedido" en la pantalla de detalle.
2. El sistema muestra un diálogo de confirmación:
   "¿Seguro que deseas cancelar el pedido #[ID]?
    Esta acción no se puede deshacer."
   [Confirmar cancelación] [Volver]
3. Si el cliente confirma:
   a. El estado del pedido pasa a "cancelado".
   b. Se restaura el stock de todos los productos del pedido.
   c. Si se realizó un cobro, se inicia la devolución automática.
   d. Se envía un correo de confirmación al cliente.
4. Si el cliente pulsa "Volver", no se realiza ninguna acción.

POSTCONDICIONES
- El pedido está en estado "cancelado".
- El stock de cada producto se ha incrementado en la cantidad del pedido.
- Se ha iniciado el proceso de devolución (si aplica).
- El cliente ha recibido un correo de confirmación de cancelación.

CASOS ESPECIALES
- Si el pedido cambia de estado a "enviado" entre que el cliente
  abre la pantalla y pulsa "Confirmar", el sistema muestra:
  "Este pedido ya ha sido enviado y no puede cancelarse."
- Si el servicio de devoluciones no está disponible, la cancelación
  se registra pero la devolución se encola para procesamiento posterior.

CRITERIOS DE VERIFICACIÓN
- Test: cliente cancela pedido pendiente → estado = cancelado, stock restaurado.
- Test: cliente intenta cancelar pedido enviado → error, estado sin cambios.
- Test: cliente intenta cancelar pedido con más de 2 horas → botón no disponible.
- Test: cancelación con cobro previo → devolución iniciada.
- Test: correo de confirmación recibido en < 5 minutos tras cancelación.

DEPENDENCIAS
- FUNC-012: Flujo de confirmación de pedido (define los estados).
- API-PAGOS-005: Contrato del servicio de devoluciones.
- DN-008: Política de cancelaciones y devoluciones.
```

### 2.3.3. Adaptación según el tipo

La estructura anterior es una referencia general. Cada tipo de especificación enfatiza elementos distintos:

| Tipo | Elementos que cobra más peso |
|---|---|
| Funcional | Descripción del comportamiento, casos especiales, criterios de aceptación |
| Técnica | Diagramas, decisiones de diseño y su justificación, restricciones técnicas |
| De interfaz | Mockups, flujos de navegación, estados de componentes, microcopy |
| De contrato | Esquemas de entrada/salida, códigos de error, ejemplos de petición/respuesta |
| De aceptación | Escenarios concretos con datos, precondiciones detalladas, resultados esperados |
| De dominio | Reglas formales, tablas de decisión, ejemplos numéricos, glosario |

---

## 2.4. Calidad de las especificaciones

Tener especificaciones no garantiza que sean buenas. Una especificación de mala calidad puede ser peor que no tener ninguna: da una falsa sensación de seguridad, genera confianza en información errónea y consume tiempo sin aportar valor.

### 2.4.1. Criterios de calidad

Una buena especificación cumple los siguientes criterios:

**Claridad**: se entiende sin ambigüedad. Cualquier persona del equipo, al leerla, llega a la misma interpretación. No requiere "preguntar al autor" para entenderla.

Señales de falta de claridad:
- Uso de pronombres sin referente claro ("el sistema lo procesa" — ¿qué es "lo"?).
- Frases largas con múltiples subordinadas.
- Mezcla de niveles de abstracción en el mismo párrafo.
- Jerga que no todo el equipo comparte.

**Precisión**: define exactamente lo que quiere decir, sin margen de interpretación. Los valores concretos, los límites, los formatos y las condiciones están explícitos.

Señales de falta de precisión:
- Adjetivos vagos: "rápido", "grande", "suficiente", "adecuado".
- Cuantificadores indefinidos: "muchos", "algunos", "varios".
- Verbos ambiguos: "gestionar", "manejar", "procesar" (sin detallar qué implican).
- Ausencia de valores límite: "el campo acepta texto" (¿cuántos caracteres? ¿qué caracteres?).

**Completitud**: cubre todos los aspectos relevantes del tema que especifica. No deja huecos que obliguen al desarrollador a tomar decisiones de diseño no autorizadas.

Señales de falta de completitud:
- No se describen los casos de error ("¿qué pasa si falla?").
- No se definen los casos límite ("¿qué pasa con cero elementos? ¿con el máximo?").
- No se especifica el comportamiento en estados intermedios ("¿qué se muestra mientras carga?").
- Ausencia de postcondiciones ("¿qué queda en el sistema después?").

**Consistencia**: no se contradice consigo misma ni con otras especificaciones del proyecto. Los términos se usan siempre con el mismo significado. Los formatos son uniformes.

Señales de inconsistencia:
- El mismo concepto recibe nombres distintos en distintas especificaciones ("cliente" vs. "usuario" vs. "comprador").
- Dos especificaciones definen comportamientos distintos para el mismo caso.
- Los formatos de datos difieren entre la especificación funcional y la de contrato.

**Verificabilidad**: cada afirmación de la especificación se puede comprobar de forma objetiva. No contiene afirmaciones que solo se puedan evaluar subjetivamente.

Señales de falta de verificabilidad:
- Criterios subjetivos: "la interfaz debe ser atractiva".
- Afirmaciones no medibles: "el sistema debe ser escalable".
- Ausencia de criterios de verificación explícitos.

**Trazabilidad**: se puede rastrear su origen (de qué necesidad viene) y su destino (qué código, tests y artefactos la implementan). Tiene un identificador único y relaciones explícitas con otros artefactos.

Señales de falta de trazabilidad:
- No tiene identificador único.
- No referencia la necesidad de negocio que la origina.
- No está vinculada a los tests que la validan.

**Concisión**: dice lo necesario sin redundancias ni relleno. Una especificación larga no es mejor; es más difícil de leer, mantener y revisar.

Señales de falta de concisión:
- Repetición de la misma información en distintos apartados.
- Explicaciones obvias que no aportan ("un campo de texto es un campo donde el usuario escribe texto").
- Introducciones largas que retrasan la información relevante.

### 2.4.2. Antipatrones habituales

Estos son errores recurrentes que degradan la calidad de las especificaciones:

**El requisito deseo**: expresa una intención sin concretar. "El sistema debería facilitar la gestión de documentos". ¿Qué significa "facilitar"? ¿Qué operaciones incluye "gestión"? Este tipo de requisito no es implementable ni verificable.

**La especificación enciclopedia**: un documento de 200 páginas que nadie lee. Contiene todo, pero es tan extenso que resulta inútil. La información relevante se pierde entre párrafos de contexto innecesario. Es preferible tener 50 especificaciones modulares de 2 páginas cada una que un monolito de 200.

**La especificación eco**: repite literalmente lo que dijo el cliente sin análisis, estructuración ni precisión. "El cliente quiere poder buscar cosas." Esto no es una especificación; es una transcripción.

**La especificación fantasma**: existe formalmente pero nadie la consulta porque está desactualizada, es difícil de encontrar o está escrita en un formato que no se integra en el flujo de trabajo del equipo.

**El contrato implícito**: la API o el servicio existe, pero su contrato no está documentado. Los consumidores descubren el comportamiento por prueba y error o leyendo el código fuente.

**La especificación wishful thinking**: describe el sistema ideal, no el que se va a construir. Incluye funcionalidades que no están en el alcance, rendimiento que la infraestructura no puede dar o integraciones que no se han aprobado.

### 2.4.3. Checklist de revisión de calidad

Esta lista se puede usar como guía rápida para revisar cualquier especificación antes de darla por válida:

| # | Pregunta | Sí/No |
|---|---|---|
| 1 | ¿Tiene un identificador único? | |
| 2 | ¿El título permite identificarla sin leer el cuerpo? | |
| 3 | ¿Se entiende sin necesidad de preguntar al autor? | |
| 4 | ¿Los términos ambiguos están definidos o concretados? | |
| 5 | ¿Están definidos los casos de error y los casos límite? | |
| 6 | ¿Tiene precondiciones y postcondiciones explícitas? | |
| 7 | ¿Los criterios de verificación son concretos y ejecutables? | |
| 8 | ¿Es consistente con las especificaciones relacionadas? | |
| 9 | ¿Se puede verificar cada afirmación de forma objetiva? | |
| 10 | ¿Indica su estado, versión y autor? | |
| 11 | ¿Referencia las especificaciones de las que depende? | |
| 12 | ¿Es concisa o contiene información redundante o irrelevante? | |

---

## 2.5. Detección de problemas en especificaciones

Más allá de conocer los criterios de calidad, es fundamental desarrollar la habilidad de **detectar problemas** en especificaciones ya escritas. Esta habilidad se entrena con práctica y se apoya en técnicas concretas.

### 2.5.1. Lectura adversarial

Consiste en leer la especificación con la intención deliberada de encontrar formas de malinterpretarla. Para cada afirmación, el revisor se pregunta: "¿Podría un desarrollador razonable entender esto de otra manera?"

Si la respuesta es sí, la especificación tiene un problema de claridad o precisión.

### 2.5.2. Análisis de casos límite

Para cada regla o comportamiento descrito, el revisor identifica los valores extremos: cero, uno, máximo, vacío, nulo, duplicado, concurrente. Si la especificación no define qué pasa en estos casos, tiene un hueco de completitud.

Preguntas útiles:
- ¿Qué pasa con cero elementos?
- ¿Qué pasa si el campo está vacío?
- ¿Qué pasa con el valor máximo permitido?
- ¿Qué pasa si dos usuarios hacen lo mismo a la vez?
- ¿Qué pasa si el servicio externo no responde?
- ¿Qué pasa si el usuario cancela a mitad del proceso?

### 2.5.3. Verificación cruzada

Consiste en contrastar la especificación con otros artefactos del proyecto para detectar inconsistencias:
- ¿El modelo de datos soporta lo que la especificación funcional describe?
- ¿El contrato de API es coherente con el comportamiento funcional?
- ¿Los criterios de aceptación cubren todos los flujos descritos?
- ¿El glosario de términos se usa de forma consistente?

### 2.5.4. Revisión por perfiles

Una especificación revisada solo por quien la escribió rara vez mejora. La revisión más efectiva es la que involucra distintos perfiles:
- **Desarrollo** detecta huecos técnicos e implementabilidad.
- **QA** detecta falta de verificabilidad y casos no cubiertos.
- **Negocio** detecta desviaciones respecto a la necesidad real.
- **UX** detecta flujos de interacción incompletos o inconsistentes.

---

## 2.6. Resumen del tema

Las especificaciones no son un artefacto genérico. Existen distintos tipos (funcional, técnica, de interfaz, de contrato, de aceptación, de dominio), cada uno con un propósito, una audiencia y un contenido diferenciado.

Una buena especificación se estructura con elementos esenciales (identificador, título, contexto, comportamiento, precondiciones, postcondiciones, criterios de verificación, estado, relaciones) y cumple criterios de calidad medibles: claridad, precisión, completitud, consistencia, verificabilidad, trazabilidad y concisión.

Detectar problemas en las especificaciones es una habilidad que se desarrolla con técnicas como la lectura adversarial, el análisis de casos límite, la verificación cruzada y la revisión por perfiles.

En el siguiente tema abordaremos cómo se descubren y refinan los requisitos antes de convertirlos en especificaciones.

---

---

# Laboratorios del Tema 2

---

## Laboratorio 2.1: Reescritura de requisitos ambiguos en formato especificable

### Enunciado

**Objetivo**: practicar la transformación de requisitos vagos, incompletos o ambiguos en especificaciones claras, precisas y verificables, aplicando la estructura y los criterios de calidad del tema.

**Instrucciones**

Se proporcionan 6 requisitos tal como los recibiría un equipo de desarrollo en un proyecto real. Para cada uno:

1. Identifica los problemas de calidad (ambigüedad, falta de precisión, huecos, falta de verificabilidad).
2. Formula al menos 3 preguntas que harías al stakeholder para clarificar el requisito.
3. Reescribe el requisito como una especificación verificable, con la estructura completa vista en el tema.
4. Define al menos 2 criterios de verificación concretos.

**Requisitos a reescribir**:

| # | Requisito original |
|---|---|
| A | "El sistema debe permitir la gestión de usuarios." |
| B | "Las búsquedas deben devolver resultados relevantes." |
| C | "El sistema debe enviar notificaciones cuando ocurra algo importante." |
| D | "Los informes deben poder exportarse en varios formatos." |
| E | "El sistema debe cumplir con la normativa de protección de datos." |
| F | "El dashboard debe mostrar información útil para el gestor." |

---

### Solución

### Requisito A: "El sistema debe permitir la gestión de usuarios"

**Problemas identificados**:
- "Gestión" es un término paraguas que puede significar cualquier combinación de operaciones: crear, leer, modificar, eliminar, activar, desactivar, asignar roles, importar, exportar...
- No se define quién gestiona a quién (¿un administrador a los usuarios? ¿cada usuario se gestiona a sí mismo?).
- No hay restricciones de seguridad ni de roles.
- No se especifica qué datos componen un "usuario".

**Preguntas al stakeholder**:
1. ¿Qué operaciones concretas se necesitan sobre los usuarios? (crear, editar perfil, desactivar, eliminar, cambiar rol...)
2. ¿Quién puede realizar cada operación? ¿Hay roles diferenciados?
3. ¿Qué datos tiene un usuario? ¿Cuáles son obligatorios?
4. ¿Puede un usuario eliminarse completamente o solo desactivarse?
5. ¿Hay restricciones sobre la creación (dominios de email permitidos, aprobación previa)?

**Especificación reescrita**:

```
ID:       FUNC-040
Título:   Alta de usuario por administrador
Estado:   Borrador (v1.0)

CONTEXTO
Los administradores necesitan poder dar de alta usuarios en el sistema
para que accedan a la plataforma. Actualmente se hace manualmente en
base de datos.

PRECONDICIONES
- El usuario que realiza la acción tiene rol "Administrador".
- El email del nuevo usuario no existe previamente en el sistema.

DESCRIPCIÓN
El administrador accede a la sección "Usuarios" > "Nuevo usuario"
y completa el formulario con los siguientes campos:

| Campo           | Tipo       | Obligatorio | Validación                         |
|-----------------|------------|-------------|------------------------------------|
| Nombre          | Texto      | Sí          | 2-100 caracteres                   |
| Apellidos       | Texto      | Sí          | 2-150 caracteres                   |
| Email           | Email      | Sí          | Formato RFC 5322, único en sistema |
| Rol             | Selección  | Sí          | Lector / Editor / Administrador    |
| Departamento    | Selección  | No          | Lista de departamentos activos     |

Al guardar, el sistema:
1. Crea el usuario en estado "pendiente de activación".
2. Envía un correo al email indicado con un enlace de activación
   válido durante 48 horas.
3. Registra la acción en el log de auditoría.

POSTCONDICIONES
- Existe un nuevo usuario en estado "pendiente de activación".
- Se ha enviado el correo de activación.
- El log de auditoría contiene la entrada correspondiente.

CASOS ESPECIALES
- Si el email ya existe: error "Ya existe un usuario con este email".
- Si el servicio de correo falla: el usuario se crea igualmente y se
  muestra aviso "Usuario creado. El correo de activación se enviará
  cuando el servicio esté disponible." Se encola el reenvío.

CRITERIOS DE VERIFICACIÓN
1. Test: admin crea usuario con datos válidos → usuario aparece en
   el listado con estado "pendiente de activación" y se recibe correo.
2. Test: admin intenta crear usuario con email duplicado → error,
   no se crea usuario.
3. Test: usuario con rol "Lector" intenta acceder a la creación
   de usuarios → acceso denegado (HTTP 403 o pantalla no visible).
4. Test: el enlace de activación expira tras 48 horas → al pulsar
   el enlace, se muestra "Enlace expirado. Contacta con tu administrador."

DEPENDENCIAS
- FUNC-041: Activación de cuenta por el usuario.
- SEC-002: Modelo de roles y permisos.
```

---

### Requisito B: "Las búsquedas deben devolver resultados relevantes"

**Problemas identificados**:
- "Relevantes" es subjetivo: ¿relevantes según qué criterio? ¿Coincidencia exacta, parcial, semántica?
- No se define qué se busca (documentos, usuarios, pedidos...).
- No se define cómo se presenta la relevancia (ordenación, puntuación, destacado).
- No hay métricas de calidad de búsqueda.

**Preguntas al stakeholder**:
1. ¿Qué entidades se buscan? ¿Documentos, usuarios, todo?
2. ¿En qué campos se busca? (título, contenido, metadatos...)
3. ¿Qué considera el usuario como "relevante"? ¿Coincidencia exacta en título? ¿Contenido que incluya los términos?
4. ¿Cómo deben ordenarse los resultados?
5. ¿Hay requisitos de rendimiento para la búsqueda?

**Especificación reescrita**:

```
ID:       FUNC-051
Título:   Búsqueda de documentos por texto libre
Estado:   Borrador (v1.0)

CONTEXTO
Los usuarios necesitan localizar documentos rápidamente. La búsqueda
actual solo busca coincidencia exacta en el título, lo que resulta
insuficiente.

PRECONDICIONES
- El usuario está autenticado.
- Existen documentos en el sistema accesibles para el usuario.

DESCRIPCIÓN
El usuario introduce un texto de búsqueda (mínimo 2 caracteres) en
la barra de búsqueda principal. El sistema busca coincidencias en:
1. Título del documento (peso x3).
2. Contenido del documento (peso x1).
3. Etiquetas del documento (peso x2).

Los resultados se ordenan por puntuación de relevancia descendente.
La puntuación se calcula como la suma ponderada de coincidencias en
cada campo. Se muestran un máximo de 50 resultados paginados en
grupos de 10.

Cada resultado muestra: título (con términos de búsqueda resaltados),
fragmento de contenido con contexto (50 caracteres antes y después
de la coincidencia), fecha de última modificación y autor.

POSTCONDICIONES
- Se muestra la lista de resultados ordenada por relevancia.
- Si no hay resultados: "No se encontraron documentos para '[texto]'."

CRITERIOS DE VERIFICACIÓN
1. Test: buscar un término que aparece solo en el título de un
   documento → ese documento aparece en los primeros 3 resultados.
2. Test: buscar un término que aparece en el título de un documento A
   y en el contenido de un documento B → A aparece antes que B.
3. Test: buscar un término inexistente → mensaje "No se encontraron
   documentos".
4. Test: búsqueda con 1 carácter → no se ejecuta, se indica
   "Introduce al menos 2 caracteres".
5. Test de rendimiento: búsqueda sobre 50.000 documentos devuelve
   resultados en menos de 500 ms (p95).
```

---

### Requisito C: "El sistema debe enviar notificaciones cuando ocurra algo importante"

**Problemas identificados**:
- "Algo importante" no está definido. ¿Importante para quién? ¿Según qué criterio?
- "Notificaciones" no indica el canal (email, push, SMS, in-app).
- No se define quién recibe la notificación.
- No se indican plazos de envío.

**Preguntas al stakeholder**:
1. ¿Qué eventos concretos deben generar notificación?
2. ¿Por qué canal se envían? ¿El usuario puede configurar sus preferencias?
3. ¿Quién recibe cada tipo de notificación?
4. ¿Hay requisitos de latencia (en tiempo real, en minutos, en horas)?
5. ¿Qué contenido debe tener cada notificación?

**Especificación reescrita**:

```
ID:       FUNC-060
Título:   Notificaciones por email al cambiar el estado de un pedido
Estado:   Borrador (v1.0)

CONTEXTO
Los clientes pierden visibilidad sobre sus pedidos una vez confirmados.
Se necesita informarles proactivamente de los cambios de estado.

PRECONDICIONES
- El cliente tiene un email verificado en su perfil.
- El pedido cambia de estado.

DESCRIPCIÓN
El sistema envía un email al cliente titular del pedido cuando este
cambia a cualquiera de los siguientes estados:

| Estado destino  | Asunto del email                        | Contenido principal                      |
|-----------------|-----------------------------------------|------------------------------------------|
| En preparación  | "Tu pedido #[ID] está en preparación"   | Detalle del pedido, fecha estimada envío  |
| Enviado         | "Tu pedido #[ID] ha sido enviado"       | Número de seguimiento, enlace de tracking |
| Entregado       | "Tu pedido #[ID] ha sido entregado"     | Enlace para valorar la experiencia        |
| Cancelado       | "Tu pedido #[ID] ha sido cancelado"     | Motivo, información sobre devolución      |

El email se envía en un plazo máximo de 5 minutos tras el cambio
de estado. Si el envío falla, se reintenta hasta 3 veces con
intervalos de 1, 5 y 15 minutos.

POSTCONDICIONES
- El cliente ha recibido el email correspondiente al nuevo estado.
- El envío queda registrado en el historial de comunicaciones del pedido.

CRITERIOS DE VERIFICACIÓN
1. Test: pedido pasa a "enviado" → email recibido con número de
   seguimiento en < 5 minutos.
2. Test: pedido pasa a estado no listado (p. ej. "en revisión")
   → no se envía email.
3. Test: fallo en servicio de email → se reintenta 3 veces y se
   registra el error si persiste.
4. Test: cliente sin email verificado → no se envía email, se
   registra incidencia en log.
```

---

### Requisito D: "Los informes deben poder exportarse en varios formatos"

**Problemas identificados**:
- "Varios formatos" no enumera cuáles.
- "Informes" no indica qué informes ni cuántos hay.
- No se definen requisitos de fidelidad (¿el PDF se ve igual que en pantalla? ¿El CSV incluye todos los datos?).
- No se indica quién puede exportar ni con qué permisos.

**Preguntas al stakeholder**:
1. ¿Qué informes deben poder exportarse?
2. ¿Qué formatos concretos se necesitan? (PDF, Excel, CSV, otro)
3. ¿Todos los informes se exportan en todos los formatos o hay combinaciones específicas?
4. ¿Hay requisitos de formato para el PDF (cabecera, logo, paginación)?
5. ¿Hay límite de tamaño o de registros para la exportación?

**Especificación reescrita**:

```
ID:       FUNC-073
Título:   Exportación de informes de ventas
Estado:   Borrador (v1.0)

CONTEXTO
Los gestores necesitan descargar los informes de ventas para
compartirlos con dirección y para análisis externo en Excel.

PRECONDICIONES
- El usuario tiene rol "Gestor" o "Administrador".
- El informe se ha generado previamente en pantalla con los filtros
  deseados.

DESCRIPCIÓN
En la pantalla de cualquier informe de ventas, el usuario puede
pulsar "Exportar" y seleccionar uno de los siguientes formatos:

| Formato | Extensión | Contenido                                          |
|---------|-----------|-----------------------------------------------------|
| PDF     | .pdf      | Réplica visual del informe en pantalla. Incluye     |
|         |           | cabecera con logo, fecha de generación y filtros    |
|         |           | aplicados. Paginado en A4 vertical.                 |
| Excel   | .xlsx     | Datos tabulares completos con formato de tabla,     |
|         |           | cabeceras en negrita y columnas con tipo correcto   |
|         |           | (numérico, fecha, texto). Hoja: "Ventas".           |
| CSV     | .csv      | Datos sin formato, separados por punto y coma,      |
|         |           | codificación UTF-8 con BOM, primera fila cabeceras. |

Si el informe tiene más de 10.000 filas, la exportación se realiza
en segundo plano y el usuario recibe una notificación in-app con
el enlace de descarga cuando esté lista.

POSTCONDICIONES
- El archivo se descarga en el formato seleccionado.
- Se registra la exportación en el log de actividad del usuario.

CRITERIOS DE VERIFICACIÓN
1. Test: exportar informe de 500 filas a PDF → archivo descargado
   con logo, fecha, filtros y datos correctos.
2. Test: exportar a Excel → abrir en Excel, verificar tipos de
   columna y que no hay pérdida de datos.
3. Test: exportar a CSV → abrir con editor de texto, verificar
   separador punto y coma, UTF-8, cabeceras presentes.
4. Test: exportar informe de 15.000 filas → se procesa en segundo
   plano, notificación recibida con enlace funcional.
5. Test: usuario con rol "Lector" → botón de exportación no visible.
```

---

### Requisito E: "El sistema debe cumplir con la normativa de protección de datos"

**Problemas identificados**:
- "Normativa de protección de datos" no identifica cuál (RGPD, LOPDGDD, CCPA, otra).
- No concreta qué implica "cumplir" en términos de funcionalidad y diseño del sistema.
- Es un requisito legal que debe traducirse en múltiples especificaciones técnicas y funcionales.
- No se puede verificar como un único requisito.

**Preguntas al stakeholder**:
1. ¿Qué normativa concreta aplica? (RGPD, LOPDGDD, ambas...)
2. ¿Qué datos personales maneja el sistema?
3. ¿Se necesita funcionalidad de consentimiento explícito?
4. ¿Se necesita un mecanismo de derecho de acceso, rectificación y supresión (derechos ARCO/ARSULOP)?
5. ¿Hay requisitos de retención y eliminación de datos?
6. ¿Se requiere un Delegado de Protección de Datos o registro de actividades de tratamiento?

**Especificación reescrita (desglosada en varias)**:

```
ID:       SEC-010
Título:   Consentimiento explícito para tratamiento de datos personales
Estado:   Borrador (v1.0)

CONTEXTO
El RGPD (Reglamento General de Protección de Datos) exige que el
tratamiento de datos personales se base en un consentimiento libre,
específico, informado e inequívoco.

PRECONDICIONES
- El usuario está en el proceso de registro.

DESCRIPCIÓN
Durante el registro, antes de completar el alta, el sistema muestra:
1. Un enlace a la política de privacidad (texto completo).
2. Un checkbox NO premarcado con el texto: "He leído y acepto la
   política de privacidad y el tratamiento de mis datos personales
   con la finalidad descrita."
3. Un segundo checkbox NO premarcado (opcional) para comunicaciones
   comerciales: "Acepto recibir comunicaciones comerciales."

El registro no se puede completar sin marcar el primer checkbox.
El segundo es opcional y su valor se almacena en el perfil del usuario.

POSTCONDICIONES
- El consentimiento queda registrado con fecha, hora, versión de la
  política aceptada e IP del usuario.
- El estado del consentimiento es consultable y modificable por el usuario.

CRITERIOS DE VERIFICACIÓN
1. Test: intentar registrarse sin marcar el checkbox obligatorio
   → error, registro bloqueado.
2. Test: registrarse con checkbox marcado → consentimiento registrado
   con timestamp e IP.
3. Test: verificar que el checkbox no está premarcado por defecto.
```

```
ID:       SEC-011
Título:   Derecho de supresión (derecho al olvido)
Estado:   Borrador (v1.0)

CONTEXTO
El RGPD reconoce el derecho del interesado a obtener la supresión
de sus datos personales.

PRECONDICIONES
- El usuario está autenticado.

DESCRIPCIÓN
El usuario puede solicitar la eliminación de su cuenta y datos
personales desde Perfil > Privacidad > "Solicitar eliminación de
mi cuenta". El sistema:
1. Solicita confirmación con contraseña.
2. Inicia un periodo de gracia de 30 días durante el cual la
   cuenta se desactiva pero los datos se conservan (por si el
   usuario cambia de opinión).
3. Transcurridos 30 días, se eliminan irreversiblemente:
   - Datos de perfil (nombre, email, teléfono, dirección).
   - Historial de actividad vinculado al usuario.
   - Consentimientos registrados.
4. Se conservan anonimizados los datos necesarios por obligación
   legal (facturas, registros fiscales) sustituyendo los datos
   personales por un hash irreversible.

POSTCONDICIONES
- Tras 30 días: los datos personales han sido eliminados o anonimizados.
- El usuario recibe un correo de confirmación al solicitar y al
  completarse la eliminación.

CRITERIOS DE VERIFICACIÓN
1. Test: solicitar eliminación → cuenta desactivada inmediatamente,
   email de confirmación recibido.
2. Test: iniciar sesión durante el periodo de gracia → opción de
   reactivar la cuenta.
3. Test: transcurridos 30 días → consulta en base de datos confirma
   que no existen datos personales vinculados al usuario.
4. Test: registros fiscales conservados con datos anonimizados
   → el hash no permite recuperar los datos originales.
```

---

### Requisito F: "El dashboard debe mostrar información útil para el gestor"

**Problemas identificados**:
- "Información útil" es completamente subjetivo.
- No se define qué métricas, datos o indicadores necesita el gestor.
- No se especifica la granularidad temporal (hoy, esta semana, este mes).
- No hay criterios de diseño ni de interacción.

**Preguntas al stakeholder**:
1. ¿Qué decisiones toma el gestor a partir del dashboard? ¿Qué información necesita para tomarlas?
2. ¿Qué KPIs o métricas son prioritarios?
3. ¿Qué periodo temporal debe cubrir por defecto?
4. ¿Debe ser interactivo (filtros, drill-down) o estático?
5. ¿Con qué frecuencia se actualizan los datos?

**Especificación reescrita**:

```
ID:       FUNC-080
Título:   Dashboard de ventas para gestores
Estado:   Borrador (v1.0)

CONTEXTO
Los gestores comerciales necesitan una vista rápida del estado de
ventas para tomar decisiones diarias sobre prioridades y seguimiento.

PRECONDICIONES
- El usuario tiene rol "Gestor" o "Administrador".
- Existen datos de ventas en el sistema.

DESCRIPCIÓN
El dashboard muestra los siguientes indicadores, con datos del
mes en curso por defecto (configurable mediante selector de rango):

| Indicador                  | Tipo          | Detalle                                     |
|---------------------------|---------------|---------------------------------------------|
| Ventas totales del periodo | KPI numérico  | Suma en € de pedidos confirmados.            |
| Nº de pedidos             | KPI numérico  | Cantidad de pedidos confirmados.             |
| Ticket medio              | KPI numérico  | Ventas totales / Nº de pedidos.              |
| Ventas por día            | Gráfico línea | Eje X: días del periodo. Eje Y: € vendidos. |
| Top 5 productos           | Tabla         | Producto, unidades vendidas, total €.        |
| Pedidos pendientes        | KPI numérico  | Pedidos en estado "pendiente" > 24 horas.    |

Cada KPI muestra la variación respecto al periodo anterior
(p. ej., "+12% vs. mes anterior") con indicador visual
(verde si positivo, rojo si negativo).

Los datos se actualizan cada 15 minutos. La última hora de
actualización se muestra en la esquina superior derecha.

El gestor puede cambiar el rango temporal a: hoy, última semana,
mes actual, trimestre actual, año actual, o rango personalizado.

POSTCONDICIONES
- Se muestran todos los indicadores con datos actualizados.
- Si no hay datos para el periodo: se muestra "Sin datos para el
  periodo seleccionado" en lugar de valores vacíos o ceros engañosos.

CRITERIOS DE VERIFICACIÓN
1. Test: acceder al dashboard con datos existentes → se muestran
   los 6 indicadores con valores correctos para el mes actual.
2. Test: cambiar rango a "última semana" → los indicadores se
   recalculan para los últimos 7 días.
3. Test: verificar variación → si ventas del mes actual = 10.000 €
   y mes anterior = 8.000 €, la variación muestra "+25%".
4. Test: acceder con rol "Lector" → dashboard no visible.
5. Test: periodo sin datos → mensaje apropiado, sin ceros falsos.
```

---

## Laboratorio 2.2: Revisión de calidad de una especificación existente

### Enunciado

**Objetivo**: aplicar los criterios de calidad y las técnicas de detección de problemas para evaluar una especificación ya redactada, identificar sus deficiencias y proponer mejoras concretas.

**Instrucciones**

Se proporciona una especificación escrita por un equipo ficticio. El alumno debe:

1. Leerla con enfoque de **lectura adversarial**.
2. Aplicar el **checklist de revisión de calidad** del tema.
3. Identificar todos los problemas que encuentre, clasificados por tipo (claridad, precisión, completitud, consistencia, verificabilidad, trazabilidad, concisión).
4. Proponer una corrección concreta para cada problema.

**Especificación a revisar**:

```
Título: Gestión de descuentos

El sistema debe permitir gestionar descuentos.

Los administradores podrán crear descuentos y asignarlos a productos
o categorías. Los descuentos pueden ser porcentuales o fijos.

Cuando un cliente compra un producto con descuento, el precio final
se calcula aplicando el descuento correspondiente. Si hay varios
descuentos aplicables, se aplica el mejor para el cliente.

Los descuentos deben poder activarse y desactivarse. Los descuentos
caducados no deben aplicarse.

El sistema debe ser eficiente al calcular los descuentos para no
ralentizar el proceso de compra.
```

---

### Solución

### Resultado del checklist de revisión

| # | Pregunta | Resultado | Observación |
|---|---|---|---|
| 1 | ¿Tiene identificador único? | **No** | No hay ID. No se puede referenciar. |
| 2 | ¿El título permite identificarla sin leer el cuerpo? | **Parcial** | "Gestión de descuentos" es genérico. No distingue si se refiere a la creación, la aplicación, la administración o todo a la vez. |
| 3 | ¿Se entiende sin preguntar al autor? | **No** | Múltiples ambigüedades (detalladas abajo). |
| 4 | ¿Los términos ambiguos están definidos? | **No** | "Gestionar", "el mejor", "eficiente", "varios descuentos". |
| 5 | ¿Están los casos de error y límite? | **No** | No se definen. |
| 6 | ¿Tiene precondiciones y postcondiciones? | **No** | Ausentes. |
| 7 | ¿Los criterios de verificación son concretos? | **No** | No hay criterios de verificación. |
| 8 | ¿Es consistente con otras especificaciones? | **No evaluable** | No referencia otras especificaciones. |
| 9 | ¿Se puede verificar cada afirmación? | **No** | "Eficiente", "el mejor para el cliente" no son verificables. |
| 10 | ¿Indica estado, versión y autor? | **No** | Ausentes. |
| 11 | ¿Referencia dependencias? | **No** | No menciona relación con catálogo, carrito, ni reglas de dominio. |
| 12 | ¿Es concisa sin ser redundante? | **Sí** | Es breve, pero por omisión, no por concisión. |

### Problemas detectados

| # | Fragmento problemático | Tipo de problema | Explicación | Corrección propuesta |
|---|---|---|---|---|
| 1 | "Gestión de descuentos" (título) | Claridad | Título demasiado genérico. Debería desglosarse en al menos dos especificaciones: creación/administración de descuentos y aplicación de descuentos en la compra. | Separar en FUNC-090 "Creación y administración de descuentos" y FUNC-091 "Aplicación de descuentos en el proceso de compra". |
| 2 | "Gestionar descuentos" | Precisión | "Gestionar" no define operaciones concretas. ¿Crear, editar, eliminar, duplicar, programar? | Enumerar las operaciones: crear, editar, activar/desactivar, eliminar, consultar historial. |
| 3 | "Descuentos pueden ser porcentuales o fijos" | Completitud | No define rangos válidos. ¿Un descuento porcentual puede ser del 100%? ¿Un fijo puede ser mayor que el precio del producto? ¿Qué formato decimal? | Definir: porcentual (1%-99%, 2 decimales), fijo (0,01 € a 9.999,99 €). Si el descuento fijo supera el precio, el precio final es 0 €. |
| 4 | "Asignarlos a productos o categorías" | Completitud | ¿Se puede asignar a ambos a la vez? ¿Qué pasa si un producto pertenece a una categoría con descuento y además tiene descuento propio? | Definir la regla de prioridad: el descuento de producto prevalece sobre el de categoría. Si se necesita acumulación, definir regla explícita. |
| 5 | "Se aplica el mejor para el cliente" | Precisión | "El mejor" es ambiguo. ¿El de mayor descuento absoluto? ¿El de mayor porcentaje? ¿Se calcula sobre el precio original o sobre un precio ya descontado? | Definir: se aplica el descuento que resulte en el menor precio final para el cliente. Se calcula cada descuento aplicable sobre el precio base del producto y se selecciona el de mayor reducción absoluta. Los descuentos no se acumulan. |
| 6 | "Descuentos caducados no deben aplicarse" | Completitud | Implica que los descuentos tienen fecha de caducidad, pero no se menciona en la parte de creación. ¿Tienen fecha de inicio también? ¿Qué pasa con un descuento sin fecha de caducidad? | Añadir a la creación: fecha de inicio (obligatoria), fecha de fin (opcional; si no se indica, el descuento no caduca). Un descuento solo se aplica si la fecha actual está entre inicio y fin (inclusive). |
| 7 | "El sistema debe ser eficiente al calcular los descuentos" | Verificabilidad | "Eficiente" no es medible. | Sustituir por: "El cálculo de descuentos aplicables a un carrito de hasta 50 productos debe completarse en menos de 100 ms (p95) para no impactar el tiempo de respuesta del checkout." |
| 8 | Sin precondiciones | Completitud | No se indica quién puede crear descuentos, ni qué permisos se requieren, ni qué estado previo debe tener el catálogo. | Añadir: "El usuario tiene rol Administrador o Gestor Comercial. Los productos o categorías a los que se asigna el descuento deben existir y estar activos." |
| 9 | Sin postcondiciones | Completitud | No se define qué estado queda en el sistema tras crear o aplicar un descuento. | Añadir postcondiciones para creación ("El descuento queda registrado con estado activo, fechas de vigencia y asignación a producto/categoría") y para aplicación ("El precio final del producto en el carrito refleja el descuento aplicado"). |
| 10 | Sin criterios de verificación | Verificabilidad | No se puede validar la implementación contra la especificación. | Añadir al menos: test de creación, test de aplicación a producto individual, test de resolución de conflictos entre descuentos, test de descuento caducado, test de rendimiento. |
| 11 | Sin dependencias | Trazabilidad | No se indica relación con el catálogo de productos, el carrito de compra, el proceso de checkout ni las reglas de dominio de precios. | Añadir dependencias: FUNC-020 (Catálogo de productos), FUNC-035 (Carrito de compra), DN-014 (Reglas de precios y descuentos). |

---

## Laboratorio 2.3: Creación de plantilla base para especificaciones de equipo

### Enunciado

**Objetivo**: diseñar una plantilla reutilizable que el equipo pueda adoptar como formato estándar para sus especificaciones, adaptable a los distintos tipos vistos en el tema.

**Instrucciones**

1. A partir de la estructura y los criterios de calidad del tema, diseña una plantilla base para especificaciones del equipo.
2. La plantilla debe incluir todos los campos esenciales y ser suficientemente flexible para adaptarse a distintos tipos (funcional, técnica, de contrato, de aceptación).
3. Incluye instrucciones breves en cada campo para guiar a quien rellene la plantilla.
4. Define un esquema de estados del ciclo de vida de la especificación.
5. Propón convenciones de nomenclatura para los identificadores.

---

### Solución

### Plantilla base para especificaciones

```
═══════════════════════════════════════════════════════════════
ESPECIFICACIÓN [TIPO]
═══════════════════════════════════════════════════════════════

ID:           [TIPO]-[NNN]
Título:       [Frase descriptiva que identifique la especificación
               sin necesidad de leer el cuerpo]
Tipo:         [Funcional | Técnica | Interfaz | Contrato |
               Aceptación | Dominio]
Estado:       [Borrador | En revisión | Aprobada | Implementada |
               Obsoleta]
Versión:      [N.M — mayor.menor]
Autor:        [Nombre] — [Fecha de creación]
Última mod.:  [Nombre] — [Fecha] (Descripción breve del cambio)
Prioridad:    [Crítica | Alta | Media | Baja]

───────────────────────────────────────────────────────────────
1. CONTEXTO Y MOTIVACIÓN
───────────────────────────────────────────────────────────────

   ¿Por qué existe esta especificación? ¿Qué necesidad de negocio
   o problema técnico resuelve? ¿Qué ocurre actualmente sin ella?

   Instrucción: escribe 2-4 frases que cualquier miembro del equipo
   pueda leer para entender el "porqué" sin conocimiento previo.

───────────────────────────────────────────────────────────────
2. ALCANCE
───────────────────────────────────────────────────────────────

   Qué cubre esta especificación:
   - [elemento incluido]
   - [elemento incluido]

   Qué NO cubre (fuera de alcance):
   - [elemento excluido — referencia a otra spec si aplica]

   Instrucción: definir el alcance evita que la especificación
   crezca indefinidamente o que se solapen con otras.

───────────────────────────────────────────────────────────────
3. PRECONDICIONES
───────────────────────────────────────────────────────────────

   ¿Qué debe ser cierto ANTES de que aplique esta especificación?

   - [Precondición 1: estado del sistema, rol del usuario, datos
     necesarios, servicios disponibles...]
   - [Precondición 2]

   Instrucción: sé explícito. "El usuario está autenticado" es
   mejor que dar por supuesto que lo está.

───────────────────────────────────────────────────────────────
4. DESCRIPCIÓN
───────────────────────────────────────────────────────────────

   Cuerpo principal de la especificación. Según el tipo:

   - Funcional: comportamiento paso a paso, reglas, flujos.
   - Técnica: arquitectura, componentes, decisiones de diseño.
   - Contrato: endpoints, esquemas, códigos de respuesta.
   - Interfaz: pantallas, flujos de navegación, estados.
   - Aceptación: escenarios con datos concretos.
   - Dominio: reglas de negocio formalizadas.

   Instrucción: usa tablas, diagramas o listas numeradas si
   mejoran la claridad. Evita párrafos largos sin estructura.

───────────────────────────────────────────────────────────────
5. POSTCONDICIONES
───────────────────────────────────────────────────────────────

   ¿Qué debe ser cierto DESPUÉS de ejecutar lo especificado?

   - [Postcondición 1: estado resultante del sistema, datos
     creados o modificados, notificaciones enviadas...]
   - [Postcondición 2]

   Instrucción: las postcondiciones son la base de la verificación.
   Si no puedes definirlas, la descripción probablemente es ambigua.

───────────────────────────────────────────────────────────────
6. CASOS ESPECIALES Y ERRORES
───────────────────────────────────────────────────────────────

   ¿Qué puede ir mal? ¿Qué pasa en los casos límite?

   | Caso                        | Comportamiento esperado        |
   |-----------------------------|--------------------------------|
   | [Caso especial 1]           | [Qué hace el sistema]          |
   | [Caso de error 1]           | [Mensaje, código, acción]      |
   | [Caso límite 1]             | [Comportamiento]               |

   Instrucción: piensa en valores extremos (0, máximo, vacío,
   duplicado), fallos de servicios externos, acciones concurrentes,
   cancelaciones a mitad de proceso.

───────────────────────────────────────────────────────────────
7. CRITERIOS DE VERIFICACIÓN
───────────────────────────────────────────────────────────────

   ¿Cómo se comprueba que la implementación cumple esta
   especificación?

   1. Test: [precondición] → [acción] → [resultado esperado]
   2. Test: [precondición] → [acción] → [resultado esperado]
   3. ...

   Instrucción: cada criterio debe ser ejecutable. Un tester
   debería poder leer esta sección y saber exactamente qué
   probar sin preguntar.

───────────────────────────────────────────────────────────────
8. DEPENDENCIAS Y RELACIONES
───────────────────────────────────────────────────────────────

   Depende de:
   - [ID]: [Título] — [tipo de dependencia: usa, extiende, requiere]

   Es requerida por:
   - [ID]: [Título]

   Relacionada con:
   - [ID]: [Título] — [tipo de relación]

   Instrucción: mantener las dependencias actualizadas es clave
   para el análisis de impacto cuando algo cambia.

───────────────────────────────────────────────────────────────
9. NOTAS Y DECISIONES ABIERTAS
───────────────────────────────────────────────────────────────

   - [Decisión pendiente o supuesto temporal que debe confirmarse]
   - [Nota para revisores o implementadores]

   Instrucción: este campo es para lo que todavía no está resuelto.
   Las decisiones tomadas van en la descripción, no aquí.

───────────────────────────────────────────────────────────────
10. HISTORIAL DE CAMBIOS
───────────────────────────────────────────────────────────────

   | Versión | Fecha      | Autor          | Cambio                    |
   |---------|------------|----------------|---------------------------|
   | 1.0     | AAAA-MM-DD | [Nombre]       | Creación inicial          |
   | 1.1     | AAAA-MM-DD | [Nombre]       | [Descripción del cambio]  |

═══════════════════════════════════════════════════════════════
```

### Ciclo de vida de la especificación

```
  ┌──────────┐     ┌─────────────┐     ┌───────────┐
  │ Borrador │────▶│ En revisión │────▶│ Aprobada  │
  └──────────┘     └──────┬──────┘     └─────┬─────┘
                          │                   │
                   Requiere cambios     Se implementa
                          │                   │
                          ▼                   ▼
                   ┌──────────┐      ┌───────────────┐
                   │ Borrador │      │ Implementada  │
                   │(revisado)│      └───────┬───────┘
                   └──────────┘              │
                                      Queda obsoleta
                                             │
                                             ▼
                                      ┌───────────┐
                                      │ Obsoleta  │
                                      └───────────┘
```

**Definición de cada estado**:

| Estado | Significado | ¿Se puede implementar? |
|---|---|---|
| Borrador | En elaboración. Puede estar incompleta o contener decisiones abiertas. | No |
| En revisión | Completa y enviada para revisión por otros perfiles del equipo. | No |
| Aprobada | Revisada, validada y aceptada como referencia para implementación. | Sí |
| Implementada | La funcionalidad descrita ha sido construida y verificada. | Ya implementada |
| Obsoleta | Ya no aplica. Ha sido sustituida por otra especificación o la funcionalidad se ha eliminado. | No |

### Convenciones de nomenclatura para identificadores

**Formato**: `[TIPO]-[NNN]`

| Prefijo | Tipo de especificación | Ejemplo |
|---|---|---|
| FUNC | Funcional | FUNC-027 |
| TECH | Técnica | TECH-004 |
| UI | Interfaz | UI-015 |
| API | Contrato de API | API-PEDIDOS-003 |
| ACC | Aceptación | ACC-027-01 (vinculada a FUNC-027) |
| DN | Dominio / regla de negocio | DN-014 |
| SEC | Seguridad | SEC-010 |
| PERF | Rendimiento | PERF-002 |

**Reglas**:
- Los números son secuenciales dentro de cada tipo y no se reutilizan (si se elimina la FUNC-015, el siguiente sigue siendo FUNC-016, no FUNC-015).
- Para contratos de API, se puede añadir un identificador de recurso: `API-PEDIDOS-003`, `API-USUARIOS-001`.
- Las especificaciones de aceptación vinculadas a una funcional se nombran con el ID de la funcional como prefijo: `ACC-027-01`, `ACC-027-02`.
- Se recomienda un documento índice o base de datos de especificaciones que permita buscar por ID, tipo, estado y palabras clave.

### Guía rápida de uso de la plantilla

1. **Al iniciar una nueva especificación**: copia la plantilla, asigna un ID según la convención, rellena los campos que puedas y marca el estado como "Borrador".
2. **Al completar el borrador**: revisa que no haya campos vacíos esenciales (al menos: contexto, descripción, precondiciones, postcondiciones y criterios de verificación). Cambia el estado a "En revisión" y comparte con el equipo.
3. **Durante la revisión**: los revisores usan el checklist de calidad del tema. Los comentarios se resuelven y se actualiza la versión.
4. **Al aprobar**: el product owner o el responsable técnico marca la especificación como "Aprobada". A partir de ese momento es la referencia para implementación.
5. **Al implementar y verificar**: una vez que los tests de la sección de criterios de verificación pasan, se marca como "Implementada".
6. **Al quedar obsoleta**: si la funcionalidad se elimina o se sustituye por otra especificación, se marca como "Obsoleta" con referencia a la especificación que la sustituye.
