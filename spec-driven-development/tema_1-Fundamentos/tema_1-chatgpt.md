Aquí tienes el **desarrollo completo del Tema 1: Fundamentos de Spec Driven Development (SDD)**, con enfoque formativo y listo para integrarlo en tu plan de formación.

---

# Tema 1. Fundamentos de Spec Driven Development

## 1. Descripción ampliada

Spec Driven Development (SDD) es un enfoque de desarrollo de software en el que la **especificación** actúa como artefacto central del proceso. En lugar de considerar los requisitos como un documento inicial que luego pierde relevancia, o de delegar el conocimiento real del sistema únicamente al código, SDD propone que el comportamiento esperado, las reglas de negocio, las restricciones y los criterios de validación queden expresados de forma clara, compartida y verificable desde el inicio y a lo largo de todo el ciclo de vida del software.

Este enfoque busca resolver un problema frecuente en los proyectos: la distancia entre lo que el negocio necesita, lo que el equipo entiende, lo que se implementa y lo que finalmente se valida. Cuando esa distancia crece, aparecen retrabajo, ambigüedad, fallos de interpretación, deuda funcional y conflictos entre áreas. SDD reduce esa fricción al convertir la especificación en una referencia común para negocio, análisis, arquitectura, desarrollo, QA y operación.

El valor de SDD no está solo en “documentar mejor”, sino en **usar la especificación como mecanismo de alineación, diseño, validación y trazabilidad**. La especificación deja de ser un anexo y pasa a ser una fuente de verdad compartida.

---

# 2. Objetivos de aprendizaje

Al finalizar este tema, el alumnado será capaz de:

* Comprender qué es Spec Driven Development y qué problemas pretende resolver.
* Explicar los principios básicos del desarrollo guiado por especificaciones.
* Diferenciar SDD de TDD, BDD y enfoques tradicionales centrados en documentación o código.
* Entender el papel de la especificación como fuente de verdad compartida entre los distintos roles del proyecto.
* Identificar situaciones reales en las que la ausencia de especificaciones claras genera errores, retrabajo o conflicto.
* Reconocer los beneficios y límites de adoptar SDD en contextos reales.

---

# 3. Resultados de aprendizaje esperados

Al terminar el tema, el participante podrá:

* Definir SDD con precisión y sin confundirlo con otras prácticas relacionadas.
* Identificar artefactos que pueden funcionar como especificación dentro de un proyecto.
* Detectar síntomas de un proyecto donde la especificación no está clara o no se utiliza correctamente.
* Evaluar si un requisito está formulado de manera ambigua o verificable.
* Explicar cómo SDD mejora la comunicación entre negocio, desarrollo y validación.

---

# 4. Contenidos

## 4.1. ¿Qué es Spec Driven Development?

Spec Driven Development es un enfoque en el que el desarrollo se guía por una **especificación explícita, compartida, precisa y útil para la validación**. Esa especificación describe qué debe hacer el sistema, bajo qué condiciones, con qué reglas y con qué resultados esperados.

En SDD, la especificación no se limita a una lista de requisitos. Puede incluir, según el contexto:

* comportamiento esperado,
* reglas de negocio,
* contratos de interfaz,
* restricciones funcionales y no funcionales,
* ejemplos verificables,
* criterios de aceptación,
* escenarios,
* trazabilidad con diseño, código y pruebas.

La idea central es que el equipo no programe basándose en interpretaciones parciales o conversaciones efímeras, sino sobre una definición acordada del sistema.

### Idea clave

**En SDD, el código implementa la especificación; las pruebas la verifican; el diseño la estructura; y el negocio la valida.**

---

## 4.2. ¿Qué problemas resuelve SDD?

SDD surge como respuesta a problemas habituales en el desarrollo de software:

### a) Ambigüedad en los requisitos

Expresiones como “rápido”, “intuitivo”, “seguro”, “debería permitir”, “cuando sea necesario” o “como de costumbre” generan interpretaciones distintas según el rol.

### b) Desalineación entre negocio y equipo técnico

Negocio puede pensar en resultados y reglas, mientras desarrollo interpreta funcionalidades y QA verifica comportamientos no siempre acordados.

### c) Dependencia excesiva del conocimiento tácito

Cuando el conocimiento del sistema está “en la cabeza” de una o dos personas, el proyecto se vuelve frágil y difícil de mantener.

### d) Retrabajo y cambios tardíos

Muchos errores funcionales no se deben a mala programación, sino a mala comprensión previa de lo que había que construir.

### e) Pruebas desconectadas del propósito real

Si no hay una especificación clara, las pruebas pueden verificar lo implementado, pero no necesariamente lo correcto.

### f) Dificultad de mantenimiento y evolución

Sin especificaciones trazables, cambiar el sistema implica interpretar de nuevo qué hacía, por qué lo hacía y qué puede romperse.

---

## 4.3. Principios básicos de SDD

### 1. La especificación es central

La especificación no es un documento auxiliar. Es el elemento que coordina análisis, diseño, construcción y validación.

### 2. La especificación debe ser compartida

Debe ser comprensible y útil para distintos perfiles: negocio, analistas, desarrolladores, testers, arquitectos y responsables funcionales.

### 3. La especificación debe ser precisa

No basta con expresar una intención general. Debe reducir ambigüedad y permitir interpretación consistente.

### 4. La especificación debe ser verificable

Tiene que poder comprobarse mediante revisión, pruebas, ejemplos, criterios de aceptación o mecanismos automáticos.

### 5. La especificación evoluciona

No es un artefacto estático. Cambia con el sistema y debe mantenerse alineada con él.

### 6. La implementación debe derivarse de la especificación

El diseño y el código deben responder a lo especificado, no sustituirlo ni redefinirlo implícitamente.

### 7. La validación debe apoyarse en la especificación

La conformidad del sistema debe medirse respecto a la especificación acordada.

---

## 4.4. La especificación como fuente de verdad compartida

Uno de los conceptos más importantes de este tema es el de **fuente de verdad compartida**.

En muchos proyectos conviven varias “verdades” al mismo tiempo:

* lo que dijo negocio en una reunión,
* lo que quedó escrito en una historia de usuario,
* lo que entendió desarrollo,
* lo que diseñó arquitectura,
* lo que validó QA,
* lo que finalmente quedó en producción.

Cuando esas versiones no coinciden, aparecen conflictos. SDD intenta evitarlo estableciendo una referencia común que permita responder preguntas como:

* ¿Qué debería hacer realmente el sistema?
* ¿Qué casos están contemplados?
* ¿Qué comportamiento es correcto ante errores?
* ¿Qué condiciones deben cumplirse antes y después?
* ¿Qué aceptó negocio como válido?

La especificación, bien mantenida, sirve como base para:

* discutir alcance,
* diseñar soluciones,
* construir código,
* definir pruebas,
* revisar cambios,
* auditar decisiones,
* facilitar mantenimiento.

---

## 4.5. Diferencias entre SDD, TDD, BDD y enfoques tradicionales

## SDD vs TDD

**TDD (Test Driven Development)** se centra en escribir pruebas antes del código. Su objetivo principal es mejorar diseño incremental, feedback rápido y calidad técnica.

**SDD** tiene un alcance más amplio. No se centra solo en pruebas, sino en definir de forma explícita qué debe construirse y cómo se valida desde una perspectiva compartida.

### Diferencia principal

* TDD guía la implementación desde pruebas.
* SDD guía el desarrollo desde especificaciones.

### Relación entre ambos

TDD puede ser una técnica útil dentro de un enfoque SDD, pero no lo sustituye. Una prueba puede estar muy bien escrita y aun así implementar un comportamiento incorrecto si la especificación original era ambigua o no existía.

---

## SDD vs BDD

**BDD (Behavior Driven Development)** pone énfasis en describir comportamientos observables del sistema, a menudo en formato cercano al lenguaje natural y con ejemplos.

**SDD** puede incorporar prácticas de BDD, pero no se limita al comportamiento externo. También incluye contratos, restricciones, reglas de dominio, trazabilidad y otras dimensiones de especificación.

### Diferencia principal

* BDD enfatiza ejemplos y comportamiento observable.
* SDD abarca la especificación como marco integral del desarrollo.

### Relación entre ambos

BDD puede verse como una forma de hacer partes de la especificación más ejecutables y colaborativas dentro de un enfoque SDD.

---

## SDD vs documentación tradicional

En enfoques tradicionales, las especificaciones suelen redactarse al inicio y después quedan desactualizadas. El desarrollo real avanza en otros artefactos: tickets, código, correos, decisiones orales o pruebas manuales.

En SDD, la especificación no es un entregable burocrático inicial, sino un artefacto vivo que acompaña todo el desarrollo.

### Diferencia principal

* La documentación tradicional muchas veces describe y se archiva.
* La especificación en SDD guía, conecta y valida.

---

## SDD vs desarrollo centrado solo en código

Hay equipos donde “la verdad está en el código”. Esto puede funcionar a nivel técnico interno, pero genera problemas cuando negocio, QA, análisis o nuevos miembros del equipo necesitan entender intención, reglas y alcance.

### Diferencia principal

* El código dice cómo está implementado algo.
* La especificación dice qué debe hacer y bajo qué condiciones.

Ambos son necesarios, pero no equivalentes.

---

## 4.6. Qué NO es SDD

Es importante evitar confusiones. SDD no significa:

* escribir documentos extensos e inmóviles,
* frenar el desarrollo con burocracia,
* sustituir conversaciones por plantillas rígidas,
* duplicar información sin propósito,
* generar especificaciones perfectas antes de empezar,
* documentarlo todo al máximo detalle desde el inicio.

SDD no busca “más papel”, sino **mejor definición**. Su propósito es reducir incertidumbre útil y aumentar alineación. La especificación debe tener el nivel de detalle necesario para permitir construir y validar con claridad.

---

## 4.7. Beneficios del enfoque SDD

### Beneficios funcionales

* Mayor claridad sobre el alcance y comportamiento esperado.
* Menor ambigüedad en requisitos.
* Mejor validación con stakeholders.

### Beneficios técnicos

* Menos retrabajo por mala interpretación.
* Mejor base para pruebas, contratos e integración.
* Mayor trazabilidad entre intención e implementación.

### Beneficios organizativos

* Mejor comunicación entre perfiles no técnicos y técnicos.
* Reducción de dependencia de conocimiento tácito.
* Facilita incorporación de nuevas personas al equipo.
* Mejora auditoría, cumplimiento y mantenimiento.

---

## 4.8. Riesgos o dificultades al implantar SDD

Aunque aporta valor, SDD también puede fallar si se aplica mal:

### a) Exceso de formalismo

Si la especificación se convierte en burocracia, el equipo la evitará.

### b) Artefactos desconectados

Una especificación que nadie consulta o actualiza pierde valor rápidamente.

### c) Falta de disciplina de mantenimiento

Si código y especificación divergen, la confianza en la especificación desaparece.

### d) Resistencia cultural

Equipos acostumbrados a trabajar solo con tickets, conversaciones o código pueden percibirlo como una carga extra.

### e) Nivel de detalle inadecuado

Demasiado poco detalle genera ambigüedad; demasiado detalle inmoviliza y encarece.

---

## 4.9. ¿Cuándo aporta más valor SDD?

SDD resulta especialmente útil cuando:

* el dominio de negocio tiene reglas complejas,
* hay varios equipos o roles implicados,
* existen integraciones entre sistemas,
* se necesita trazabilidad o auditoría,
* el coste de un error funcional es alto,
* el producto evoluciona durante largo tiempo,
* hay alta rotación o necesidad de transferencia de conocimiento,
* el equipo quiere mejorar alineación entre negocio, desarrollo y QA.

No obstante, incluso en proyectos pequeños, aplicar principios de SDD puede mejorar significativamente la claridad y reducir errores tempranos.

---

# 5. Estructura didáctica recomendada para impartición

## 5.1. Introducción del tema

Comenzar con ejemplos reales de proyectos donde:

* se implementó algo distinto a lo esperado,
* QA validó algo que negocio no aceptó,
* una regla de negocio importante no estaba escrita,
* el equipo dependía de una persona para entender el sistema.

Esto ayuda a aterrizar el problema antes de introducir el concepto de SDD.

## 5.2. Exposición conceptual

Presentar definición, principios y comparativas con otros enfoques.

## 5.3. Discusión guiada

Plantear preguntas como:

* ¿Dónde está hoy la verdad del sistema en nuestros proyectos?
* ¿Qué parte del conocimiento está escrita y cuál es implícita?
* ¿Qué errores hemos sufrido por ambigüedad?

## 5.4. Trabajo práctico

Aplicar análisis sobre casos ambiguos y convertirlos en especificaciones verificables.

## 5.5. Cierre

Sintetizar la idea de que SDD no es solo escribir mejor, sino **desarrollar con una referencia compartida y verificable**.

---

# 6. Desarrollo de sesión propuesto

## Duración estimada

4 horas

## Distribución sugerida

### Bloque 1. Apertura e introducción al problema (30 min)

* Presentación del tema.
* Debate sobre fallos causados por requisitos ambiguos.
* Ejemplos de desalineación entre negocio y desarrollo.

### Bloque 2. Conceptos fundamentales de SDD (60 min)

* Definición.
* Propósito.
* Principios.
* La especificación como fuente de verdad.

### Bloque 3. Comparativa con otros enfoques (30 min)

* TDD.
* BDD.
* enfoques tradicionales.
* código como única referencia.

### Bloque 4. Laboratorio 1 (45 min)

* Identificación de problemas en proyectos sin especificaciones claras.

### Bloque 5. Laboratorio 2 (45 min)

* Comparativa entre requisitos ambiguos y especificaciones verificables.

### Bloque 6. Laboratorio 3 y cierre (30 min)

* Mapa conceptual de SDD dentro del ciclo de desarrollo.
* Puesta en común.
* Conclusiones.

---

# 7. Desarrollo teórico para material del alumno

## 7.1. Definición operativa de SDD

Spec Driven Development es una forma de organizar el desarrollo de software en la que la especificación del sistema se convierte en el eje que alinea a todos los participantes del proyecto. La especificación describe de manera explícita qué se espera del sistema, cómo debe comportarse, qué reglas debe cumplir y cómo se comprobará que lo hace correctamente.

## 7.2. Por qué no basta con el código

El código expresa implementación, pero no siempre expresa intención. Muchas decisiones funcionales, restricciones del dominio o supuestos de negocio no quedan claras solo leyendo clases, funciones o endpoints. Por eso, cuando el conocimiento se apoya exclusivamente en el código, aparecen malas interpretaciones y dificultades de mantenimiento.

## 7.3. Por qué no basta con pruebas aisladas

Las pruebas pueden confirmar un comportamiento, pero ese comportamiento puede estar mal entendido desde el origen. Si las pruebas no derivan de una especificación acordada, pueden convertirse en validación técnica de una interpretación errónea.

## 7.4. Por qué la documentación clásica suele fallar

Cuando la documentación se redacta solo al principio, pero el proyecto evoluciona después en otros canales, deja de ser fiable. En SDD, la especificación debe permanecer conectada al trabajo real del equipo.

## 7.5. El cambio de mentalidad que propone SDD

SDD propone pasar de:

* “construimos y luego explicamos”
  a
* “definimos, alineamos, construimos y verificamos”.

---

# 8. Ejemplos didácticos

## Ejemplo 1. Requisito ambiguo

“El sistema deberá gestionar rápidamente los pedidos urgentes.”

### Problemas

* ¿Qué significa “rápidamente”?
* ¿Qué es un pedido urgente?
* ¿Qué tratamiento diferencial recibe?
* ¿Cómo se valida?

### Reescritura orientada a especificación

“Un pedido marcado con prioridad ‘urgente’ deberá aparecer en la cola priorizada de preparación en menos de 2 segundos desde su confirmación. Los pedidos urgentes deberán procesarse antes que cualquier pedido estándar pendiente del mismo centro logístico.”

Aquí ya existe:

* condición,
* comportamiento esperado,
* criterio temporal,
* regla de prioridad,
* posibilidad de validación.

---

## Ejemplo 2. Falta de especificación compartida

Negocio espera que un descuento se aplique solo a clientes premium con más de 12 meses de antigüedad. Desarrollo interpreta que basta con ser premium. QA prueba solo casos premium/no premium. Resultado: error funcional en producción.

### Lección

El fallo no era de código ni necesariamente de pruebas, sino de especificación insuficiente.

---

## Ejemplo 3. Código correcto, producto incorrecto

Una API devuelve 200 OK con un cuerpo vacío cuando no encuentra datos. Técnicamente funciona. Pero negocio esperaba un mensaje específico y frontend dependía de un código 404 para mostrar una pantalla concreta.

### Lección

Sin especificación de contrato, cada parte interpreta el comportamiento a su manera.

---

# 9. Laboratorios desarrollados

## Laboratorio 1. Identificación de problemas en proyectos sin especificaciones claras

### Objetivo

Reconocer síntomas y consecuencias de trabajar sin una especificación suficientemente definida.

### Actividad

Se entrega al alumnado un caso breve de proyecto con incidencias:

* cambios frecuentes de alcance,
* conflictos entre QA y desarrollo,
* bugs funcionales repetidos,
* dependencia de una persona experta.

### Tareas

1. Identificar qué problemas se derivan de la falta de especificación.
2. Clasificar los impactos en negocio, desarrollo, calidad y mantenimiento.
3. Proponer qué tipo de especificación habría evitado cada problema.

### Evidencia esperada

Una tabla con:

* problema detectado,
* causa probable,
* impacto,
* mejora propuesta.

---

## Laboratorio 2. Comparativa entre requisitos ambiguos y especificaciones verificables

### Objetivo

Aprender a transformar formulaciones imprecisas en enunciados verificables.

### Actividad

Se proporciona una lista de requisitos ambiguos, por ejemplo:

* “el sistema debe ser intuitivo”,
* “la búsqueda debe ser rápida”,
* “el usuario podrá modificar sus datos si procede”,
* “se notificará cualquier incidencia importante”.

### Tareas

1. Detectar ambigüedades.
2. Formular preguntas de aclaración.
3. Reescribir cada requisito en formato más verificable.
4. Indicar cómo se comprobaría.

### Evidencia esperada

Documento con:

* requisito original,
* ambigüedad detectada,
* versión especificada,
* criterio de validación.

---

## Laboratorio 3. Mapa conceptual de SDD dentro del ciclo de desarrollo

### Objetivo

Relacionar la especificación con el resto de artefactos del ciclo de vida.

### Actividad

El alumnado construye un mapa conceptual que conecte:

* necesidad de negocio,
* requisito,
* especificación,
* diseño,
* implementación,
* prueba,
* aceptación,
* mantenimiento.

### Tareas

1. Dibujar relaciones entre artefactos.
2. Identificar entradas y salidas principales.
3. Marcar dónde se producen normalmente pérdidas de información.
4. Indicar cómo SDD reduce esas pérdidas.

### Evidencia esperada

Mapa visual acompañado de una breve explicación.

---

# 10. Actividades de evaluación

## Evaluación formativa

* Participación en debate inicial.
* Identificación correcta de ambigüedades.
* Calidad de la reescritura de requisitos.
* Coherencia del mapa conceptual.

## Evaluación sumativa sugerida

### Opción A. Cuestionario breve

Preguntas como:

1. ¿Cuál es el artefacto central en SDD?
2. ¿Qué diferencia principal existe entre SDD y TDD?
3. ¿Por qué una prueba correcta no garantiza un comportamiento correcto?
4. ¿Qué significa que una especificación sea verificable?
5. ¿Qué problema intenta resolver la idea de fuente de verdad compartida?

### Opción B. Caso práctico corto

Dar un mini caso de proyecto y pedir:

* detección de riesgos por falta de especificación,
* propuesta de mejora,
* comparación con otro enfoque.

---

# 11. Criterios de evaluación

Se considerará superado el tema cuando el participante:

* Define SDD con claridad y precisión.
* Distingue SDD de TDD, BDD y documentación tradicional.
* Identifica ambigüedades en requisitos de forma consistente.
* Explica el papel de la especificación como elemento de alineación.
* Propone mejoras razonables para convertir requisitos en bases verificables.

---

# 12. Recursos didácticos recomendados

* Presentación con ejemplos de ambigüedad y retrabajo.
* Fichas de requisitos ambiguos para reescritura.
* Plantilla simple de especificación inicial.
* Pizarra o mural colaborativo para mapa conceptual.
* Casos reales anonimizados del entorno de la organización, si existen.

---

# 13. Mensajes clave para cerrar el tema

1. **SDD no consiste en documentar más, sino en definir mejor.**
2. **La especificación no reemplaza al código ni a las pruebas, los coordina.**
3. **Muchos errores de software no nacen en la implementación, sino en la ambigüedad previa.**
4. **Una especificación útil debe ser compartida, precisa y verificable.**
5. **SDD convierte la especificación en un activo vivo del proyecto.**

---

# 14. Resumen ejecutivo del tema

Spec Driven Development sitúa la especificación en el centro del desarrollo de software para alinear negocio, diseño, implementación y validación. Su objetivo es reducir ambigüedad, retrabajo y desalineación entre roles. A diferencia de enfoques centrados solo en pruebas, código o documentación inicial, SDD trata la especificación como una fuente de verdad compartida, precisa, evolutiva y verificable. Este tema introduce los principios, beneficios, diferencias con otros enfoques y problemas que SDD ayuda a resolver, sentando la base del resto del itinerario formativo.

---

Puedo seguir con el **Tema 1 en formato docente completo**, incluyendo **introducción del formador, diapositivas sugeridas, ejercicios con soluciones y test de evaluación**.
