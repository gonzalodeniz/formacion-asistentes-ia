# Tema 3. Descubrimiento y refinamiento de requisitos

## 1. Introducción

El descubrimiento y refinamiento de requisitos es la disciplina que permite pasar de una necesidad difusa del negocio a un conjunto de especificaciones claras, verificables y útiles para desarrollo. En términos de análisis de negocio, esta etapa incluye **estructurar, modelar, verificar y validar requisitos** para reducir ambigüedades y alinear expectativas entre negocio, usuarios y equipo técnico. ([iiba.org][1])

En la práctica, el problema no suele ser “no tener requisitos”, sino tenerlos en estado implícito, incompleto o contradictorio. El trabajo del analista, product owner o equipo de requisitos consiste en:

* descubrir necesidades reales;
* separar problema de solución;
* refinar el detalle progresivamente;
* validar pronto con stakeholders;
* dejar evidencia suficiente para construir sin malentendidos.

En entornos iterativos, este refinamiento no ocurre una sola vez. El backlog o conjunto de requisitos se **refina de forma continua** a medida que se aprende más del producto, del contexto y de los usuarios. ([scrumguides.org][2])

---

## 2. Objetivos del tema

Al finalizar este tema, el estudiante debería ser capaz de:

1. **Convertir necesidades de negocio en requisitos estructurados.**
2. **Refinar requisitos de alto nivel hasta hacerlos implementables.**
3. **Involucrar a stakeholders en la validación temprana.**
4. **Reducir malentendidos antes de empezar a construir.**

---

## 3. ¿Qué es un requisito?

Un requisito expresa una necesidad, capacidad, condición o restricción relevante para una solución. En ingeniería de requisitos, no todos los requisitos son iguales: unos describen lo que el sistema debe hacer, otros cómo debe comportarse y otros limitan el diseño o la operación. ([ISO][3])

### 3.1 Tipos de requisitos

### a) Requisitos de negocio

Describen el objetivo organizativo o el resultado esperado.

**Ejemplos**

* Reducir en 30% el tiempo de atención al cliente.
* Disminuir errores de facturación.
* Aumentar conversión de ventas online.

### b) Requisitos de usuario o stakeholder

Expresan lo que un usuario necesita poder hacer.

**Ejemplos**

* El cliente debe poder consultar el estado de su pedido.
* El supervisor debe poder aprobar solicitudes pendientes.

### c) Requisitos funcionales

Definen comportamientos o servicios del sistema.

**Ejemplos**

* El sistema permitirá registrar pedidos.
* El sistema enviará una notificación al confirmar el pago.

### d) Requisitos no funcionales

Definen cualidades o restricciones: rendimiento, seguridad, disponibilidad, usabilidad, cumplimiento, etc. BABOK e ISO/IEC/IEEE 29148 contemplan explícitamente el análisis y especificación de este tipo de requisitos. ([iiba.org][1])

**Ejemplos**

* El tiempo de respuesta será menor de 2 segundos en el 95% de las consultas.
* El acceso administrativo requerirá autenticación multifactor.

### e) Reglas de negocio y restricciones

No siempre son funcionalidades; a veces imponen condiciones obligatorias.

**Ejemplos**

* Ningún descuento superior al 20% podrá aplicarse sin aprobación.
* La información personal debe almacenarse cifrada.

---

## 4. Del problema al requisito

Una de las habilidades más importantes consiste en diferenciar entre:

* **síntoma**: “los clientes se quejan”;
* **problema**: “no tienen visibilidad del estado de su pedido”;
* **necesidad**: “consultar el estado sin llamar al soporte”;
* **requisito**: “el portal mostrará estado, fecha estimada y eventos del pedido”.

### Ejemplo

**Declaración inicial del negocio**
“Necesitamos mejorar la atención al cliente porque el call center está saturado.”

Esto aún no es un requisito. El análisis debe convertirlo en algo más útil:

**Posibles hallazgos**

* El 40% de llamadas es para consultar estado de pedido.
* Los usuarios no reciben notificaciones claras.
* Los agentes no tienen una vista consolidada.

**Requisitos derivados**

* El cliente podrá consultar el estado del pedido desde web y móvil.
* El sistema enviará notificaciones automáticas ante cambios de estado.
* El agente verá historial de eventos del pedido en una sola pantalla.

---

## 5. Proceso de descubrimiento de requisitos

## 5.1 Preparación

Antes de entrevistar o modelar, conviene entender:

* contexto del negocio;
* objetivo del proyecto;
* actores involucrados;
* restricciones iniciales;
* supuestos y riesgos.

### Entregables útiles

* mapa de stakeholders;
* lista de objetivos de negocio;
* preguntas de descubrimiento;
* glosario básico.

## 5.2 Elicitación o levantamiento

BABOK considera entrevistas, workshops, observación, revisiones y prototipado entre las técnicas habituales de descubrimiento. ([iiba.org][1])

### Técnicas frecuentes

* entrevistas;
* talleres;
* observación del trabajo real;
* análisis documental;
* tormenta de ideas;
* prototipos;
* historias de usuario y escenarios;
* modelado de procesos.

## 5.3 Análisis y estructuración

La información obtenida suele venir mezclada:

* necesidades reales;
* opiniones;
* soluciones propuestas;
* restricciones;
* excepciones;
* conflictos entre áreas.

Aquí se organiza todo en categorías comprensibles.

## 5.4 Refinamiento

Refinar es pasar de algo grande, ambiguo o abstracto a algo:

* más pequeño,
* más concreto,
* más verificable,
* más priorizable,
* más implementable.

En entornos ágiles, el refinamiento continuo del backlog es una práctica central. ([scrumguides.org][2])

## 5.5 Verificación y validación

Según BABOK, **verificar** consiste en revisar calidad y consistencia del requisito; **validar** consiste en comprobar que el requisito realmente aporta valor y responde a la necesidad del negocio. ([iiba.org][4])

---

## 6. Técnicas para transformar necesidades en requisitos

## 6.1 Entrevistas

Sirven para entender objetivos, dolores, reglas y prioridades.

### Buenas prácticas

* preguntar por objetivos antes que por pantallas;
* pedir ejemplos concretos;
* identificar excepciones;
* distinguir entre “debe” y “sería deseable”;
* confirmar lo entendido al final.

### Preguntas útiles

* ¿Qué problema intentas resolver?
* ¿Cómo se hace hoy?
* ¿Qué errores ocurren?
* ¿Qué casos especiales existen?
* ¿Cómo sabrás que esto ha mejorado?

---

## 6.2 Historias de usuario

La Agile Alliance recoge como formato común la plantilla **“Como [rol], quiero [objetivo], para [beneficio]”**. ([Agile Alliance][5])

**Ejemplo**
Como cliente, quiero consultar el estado de mi pedido, para no tener que llamar a soporte.

Ventaja: mantiene foco en el valor.
Riesgo: si se usa sola, puede quedarse demasiado superficial.

---

## 6.3 Criterios de aceptación

La Agile Alliance describe **Given-When-Then** como plantilla para redactar pruebas o criterios de aceptación de forma observable. ([Agile Alliance][6])

**Ejemplo**

* Dado que el cliente tiene un pedido confirmado,
* cuando accede a “Mis pedidos”,
* entonces verá el estado actual y la fecha estimada de entrega.

---

## 6.4 Casos de uso y escenarios

Útiles cuando hay interacción más compleja.

Incluyen:

* actor;
* objetivo;
* flujo principal;
* flujos alternativos;
* precondiciones;
* postcondiciones.

---

## 6.5 Modelado de procesos

Ayuda a detectar cuellos de botella, duplicidades y puntos de integración.

**Ejemplo simple**

1. Cliente realiza pedido
2. Sistema valida pago
3. Almacén prepara envío
4. Transporte recoge paquete
5. Cliente recibe notificación

Del proceso pueden salir requisitos funcionales, datos necesarios y eventos relevantes.

---

## 7. Criterios de calidad de un buen requisito

Un buen requisito debería ser, idealmente:

* claro;
* no ambiguo;
* consistente;
* necesario;
* verificable;
* priorizado;
* trazable;
* factible.

Esto está alineado con prácticas de verificación de requisitos descritas en estándares y guías de análisis de requisitos. ([ISO][3])

### Ejemplo malo

“El sistema será rápido y fácil de usar.”

### Ejemplo mejor

“El sistema mostrará el historial de pedidos en menos de 2 segundos para el 95% de las consultas, con un máximo de 3 clics desde la pantalla principal.”

---

## 8. Refinamiento incremental

Refinar no es “documentar más”, sino **mejorar la precisión útil para decidir y construir**.

### Evolución típica

### Nivel 1: necesidad

“Queremos mejorar la gestión de incidencias.”

### Nivel 2: capacidad deseada

“Los usuarios deben reportar incidencias y hacer seguimiento.”

### Nivel 3: historia o requisito funcional

“El usuario autenticado podrá registrar una incidencia con categoría, prioridad y descripción.”

### Nivel 4: criterios de aceptación

* Debe obligar a seleccionar categoría.
* Debe asignar un identificador único.
* Debe permitir consultar estado.
* Debe registrar fecha y usuario creador.

### Nivel 5: detalle implementable

* Campos: id, categoría, prioridad, descripción, adjunto, estado, fecha_creación.
* Reglas: prioridad alta notifica al supervisor.
* Restricción: adjuntos máx. 10 MB.
* API/servicios implicados.
* Eventos de auditoría.

---

## 9. Validación temprana con stakeholders

Validar pronto cuesta menos que corregir tarde. Una especificación aparentemente correcta puede ser inútil si no resuelve la necesidad real.

### Técnicas de validación temprana

* revisión conjunta de requisitos;
* walkthrough con negocio;
* prototipos de baja fidelidad;
* role-play entre negocio y desarrollo;
* ejemplos concretos de uso;
* definición de criterios de aceptación compartidos.

### Preguntas de validación

* ¿Esto resuelve el problema real?
* ¿Falta algún caso importante?
* ¿Hay reglas que no estén reflejadas?
* ¿Qué pasa cuando algo sale mal?
* ¿Esto sería aceptable para operar el día 1?

---

## 10. Errores frecuentes

1. Confundir solución con necesidad.
   “Necesitamos una app” no explica el problema.

2. Redactar requisitos ambiguos.
   “rápido”, “intuitivo”, “seguro” sin métricas.

3. Ignorar excepciones.
   Los casos raros suelen romper el proceso.

4. No involucrar a desarrollo temprano.
   Puede haber requisitos inviables o incompletos.

5. No validar con usuarios reales.
   El negocio puede asumir cosas que el usuario final no comparte.

6. No definir criterios de aceptación.
   Sin ellos, el equipo interpreta cada requisito a su manera.

---

# 11. Laboratorios resueltos

---

# Laboratorio 1. Transformar entrevistas de negocio en especificaciones iniciales

## Enunciado propuesto

Se han realizado entrevistas a personal de una empresa de ventas online. A partir de los extractos, se pide convertir la información en una especificación inicial.

## Extracto de entrevistas

### Responsable de atención al cliente

“Recibimos muchas llamadas preguntando por el estado del pedido. Los clientes dicen que los correos no son suficientes o llegan tarde.”

### Responsable de operaciones

“Cuando el pedido cambia de estado en almacén, esa información no siempre llega al sistema que consulta soporte.”

### Directora comercial

“Queremos mejorar la experiencia postventa y reducir llamadas al call center al menos un 25% este semestre.”

### Agente de soporte

“A veces el cliente llama y ni siquiera tenemos la fecha estimada actualizada.”

---

## Solución

## 1. Necesidades de negocio identificadas

* Reducir volumen de llamadas por consultas de estado.
* Mejorar experiencia postventa.
* Unificar visibilidad del estado de pedidos.
* Disponer de información actualizada para soporte.

## 2. Problemas detectados

* Falta de autoservicio efectivo para el cliente.
* Notificaciones insuficientes o tardías.
* Integración incompleta entre almacén y sistema de soporte.
* Fecha estimada de entrega desactualizada.

## 3. Objetivos del negocio

* Reducir llamadas al call center en al menos 25%.
* Mejorar transparencia del proceso de entrega.
* Disminuir tiempo medio de atención en consultas de pedido.

## 4. Stakeholders

* Cliente final
* Agente de soporte
* Responsable de operaciones
* Dirección comercial
* Equipo de desarrollo
* Equipo de integración / sistemas

## 5. Especificación inicial de requisitos

### Requisitos funcionales

**RF-01.** El sistema permitirá al cliente consultar el estado actual de su pedido desde el portal web.
**RF-02.** El sistema mostrará la fecha estimada de entrega actualizada.
**RF-03.** El sistema registrará y mostrará el historial de cambios de estado del pedido.
**RF-04.** El sistema notificará al cliente cuando el pedido cambie de estado relevante.
**RF-05.** El sistema mostrará al agente de soporte la misma información de seguimiento visible para el cliente.
**RF-06.** El sistema integrará los eventos de cambio de estado procedentes del almacén.

### Requisitos no funcionales

**RNF-01.** La información de estado deberá actualizarse en un plazo máximo de 5 minutos desde el evento en almacén.
**RNF-02.** La consulta del estado deberá responder en menos de 2 segundos en el 95% de los casos.
**RNF-03.** El historial del pedido deberá estar disponible 24/7 con una disponibilidad mensual mínima del 99,5%.

### Reglas de negocio

**RB-01.** Solo se notificarán automáticamente los cambios de estado definidos como relevantes: confirmado, preparado, enviado, en reparto y entregado.
**RB-02.** La fecha estimada de entrega deberá recalcularse cuando cambie el estado logístico.

## 6. Historias de usuario iniciales

* Como cliente, quiero consultar el estado de mi pedido, para saber cuándo lo recibiré.
* Como cliente, quiero recibir notificaciones de cambios relevantes, para no tener que llamar a soporte.
* Como agente de soporte, quiero ver el historial actualizado del pedido, para responder al cliente sin depender de otros sistemas.

## 7. Criterios de aceptación de ejemplo

**HU-01: Consultar estado del pedido**

* Dado un pedido existente del cliente,
* cuando accede a la sección “Mis pedidos”,
* entonces verá estado actual, fecha estimada e historial de eventos.

**HU-02: Notificación de cambio de estado**

* Dado un pedido confirmado,
* cuando el pedido pase a “enviado”,
* entonces el cliente recibirá una notificación con el nuevo estado.

## 8. Supuestos

* Existe identificación unívoca de pedido.
* El sistema de almacén emite eventos confiables.
* El cliente ya dispone de acceso autenticado al portal.

## 9. Riesgos

* Integración deficiente con almacén.
* Calidad baja de datos logísticos.
* Demoras en sincronización entre sistemas.

## Resultado esperado del laboratorio

El alumno debe demostrar que puede convertir declaraciones narrativas en:

* objetivos;
* problemas;
* stakeholders;
* requisitos estructurados;
* criterios iniciales de validación.

---

# Laboratorio 2. Taller de refinamiento incremental de requisitos

## Enunciado propuesto

A partir de un requisito de alto nivel, refinar hasta dejarlo preparado para desarrollo.

## Requisito inicial

“El sistema debe permitir gestionar incidencias.”

---

## Solución

## Paso 1. Detectar ambigüedad

La frase es demasiado amplia:

* ¿quién gestiona?
* ¿qué significa gestionar?
* ¿crear, asignar, cerrar, comentar, escalar?
* ¿qué tipos de incidencia existen?
* ¿qué reglas de prioridad hay?

## Paso 2. Descomponer capacidades

La gestión de incidencias puede dividirse en:

1. registrar incidencia;
2. clasificarla;
3. asignarla;
4. consultar su estado;
5. actualizarla;
6. cerrarla;
7. auditar cambios.

## Paso 3. Identificar roles

* Usuario reportante
* Agente técnico
* Supervisor
* Administrador

## Paso 4. Convertir en historias de usuario

### HU-01

Como usuario reportante, quiero registrar una incidencia, para solicitar soporte.

### HU-02

Como agente técnico, quiero ver incidencias asignadas, para poder resolverlas.

### HU-03

Como supervisor, quiero reasignar incidencias según prioridad y carga, para asegurar tiempos de respuesta.

### HU-04

Como usuario reportante, quiero consultar el estado de mi incidencia, para saber si está siendo atendida.

## Paso 5. Añadir criterios de aceptación

### HU-01 Registrar incidencia

* Dado que el usuario está autenticado,
* cuando accede al formulario de incidencias,
* entonces podrá introducir categoría, asunto, descripción y adjunto.
* La categoría será obligatoria.
* El sistema generará identificador único.
* El estado inicial será “abierta”.

### HU-02 Consultar incidencias asignadas

* Dado que el agente ha iniciado sesión,
* cuando accede a su bandeja,
* entonces verá solo incidencias asignadas a él o a su grupo.
* Podrá filtrar por estado y prioridad.

### HU-03 Reasignar incidencia

* Solo el supervisor podrá cambiar asignación.
* Toda reasignación quedará registrada en auditoría.
* Si la prioridad es crítica, el sistema notificará al nuevo responsable.

## Paso 6. Especificar datos necesarios

* id_incidencia
* fecha_creación
* usuario_creador
* categoría
* prioridad
* estado
* descripción
* adjunto
* agente_asignado
* fecha_última_actualización
* historial_cambios

## Paso 7. Reglas de negocio

* Toda incidencia debe tener una categoría.
* Solo incidencias en estado “resuelta” pueden pasar a “cerrada”.
* Prioridad crítica exige notificación inmediata.
* Si pasan más de 24 horas sin asignación, se escala al supervisor.

## Paso 8. Requisitos no funcionales

* El registro de incidencia no superará 3 segundos.
* El sistema mantendrá trazabilidad completa de cambios.
* Los adjuntos aceptarán hasta 10 MB.
* Solo usuarios autenticados podrán consultar incidencias internas.

## Paso 9. Criterio de “listo para desarrollo”

Un requisito refinado está listo cuando:

* tiene actor claro;
* describe comportamiento observable;
* incluye reglas;
* contempla excepciones básicas;
* tiene criterios de aceptación;
* se puede estimar e implementar.

## Resultado refinado final

En lugar de “gestionar incidencias”, ahora existe un conjunto de unidades claras, priorizables y verificables.

---

# Laboratorio 3. Validación de especificaciones con roles simulados de negocio y desarrollo

## Enunciado propuesto

Se presenta una especificación preliminar y se simula una sesión de validación entre negocio y desarrollo.

## Especificación a validar

“Los clientes podrán cancelar un pedido mientras no haya sido enviado.”

---

## Solución

## 1. Preparación de la sesión

### Roles simulados

* **Negocio / Comercial**
* **Operaciones / Logística**
* **Atención al cliente**
* **Desarrollo**
* **QA**

### Objetivo de la validación

Comprobar si el requisito:

* refleja la intención del negocio;
* es viable técnicamente;
* contempla excepciones;
* se puede probar.

---

## 2. Revisión desde cada rol

### Aporte de negocio

“Queremos que el cliente tenga autonomía para cancelar sin llamar.”

**Necesidad real:** reducir fricción y llamadas.

### Aporte de operaciones

“Si el pedido ya está en preparación física, cancelarlo puede generar costes.”

**Riesgo detectado:** “no enviado” quizá no es suficiente; puede existir estado “preparándose”.

### Aporte de atención al cliente

“Necesitamos ver por qué se canceló y si corresponde devolución.”

**Nuevo requisito:** registrar motivo y disparar flujo asociado.

### Aporte de desarrollo

“Necesitamos definición exacta de estados y de qué ocurre con el pago.”

**Ambigüedad técnica detectada:** falta modelo de estados y reglas de reversión.

### Aporte de QA

“Necesitamos escenarios de prueba claros: pagado/no pagado, parcial, pedido con varios artículos.”

**Falta:** criterios de aceptación y casos alternativos.

---

## 3. Problemas detectados en la especificación original

* “Mientras no haya sido enviado” es ambiguo.
* No define estados válidos.
* No contempla pedidos parcialmente preparados.
* No contempla pagos capturados.
* No contempla trazabilidad de la cancelación.
* No define respuesta al usuario.

---

## 4. Requisito validado y corregido

### Requisito funcional refinado

**RF-CP-01.** El cliente podrá solicitar la cancelación de un pedido desde su área personal cuando el pedido se encuentre en estado **pendiente de pago**, **pagado** o **en preparación no iniciada**.

### Reglas de negocio

**RB-CP-01.** No se permitirá la cancelación si el pedido está en estado **preparación iniciada**, **enviado**, **en reparto** o **entregado**.
**RB-CP-02.** Si el pago ya fue capturado, el sistema iniciará automáticamente el flujo de reembolso.
**RB-CP-03.** El sistema solicitará al cliente un motivo de cancelación opcional.
**RB-CP-04.** Toda cancelación quedará registrada con fecha, hora y usuario.

### Requisitos de usuario

* Como cliente, quiero cancelar un pedido elegible, para corregir una compra no deseada.
* Como agente de soporte, quiero ver el estado y motivo de la cancelación, para atender reclamaciones.
* Como finanzas, quiero que las cancelaciones de pedidos pagados generen flujo de reembolso.

### Criterios de aceptación

* Dado un pedido en estado “pagado”,
  cuando el cliente pulse “Cancelar pedido” y confirme,
  entonces el sistema marcará el pedido como “cancelado” e iniciará reembolso.
* Dado un pedido en estado “enviado”,
  cuando el cliente intente cancelarlo,
  entonces el sistema mostrará que la cancelación ya no está disponible.
* Dado un pedido cancelable,
  cuando se confirme la cancelación,
  entonces se registrará usuario, fecha y motivo.

### Casos de prueba básicos

1. Pedido pendiente de pago → cancelación permitida.
2. Pedido pagado → cancelación permitida con reembolso.
3. Pedido en preparación iniciada → cancelación denegada.
4. Pedido enviado → cancelación denegada.
5. Pedido cancelado → no permite segunda cancelación.

---

## 5. Conclusión del laboratorio

La validación con roles simulados demuestra que un requisito aparentemente simple suele ocultar:

* estados intermedios;
* reglas operativas;
* implicaciones técnicas;
* necesidades de auditoría;
* escenarios de prueba.

El valor de la validación temprana es precisamente descubrir esto antes de construir.

---

# 12. Plantilla práctica para trabajar requisitos

Te dejo una plantilla útil para clase o ejercicios.

## Ficha de requisito

**ID:**
**Nombre:**
**Origen:** entrevista / taller / documento / observación
**Objetivo de negocio asociado:**
**Stakeholders:**
**Descripción:**
**Tipo:** funcional / no funcional / regla de negocio
**Prioridad:** alta / media / baja
**Precondiciones:**
**Flujo principal:**
**Excepciones:**
**Criterios de aceptación:**
**Dependencias:**
**Riesgos:**
**Observaciones:**

---

# 13. Resumen del tema

El descubrimiento y refinamiento de requisitos consiste en transformar información dispersa en especificaciones útiles, verificables y alineadas con el negocio. Para hacerlo bien hay que:

* escuchar y analizar antes de escribir;
* separar necesidad de solución;
* refinar de forma incremental;
* documentar reglas y criterios de aceptación;
* validar pronto con negocio, desarrollo y QA.

Cuando esto se hace bien, disminuyen los retrabajos, las interpretaciones erróneas y la construcción de funcionalidades que no aportan valor. Las guías de BABOK, Scrum y el estándar ISO/IEC/IEEE 29148 coinciden en la importancia de **estructurar, verificar, validar y refinar continuamente** los requisitos. ([iiba.org][1])

---

# 14. Fuentes

* IIBA, **BABOK / Requirements Analysis and Design Definition**. ([iiba.org][1])
* ISO, **ISO/IEC/IEEE 29148 Requirements Engineering**. ([ISO][3])
* Scrum Guides, **2020 Scrum Guide**. ([scrumguides.org][2])
* Agile Alliance, **User Stories**, **User Story Template**, **Given-When-Then**. ([Agile Alliance][7])

Puedo convertir este contenido en formato **apuntes de clase**, **tema académico formal**, o **presentación de diapositivas**.

[1]: https://www.iiba.org/knowledgehub/business-analysis-body-of-knowledge-babok-guide/7-requirements-analysis-and-design-definition/?utm_source=chatgpt.com "7. Requirements Analysis and Design Definition"
[2]: https://scrumguides.org/docs/scrumguide/v2020/2020-Scrum-Guide-US.pdf?utm_source=chatgpt.com "2020 Scrum Guide"
[3]: https://www.iso.org/obp/ui/en/?utm_source=chatgpt.com "ISO/IEC/IEEE 29148:2018(en), Systems and software ..."
[4]: https://www.iiba.org/knowledgehub/the-business-analysis-standard/5-applying-business-analysis-tasks/5-3-business-analysis-knowledge-areas/requirements-analysis-and-design-definition/?utm_source=chatgpt.com "Requirements Analysis and Design Definition"
[5]: https://agilealliance.org/glossary/user-story-template/?utm_source=chatgpt.com "User Story Template"
[6]: https://agilealliance.org/glossary/given-when-then/?utm_source=chatgpt.com "What is \"Given - When - Then\"?"
[7]: https://agilealliance.org/glossary/user-stories/?utm_source=chatgpt.com "What are User Stories?"
