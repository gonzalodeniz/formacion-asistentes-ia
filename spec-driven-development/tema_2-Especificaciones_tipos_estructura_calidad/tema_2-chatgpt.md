# Tema 2. Especificaciones: tipos, estructura y calidad

## Descripción ampliada

En un enfoque de Spec Driven Development (SDD), la calidad del desarrollo depende en gran medida de la calidad de la especificación. No basta con “tener requisitos”: es necesario que estén formulados de manera que permitan comprender el comportamiento esperado del sistema, reducir interpretaciones contradictorias, facilitar el diseño técnico y servir como base para validación y trazabilidad.

Este tema aborda los principales tipos de especificaciones que aparecen en un proyecto de software, cómo estructurarlas y qué criterios permiten evaluar si una especificación es realmente útil. El foco no está en producir documentos extensos, sino en generar artefactos claros, consistentes, verificables y mantenibles.

Una buena especificación debe responder, como mínimo, a estas preguntas:

* ¿Qué debe hacer el sistema?
* ¿En qué contexto o condiciones debe hacerlo?
* ¿Qué entradas recibe y qué salidas produce?
* ¿Qué reglas o restricciones aplican?
* ¿Qué errores o excepciones deben contemplarse?
* ¿Cómo se sabrá que está correctamente implementado?

Este tema proporciona una base práctica para redactar, revisar y mejorar especificaciones funcionales, técnicas, de interfaz, de contrato y de aceptación, entendiendo que cada una aporta una visión distinta pero complementaria del sistema.

---

# Objetivos de aprendizaje

Al finalizar este tema, el alumnado será capaz de:

* Reconocer los distintos tipos de especificaciones en un proyecto software.
* Aprender a estructurar especificaciones claras, completas y verificables.
* Detectar ambigüedades, inconsistencias y huecos en una especificación.
* Definir criterios de calidad para una buena especificación.
* Diferenciar entre información útil, información redundante e información ausente dentro de una especificación.
* Aplicar una revisión sistemática sobre una especificación existente.
* Elaborar una plantilla base reutilizable para equipos de desarrollo.

---

# Resultados de aprendizaje esperados

Al terminar el tema, el participante podrá:

* Clasificar una especificación según su propósito: funcional, técnica, de interfaz, de contrato o de aceptación.
* Diseñar una estructura mínima útil para documentar una funcionalidad o componente.
* Evaluar si una especificación es clara, consistente, completa y verificable.
* Reescribir requisitos ambiguos en un formato más preciso.
* Identificar omisiones que podrían generar errores en diseño, implementación o pruebas.
* Crear una plantilla base de especificación aplicable a su contexto profesional.

---

# Contenidos

## 1. Qué entendemos por especificación en SDD

Una especificación es una descripción explícita de lo que un sistema, módulo, proceso o interfaz debe hacer, bajo qué condiciones y con qué resultados esperados. En SDD, la especificación no es solo un documento inicial, sino un artefacto de trabajo que debe ser útil durante análisis, diseño, implementación, pruebas y evolución.

La especificación puede expresarse en distintos formatos:

* texto estructurado,
* tablas,
* casos de uso,
* contratos,
* ejemplos,
* criterios de aceptación,
* esquemas de entrada y salida,
* diagramas,
* reglas de negocio,
* escenarios verificables.

La forma concreta puede variar, pero su propósito permanece: reducir ambigüedad y permitir alineación entre roles.

---

## 2. Tipos de especificaciones

En un proyecto real no existe una única especificación monolítica. Lo habitual es que convivan varios tipos, cada uno orientado a responder preguntas distintas.

## 2.1. Especificaciones funcionales

Describen qué debe hacer el sistema desde la perspectiva del negocio o del usuario.

Suelen incluir:

* objetivo de la funcionalidad,
* comportamiento esperado,
* condiciones de uso,
* reglas de negocio,
* flujos principales,
* flujos alternativos,
* restricciones funcionales.

### Ejemplo

“Cuando un cliente confirmado realiza un pedido superior a 100 euros, el sistema deberá ofrecer la opción de envío gratuito, salvo que el pedido incluya productos excluidos de promoción.”

Esta especificación se centra en el comportamiento esperado.

---

## 2.2. Especificaciones técnicas

Describen cómo debe resolverse o condicionarse técnicamente una funcionalidad, integración o componente.

Suelen incluir:

* arquitectura implicada,
* tecnologías,
* restricciones técnicas,
* dependencias,
* políticas de seguridad,
* rendimiento esperado,
* observabilidad,
* despliegue o versionado.

### Ejemplo

“El servicio de cálculo de promociones deberá exponer una API interna REST, responder en menos de 300 ms en el percentil 95 y registrar trazas con identificador de correlación.”

Aquí se introducen decisiones y restricciones técnicas.

---

## 2.3. Especificaciones de interfaz

Definen cómo interactúan los actores con el sistema o cómo se relacionan sistemas entre sí.

Pueden referirse a:

* interfaz de usuario,
* API,
* eventos,
* mensajes,
* formularios,
* endpoints,
* formatos de respuesta.

### Ejemplo

“El endpoint `POST /orders` aceptará un cuerpo JSON con los campos `customerId`, `items`, `deliveryAddress` y `paymentMethod`. Si falta `paymentMethod`, devolverá `400 Bad Request` con código funcional `ORDER-001`.”

---

## 2.4. Especificaciones de contrato

Definen acuerdos explícitos entre productor y consumidor de un servicio, módulo o componente.

Suelen incluir:

* entradas,
* salidas,
* precondiciones,
* postcondiciones,
* invariantes,
* errores esperados,
* compatibilidad entre versiones.

### Ejemplo

“Si el consumidor envía un identificador de cliente inexistente, el servicio deberá devolver `404` y no generar ningún pedido parcial.”

La idea central es evitar interpretaciones distintas entre las partes integradas.

---

## 2.5. Especificaciones de aceptación

Definen las condiciones que deben cumplirse para considerar válida una funcionalidad desde el punto de vista del negocio, QA o cliente.

Suelen expresarse como:

* criterios de aceptación,
* escenarios,
* ejemplos verificables,
* condiciones de éxito y rechazo.

### Ejemplo

“Dado un usuario autenticado con rol administrador, cuando accede al panel de gestión, entonces debe poder visualizar el listado de usuarios y exportarlo en formato CSV.”

---

## 2.6. Relación entre tipos

Estos tipos no compiten entre sí; se complementan.

Por ejemplo, una funcionalidad puede tener:

* una especificación funcional que describe la intención,
* una especificación de interfaz que describe el endpoint,
* una especificación de contrato que establece condiciones técnicas y de error,
* una especificación de aceptación que define cómo se valida.

Una especificación madura suele conectar estas perspectivas.

---

# 3. Estructura de una buena especificación

No existe una única plantilla universal, pero sí una estructura mínima recomendada para que una especificación sea útil y mantenible.

## 3.1. Identificación

Debe incluir información básica que permita ubicar la especificación.

Campos sugeridos:

* título,
* identificador único,
* versión,
* estado,
* autor o responsable,
* fecha,
* sistema o módulo afectado.

### Ejemplo

* ID: ORD-SPEC-012
* Título: Aplicación de envío gratuito en pedidos promocionables
* Versión: 1.2
* Estado: Aprobada

---

## 3.2. Propósito

Explica qué problema resuelve la especificación y por qué existe.

### Ejemplo

“Definir las reglas y condiciones bajo las cuales el sistema ofrece envío gratuito durante el proceso de compra.”

---

## 3.3. Alcance

Indica qué cubre y qué no cubre.

### Ejemplo

Incluye:

* cálculo de elegibilidad,
* visualización de la opción en checkout,
* validación en confirmación de pedido.

Excluye:

* campañas promocionales manuales,
* descuentos de transporte para canal telefónico.

---

## 3.4. Contexto y dependencias

Sitúa la especificación dentro del sistema.

Puede incluir:

* procesos relacionados,
* módulos dependientes,
* integraciones externas,
* supuestos previos.

---

## 3.5. Definiciones y términos

Muy útil cuando el dominio usa conceptos que pueden interpretarse de formas distintas.

### Ejemplo

* Cliente premium: cliente con suscripción activa y pagos al día.
* Pedido promocionable: pedido sin productos marcados como excluidos de promoción.

---

## 3.6. Reglas de negocio

Expresan las condiciones lógicas o funcionales relevantes.

### Ejemplo

* RB-01: El envío gratuito se ofrecerá solo si el total promocionable del pedido es igual o superior a 100 euros.
* RB-02: Los productos excluidos no computan para el umbral promocional.
* RB-03: Si el pedido contiene únicamente productos excluidos, no se ofrecerá envío gratuito.

---

## 3.7. Entradas y salidas

Especialmente importante en APIs, servicios, formularios o procesos automáticos.

### Entradas

* total del pedido,
* lista de productos,
* indicador de exclusión promocional,
* tipo de cliente.

### Salidas

* `eligibleForFreeShipping: true|false`
* motivo de rechazo,
* mensaje visible al usuario.

---

## 3.8. Flujo principal

Describe el comportamiento normal esperado.

### Ejemplo

1. El sistema recibe el carrito confirmado.
2. Calcula el total promocionable.
3. Evalúa la elegibilidad.
4. Si cumple condiciones, muestra envío gratuito.
5. Registra la decisión en el resumen del pedido.

---

## 3.9. Flujos alternativos y excepciones

Describe comportamientos no principales, errores o casos borde.

### Ejemplo

* Si faltan datos de productos, el sistema no ofrecerá envío gratuito y registrará un error técnico.
* Si el servicio de promociones no responde, se aplicará política de degradación definida por arquitectura.

---

## 3.10. Criterios de aceptación

Permiten validar si la implementación cumple lo esperado.

### Ejemplo

* CA-01: Dado un pedido con 120 euros en productos promocionables, el sistema ofrece envío gratuito.
* CA-02: Dado un pedido de 130 euros con todos los productos excluidos, el sistema no ofrece envío gratuito.
* CA-03: Dado un pedido con 90 euros promocionables, el sistema no ofrece envío gratuito.

---

## 3.11. Reglas no funcionales, si aplican

Puede incluir:

* rendimiento,
* seguridad,
* accesibilidad,
* disponibilidad,
* trazabilidad,
* auditoría.

---

## 3.12. Trazabilidad

Relaciona la especificación con otros artefactos.

Ejemplos:

* requisito de negocio,
* historia de usuario,
* componente técnico,
* caso de prueba,
* decisión arquitectónica.

---

# 4. Criterios de calidad de una buena especificación

Una especificación útil no se mide por longitud, sino por calidad.

## 4.1. Claridad

Debe poder entenderse sin interpretaciones arbitrarias.

### Mala formulación

“El sistema mostrará la información adecuada al usuario cuando corresponda.”

### Mejor formulación

“Cuando el usuario no tenga permisos de edición, el sistema mostrará el mensaje ‘No dispone de permisos para modificar este recurso’ y ocultará el botón Guardar.”

---

## 4.2. Precisión

Debe evitar términos vagos o subjetivos.

Términos problemáticos:

* rápido,
* intuitivo,
* fácil,
* adecuado,
* importante,
* normal,
* eficiente,
* si procede.

La precisión no implica complicación, sino concreción.

---

## 4.3. Completitud

Debe contemplar la información necesaria para diseñar, implementar y validar.

Una especificación incompleta suele omitir:

* casos de error,
* límites,
* actores,
* reglas de negocio,
* dependencias,
* criterios de aceptación.

---

## 4.4. Consistencia

No debe contener contradicciones internas ni chocar con otras especificaciones.

### Ejemplo de inconsistencia

* En una sección se indica que el máximo de intentos es 3.
* En otra se indica que tras 5 intentos se bloquea la cuenta.

---

## 4.5. Verificabilidad

Debe poder comprobarse objetivamente.

### No verificable

“El sistema debe ser cómodo de usar.”

### Más verificable

“Un usuario habitual deberá poder completar el proceso de alta en un máximo de 3 pantallas sin introducir datos redundantes.”

---

## 4.6. Trazabilidad

Debe poder relacionarse con origen, implementación y validación.

Una especificación sin trazabilidad dificulta saber:

* por qué existe,
* qué cubre,
* qué depende de ella,
* qué pruebas la validan,
* qué impacto tiene modificarla.

---

## 4.7. Consumo por distintos roles

Una buena especificación debe ser útil para más de un perfil, aunque algunas secciones tengan mayor valor para unos roles que para otros.

* negocio: intención y reglas,
* desarrollo: condiciones, datos, excepciones,
* QA: aceptación y validación,
* arquitectura: restricciones e integración.

---

## 4.8. Mantenibilidad

Debe poder actualizarse sin romper coherencia.

Cuanto más redundante, dispersa o informal sea la especificación, más difícil será mantenerla viva.

---

# 5. Errores frecuentes en las especificaciones

## 5.1. Ambigüedad léxica

Una palabra admite varias interpretaciones.

Ejemplo:
“usuario activo”
¿Activo hoy? ¿Activo en los últimos 30 días? ¿Con cuenta habilitada?

---

## 5.2. Ambigüedad contextual

No se entiende en qué caso aplica la regla.

Ejemplo:
“Se enviará una alerta en caso de incidencia.”
¿A quién? ¿Qué se considera incidencia? ¿Cuándo?

---

## 5.3. Omisiones

Falta una pieza crítica de información.

Ejemplo:
Se describe el alta de usuario, pero no qué ocurre si el email ya existe.

---

## 5.4. Contradicciones

Dos partes dicen cosas incompatibles.

---

## 5.5. Mezcla desordenada de niveles

Se mezclan objetivos de negocio, detalles de interfaz, decisiones técnicas y comentarios informales sin estructura clara.

---

## 5.6. Redacción centrada en solución prematura

A veces se fuerza una implementación concreta antes de aclarar el problema funcional.

Ejemplo:
“Se añadirá un botón azul que llame al microservicio X...”
Antes habría que definir qué necesidad cubre ese comportamiento.

---

## 5.7. Falta de criterios de validación

La especificación describe intención, pero no indica cómo comprobar el cumplimiento.

---

# 6. Método práctico para revisar una especificación

Una forma simple y eficaz es revisar cada especificación con estas preguntas:

## 6.1. Comprensión

* ¿Se entiende qué problema resuelve?
* ¿Se identifican claramente actores y contexto?

## 6.2. Precisión

* ¿Hay términos vagos o subjetivos?
* ¿Se pueden hacer interpretaciones distintas?

## 6.3. Completitud

* ¿Incluye flujos normales, alternativos y errores?
* ¿Faltan reglas, límites o definiciones?

## 6.4. Consistencia

* ¿Hay contradicciones internas?
* ¿Está alineada con otras reglas o artefactos?

## 6.5. Verificabilidad

* ¿Puede derivarse una prueba objetiva?
* ¿Existen criterios de aceptación claros?

## 6.6. Mantenibilidad

* ¿La estructura facilita actualización?
* ¿Evita duplicidad innecesaria?

---

# 7. Desarrollo teórico para material del alumno

## 7.1. Una especificación no es solo un texto

La especificación debe entenderse como un artefacto operativo. Su valor está en orientar decisiones y reducir incertidumbre, no en “cumplir una formalidad documental”.

## 7.2. No todas las especificaciones tienen el mismo nivel de detalle

Una regla de negocio simple puede requerir una especificación breve. Una API crítica o un cálculo financiero puede necesitar mucha mayor precisión. El nivel de especificación debe ajustarse al riesgo, complejidad e impacto.

## 7.3. La calidad de la especificación condiciona la calidad del producto

Muchas incidencias funcionales no provienen de fallos de codificación, sino de definiciones incompletas o ambiguas. Corregir eso en producción suele ser más costoso que aclararlo antes.

## 7.4. Estructurar no significa burocratizar

Una estructura básica ayuda a pensar mejor. No obliga a crear documentos pesados. Puede aplicarse en una wiki, en tickets enriquecidos, en contratos API o en plantillas ligeras.

## 7.5. Especificar mejor mejora la colaboración

Cuando desarrollo, negocio y QA trabajan sobre una misma definición, disminuyen las suposiciones y aumenta la capacidad de validar de forma compartida.

---

# 8. Ejemplos didácticos

## Ejemplo 1. Requisito ambiguo

“El sistema notificará los retrasos importantes.”

### Problemas detectados

* No define qué es “retraso”.
* No define qué es “importante”.
* No indica a quién se notifica.
* No indica canal ni plazo.
* No indica excepciones.

### Reescritura

“Cuando un pedido supere en más de 24 horas la fecha estimada de entrega, el sistema enviará una notificación por correo electrónico al cliente y registrará un evento de incidencia en el historial del pedido.”

### Mejora aportada

* umbral definido,
* destinatario identificado,
* canal concreto,
* evidencia registrable.

---

## Ejemplo 2. Especificación incompleta

“Un usuario podrá cambiar su contraseña.”

### Qué falta

* ¿Debe introducir la contraseña actual?
* ¿Hay política de longitud?
* ¿Se permiten contraseñas anteriores?
* ¿Qué ocurre si falla varias veces?
* ¿Cómo se confirma el cambio?

### Versión mejorada

“El usuario autenticado podrá cambiar su contraseña desde su perfil introduciendo su contraseña actual y una nueva contraseña que cumpla las siguientes reglas: longitud mínima de 12 caracteres, al menos una letra mayúscula, una minúscula, un número y un carácter especial. El sistema impedirá reutilizar cualquiera de las últimas 5 contraseñas y mostrará un mensaje de confirmación tras el cambio exitoso.”

---

## Ejemplo 3. Contradicción

* Sección A: “La sesión expirará tras 15 minutos de inactividad.”
* Sección B: “La sesión permanecerá abierta durante 30 minutos salvo cierre manual.”

### Problema

La especificación no es consistente, y desarrollo o QA no sabrán qué validar.

---

# 9. Laboratorios desarrollados con solución

---

## Laboratorio 1. Reescritura de requisitos ambiguos en formato especificable

### Objetivo

Transformar requisitos ambiguos en enunciados claros, precisos y verificables.

## Enunciado

Reescribir los siguientes requisitos ambiguos para convertirlos en especificaciones más útiles:

1. El sistema debe ser intuitivo.
2. La búsqueda debe ser rápida.
3. El usuario podrá modificar sus datos si procede.
4. Se notificará cualquier incidencia importante.
5. El sistema protegerá adecuadamente la información sensible.

---

## Solución propuesta

### Caso 1

**Requisito ambiguo:**
El sistema debe ser intuitivo.

**Problemas detectados:**

* “intuitivo” es subjetivo;
* no hay actor ni tarea concreta;
* no es verificable.

**Versión especificable:**
“Un usuario nuevo deberá poder completar el proceso de registro en un máximo de 3 pantallas, con etiquetas visibles en todos los campos obligatorios y mensajes de error mostrados junto al campo correspondiente.”

**Cómo se valida:**

* revisión de interfaz;
* prueba funcional de registro;
* test con usuarios o checklist de UX.

---

### Caso 2

**Requisito ambiguo:**
La búsqueda debe ser rápida.

**Problemas detectados:**

* “rápida” no define umbral;
* no identifica contexto de carga;
* no define qué búsquedas.

**Versión especificable:**
“La búsqueda de productos por nombre deberá devolver resultados en menos de 2 segundos para consultas sobre un catálogo de hasta 100.000 productos, en condiciones normales de operación.”

**Cómo se valida:**

* prueba de rendimiento;
* medición de tiempos de respuesta.

---

### Caso 3

**Requisito ambiguo:**
El usuario podrá modificar sus datos si procede.

**Problemas detectados:**

* “si procede” es ambiguo;
* no se sabe qué datos;
* no se indican restricciones.

**Versión especificable:**
“El usuario autenticado podrá modificar su teléfono, dirección postal y preferencias de notificación desde su perfil. No podrá modificar su documento de identidad ni su correo electrónico si tiene pedidos en curso.”

**Cómo se valida:**

* prueba funcional con usuarios con y sin pedidos;
* verificación de campos editables y bloqueados.

---

### Caso 4

**Requisito ambiguo:**
Se notificará cualquier incidencia importante.

**Problemas detectados:**

* “cualquier” e “importante” son imprecisos;
* no se define el destinatario;
* no se define el canal.

**Versión especificable:**
“Cuando una transacción de pago falle tres veces consecutivas para un mismo pedido, el sistema enviará una notificación por correo electrónico al equipo de soporte y registrará una alerta crítica en el panel de monitorización.”

**Cómo se valida:**

* simulación de error repetido;
* verificación de email y alerta.

---

### Caso 5

**Requisito ambiguo:**
El sistema protegerá adecuadamente la información sensible.

**Problemas detectados:**

* “adecuadamente” no es verificable;
* no define qué es información sensible;
* no concreta mecanismos.

**Versión especificable:**
“El sistema almacenará cifrados los datos bancarios y los documentos de identidad mediante algoritmos aprobados por la política de seguridad corporativa. Además, solo los usuarios con rol `compliance` podrán acceder a dichos datos mediante autenticación multifactor.”

**Cómo se valida:**

* revisión técnica;
* pruebas de autorización;
* revisión de configuración de seguridad.

---

## Plantilla de corrección para el laboratorio

Se considera correcta una reescritura si:

* elimina términos subjetivos;
* identifica actor y contexto;
* define comportamiento observable;
* incorpora restricciones o condiciones;
* puede derivar una validación objetiva.

---

## Laboratorio 2. Revisión de calidad de una especificación existente

### Objetivo

Detectar problemas de calidad en una especificación y proponer mejoras.

## Enunciado

Se entrega esta especificación breve:

> “El sistema de tickets permitirá que los agentes gestionen incidencias de forma eficiente.
> Cuando llegue una incidencia relevante, deberá notificarse al equipo correspondiente.
> Los usuarios podrán consultar el estado de sus tickets.
> Las incidencias urgentes tendrán prioridad alta.
> El sistema deberá responder correctamente ante errores.”

Se pide:

1. Detectar problemas de calidad.
2. Clasificarlos.
3. Reescribir la especificación con mejor estructura.

---

## Solución propuesta

## 1. Problemas detectados

### a) Ambigüedad

* “de forma eficiente”
* “incidencia relevante”
* “equipo correspondiente”
* “urgentes”
* “correctamente ante errores”

### b) Falta de completitud

* no se define quién crea la incidencia;
* no se define qué estados puede consultar el usuario;
* no se definen canales de notificación;
* no se explican criterios de prioridad;
* no se indican errores concretos ni comportamiento esperado.

### c) Falta de verificabilidad

* no pueden derivarse pruebas claras;
* no hay tiempos, condiciones ni resultados observables.

### d) Falta de estructura

* no hay propósito, reglas, entradas/salidas ni criterios de aceptación.

---

## 2. Reescritura mejorada

### ID

TCK-SPEC-001

### Título

Gestión y priorización de incidencias en sistema de tickets

### Propósito

Definir el comportamiento del sistema de tickets para creación, consulta, notificación y priorización de incidencias.

### Alcance

Incluye:

* registro de incidencias,
* consulta de estado,
* priorización de tickets urgentes,
* notificación a equipos responsables.

Excluye:

* escalado automático entre departamentos,
* resolución automática por IA.

### Definiciones

* Incidencia urgente: incidencia marcada con impacto alto y tiempo objetivo de resolución inferior a 4 horas.
* Equipo responsable: equipo asignado según categoría funcional del ticket.

### Reglas de negocio

* RB-01: Todo ticket creado deberá recibir un identificador único.
* RB-02: El usuario creador podrá consultar el estado de sus tickets en cualquier momento.
* RB-03: Si un ticket se clasifica como urgente, el sistema asignará prioridad alta.
* RB-04: Cuando un ticket se clasifique como urgente, el sistema notificará por correo electrónico al equipo responsable en menos de 1 minuto.
* RB-05: Si ocurre un error al registrar el ticket, el sistema mostrará un mensaje al usuario y no guardará información parcial inconsistente.

### Estados del ticket

* Nuevo
* En análisis
* En progreso
* Resuelto
* Cerrado

### Flujo principal

1. El usuario crea una incidencia.
2. El sistema valida los datos obligatorios.
3. El sistema genera el ticket.
4. Asigna categoría y prioridad inicial.
5. Si el ticket es urgente, envía notificación al equipo responsable.
6. El usuario puede consultar posteriormente el estado del ticket.

### Excepciones

* Si faltan datos obligatorios, el sistema mostrará los campos en error y no creará el ticket.
* Si falla el servicio de notificaciones, el ticket se creará igualmente y quedará una alerta interna pendiente de reintento.

### Criterios de aceptación

* CA-01: Dado un ticket válido, cuando se registra, entonces el sistema genera un identificador único y lo deja en estado “Nuevo”.
* CA-02: Dado un ticket urgente, cuando se registra, entonces el sistema le asigna prioridad alta y notifica al equipo responsable en menos de 1 minuto.
* CA-03: Dado un usuario autenticado, cuando consulta sus tickets, entonces puede ver el estado actual de cada uno.
* CA-04: Dado un ticket con datos obligatorios incompletos, cuando se intenta registrar, entonces el sistema no lo crea y muestra errores de validación.

---

## 3. Tabla resumen de hallazgos

| Problema original                          | Tipo de defecto     | Mejora aplicada                                  |
| ------------------------------------------ | ------------------- | ------------------------------------------------ |
| “gestionen incidencias de forma eficiente” | Ambigüedad          | Se sustituyó por comportamientos concretos       |
| “incidencia relevante”                     | Ambigüedad          | Se definió criterio operativo                    |
| “equipo correspondiente”                   | Falta de definición | Se definió como equipo responsable por categoría |
| “responder correctamente ante errores”     | No verificable      | Se describieron errores y conducta esperada      |
| Ausencia de estados                        | Incompletitud       | Se incorporó modelo de estados                   |

---

## Laboratorio 3. Creación de plantilla base para especificaciones de equipo

### Objetivo

Diseñar una plantilla reutilizable para redactar especificaciones con calidad mínima común.

## Enunciado

El equipo necesita una plantilla base para especificar nuevas funcionalidades. Debe ser simple, reutilizable y suficiente para permitir análisis, desarrollo y pruebas.

Se pide proponer una plantilla y justificar cada sección.

---

## Solución propuesta

## Plantilla base de especificación

```markdown
# [ID] Título de la especificación

## 1. Información general
- ID:
- Versión:
- Estado:
- Autor/Responsable:
- Fecha:
- Sistema/Módulo:

## 2. Propósito
Descripción breve del problema que se resuelve y del objetivo de la especificación.

## 3. Alcance
### Incluye
- 
### Excluye
- 

## 4. Contexto y dependencias
- Procesos relacionados:
- Módulos implicados:
- Sistemas externos:
- Supuestos relevantes:

## 5. Definiciones
- Término 1:
- Término 2:

## 6. Actores
- Actor 1:
- Actor 2:

## 7. Entradas
- Campo / dato:
- Origen:
- Restricciones:

## 8. Salidas
- Resultado esperado:
- Formato:
- Destinatario o consumidor:

## 9. Reglas de negocio
- RB-01:
- RB-02:
- RB-03:

## 10. Flujo principal
1.
2.
3.

## 11. Flujos alternativos y excepciones
- FA-01:
- EX-01:

## 12. Requisitos no funcionales
- Rendimiento:
- Seguridad:
- Auditoría:
- Accesibilidad:
- Disponibilidad:

## 13. Criterios de aceptación
- CA-01:
- CA-02:
- CA-03:

## 14. Trazabilidad
- Requisito origen:
- Historia de usuario:
- Diseño técnico:
- Casos de prueba:
- Componentes implicados:

## 15. Observaciones y decisiones abiertas
- 
```

---

## Justificación de la plantilla

### 1. Información general

Permite identificar la especificación y gestionarla como artefacto versionado.

### 2. Propósito

Evita perder de vista la necesidad real que se quiere cubrir.

### 3. Alcance

Reduce malentendidos sobre lo que forma parte de la especificación y lo que no.

### 4. Contexto y dependencias

Facilita comprender impacto e integraciones.

### 5. Definiciones

Evita ambigüedad terminológica.

### 6. Actores

Aclara quién interactúa con la funcionalidad o se ve afectado.

### 7. Entradas

Concreta datos necesarios y restricciones iniciales.

### 8. Salidas

Permite definir qué produce el sistema y cómo lo consumen otros.

### 9. Reglas de negocio

Recoge la lógica central del dominio.

### 10. Flujo principal

Describe el comportamiento normal.

### 11. Flujos alternativos y excepciones

Cubre casos no ideales y errores.

### 12. Requisitos no funcionales

Asegura que no se omitan dimensiones críticas.

### 13. Criterios de aceptación

Conecta la especificación con validación.

### 14. Trazabilidad

Facilita mantenimiento, auditoría e impacto de cambios.

### 15. Observaciones y decisiones abiertas

Permite registrar dudas o acuerdos pendientes sin contaminar otras secciones.

---

## Ejemplo breve de uso de la plantilla

```markdown
# [USR-004] Cambio de contraseña de usuario

## 1. Información general
- ID: USR-004
- Versión: 1.0
- Estado: Borrador
- Autor/Responsable: Equipo Plataforma
- Fecha: 2026-04-13
- Sistema/Módulo: Gestión de identidad

## 2. Propósito
Permitir que un usuario autenticado cambie su contraseña de forma segura.

## 3. Alcance
### Incluye
- Validación de contraseña actual
- Definición de nueva contraseña
- Confirmación de cambio
### Excluye
- Recuperación por olvido
- Administración de contraseñas por soporte

## 5. Definiciones
- Usuario autenticado: usuario con sesión activa y válida.

## 6. Actores
- Usuario autenticado

## 7. Entradas
- Contraseña actual
- Nueva contraseña
- Confirmación de nueva contraseña

## 9. Reglas de negocio
- RB-01: La contraseña actual debe coincidir con la registrada.
- RB-02: La nueva contraseña deberá tener al menos 12 caracteres.
- RB-03: No se permitirá reutilizar ninguna de las últimas 5 contraseñas.

## 10. Flujo principal
1. El usuario accede a su perfil.
2. Introduce contraseña actual y nueva contraseña.
3. El sistema valida los datos.
4. El sistema actualiza la contraseña.
5. El sistema muestra confirmación.

## 11. Flujos alternativos y excepciones
- EX-01: Si la contraseña actual es incorrecta, el sistema rechazará el cambio.
- EX-02: Si la nueva contraseña no cumple la política, el sistema mostrará el motivo.

## 13. Criterios de aceptación
- CA-01: Dado un usuario autenticado con contraseña actual correcta, cuando introduce una nueva contraseña válida, entonces el sistema actualiza la contraseña y muestra confirmación.
- CA-02: Dado un usuario autenticado, cuando introduce una contraseña actual incorrecta, entonces el sistema no cambia la contraseña e informa del error.
```

---

# 10. Actividades de evaluación

## Evaluación formativa

* identificación de ambigüedades;
* participación en revisión de especificaciones;
* capacidad de reescritura;
* calidad de la plantilla propuesta.

## Evaluación sumativa sugerida

### Opción A. Cuestionario breve

1. ¿Qué diferencia hay entre una especificación funcional y una de contrato?
2. ¿Por qué una especificación puede ser clara pero no completa?
3. ¿Qué significa que una especificación sea verificable?
4. ¿Qué tipo de problema aparece cuando una misma regla se expresa de dos formas incompatibles?
5. ¿Qué secciones mínimas debería tener una plantilla de especificación?

### Respuestas orientativas

1. La funcional describe comportamiento de negocio; la de contrato define acuerdos explícitos entre componentes o servicios.
2. Porque puede entenderse bien lo que dice, pero seguir faltando casos, reglas o excepciones.
3. Que puede comprobarse objetivamente mediante revisión, prueba o criterio observable.
4. Una inconsistencia o contradicción.
5. Identificación, propósito, alcance, reglas, entradas/salidas, flujos, excepciones y criterios de aceptación, entre otras.

---

### Opción B. Caso práctico corto

Se entrega esta frase:

> “El sistema mostrará alertas cuando detecte actividad sospechosa.”

Se pide:

* identificar defectos de calidad;
* reescribir la especificación;
* proponer dos criterios de aceptación.

### Solución orientativa

**Defectos:**

* no define actividad sospechosa;
* no define a quién se muestra la alerta;
* no define canal ni momento;
* no es verificable.

**Reescritura:**
“Cuando un usuario inicie sesión desde una ubicación geográfica no registrada previamente y falle dos intentos consecutivos de verificación adicional, el sistema mostrará una alerta en el panel de seguridad del usuario y enviará un correo electrónico a la cuenta asociada.”

**Criterios de aceptación:**

* CA-01: Dado un inicio de sesión desde ubicación no habitual con dos fallos de verificación, el sistema registra y muestra una alerta.
* CA-02: Dado el caso anterior, el sistema envía un correo al usuario afectado.

---

# 11. Criterios de evaluación

Se considerará superado el tema cuando el participante:

* reconoce correctamente tipos de especificaciones;
* estructura una especificación de forma ordenada y útil;
* identifica ambigüedades, omisiones e inconsistencias;
* propone mejoras con mayor precisión y verificabilidad;
* diseña una plantilla base adecuada al trabajo del equipo.

---

# 12. Recursos didácticos recomendados

* colección de requisitos ambiguos para reescritura;
* checklist de revisión de calidad;
* plantilla editable de especificación;
* ejemplos reales anonimizados;
* rúbrica de evaluación para revisión entre pares.

---

# 13. Checklist práctico de calidad de especificaciones

Puede usarse como herramienta de revisión rápida:

```markdown
## Checklist de revisión

### Comprensión
- [ ] Se entiende el objetivo de la especificación
- [ ] Se identifican actores y contexto
- [ ] Los términos de dominio están definidos

### Precisión
- [ ] No hay términos subjetivos o vagos
- [ ] Las condiciones están claramente expresadas
- [ ] Las reglas de negocio son concretas

### Completitud
- [ ] Se incluyen entradas y salidas relevantes
- [ ] Se contempla flujo principal
- [ ] Se contemplan flujos alternativos y errores
- [ ] Se identifican restricciones y dependencias

### Consistencia
- [ ] No hay contradicciones internas
- [ ] Está alineada con otras reglas o documentos

### Verificabilidad
- [ ] Existen criterios de aceptación
- [ ] Se pueden derivar pruebas objetivas

### Mantenibilidad
- [ ] La estructura es clara
- [ ] La información no está duplicada innecesariamente
- [ ] La especificación puede versionarse y actualizarse
```

---

# 14. Mensajes clave para cerrar el tema

1. Una especificación útil no es la más larga, sino la más clara, precisa y verificable.
2. Existen distintos tipos de especificaciones porque cada una responde a preguntas diferentes.
3. Una buena estructura ayuda a pensar mejor y a reducir omisiones.
4. La mayoría de los problemas en una especificación aparecen como ambigüedad, incompletitud o inconsistencia.
5. Revisar especificaciones de forma sistemática mejora tanto el desarrollo como las pruebas.
6. Una plantilla común de equipo favorece consistencia y colaboración.

---

# 15. Resumen ejecutivo del tema

El Tema 2 profundiza en cómo construir especificaciones útiles para SDD. Se presentan los principales tipos de especificación —funcional, técnica, de interfaz, de contrato y de aceptación— y se explica cómo estructurarlas para que sean claras, completas y mantenibles. Además, se trabajan criterios de calidad como claridad, precisión, consistencia, completitud, verificabilidad y trazabilidad. Los laboratorios permiten practicar la reescritura de requisitos ambiguos, la revisión de especificaciones defectuosas y la creación de una plantilla base reutilizable para el equipo.

---

# Anexo. Versión resumida de plantilla base en Markdown

```markdown
# [ID] Título

## Información general
- ID:
- Versión:
- Estado:
- Responsable:
- Fecha:
- Sistema/Módulo:

## Propósito
...

## Alcance
### Incluye
- ...
### Excluye
- ...

## Contexto y dependencias
- ...

## Definiciones
- ...

## Actores
- ...

## Entradas
- ...

## Salidas
- ...

## Reglas de negocio
- RB-01:
- RB-02:

## Flujo principal
1.
2.
3.

## Flujos alternativos y excepciones
- FA-01:
- EX-01:

## Requisitos no funcionales
- ...

## Criterios de aceptación
- CA-01:
- CA-02:

## Trazabilidad
- ...
```

Si quieres, sigo con el **Tema 3** manteniendo este mismo formato y nivel de detalle.
