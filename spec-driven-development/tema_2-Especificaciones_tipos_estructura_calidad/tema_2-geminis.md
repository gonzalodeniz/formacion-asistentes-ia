Aquí tienes el desarrollo completo del **Tema 2: Especificaciones: tipos, estructura y calidad**, junto con las soluciones de sus respectivos laboratorios.

---

## Tema 2. Especificaciones: tipos, estructura y calidad

> Una especificación de calidad es aquella que no requiere que el desarrollador "adivine" la intención del negocio ni que el tester "invente" los casos de prueba. Es un documento vivo, unívoco y estructurado.

### 1. Tipos de Especificaciones en un Proyecto Software

En SDD, no existe un único "Documento de Requisitos". La especificación se divide en varias capas o tipos para abordar el sistema desde diferentes perspectivas, asegurando que todos los roles tengan la información que necesitan.

* **Especificaciones Funcionales:** Describen *qué* debe hacer el sistema desde el punto de vista del usuario o del negocio. Incluyen reglas de negocio, flujos de trabajo, roles y permisos.
* **Especificaciones Técnicas / Arquitectónicas:** Describen *cómo* el sistema soportará la funcionalidad. Incluyen diagramas de secuencia, modelos de datos, infraestructura y políticas de seguridad o rendimiento.
* **Especificaciones de Interfaz (UI/UX):** Detallan la interacción humana. Van más allá de un diseño estático; deben especificar los distintos estados de un componente (vacío, cargando, error, éxito), accesibilidad y validaciones en cliente.
* **Especificaciones de Contrato (APIs y Servicios):** Definen cómo se comunican las máquinas. Son estrictas e incluyen endpoints, esquemas de petición (request), esquemas de respuesta (response), códigos HTTP y cabeceras obligatorias (ej. documentos OpenAPI/Swagger).
* **Especificaciones de Aceptación (Ejecutables):** Son ejemplos concretos de cómo se debe comportar el sistema, redactados de tal forma que puedan automatizarse (ej. formato `Given-When-Then` de Gherkin/BDD).

### 2. Estructura de una Buena Especificación

Para que una especificación sea útil durante todo el desarrollo, debe seguir una estructura predecible que evite el síndrome del "folio en blanco" y garantice la completitud:

1.  **Metadatos y Trazabilidad:** Autor, fecha, versión, estado (Borrador, Aprobado) y enlace a la necesidad de negocio o épica.
2.  **Contexto y Propósito:** Un breve resumen de *por qué* se construye esto y qué valor aporta.
3.  **Precondiciones:** ¿Qué estado previo debe tener el sistema o el usuario para que esto aplique? (Ej. "El usuario debe estar autenticado y tener rol de Administrador").
4.  **Flujo Principal (Happy Path):** El escenario ideal donde todo sale bien paso a paso.
5.  **Flujos Alternativos y Excepciones:** Qué ocurre si el usuario hace algo distinto o si el sistema falla (ej. "Stock agotado en el momento del pago", "Servicio de terceros caído").
6.  **Reglas de Negocio / Invariantes:** Límites estrictos que el sistema nunca debe romper (ej. "Un reembolso nunca puede superar el importe original cobrado").
7.  **Postcondiciones:** Estado final del sistema tras ejecutar la acción.

### 3. Criterios de Calidad: Detectando Ambigüedades

Una especificación debe ser **Clara, Precisa, Consistente y Trazable**. El mayor enemigo de la calidad son las "palabras trampa" que abren la puerta a la interpretación subjetiva:

* **Subjetivas:** *Rápido, intuitivo, fácil, seguro, amigable.* (¿Qué es "rápido"? Mejor: "El tiempo de respuesta debe ser inferior a 200ms").
* **Incompletas:** *Etcétera, y otros, como siempre, lo habitual.* (Exigen que el lector asuma o recuerde algo que no está escrito).
* **Absolutas sin contexto:** *Todo, nada, siempre, nunca.* (¿Qué pasa si "siempre" falla la base de datos?).

---

## Soluciones a los Laboratorios (Tema 2)

### Laboratorio 1: Reescritura de requisitos ambiguos en formato especificable

**Instrucción original:** Reestructurar un requisito pobre ("El usuario puede subir una foto de perfil") aplicando los conceptos estructurales del Tema 2.

**Solución propuesta:**

* **Contexto:** Permitir la personalización de la cuenta de usuario para mejorar la identificación en la plataforma.
* **Precondiciones:** El usuario ha iniciado sesión.
* **Reglas de Negocio (Validaciones):**
    * Formatos permitidos: `.jpg`, `.png`, `.webp`.
    * Tamaño máximo: `2 MB`.
    * Resolución mínima: `200x200 px`.
* **Flujo Principal:** El usuario selecciona un archivo válido, el sistema lo procesa, actualiza el avatar en la base de datos y muestra un mensaje de éxito ("Foto actualizada").
* **Flujos de Excepción (Casos de Error):**
    * *Excepción 1 (Formato inválido):* El sistema rechaza la subida y muestra: "Formato no soportado. Usa JPG, PNG o WEBP."
    * *Excepción 2 (Tamaño excedido):* El sistema rechaza y muestra: "El archivo supera los 2 MB permitidos."
* **Postcondiciones:** La URL de la nueva imagen queda asociada al `user_id` y reemplaza a la imagen anterior en el CDN.

### Laboratorio 2: Revisión de calidad de una especificación existente

**Instrucción original:** Detectar ambigüedades, inconsistencias y huecos en el siguiente texto: *"El sistema procesará los pagos por tarjeta y guardará el recibo. Si falla, avisa al usuario."*

**Solución (Revisión de Calidad):**

Al aplicar los criterios de calidad, se detectan los siguientes **huecos y ambigüedades**:

1.  **"pagos por tarjeta":** *Falta precisión.* ¿Qué tipo de tarjetas? (Visa, Mastercard, Amex, prepago). ¿Requiere validación 3D Secure?
2.  **"guardará el recibo":** *Falta estructura e interfaz.* ¿Dónde se guarda? ¿En la base de datos, en un bucket S3, se envía por email? ¿Qué formato tiene el recibo (PDF, HTML)?
3.  **"Si falla":** *Falta completitud (edge cases).* Faltan los motivos del fallo: ¿Fondos insuficientes?, ¿tarjeta caducada?, ¿pasarela caída? Cada fallo requiere un manejo distinto.
4.  **"avisa al usuario":** *Ambigüedad.* ¿Cómo le avisa? (Email, SMS, modal en pantalla). ¿Qué texto exacto se muestra?
5.  **Postcondición oculta:** No se menciona qué ocurre con la entidad principal (ej. el carrito de la compra o la reserva) en caso de éxito o fallo.

### Laboratorio 3: Creación de plantilla base para especificaciones de equipo

**Instrucción original:** Crear una plantilla en Markdown estandarizada para que el equipo la utilice como base en el desarrollo guiado por especificaciones.

**Solución (Plantilla Base SDD):**

```markdown
# [Código ID] - Título de la Funcionalidad

## 1. Metadatos
* **Autor/es:** * **Fecha de actualización:**
* **Estado:** [Borrador / En Revisión / Aprobada]
* **Enlace a Épica/Ticket:** ## 2. Contexto y Propósito
[Explicar brevemente qué problema resuelve esta funcionalidad y el valor que aporta al negocio y al usuario].

## 3. Especificación Funcional
### 3.1. Precondiciones
* [Condición 1 que debe cumplirse antes de empezar]
* [Condición 2]

### 3.2. Reglas de Negocio / Invariantes
* [Regla estricta 1. Ej: Un usuario menor de edad no puede...]
* [Regla estricta 2]

### 3.3. Comportamiento (Flujos)
**Flujo Principal (Happy Path):**
1. [Paso 1]
2. [Paso 2]

**Flujos Alternativos / Excepciones:**
* **EX-01 [Nombre del error]:** Si [condición], entonces el sistema [comportamiento] y muestra [mensaje exacto].

### 4. Especificación de Contrato / Interfaz (Si aplica)
* **Endpoint API:** `[POST] /api/v1/...`
* **Validaciones Frontend:** [Mapeo de campos requeridos, longitudes, regex]

### 5. Criterios de Aceptación (Verificabilidad)
* **Escenario 1: [Nombre]**
  * **Dado** [contexto inicial]
  * **Cuando** [acción ejecutada]
  * **Entonces** [resultado medible]
```
