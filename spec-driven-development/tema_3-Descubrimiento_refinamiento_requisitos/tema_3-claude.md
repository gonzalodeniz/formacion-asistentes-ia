# Tema 3. Descubrimiento y refinamiento de requisitos

---

## 3.1. Introducción

En los temas anteriores hemos establecido qué es SDD, qué tipos de especificaciones existen y qué criterios de calidad deben cumplir. Pero hay una pregunta previa que todo equipo se plantea al adoptar SDD: **¿de dónde salen las especificaciones?**

Las especificaciones no aparecen de la nada. Nacen de necesidades de negocio, expectativas de usuarios, restricciones regulatorias, problemas operativos o decisiones estratégicas. El camino entre una necesidad expresada de forma vaga ("necesitamos digitalizar el proceso de facturación") y una especificación verificable e implementable es largo, y es precisamente en ese camino donde se producen la mayoría de los malentendidos que arruinan proyectos.

Este tema aborda ese camino: cómo se descubren las necesidades reales, cómo se estructuran en requisitos y cómo se refinan iterativamente hasta convertirlas en especificaciones que el equipo de desarrollo puede implementar con confianza.

### El problema del "teléfono roto"

En muchos proyectos, la información fluye así:

1. El sponsor del proyecto tiene una idea general de lo que necesita.
2. Se lo cuenta al responsable de producto en una reunión.
3. El responsable de producto lo reformula y lo escribe en un documento o un ticket.
4. El analista lo descompone en historias de usuario.
5. El desarrollador lee la historia y la interpreta según su criterio.
6. QA prueba lo que cree que debería hacer el sistema.

En cada paso se pierde contexto, se añaden suposiciones y se introducen interpretaciones. Al final del proceso, lo que se construye puede no tener relación con lo que se necesitaba. El descubrimiento y refinamiento de requisitos es la disciplina que minimiza esta degradación.

---

## 3.2. El proceso de descubrimiento

### 3.2.1. ¿Qué es descubrir requisitos?

Descubrir requisitos no es simplemente "preguntar al cliente qué quiere". Es un proceso de investigación activa que combina escucha, análisis, observación y síntesis. Los stakeholders rara vez conocen todos sus requisitos de antemano. Muchos requisitos están implícitos, son contradictorios entre sí o solo emergen cuando se profundiza en los detalles.

El objetivo del descubrimiento no es obtener una lista cerrada de requisitos, sino construir una **comprensión compartida** del problema que se quiere resolver, los actores involucrados, las restricciones que existen y el valor que se espera obtener.

### 3.2.2. Fuentes de requisitos

Los requisitos no provienen de una única fuente. Un buen proceso de descubrimiento consulta múltiples fuentes para obtener una visión completa:

**Stakeholders directos**: las personas que solicitan, financian o usarán el sistema. Aportan la visión de negocio, las prioridades y las expectativas. Sin embargo, su visión puede ser parcial (cada uno ve "su parte" del problema) y a veces contradictoria.

**Usuarios finales**: las personas que interactuarán con el sistema en su día a día. Aportan conocimiento práctico sobre los flujos de trabajo reales, los problemas actuales y las necesidades operativas. A menudo conocen detalles que los stakeholders de nivel directivo desconocen.

**Sistemas existentes**: si hay un sistema anterior (o un proceso manual), estudiarlo revela requisitos que nadie mencionaría porque los da por supuestos. El sistema actual es una fuente rica de reglas de negocio implícitas, casos especiales y flujos alternativos.

**Documentación existente**: manuales de procedimiento, normativa, contratos, informes de auditoría, tickets de soporte, actas de reuniones anteriores. Estos documentos contienen requisitos que nadie recuerda haber formulado pero que son críticos.

**Datos y métricas**: los datos de uso del sistema actual (si existe) revelan patrones reales: qué funcionalidades se usan, cuáles se ignoran, dónde se producen errores, qué flujos se abandonan.

**Regulación y normativa**: requisitos legales que no son negociables y que a menudo no se mencionan en las entrevistas porque se asumen como "obvios" (protección de datos, accesibilidad, retención fiscal, etc.).

**Competencia y mercado**: análisis de productos similares o competidores. No para copiar, sino para identificar estándares del sector, expectativas de los usuarios y oportunidades de diferenciación.

### 3.2.3. Barreras habituales en el descubrimiento

El descubrimiento no siempre es sencillo. Estas son las barreras más frecuentes:

**El stakeholder que sabe la solución pero no el problema**: llega a la reunión diciendo "necesito un botón que haga X" en lugar de explicar qué problema intenta resolver. Si el equipo implementa el botón sin cuestionar, puede estar resolviendo el síntoma en lugar de la causa.

**El requisito implícito**: el stakeholder asume que ciertas cosas son "obvias" y no las menciona. "Es evidente que el sistema tiene que funcionar en móvil" — pero nadie lo dijo, y el equipo diseñó solo para escritorio.

**El conflicto entre stakeholders**: dos departamentos tienen necesidades contradictorias. Comercial quiere que los clientes puedan hacer pedidos sin restricciones; Finanzas quiere que no se pueda pedir sin crédito aprobado. Si el conflicto no se detecta y resuelve en el descubrimiento, se descubrirá en producción.

**La resistencia al cambio**: los usuarios del sistema actual pueden sabotear (consciente o inconscientemente) el descubrimiento porque perciben el nuevo sistema como una amenaza. Proporcionan información incompleta o sesgada.

**La sobrecarga de información**: el stakeholder proporciona tanta información (documentos, procesos, excepciones, casos históricos) que el equipo no puede procesarla y se pierde en los detalles sin captar lo esencial.

---

## 3.3. Técnicas de descubrimiento

### 3.3.1. Entrevistas estructuradas

La entrevista es la técnica más directa para obtener información de los stakeholders. Pero una entrevista mal preparada produce información vaga e inutilizable. Una entrevista estructurada sigue un guion diseñado para obtener información concreta y accionable.

**Estructura recomendada**:

1. **Contexto y objetivo** (5 min): explicar el propósito de la entrevista y qué se hará con la información obtenida.
2. **Visión general** (10 min): ¿cuál es el problema que quieres resolver? ¿Qué ocurre hoy? ¿Qué impacto tiene?
3. **Actores y roles** (10 min): ¿quién participa en este proceso? ¿Qué rol tiene cada persona? ¿Quién toma las decisiones?
4. **Flujo actual** (15 min): describe paso a paso cómo funciona el proceso hoy. ¿Qué herramientas usas? ¿Dónde están los cuellos de botella?
5. **Excepciones y problemas** (10 min): ¿qué falla habitualmente? ¿Qué casos especiales existen? ¿Qué workarounds usas?
6. **Expectativas** (10 min): ¿qué debería cambiar con el nuevo sistema? ¿Cómo sabrías que funciona bien? ¿Qué sería inaceptable?
7. **Cierre** (5 min): resumen de los puntos clave, próximos pasos, compromiso de revisión.

**Buenas prácticas**:

- Preguntar "¿por qué?" al menos tres veces para llegar a la causa raíz. Si el stakeholder dice "necesito un informe de ventas diario", preguntar por qué lo necesita puede revelar que el problema real es que no tiene visibilidad del pipeline, y quizá un dashboard en tiempo real es mejor solución que un informe diario.
- Pedir ejemplos concretos: "¿Puedes enseñarme un caso real de este problema?" es más productivo que "¿Qué problemas tienes?"
- Distinguir entre lo que el stakeholder dice que necesita, lo que realmente necesita y lo que desea. Las tres cosas rara vez coinciden.
- Tomar notas literales de frases clave, no interpretaciones. La frase exacta del stakeholder es más valiosa que la paráfrasis del analista.
- Grabar la entrevista (con permiso) como respaldo, pero no como sustituto de las notas.

### 3.3.2. Talleres de descubrimiento colaborativo

Cuando hay múltiples stakeholders con visiones complementarias o contradictorias, las entrevistas individuales no bastan. Un taller de descubrimiento reúne a los actores clave en una sesión facilitada para construir una visión compartida.

**Formatos útiles**:

**Event Storming**: técnica de modelado colaborativo donde los participantes identifican los eventos del dominio (cosas que ocurren en el sistema) usando post-its en una pared o pizarra. Cada evento se escribe en pasado ("Pedido confirmado", "Factura emitida", "Pago rechazado"). Los eventos se ordenan cronológicamente y se enriquecen con comandos (acciones del usuario), actores, políticas de negocio y sistemas externos. El resultado es un mapa del dominio que todos los participantes entienden porque lo han construido juntos.

**Example Mapping**: técnica para explorar una historia de usuario o funcionalidad mediante cuatro tipos de tarjetas de colores: la historia (amarilla), las reglas de negocio (azul), los ejemplos concretos (verde) y las preguntas abiertas (roja). Si una historia acumula demasiadas tarjetas rojas, no está lista para implementarse. Si acumula muchas azules, probablemente debería dividirse.

**User Story Mapping**: técnica para visualizar el sistema completo desde la perspectiva del usuario. Se crea un mapa horizontal con las actividades principales del usuario (flujo narrativo) y vertical con los detalles y variaciones de cada actividad. El mapa permite identificar un MVP (producto mínimo viable), priorizar funcionalidades y detectar huecos.

### 3.3.3. Observación directa

A veces la mejor forma de entender un proceso no es preguntar, sino observar. La observación directa (a veces llamada "shadowing" o "contextual inquiry") consiste en acompañar al usuario en su entorno de trabajo real y observar cómo realiza las tareas que el sistema debe soportar.

Esta técnica revela información que las entrevistas no capturan:
- Pasos que el usuario hace automáticamente sin ser consciente de ellos.
- Workarounds informales (hojas de cálculo paralelas, post-its, correos a compañeros).
- Interrupciones y cambios de contexto que afectan al flujo de trabajo.
- Diferencias entre el proceso oficial (el que describe el manual) y el proceso real (el que se ejecuta día a día).

### 3.3.4. Análisis de documentación y sistemas existentes

Antes de una entrevista o taller, conviene revisar la documentación existente:
- Manuales de procedimiento: revelan el proceso oficial y las reglas formales.
- Tickets de soporte o incidencias: revelan los problemas recurrentes y los puntos de dolor.
- Informes de auditoría: revelan riesgos y requisitos de cumplimiento.
- El sistema actual (si existe): las pantallas, los formularios, los informes y los flujos del sistema actual codifican años de decisiones de negocio que nadie recuerda explícitamente.

### 3.3.5. Prototipado rápido como herramienta de descubrimiento

A veces, la mejor forma de descubrir requisitos es mostrar algo tangible al stakeholder y dejar que reaccione. Un prototipo de baja fidelidad (wireframe, mockup en papel, maqueta interactiva) provoca respuestas más concretas que una pregunta abierta.

Cuando el stakeholder ve un prototipo, sus reacciones revelan requisitos implícitos:
- "Ah, pero aquí falta el campo de referencia interna, que usamos siempre."
- "Esto no puede ser así, porque los pedidos urgentes tienen un flujo diferente."
- "¿Y si el cliente quiere modificar la dirección después de confirmar?"

El prototipo no es la solución; es una herramienta para provocar conversaciones productivas.

---

## 3.4. Del descubrimiento al requisito estructurado

### 3.4.1. El embudo de transformación

La información obtenida en el descubrimiento es cruda: notas de entrevistas, post-its de talleres, observaciones de campo, fragmentos de documentación. Transformarla en requisitos estructurados es un proceso de análisis y síntesis que sigue un embudo:

```
  ┌────────────────────────────────────────────┐
  │     Información cruda                      │
  │  Notas, entrevistas, observaciones,        │
  │  documentos, datos, prototipos             │
  └─────────────────┬──────────────────────────┘
                    ▼
  ┌────────────────────────────────────────────┐
  │     Necesidades identificadas              │
  │  Problemas, objetivos, restricciones       │
  │  expresados en lenguaje de negocio         │
  └─────────────────┬──────────────────────────┘
                    ▼
  ┌────────────────────────────────────────────┐
  │     Requisitos de alto nivel               │
  │  Capacidades que el sistema debe ofrecer,  │
  │  agrupadas por dominio o funcionalidad     │
  └─────────────────┬──────────────────────────┘
                    ▼
  ┌────────────────────────────────────────────┐
  │     Requisitos detallados                  │
  │  Comportamiento específico, reglas,        │
  │  restricciones, criterios de aceptación    │
  └─────────────────┬──────────────────────────┘
                    ▼
  ┌────────────────────────────────────────────┐
  │     Especificaciones verificables          │
  │  Formato SDD, verificables, trazables     │
  └────────────────────────────────────────────┘
```

### 3.4.2. Técnicas de estructuración

**Agrupación temática**: los requisitos se agrupan por dominio funcional (gestión de usuarios, proceso de compra, facturación, notificaciones...). Esto facilita la organización, la asignación a equipos y la detección de dependencias.

**Descomposición jerárquica**: los requisitos de alto nivel se descomponen en requisitos más detallados. Una necesidad como "el cliente debe poder hacer pedidos online" se descompone en: buscar productos, añadir al carrito, gestionar el carrito, seleccionar dirección de envío, seleccionar método de pago, confirmar pedido, recibir confirmación.

**Modelado de actores y roles**: identificar quién interactúa con el sistema y qué puede hacer cada perfil. Esto estructura los requisitos por actor y evita funcionalidades huérfanas (que nadie usa) o conflictos de permisos.

**Identificación de reglas de negocio**: separar las reglas de negocio (lógica de dominio) de los flujos funcionales. Las reglas son transversales: la regla "no se puede pedir sin stock" afecta al carrito, al checkout, a la API y al backoffice. Documentarla una vez y referenciarla es más eficiente y consistente que repetirla en cada especificación.

### 3.4.3. Del requisito a la especificación: qué añade SDD

Un requisito bien estructurado dice **qué** se necesita. Una especificación SDD añade:

| Elemento | Requisito | Especificación SDD |
|---|---|---|
| Qué | "El cliente puede cancelar un pedido" | "El cliente puede cancelar un pedido en estado pendiente o en preparación..." |
| Cuándo | (implícito) | "...siempre que hayan pasado menos de 2 horas desde la confirmación." |
| Cómo se verifica | (no definido) | "Test: cancelar pedido pendiente → estado = cancelado, stock restaurado." |
| Qué pasa si falla | (no definido) | "Si el servicio de devoluciones no está disponible, la cancelación se registra y la devolución se encola." |
| Quién puede | (implícito) | "Precondición: el usuario está autenticado como titular del pedido." |
| Qué queda después | (no definido) | "Postcondición: pedido en estado cancelado, stock restaurado, correo enviado." |
| De dónde viene | (no definido) | "Dependencia: DN-008 Política de cancelaciones." |

---

## 3.5. Refinamiento iterativo

### 3.5.1. ¿Qué es el refinamiento?

El refinamiento es el proceso de tomar un requisito de alto nivel y trabajarlo progresivamente hasta que sea lo suficientemente detallado, preciso y verificable para ser implementado. No es un paso único, sino un proceso iterativo que puede requerir varias rondas.

El refinamiento no consiste solo en añadir detalle. También implica:
- **Clarificar**: eliminar ambigüedades y múltiples interpretaciones.
- **Completar**: identificar y cubrir huecos (casos de error, límites, excepciones).
- **Simplificar**: eliminar complejidad innecesaria o dividir requisitos demasiado grandes.
- **Priorizar**: distinguir lo esencial de lo deseable.
- **Validar**: confirmar con los stakeholders que la interpretación es correcta.

### 3.5.2. Niveles de refinamiento

Un modelo práctico de refinamiento usa tres niveles:

**Nivel 1 — Necesidad**: expresada en lenguaje de negocio, sin detalle técnico. Describe el problema o el objetivo, no la solución.

> "Los gestores necesitan saber en todo momento cuántos pedidos están pendientes de preparación y cuáles llevan más de 24 horas sin procesarse."

**Nivel 2 — Requisito funcional**: describe la capacidad que debe ofrecer el sistema, con suficiente detalle para entender el alcance pero sin definir la implementación.

> "El sistema muestra un panel con el número de pedidos en estado 'pendiente', agrupados por antigüedad: menos de 4 horas, entre 4 y 24 horas, y más de 24 horas. Los pedidos de más de 24 horas se destacan visualmente y generan una alerta al gestor responsable."

**Nivel 3 — Especificación verificable**: cumple los criterios de calidad de SDD. Incluye precondiciones, postcondiciones, casos especiales, criterios de verificación y dependencias.

> (Especificación completa en formato de la plantilla del Tema 2, con todos los campos.)

### 3.5.3. Técnicas de refinamiento

**Preguntas de profundización**: para cada requisito, hacer preguntas sistemáticas que fuercen el detalle:

| Pregunta | Propósito |
|---|---|
| ¿Quién lo usa? ¿Con qué rol? | Identificar actores y permisos |
| ¿Cuándo ocurre? ¿Qué lo desencadena? | Identificar eventos y precondiciones |
| ¿Qué datos necesita? ¿De dónde vienen? | Identificar entradas y dependencias de datos |
| ¿Qué resultado produce? ¿Dónde se refleja? | Identificar salidas y postcondiciones |
| ¿Qué pasa si falla? ¿Qué puede ir mal? | Identificar casos de error |
| ¿Qué pasa con cero? ¿Con uno? ¿Con muchos? | Identificar casos límite |
| ¿Con qué frecuencia ocurre? ¿Cuántos registros? | Identificar requisitos de rendimiento |
| ¿Cómo sabemos que funciona? | Definir criterios de verificación |

**División de requisitos**: un requisito demasiado grande (épica) debe dividirse en partes que se puedan implementar y validar de forma independiente. La técnica INVEST ayuda a evaluar si una división es adecuada:

- **I**ndependiente: cada parte se puede implementar sin depender de las demás (o con dependencias mínimas).
- **N**egociable: el detalle puede ajustarse sin perder el valor.
- **V**aliosa: cada parte entrega valor al usuario o al negocio por sí sola.
- **E**stimable: el equipo puede estimar el esfuerzo.
- **S**mall (pequeña): se puede implementar en un sprint o iteración.
- **T**estable: se puede verificar con criterios concretos.

**Refinamiento por ejemplos**: en lugar de definir reglas abstractas, proporcionar ejemplos concretos que las ilustren. Los ejemplos son más fáciles de validar con el stakeholder y más útiles para el desarrollador.

Regla abstracta:
> "Se aplica descuento por volumen en pedidos grandes."

Ejemplos concretos:
> - Pedido de 50 unidades del producto A (precio unitario 10 €) → sin descuento → total 500 €.
> - Pedido de 101 unidades del producto A → descuento 5% → precio unitario 9,50 € → total 959,50 €.
> - Pedido de 101 unidades del producto A + 20 unidades del producto B → descuento solo sobre A (> 100 ud.), B sin descuento.
> - Pedido de 101 unidades con código promocional del 10% → se aplica el 10% (mayor que el 5% por volumen), no ambos.

### 3.5.4. El papel de los "Three Amigos"

Una práctica efectiva para el refinamiento es la reunión de "Three Amigos" (o "Trío de refinamiento"), donde tres perfiles revisan juntos cada requisito antes de darlo por listo:

- **Negocio** (PO, analista): valida que el requisito refleja la necesidad real y que la prioridad es correcta.
- **Desarrollo** (desarrollador): evalúa la viabilidad técnica, identifica dependencias y propone alternativas si el requisito es demasiado costoso.
- **QA** (tester): identifica huecos en los criterios de aceptación, propone escenarios de prueba y detecta ambigüedades que los otros dos perfiles pasan por alto.

La reunión no es larga (15-30 minutos por requisito) y su objetivo no es resolver todo, sino detectar lo que falta y acordar los próximos pasos.

---

## 3.6. Validación temprana con stakeholders

### 3.6.1. ¿Por qué validar antes de construir?

La validación temprana es uno de los principios más valiosos de SDD: **confirmar con los stakeholders que la especificación refleja correctamente su necesidad antes de invertir esfuerzo en implementarla.**

El coste de corregir un error de requisitos crece exponencialmente con el tiempo:
- Detectado en el refinamiento: se corrige la especificación (minutos).
- Detectado en la implementación: se reescribe código (horas o días).
- Detectado en el testing: se reescribe código y se repiten pruebas (días).
- Detectado en producción: se gestiona una incidencia, se replanifica, se reescribe, se prueba y se despliega (semanas, más daño reputacional).

### 3.6.2. Técnicas de validación temprana

**Revisión de especificación con stakeholders**: la forma más directa. Se presenta la especificación al stakeholder y se le pide que confirme, corrija o complete. La clave es usar un formato que el stakeholder pueda entender: si la especificación está en lenguaje técnico, el stakeholder asentirá sin entender realmente.

Buenas prácticas para la revisión:
- Presentar la especificación en términos de comportamiento observable, no de implementación técnica.
- Usar ejemplos concretos con datos reales o realistas.
- Pedir al stakeholder que "narrate" el flujo: "Imagina que eres el gestor y quieres cancelar un pedido. ¿Qué harías? ¿Qué esperarías ver?"
- Preguntar explícitamente: "¿Hay algún caso que no esté cubierto? ¿Hay alguna excepción que deba considerar?"

**Walkthrough de escenarios**: se preparan escenarios concretos (con datos ficticios pero realistas) y se recorren paso a paso con el stakeholder. Cada escenario sigue el formato: "Dado [contexto], cuando [acción], entonces [resultado esperado]."

**Prototipado validativo**: se presenta un prototipo (de baja o media fidelidad) al stakeholder para validar flujos, pantallas o interacciones. El prototipo es desechable; su valor está en las correcciones que provoca, no en el artefacto en sí.

**Revisión cruzada entre stakeholders**: cuando hay múltiples stakeholders, es útil que revisen las especificaciones del área de los demás. Esto detecta conflictos e inconsistencias que no aparecen en revisiones aisladas.

### 3.6.3. Criterios para considerar un requisito "listo"

Un requisito está listo para ser implementado cuando cumple estos criterios (a veces llamados "Definition of Ready"):

| Criterio | Pregunta de verificación |
|---|---|
| Comprendido | ¿El equipo de desarrollo entiende qué hay que construir sin preguntar? |
| Verificable | ¿Tiene criterios de aceptación concretos y ejecutables? |
| Independiente | ¿Se puede implementar sin esperar a otros requisitos no terminados? |
| Estimable | ¿El equipo puede estimar el esfuerzo con confianza razonable? |
| Validado | ¿El stakeholder ha confirmado que la especificación refleja su necesidad? |
| Completo | ¿Están definidos los casos de error, los límites y las excepciones? |
| Priorizado | ¿Se sabe cuándo debe implementarse respecto a otros requisitos? |

Si alguno de estos criterios no se cumple, el requisito vuelve a la fase de refinamiento.

---

## 3.7. Errores comunes en el descubrimiento y refinamiento

### La solución prematura

El stakeholder (o el propio equipo) salta directamente a describir la solución ("necesito un botón que...") sin haber comprendido el problema. El resultado es una solución que resuelve un síntoma, no la causa.

**Antídoto**: antes de hablar de soluciones, asegurarse de que el problema está bien definido. Preguntar "¿qué problema resuelve esto?" hasta obtener una respuesta que no incluya tecnología ni componentes de UI.

### El refinamiento infinito

El equipo refina y refina sin atreverse a dar por listo el requisito. Cada revisión añade más detalle, más casos, más excepciones. El proyecto se paraliza en la fase de análisis.

**Antídoto**: aplicar el principio de "suficientemente bueno". Una especificación no necesita cubrir el 100% de los casos para empezar a implementarse. Necesita cubrir el camino principal, los errores más probables y los casos límite más relevantes. Los detalles restantes se descubren durante la implementación y se incorporan a la especificación.

### El descubrimiento en solitario

Un único analista recoge los requisitos, los estructura y los entrega al equipo. Nadie más ha participado en el proceso. El resultado es una visión sesgada por la interpretación del analista.

**Antídoto**: hacer del descubrimiento y el refinamiento una actividad colaborativa. Los "Three Amigos", los talleres de Event Storming y las revisiones cruzadas mitigan este riesgo.

### La validación complaciente

El stakeholder revisa la especificación y dice "sí, está bien" sin haberla leído realmente. Esto ocurre cuando el formato es demasiado técnico, cuando la revisión se hace con prisa o cuando el stakeholder no entiende que su validación es vinculante.

**Antídoto**: usar ejemplos concretos y pedir al stakeholder que narre el flujo. Si puede recorrer un escenario con datos ficticios y confirmar cada paso, la validación es real. Si solo asiente, no lo es.

---

## 3.8. Resumen del tema

El descubrimiento y refinamiento de requisitos es el puente entre las necesidades de negocio y las especificaciones que SDD utiliza como fuente de verdad. Los puntos clave de este tema son:

- Las necesidades de negocio no llegan como especificaciones listas para implementar. Requieren un proceso activo de descubrimiento, estructuración, refinamiento y validación.
- Las fuentes de requisitos son múltiples: stakeholders, usuarios, sistemas existentes, documentación, datos, regulación y mercado. Un buen descubrimiento consulta varias.
- Las técnicas de descubrimiento (entrevistas, talleres, observación, análisis documental, prototipado) se complementan entre sí y se seleccionan según el contexto.
- El refinamiento es iterativo y progresivo: de necesidad a requisito de alto nivel, de requisito a especificación verificable. Las preguntas de profundización, la división de requisitos y el refinamiento por ejemplos son técnicas clave.
- La validación temprana con stakeholders reduce drásticamente el coste de los errores de requisitos. Un requisito no está listo hasta que ha sido comprendido, verificable, validado y completo.
- Los errores más comunes (solución prematura, refinamiento infinito, descubrimiento en solitario, validación complaciente) se mitigan con prácticas colaborativas y criterios explícitos de "listo".

---

---

# Laboratorios del Tema 3

---

## Laboratorio 3.1: Transformar entrevistas de negocio en especificaciones iniciales

### Enunciado

**Objetivo**: practicar la extracción de requisitos a partir de una entrevista de negocio simulada y su transformación en especificaciones iniciales estructuradas.

**Contexto**

Se presenta la transcripción de una entrevista con la directora comercial de una empresa de distribución de material de oficina. La empresa quiere lanzar una tienda online B2B para sus clientes corporativos.

**Transcripción de la entrevista**

> **Analista**: Gracias por tu tiempo, Laura. ¿Podrías contarnos qué necesidad tenéis con este proyecto?
>
> **Laura**: Mira, ahora mismo nuestros clientes nos hacen los pedidos por email, por teléfono o incluso por WhatsApp. Tenemos 3 comerciales que reciben los pedidos y los meten a mano en nuestro ERP. Es un desastre: se pierden pedidos, se cometen errores en las cantidades, y a veces se duplican. Necesitamos que los clientes puedan hacer pedidos ellos mismos, online.
>
> **Analista**: ¿Cuántos clientes tenéis aproximadamente?
>
> **Laura**: Unos 400 clientes activos. Pero no todos son iguales. Tenemos clientes con acuerdos de precios especiales, clientes con descuento por volumen, y clientes que tienen crédito aprobado para pagar a 30 o 60 días. Los demás pagan con tarjeta o transferencia al pedir.
>
> **Analista**: ¿Y el catálogo? ¿Cuántos productos manejáis?
>
> **Laura**: Unas 3.000 referencias. Pero ojo, no todos los productos están disponibles para todos los clientes. Algunos productos tienen restricciones por zona geográfica, y los precios especiales solo aplican a ciertos clientes o a ciertas familias de producto.
>
> **Analista**: ¿Cómo funciona el proceso de pedido actualmente?
>
> **Laura**: El cliente contacta al comercial, le dice lo que quiere, el comercial verifica el stock en el ERP, le confirma disponibilidad y precio, y si el cliente acepta, el comercial crea el pedido en el ERP. Luego el almacén lo prepara y se envía. El problema es que el comercial tarda a veces horas en responder y el cliente se va a la competencia.
>
> **Analista**: ¿Qué pasa con los pedidos fuera de horario?
>
> **Laura**: No se pueden hacer. Si un cliente quiere pedir a las 9 de la noche, tiene que esperar al día siguiente. Eso es otro problema que queremos resolver.
>
> **Analista**: ¿Hay algo más que os preocupe del proceso actual?
>
> **Laura**: Sí, el tema de las devoluciones. Ahora el cliente llama al comercial, el comercial negocia, y a veces se acepta la devolución sin registrarla bien. No tenemos control. Y luego está el tema de los informes: yo no tengo visibilidad de las ventas en tiempo real. Tengo que pedir al equipo de sistemas que me saque un informe del ERP, y tardo días en tenerlo.
>
> **Analista**: ¿Hay algún requisito regulatorio que debamos tener en cuenta?
>
> **Laura**: Somos distribuidores, así que las facturas tienen que cumplir con la normativa fiscal española. Y los datos de los clientes, protección de datos, claro. Ah, y un detalle: algunos clientes necesitan que sus pedidos pasen por un flujo de aprobación interno. Es decir, el empleado que hace el pedido no tiene autorización para aprobarlo; tiene que aprobarlo su jefe.

**Instrucciones**

1. Lee la transcripción con atención e identifica todas las necesidades, requisitos y restricciones que menciona la stakeholder (tanto explícitas como implícitas).
2. Agrupa las necesidades por dominio funcional.
3. Para cada grupo, redacta al menos una especificación inicial (nivel 2: requisito funcional con suficiente detalle para entender el alcance).
4. Identifica al menos 5 preguntas que harías en una segunda entrevista para cubrir huecos.
5. Señala al menos 3 requisitos implícitos que Laura no ha mencionado pero que son necesarios.

---

### Solución

### Paso 1: Necesidades identificadas

| # | Necesidad/Requisito | Fuente en la entrevista | Tipo |
|---|---|---|---|
| N1 | Los clientes deben poder hacer pedidos online sin depender de un comercial | "Necesitamos que los clientes puedan hacer pedidos ellos mismos, online" | Funcional explícita |
| N2 | El sistema debe estar disponible 24/7 (pedidos fuera de horario) | "Si un cliente quiere pedir a las 9 de la noche, tiene que esperar" | Funcional explícita |
| N3 | Los clientes tienen precios especiales según acuerdos | "Tenemos clientes con acuerdos de precios especiales" | Regla de negocio |
| N4 | Existe descuento por volumen | "Clientes con descuento por volumen" | Regla de negocio |
| N5 | Algunos clientes tienen crédito aprobado (pago a 30/60 días) | "Clientes que tienen crédito aprobado para pagar a 30 o 60 días" | Regla de negocio |
| N6 | Los demás clientes pagan con tarjeta o transferencia | "Los demás pagan con tarjeta o transferencia al pedir" | Funcional explícita |
| N7 | El catálogo tiene ~3.000 referencias | Dato de contexto | Restricción |
| N8 | No todos los productos están disponibles para todos los clientes (restricciones geográficas) | "Algunos productos tienen restricciones por zona geográfica" | Regla de negocio |
| N9 | El cliente debe poder ver stock y precio antes de pedir | Implícito del flujo actual: "verifica stock, confirma precio" | Funcional implícita |
| N10 | Gestión de devoluciones con control y registro | "A veces se acepta la devolución sin registrarla bien. No tenemos control" | Funcional explícita |
| N11 | Dashboard de ventas en tiempo real para la directora comercial | "No tengo visibilidad de las ventas en tiempo real" | Funcional explícita |
| N12 | Cumplimiento de normativa fiscal española en facturas | "Las facturas tienen que cumplir con la normativa fiscal española" | Regulatoria |
| N13 | Cumplimiento de protección de datos | "Protección de datos, claro" | Regulatoria |
| N14 | Flujo de aprobación de pedidos en algunos clientes | "El empleado que hace el pedido no tiene autorización para aprobarlo" | Funcional explícita |
| N15 | ~400 clientes activos | Dato de contexto | Restricción |

### Paso 2: Agrupación por dominio funcional

| Dominio | Necesidades |
|---|---|
| Catálogo y precios | N7, N8, N3, N4, N9 |
| Proceso de pedido | N1, N2, N14 |
| Pagos y facturación | N5, N6, N12 |
| Devoluciones | N10 |
| Informes y visibilidad | N11 |
| Regulatorio y transversal | N12, N13 |
| Gestión de clientes | N15 (implícita: alta, perfiles, roles) |

### Paso 3: Especificaciones iniciales (nivel 2)

#### Dominio: Catálogo y precios

```
ID:       FUNC-100
Título:   Catálogo de productos con precios personalizados por cliente
Estado:   Borrador (v0.1)

CONTEXTO
Los clientes corporativos necesitan consultar el catálogo de
productos con los precios que les corresponden según sus acuerdos
comerciales, y ver la disponibilidad de stock en tiempo real.

DESCRIPCIÓN
El sistema muestra al cliente autenticado un catálogo de productos
filtrado según sus restricciones:
- Solo se muestran los productos disponibles en su zona geográfica.
- Los precios mostrados corresponden al acuerdo comercial del
  cliente. Si no hay acuerdo específico, se muestra el precio
  de tarifa general.
- Cada producto muestra: nombre, descripción, imagen, precio
  unitario (con IVA desglosado), stock disponible y familia
  de producto.
- El cliente puede buscar por texto libre, filtrar por familia
  de producto y ordenar por nombre, precio o disponibilidad.

El catálogo contiene aproximadamente 3.000 referencias activas.

DEPENDENCIAS
- DN-020: Reglas de precios y acuerdos comerciales.
- DN-021: Restricciones geográficas de producto.
```

#### Dominio: Proceso de pedido

```
ID:       FUNC-110
Título:   Creación de pedido online por el cliente
Estado:   Borrador (v0.1)

CONTEXTO
Actualmente los pedidos se realizan por email, teléfono o WhatsApp
a través de comerciales, lo que genera retrasos, errores y pérdida
de pedidos. El sistema debe permitir que el cliente realice pedidos
de forma autónoma, 24 horas al día.

DESCRIPCIÓN
El cliente autenticado puede:
1. Añadir productos al carrito desde el catálogo, indicando la
   cantidad deseada.
2. Revisar el carrito: ver productos, cantidades, precios
   unitarios, subtotales y total.
3. Seleccionar la dirección de envío (de entre sus direcciones
   registradas).
4. Seleccionar el método de pago:
   - Si tiene crédito aprobado: pago a 30 o 60 días (según su
     acuerdo).
   - Si no: pago con tarjeta o transferencia bancaria.
5. Confirmar el pedido.
6. Recibir un correo de confirmación con el resumen del pedido
   y el número de referencia.

Si el cliente pertenece a una organización con flujo de aprobación
activado, el pedido no se confirma directamente sino que pasa a
estado "pendiente de aprobación". El aprobador designado recibe
una notificación y puede aprobar o rechazar el pedido.

El sistema está disponible 24/7.

DEPENDENCIAS
- FUNC-100: Catálogo de productos.
- FUNC-120: Flujo de aprobación de pedidos.
- DN-022: Política de crédito y formas de pago.
```

#### Dominio: Flujo de aprobación

```
ID:       FUNC-120
Título:   Flujo de aprobación interna de pedidos
Estado:   Borrador (v0.1)

CONTEXTO
Algunos clientes corporativos requieren que los pedidos realizados
por sus empleados sean aprobados por un responsable antes de
tramitarse.

DESCRIPCIÓN
Para los clientes con flujo de aprobación activado:
1. Cuando un empleado confirma un pedido, el estado es "pendiente
   de aprobación" (no se tramita ni se cobra).
2. El aprobador designado recibe una notificación (email y/o
   in-app) con el resumen del pedido.
3. El aprobador puede:
   a. Aprobar: el pedido pasa a estado "confirmado" y sigue el
      flujo normal.
   b. Rechazar: el pedido pasa a estado "rechazado". El empleado
      recibe notificación con el motivo.
   c. Solicitar modificaciones: el pedido vuelve al empleado para
      que lo edite.
4. Si el aprobador no actúa en 48 horas, se envía un recordatorio.

DEPENDENCIAS
- FUNC-110: Creación de pedido.
- Gestión de clientes: configuración de roles (empleado/aprobador).
```

#### Dominio: Devoluciones

```
ID:       FUNC-130
Título:   Solicitud de devolución por el cliente
Estado:   Borrador (v0.1)

CONTEXTO
Las devoluciones actuales se gestionan informalmente por teléfono,
sin registro ni control. Se necesita un proceso formalizado y
trazable.

DESCRIPCIÓN
El cliente puede solicitar la devolución de uno o varios productos
de un pedido entregado, desde la pantalla de detalle del pedido:
1. Selecciona los productos y cantidades a devolver.
2. Indica el motivo de devolución (lista predefinida + campo
   de texto libre).
3. El sistema registra la solicitud con estado "pendiente de
   revisión".
4. Un gestor comercial revisa la solicitud y puede aprobar,
   rechazar o solicitar información adicional.
5. Si se aprueba, se genera una autorización de devolución y
   se inicia el proceso de recogida/envío de vuelta.
6. Una vez recibido el material, se emite el abono correspondiente.

Todo el proceso queda registrado con fechas, responsables y estados.

DEPENDENCIAS
- FUNC-110: Proceso de pedido (estados del pedido).
- DN-025: Política de devoluciones (plazos, condiciones).
```

#### Dominio: Informes

```
ID:       FUNC-140
Título:   Dashboard de ventas en tiempo real
Estado:   Borrador (v0.1)

CONTEXTO
La directora comercial no tiene visibilidad de las ventas sin
solicitar informes al departamento de sistemas, lo que tarda días.
Necesita un panel con datos actualizados para la toma de decisiones.

DESCRIPCIÓN
El dashboard muestra, para el periodo seleccionable por el usuario
(hoy, semana, mes, trimestre, año, personalizado):
- Ventas totales en € y en número de pedidos.
- Comparativa con el periodo anterior (% variación).
- Top 10 clientes por volumen de compra.
- Top 10 productos más vendidos.
- Pedidos pendientes de preparación / envío.
- Distribución de ventas por zona geográfica.

Los datos se actualizan en tiempo real (o con un retraso máximo
de 15 minutos).

Acceso restringido a usuarios con rol "Dirección Comercial" o
"Administrador".

DEPENDENCIAS
- FUNC-110: Proceso de pedido (datos de ventas).
- SEC-002: Modelo de roles y permisos.
```

### Paso 4: Preguntas para una segunda entrevista

1. **Sobre el catálogo**: ¿Los precios especiales se asignan por cliente individual o por grupo de clientes? ¿Pueden tener precio especial solo para ciertos productos y precio de tarifa para el resto? ¿Los precios incluyen IVA o son sin IVA?

2. **Sobre el pedido**: ¿Existe un pedido mínimo (en unidades o en importe)? ¿Puede el cliente repetir un pedido anterior? ¿Puede guardar listas de productos frecuentes?

3. **Sobre el flujo de aprobación**: ¿Puede haber más de un nivel de aprobación? ¿Hay un importe a partir del cual se requiere aprobación, o siempre se requiere? ¿Quién configura los roles de empleado/aprobador en cada organización cliente?

4. **Sobre las devoluciones**: ¿Hay un plazo máximo para solicitar devolución? ¿Se devuelve el dinero o se emite un crédito para futuras compras? ¿Qué pasa con los gastos de envío de la devolución?

5. **Sobre la integración con el ERP**: ¿Los pedidos se sincronizan automáticamente con el ERP actual o lo sustituyen? ¿El stock se lee del ERP en tiempo real? ¿Las facturas se generan en el ERP o en el nuevo sistema?

6. **Sobre los usuarios del cliente**: ¿Cada cliente tiene un solo usuario o puede tener varios empleados con acceso? ¿Quién da de alta a los usuarios del cliente? ¿Los empleados de un cliente pueden ver los pedidos de otros empleados de la misma empresa?

7. **Sobre el envío**: ¿Hay varias opciones de envío (urgente, estándar)? ¿El coste de envío depende del volumen? ¿Hay entregas parciales si no hay stock completo?

### Paso 5: Requisitos implícitos no mencionados

| # | Requisito implícito | Justificación |
|---|---|---|
| I1 | **Autenticación y gestión de cuentas de cliente**: registro, login, recuperación de contraseña, gestión de perfil. | Laura habla de clientes que acceden al sistema pero no menciona cómo se identifican ni cómo se crean las cuentas. |
| I2 | **Gestión de direcciones de envío**: el cliente debe poder mantener varias direcciones. | El flujo de pedido requiere seleccionar dirección, pero no se ha hablado de cómo se crean o modifican. |
| I3 | **Notificaciones de estado del pedido**: el cliente necesita saber cuándo su pedido está en preparación, enviado, entregado. | Laura menciona el correo de confirmación pero no el seguimiento posterior, que es expectativa estándar en comercio online. |
| I4 | **Búsqueda y navegación en el catálogo**: con 3.000 referencias, el catálogo necesita búsqueda, filtros, categorías y paginación. | Laura menciona el catálogo pero no cómo se navega, lo cual es crítico para la usabilidad. |
| I5 | **Gestión de stock y disponibilidad**: reglas para qué ocurre cuando un producto se queda sin stock (¿se oculta? ¿se muestra como no disponible? ¿se permite pedido con aviso de plazo?). | Laura menciona que se verifica stock pero no las reglas de negocio para productos sin stock. |
| I6 | **Accesibilidad y responsive**: si los clientes hacen pedidos desde móvil o tablet, el sistema debe funcionar en esos dispositivos. | No se ha preguntado desde qué dispositivos trabajan los clientes. |
| I7 | **Historial de pedidos del cliente**: para poder repetir pedidos, consultar facturas anteriores y gestionar devoluciones. | Implícito en varios flujos pero no mencionado como funcionalidad independiente. |

---

## Laboratorio 3.2: Taller de refinamiento incremental de requisitos

### Enunciado

**Objetivo**: practicar el refinamiento progresivo de un requisito de alto nivel a través de tres niveles de detalle, aplicando las técnicas de preguntas de profundización, división y refinamiento por ejemplos.

**Instrucciones**

Se proporciona un requisito de alto nivel del proyecto de la tienda online B2B. El alumno debe:

1. **Nivel 1**: Analizar el requisito tal como está y listar las ambigüedades y huecos.
2. **Nivel 2**: Refinar el requisito respondiendo a las preguntas de profundización (quién, cuándo, qué datos, qué resultado, qué si falla, etc.).
3. **Nivel 3**: Escribir la especificación verificable completa en formato de plantilla SDD, con ejemplos concretos y criterios de verificación.

**Requisito de alto nivel**:

> "El sistema debe aplicar descuentos por volumen a los pedidos de los clientes."

---

### Solución

### Nivel 1: Análisis de ambigüedades y huecos

| # | Ambigüedad o hueco | Tipo |
|---|---|---|
| 1 | ¿Qué se entiende por "volumen"? ¿Unidades de un mismo producto? ¿Importe total del pedido? ¿Unidades totales del pedido? | Precisión |
| 2 | ¿Cuáles son los tramos de descuento? ¿Son fijos o configurables por producto/cliente? | Completitud |
| 3 | ¿El descuento se aplica sobre el precio unitario o sobre el total de la línea? | Precisión |
| 4 | ¿Es acumulable con otros descuentos (precio especial, código promocional)? | Completitud |
| 5 | ¿Se aplica automáticamente o el cliente tiene que activarlo? | Claridad |
| 6 | ¿Es visible para el cliente antes de confirmar el pedido? | Completitud |
| 7 | ¿Qué pasa si el cliente modifica la cantidad después de haber visto el descuento? ¿Se recalcula? | Casos especiales |
| 8 | ¿Aplica a todos los productos o solo a algunos? | Completitud |
| 9 | ¿Quién define los tramos de descuento? ¿Se pueden cambiar? | Gestión |
| 10 | ¿Afecta a la facturación? ¿Cómo aparece en la factura? | Completitud |

### Nivel 2: Refinamiento con respuestas a las preguntas de profundización

| Pregunta | Respuesta (tras consulta con stakeholder) |
|---|---|
| ¿Quién lo usa? | Todos los clientes. El descuento se aplica automáticamente. La configuración de tramos la gestiona el administrador comercial. |
| ¿Qué es "volumen"? | Unidades del mismo producto en el mismo pedido. No se suman unidades de productos distintos. |
| ¿Cuáles son los tramos? | Son configurables por familia de producto. Por defecto: 50-99 ud. → 3%, 100-499 ud. → 5%, 500+ ud. → 8%. |
| ¿Sobre qué se aplica? | Sobre el precio unitario del producto (antes de IVA). El resultado se redondea a 2 decimales. |
| ¿Es acumulable? | No. Si el cliente tiene precio especial (acuerdo comercial), se compara el precio con descuento por volumen vs. el precio especial y se aplica el más favorable para el cliente. |
| ¿Es visible antes de confirmar? | Sí. El carrito muestra el precio original tachado, el precio con descuento, el porcentaje de descuento y el ahorro total. |
| ¿Qué pasa si cambia la cantidad? | Se recalcula automáticamente. Si la cantidad baja del umbral, se elimina el descuento. |
| ¿Qué productos aplican? | Todos los productos activos, salvo los marcados como "sin descuento por volumen" por el administrador. |
| ¿Cómo aparece en factura? | Línea de pedido con precio unitario ya descontado. Nota al pie: "Descuento por volumen aplicado: X%". |

### Nivel 3: Especificación verificable completa

```
ID:          DN-030
Título:      Descuento por volumen en pedidos B2B
Tipo:        Dominio / Regla de negocio
Estado:      Borrador (v1.0)
Autor:       Equipo de análisis — 2025-04-10

═══════════════════════════════════════════════════════════════
1. CONTEXTO Y MOTIVACIÓN
═══════════════════════════════════════════════════════════════

Los clientes corporativos que realizan pedidos de grandes
cantidades esperan un descuento por volumen, práctica habitual
en el sector de distribución B2B. Actualmente, los comerciales
aplican estos descuentos de forma manual e inconsistente. Se
necesita una regla automatizada y configurable.

═══════════════════════════════════════════════════════════════
2. ALCANCE
═══════════════════════════════════════════════════════════════

Cubre:
- Cálculo automático del descuento por volumen en el carrito
  y en la confirmación de pedido.
- Configuración de tramos por familia de producto.
- Visualización del descuento en el carrito.
- Reflejo del descuento en la factura.

No cubre:
- Descuentos por código promocional (ver DN-031).
- Precios especiales por acuerdo comercial (ver DN-020).
- Resolución de conflictos entre descuentos (ver DN-035).

═══════════════════════════════════════════════════════════════
3. PRECONDICIONES
═══════════════════════════════════════════════════════════════

- El producto está activo y no está marcado como "sin descuento
  por volumen".
- Existen tramos de descuento configurados para la familia de
  producto a la que pertenece el producto.
- El pedido no ha sido confirmado aún (el descuento se calcula
  en el carrito, antes de la confirmación).

═══════════════════════════════════════════════════════════════
4. DESCRIPCIÓN (REGLA DE NEGOCIO)
═══════════════════════════════════════════════════════════════

4.1. Definición del volumen
El volumen se define como el número de unidades del MISMO
PRODUCTO en el MISMO PEDIDO. No se suman unidades de productos
distintos, ni unidades del mismo producto en pedidos distintos.

4.2. Tramos de descuento
Los tramos se configuran por familia de producto. Cada tramo
define un rango de unidades y un porcentaje de descuento:

   Tramos por defecto (familia genérica):
   | Desde (ud.) | Hasta (ud.) | Descuento |
   |-------------|-------------|-----------|
   | 1           | 49          | 0%        |
   | 50          | 99          | 3%        |
   | 100         | 499         | 5%        |
   | 500         | sin límite  | 8%        |

El administrador comercial puede crear tramos diferentes para
cada familia de producto.

4.3. Cálculo
El descuento se aplica sobre el precio unitario base del
producto (sin IVA). El precio descontado se redondea a 2
decimales (redondeo bancario: mitad al par más cercano).

   Precio descontado = Precio base × (1 - porcentaje / 100)

4.4. Interacción con otros descuentos
El descuento por volumen NO es acumulable con:
- Precio especial por acuerdo comercial.
- Descuento por código promocional.

Si coexisten, se calcula el precio resultante de cada descuento
de forma independiente y se aplica el que resulte en el MENOR
PRECIO FINAL para el cliente.

El descuento aplicado (tipo y porcentaje) se registra en la
línea de pedido para trazabilidad.

4.5. Visualización en el carrito
Cuando aplica un descuento por volumen, el carrito muestra para
cada línea afectada:
- Precio unitario original (tachado).
- Precio unitario con descuento.
- Etiqueta: "Descuento por volumen: -X%".
- Ahorro total en la línea: (precio original - precio descontado)
  × cantidad.

4.6. Reflejo en factura
La factura muestra el precio unitario ya descontado en cada
línea. Al pie de la factura se incluye la nota: "Descuento por
volumen aplicado en líneas marcadas con (*)" y cada línea
afectada se marca con (*).

4.7. Recálculo dinámico
Si el cliente modifica la cantidad en el carrito:
- Si la nueva cantidad entra en un tramo superior, se aplica
  el nuevo descuento automáticamente.
- Si la nueva cantidad baja de un tramo, se reduce o elimina
  el descuento.
- El carrito se actualiza inmediatamente tras el cambio de
  cantidad.

═══════════════════════════════════════════════════════════════
5. POSTCONDICIONES
═══════════════════════════════════════════════════════════════

- El precio del producto en la línea de pedido refleja el
  descuento aplicado.
- El tipo de descuento y el porcentaje quedan registrados en
  la línea de pedido.
- El total del pedido refleja los precios descontados.

═══════════════════════════════════════════════════════════════
6. CASOS ESPECIALES Y ERRORES
═══════════════════════════════════════════════════════════════

| Caso | Comportamiento |
|------|---------------|
| Producto marcado "sin descuento por volumen" | No se aplica descuento independientemente de la cantidad. |
| Familia de producto sin tramos configurados | Se usan los tramos por defecto (familia genérica). |
| Cantidad = 0 | La línea se elimina del carrito. |
| Cliente con precio especial más favorable que el volumen | Se aplica el precio especial. Se muestra "Precio especial" en lugar de "Descuento por volumen". |
| Cliente con precio especial menos favorable que el volumen | Se aplica el descuento por volumen. |
| Cambio de tramos por el admin mientras hay carritos activos | Los carritos existentes se recalculan con los nuevos tramos al siguiente acceso del usuario o al confirmar. |

═══════════════════════════════════════════════════════════════
7. CRITERIOS DE VERIFICACIÓN
═══════════════════════════════════════════════════════════════

Ejemplo 1: Descuento aplicado correctamente
  Producto: Bolígrafo BIC (familia: Escritura), precio base: 0,50 €
  Cantidad: 120 unidades
  Tramo aplicable: 100-499 → 5%
  Precio descontado: 0,50 × 0,95 = 0,475 → redondeado: 0,48 €
  Total línea: 0,48 × 120 = 57,60 €
  Ahorro: (0,50 - 0,48) × 120 = 2,40 €
  → Verificar: carrito muestra 0,50 € tachado, 0,48 €, "-5%",
    ahorro 2,40 €.

Ejemplo 2: Sin descuento por cantidad insuficiente
  Producto: Bolígrafo BIC, precio base: 0,50 €
  Cantidad: 30 unidades
  → Verificar: carrito muestra 0,50 €, sin indicación de descuento.

Ejemplo 3: Cambio de tramo al modificar cantidad
  Producto: Bolígrafo BIC, cantidad inicial: 80 (tramo 3%)
  El cliente cambia a 120 (tramo 5%)
  → Verificar: el carrito se actualiza de 0,49 € a 0,48 €.

Ejemplo 4: Conflicto con precio especial (volumen más favorable)
  Producto: Bolígrafo BIC, precio base: 0,50 €
  Cliente tiene precio especial: 0,49 €
  Cantidad: 120 → descuento volumen → 0,48 €
  → Verificar: se aplica 0,48 € (volumen), se muestra
    "Descuento por volumen: -5%".

Ejemplo 5: Conflicto con precio especial (especial más favorable)
  Producto: Bolígrafo BIC, precio base: 0,50 €
  Cliente tiene precio especial: 0,45 €
  Cantidad: 120 → descuento volumen → 0,48 €
  → Verificar: se aplica 0,45 € (especial), se muestra
    "Precio especial".

Ejemplo 6: Producto excluido de descuento por volumen
  Producto marcado "sin descuento por volumen", cantidad: 500
  → Verificar: precio sin descuento, sin etiqueta de volumen.

═══════════════════════════════════════════════════════════════
8. DEPENDENCIAS Y RELACIONES
═══════════════════════════════════════════════════════════════

Depende de:
- FUNC-100: Catálogo de productos (precios base, familias).
- DN-020: Reglas de precios especiales por acuerdo comercial.

Es requerida por:
- FUNC-110: Creación de pedido (cálculo del total).
- FUNC-150: Generación de facturas (reflejo del descuento).

Relacionada con:
- DN-031: Descuentos por código promocional.
- DN-035: Resolución de conflictos entre descuentos.

═══════════════════════════════════════════════════════════════
9. NOTAS Y DECISIONES ABIERTAS
═══════════════════════════════════════════════════════════════

- Pendiente confirmar: ¿los tramos por defecto son definitivos o
  deben revisarse con el equipo comercial?
- Pendiente confirmar: ¿el descuento por volumen aplica también
  a pedidos repetidos automáticos (si se implementa esa función)?
- Decisión tomada: redondeo bancario (no truncamiento) por
  consistencia con el ERP existente.
```

---

## Laboratorio 3.3: Validación de especificaciones con roles simulados de negocio y desarrollo

### Enunciado

**Objetivo**: practicar la validación de una especificación asumiendo distintos roles (negocio, desarrollo, QA) para detectar problemas desde cada perspectiva.

**Instrucciones**

Se proporciona una especificación de funcionalidad. El alumno debe revisarla tres veces, cada vez desde un rol diferente, y documentar los problemas detectados y las preguntas o correcciones que plantearía.

1. **Revisión como Negocio/Product Owner**: ¿la especificación refleja correctamente la necesidad? ¿Falta algún caso relevante para el negocio? ¿Las reglas son correctas?
2. **Revisión como Desarrollo**: ¿es implementable? ¿Hay ambigüedades técnicas? ¿Faltan datos? ¿Hay dependencias no resueltas?
3. **Revisión como QA**: ¿es verificable? ¿Los criterios de aceptación son suficientes? ¿Faltan escenarios de prueba? ¿Hay huecos?

**Especificación a revisar**:

```
ID:       FUNC-115
Título:   Pedido recurrente automático
Estado:   En revisión (v1.0)
Autor:    Analista — 2025-04-08

CONTEXTO
Algunos clientes B2B realizan siempre los mismos pedidos con la
misma periodicidad (por ejemplo, material de oficina mensual).
Se quiere automatizar estos pedidos para reducir la carga manual.

PRECONDICIONES
- El cliente está autenticado.
- El cliente ha realizado al menos un pedido previo.

DESCRIPCIÓN
El cliente puede configurar un pedido recurrente a partir de un
pedido existente:
1. Desde el historial de pedidos, selecciona un pedido y pulsa
   "Convertir en pedido recurrente".
2. Selecciona la frecuencia: semanal, quincenal o mensual.
3. Indica la fecha del próximo pedido.
4. El sistema crea automáticamente un nuevo pedido con los mismos
   productos, cantidades y dirección de envío en la fecha indicada
   y en cada periodo sucesivo.
5. El cliente recibe un email de confirmación 24 horas antes de
   cada pedido automático.

El cliente puede modificar, pausar o cancelar la recurrencia
desde la sección "Mis pedidos recurrentes".

CRITERIOS DE VERIFICACIÓN
1. Crear pedido recurrente mensual → se genera el pedido en la
   fecha indicada.
2. Modificar la frecuencia → el siguiente pedido refleja la
   nueva frecuencia.
3. Cancelar recurrencia → no se generan más pedidos.
```

---

### Solución

### Revisión como Negocio / Product Owner

| # | Observación | Tipo | Detalle |
|---|---|---|---|
| B1 | **Falta: ¿qué pasa con los precios?** | Hueco crítico | Los precios cambian con el tiempo. ¿El pedido recurrente usa el precio del pedido original o el precio vigente en el momento de cada repetición? Si se usa el precio original, el cliente podría pagar por debajo del precio actual indefinidamente. Si se usa el vigente, el cliente podría llevarse sorpresas. Esto es una decisión de negocio fundamental. **Propuesta**: usar el precio vigente en el momento de generación de cada pedido recurrente y avisar al cliente en el email previo si hay cambios de precio respecto al pedido anterior. |
| B2 | **Falta: ¿qué pasa con el stock?** | Hueco crítico | Si un producto del pedido recurrente no tiene stock en el momento de la repetición, ¿se omite esa línea? ¿Se cancela todo el pedido? ¿Se espera? **Propuesta**: se genera el pedido con los productos disponibles. Los no disponibles se excluyen y se notifica al cliente. Si todos los productos están sin stock, el pedido no se genera y se notifica al cliente. |
| B3 | **Falta: ¿qué pasa con productos descatalogados?** | Hueco | Si un producto del pedido original se descataloga, ¿qué ocurre con la línea? ¿Y si se descatalogan todos? |
| B4 | **Falta: método de pago** | Hueco | El pedido original tenía un método de pago. ¿Se reutiliza? Si era tarjeta, ¿se carga automáticamente? ¿Tiene el cliente que autorizar cada cobro? Para clientes con crédito, ¿se verifica que el crédito sigue aprobado? |
| B5 | **Falta: flujo de aprobación** | Inconsistencia | Si el cliente tiene flujo de aprobación activado (FUNC-120), ¿cada pedido recurrente pasa por aprobación? Sería lógico, pero generaría mucha carga para el aprobador. ¿Se puede preautorizar la recurrencia? |
| B6 | **La frecuencia podría ser insuficiente** | Mejora | Solo ofrece semanal, quincenal y mensual. ¿Qué pasa con clientes que piden cada 2 meses? ¿O cada trimestre? **Propuesta**: permitir personalizado en días (mínimo 7, máximo 90). |

### Revisión como Desarrollo

| # | Observación | Tipo | Detalle |
|---|---|---|---|
| D1 | **Falta: mecanismo de ejecución** | Ambigüedad técnica | ¿Quién genera el pedido recurrente? ¿Un cron job? ¿Un sistema de colas? ¿A qué hora del día se ejecuta? Si hay miles de pedidos recurrentes programados para el mismo día, ¿hay riesgo de sobrecarga? **Necesario**: definir la hora de ejecución (p. ej., 06:00 UTC) y el mecanismo (job programado con cola de procesamiento). |
| D2 | **Falta: gestión de fallos del job** | Hueco técnico | ¿Qué pasa si el job de generación falla a mitad? ¿Se reintentan los pedidos no generados? ¿Hay riesgo de duplicación? **Necesario**: definir idempotencia (si se ejecuta dos veces, no se generan pedidos duplicados) y reintentos. |
| D3 | **Falta: modelo de datos de la recurrencia** | Hueco técnico | ¿Qué se almacena? Al menos: ID del pedido origen, frecuencia en días, próxima fecha de ejecución, estado (activo/pausado/cancelado), fecha de creación, fecha de última ejecución. |
| D4 | **"Mismos productos, cantidades y dirección"** | Ambigüedad | ¿Se copia la dirección literal del pedido original o la dirección activa del cliente? Si el cliente cambió de dirección entre medio, ¿a dónde se envía? **Propuesta**: usar la dirección que el cliente tiene configurada como "dirección principal" en el momento de generar cada pedido, no la del pedido original. Permitir que el cliente vincule una dirección específica a la recurrencia. |
| D5 | **"24 horas antes"** | Precisión | ¿Exactamente 24 horas antes, o el día anterior a una hora fija? Si el pedido se genera a las 06:00, ¿el email se envía a las 06:00 del día anterior? **Propuesta**: email a las 09:00 del día anterior al pedido (horario de trabajo del cliente). |
| D6 | **Falta: API** | Completitud | ¿Se expone la gestión de recurrencias por API o solo por interfaz web? Si hay integraciones futuras, conviene definir el contrato. |
| D7 | **Dependencia con el ERP** | Dependencia no documentada | Si los pedidos se sincronizan con el ERP, ¿los pedidos recurrentes se sincronizan igual? ¿Hay alguna marca que los identifique como automáticos? |

### Revisión como QA

| # | Observación | Tipo | Detalle |
|---|---|---|---|
| Q1 | **Falta: test de email previo** | Cobertura insuficiente | No hay criterio de verificación para el email de aviso previo. ¿Se envía? ¿Con qué contenido? ¿Qué pasa si el envío falla? |
| Q2 | **Falta: test de pausa** | Cobertura insuficiente | La descripción menciona "pausar" pero no hay criterio de verificación para ello. ¿Qué pasa al pausar? ¿Se mantiene la fecha? ¿Al reanudar, se recalcula desde hoy? |
| Q3 | **Falta: test de producto sin stock** | Caso no cubierto | ¿Qué pruebo si un producto del pedido recurrente está sin stock? No hay comportamiento definido. |
| Q4 | **Falta: test de cambio de precio** | Caso no cubierto | ¿Cómo verifico que el precio se calcula correctamente si ha cambiado entre un pedido y el siguiente? |
| Q5 | **Falta: test de pedido origen eliminado** | Caso especial | ¿Qué pasa si el pedido original a partir del cual se creó la recurrencia es cancelado o eliminado? ¿La recurrencia sigue activa? |
| Q6 | **Falta: test de concurrencia** | Caso especial | ¿Qué pasa si el cliente modifica la recurrencia mientras el job la está ejecutando? |
| Q7 | **Falta: test de límite temporal** | Caso límite | ¿Tiene fecha de fin la recurrencia? ¿Se repite indefinidamente? ¿Hay un máximo de repeticiones? |
| Q8 | **Los criterios existentes son insuficientes** | Calidad | Los 3 criterios de verificación son demasiado genéricos. "Se genera el pedido en la fecha indicada" no especifica qué se verifica del pedido generado (productos, cantidades, precios, dirección, estado). |
| Q9 | **Falta: test de modificación de contenido** | Cobertura | ¿Puede el cliente modificar los productos o cantidades de la recurrencia sin cambiar el pedido original? Si sí, falta criterio de verificación. |

### Criterios de verificación propuestos (QA)

A partir de la revisión, QA propone los siguientes criterios ampliados:

```
CRITERIOS DE VERIFICACIÓN REVISADOS

Creación:
1. Crear recurrencia mensual a partir de pedido existente →
   se crea configuración con estado "activo", frecuencia
   mensual y próxima fecha correcta.
2. Intentar crear recurrencia desde un pedido cancelado → error.

Ejecución:
3. Llegar a la fecha de ejecución → se genera nuevo pedido con
   los mismos productos y cantidades, precios vigentes y
   dirección principal del cliente. Estado del pedido: confirmado
   (o pendiente de aprobación si aplica).
4. Producto sin stock en la fecha de ejecución → el pedido se
   genera sin esa línea, se notifica al cliente.
5. Todos los productos sin stock → no se genera pedido, se
   notifica al cliente.
6. Precio de un producto ha cambiado → se usa el precio nuevo,
   el email previo incluye aviso de cambio de precio.

Notificación:
7. 24 horas antes de la ejecución → el cliente recibe email con
   resumen del pedido que se va a generar (productos, cantidades,
   precios actuales, total estimado).
8. Fallo en el envío del email → se registra el error, el pedido
   se genera igualmente (el email es informativo, no bloqueante).

Modificación:
9. Cambiar frecuencia de mensual a semanal → la próxima fecha
   se recalcula correctamente.
10. Cambiar productos o cantidades de la recurrencia → el
    siguiente pedido refleja los cambios.
11. Cambiar dirección → el siguiente pedido usa la nueva dirección.

Pausa:
12. Pausar recurrencia → no se generan pedidos mientras está
    pausada. La fecha de próxima ejecución se congela.
13. Reanudar recurrencia → la próxima ejecución se programa
    según la frecuencia a partir de la fecha de reanudación.

Cancelación:
14. Cancelar recurrencia → no se generan más pedidos. La
    configuración queda con estado "cancelada" (consultable
    en historial).

Flujo de aprobación:
15. Cliente con flujo de aprobación activo → cada pedido
    recurrente generado pasa por aprobación antes de tramitarse.

Robustez:
16. Job de generación ejecutado dos veces → no se duplican
    pedidos (idempotencia).
17. Modificación de recurrencia durante la ejecución del job →
    no se corrompe ni la configuración ni el pedido.

Límites:
18. Recurrencia sin fecha de fin → se ejecuta indefinidamente
    hasta que el cliente la cancele o pause.
19. Producto descatalogado → se excluye de futuros pedidos
    recurrentes y se notifica al cliente.
```

### Resumen de la validación por roles

| Rol | Problemas detectados | Tipo predominante | Aportación principal |
|---|---|---|---|
| **Negocio** | 6 | Huecos de reglas de negocio y decisiones no tomadas | Detecta que la especificación no aborda precios, stock, pagos ni flujo de aprobación en el contexto de la recurrencia. Son decisiones que solo negocio puede tomar. |
| **Desarrollo** | 7 | Ambigüedades técnicas y dependencias no resueltas | Detecta que la especificación no define mecanismo de ejecución, modelo de datos, gestión de fallos ni integración con el ERP. Sin estas definiciones, la implementación requiere tomar decisiones de arquitectura "al vuelo". |
| **QA** | 9 + 19 criterios ampliados | Falta de verificabilidad y cobertura insuficiente | Detecta que los criterios de verificación originales (solo 3) son insuficientes y genéricos. Propone 19 criterios concretos que cubren creación, ejecución, notificación, modificación, pausa, cancelación, flujo de aprobación, robustez y límites. |

### Conclusión del laboratorio

La revisión multi-rol demuestra que cada perfil detecta problemas que los demás pasan por alto. Una especificación revisada solo por un rol siempre tendrá huecos significativos. La práctica de "Three Amigos" (negocio + desarrollo + QA) aplicada sistemáticamente antes de dar por lista una especificación es una de las inversiones más rentables del proceso SDD.

En este caso, la especificación FUNC-115 pasó de tener 3 criterios de verificación genéricos a necesitar al menos 19 criterios concretos, 6 decisiones de negocio no tomadas y 7 definiciones técnicas pendientes. Si se hubiera implementado sin esta revisión, el resultado habría sido un pedido recurrente que "funciona" en el camino feliz pero falla en la mayoría de los escenarios reales.