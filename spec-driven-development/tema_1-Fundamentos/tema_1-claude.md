# Tema 1. Fundamentos de Spec Driven Development

## 1.1. ¿Qué es Spec Driven Development?

Spec Driven Development (SDD) es un enfoque de desarrollo de software en el que **la especificación es el artefacto central** que guía todas las fases del ciclo de vida: análisis, diseño, implementación, validación y mantenimiento.

A diferencia de otros enfoques donde el código, los tests o la documentación actúan como fuente de verdad de facto, en SDD se parte de una premisa clara: **si no está especificado, no se puede construir de forma fiable, ni validar de forma objetiva, ni mantener de forma sostenible.**

Una especificación en SDD no es un documento estático que se redacta al inicio y se olvida. Es un **artefacto vivo**, versionado, revisable y verificable, que evoluciona junto con el software y sirve como punto de encuentro entre todos los perfiles involucrados: negocio, diseño, desarrollo, QA y operaciones.

### El problema que resuelve SDD

En la práctica habitual del desarrollo de software, nos encontramos con situaciones recurrentes:

- El equipo de negocio describe una necesidad de forma general, pero no hay un documento que concrete qué significa exactamente.
- El desarrollador interpreta los requisitos según su criterio y construye algo que "funciona", pero no necesariamente lo que se esperaba.
- QA no tiene una referencia clara contra la que validar, así que prueba lo que puede y prioriza según intuición.
- Cuando hay que mantener o evolucionar el sistema, nadie recuerda exactamente por qué se tomaron ciertas decisiones.

SDD aborda estos problemas estableciendo la especificación como el **contrato compartido** entre todos los actores del proyecto. No se trata de documentar más, sino de documentar mejor, antes y de forma que la especificación sea directamente útil para construir y validar.

### Definición práctica

Podemos definir SDD como:

> Un enfoque de desarrollo en el que toda decisión de diseño, implementación y validación se deriva de una especificación explícita, verificable y mantenida como fuente de verdad a lo largo de la vida del proyecto.

Esto implica tres compromisos:

1. **Especificar antes de construir**: no como un ejercicio burocrático, sino como una actividad de diseño que reduce la ambigüedad y alinea al equipo.
2. **Mantener la especificación actualizada**: tratándola como un artefacto de primera clase, con el mismo rigor que el código fuente.
3. **Verificar contra la especificación**: utilizando los criterios definidos en la especificación como base objetiva para la validación.

---

## 1.2. Principios básicos de SDD

SDD se fundamenta en un conjunto de principios que guían tanto la forma de trabajar como la cultura del equipo.

### Principio 1: La especificación es la fuente de verdad

En cualquier proyecto hay múltiples artefactos: código, tests, documentación, diagramas, tickets, correos, actas de reunión. Sin una fuente de verdad explícita, cada persona recurre al artefacto que le resulta más cercano, lo que produce **versiones divergentes de la realidad**.

En SDD, la especificación es el artefacto de referencia. Cuando hay duda sobre qué debe hacer el sistema, la respuesta está en la especificación. Cuando hay conflicto entre lo que dice el código y lo que dice la especificación, es el código el que debe corregirse (o la especificación debe actualizarse conscientemente).

### Principio 2: Especificar es diseñar

Escribir una buena especificación no es una tarea administrativa. Es un **acto de diseño**: obliga a pensar en los casos límite, en las relaciones entre componentes, en los flujos alternativos y en las restricciones del dominio. Muchos errores de software no se introducen al codificar, sino al no pensar con suficiente profundidad antes de codificar.

### Principio 3: Lo que no se puede verificar no está especificado

Una especificación que dice "el sistema debe ser rápido" no es verificable. Una que dice "el tiempo de respuesta del endpoint `/api/pedidos` no debe superar los 200 ms para el percentil 95 con carga normal" sí lo es. SDD exige que cada elemento de la especificación sea **comprobable**: contra una prueba automatizada, una revisión manual o una métrica observable.

### Principio 4: La especificación evoluciona con el proyecto

Los proyectos de software cambian. Los requisitos cambian. SDD no pretende congelar la especificación, sino gestionarla como un artefacto versionado que se actualiza de forma controlada, con trazabilidad sobre qué cambió, cuándo y por qué.

### Principio 5: La especificación es compartida

Una especificación encerrada en la cabeza de un analista, en un correo o en un documento que nadie consulta no cumple su función. SDD promueve que la especificación sea **accesible, legible y comprensible** para todos los perfiles del equipo, no solo para los técnicos.

---

## 1.3. SDD frente a otros enfoques

Para entender mejor el espacio que ocupa SDD, conviene compararlo con enfoques conocidos que también intentan mejorar la calidad y la comunicación en el desarrollo de software.

### SDD vs. desarrollo tradicional (waterfall)

En el desarrollo tradicional en cascada, existe una fase de especificación formal al inicio del proyecto. Sin embargo, esta especificación suele ser un documento extenso, monolítico, redactado por analistas y entregado al equipo de desarrollo como un bloque cerrado.

Las diferencias con SDD son significativas:

| Aspecto | Waterfall | SDD |
|---|---|---|
| Momento de especificación | Todo al inicio | Iterativo y continuo |
| Formato | Documento largo y estático | Artefactos modulares y versionados |
| Participación | Analistas → Desarrolladores | Colaboración de todos los perfiles |
| Evolución | Resistente al cambio | Cambio gestionado y trazable |
| Verificabilidad | A menudo ambigua | Explícitamente verificable |

SDD toma la idea de especificar con rigor pero la adapta a un flujo iterativo, colaborativo y orientado a la verificación.

### SDD vs. TDD (Test Driven Development)

TDD propone escribir primero el test y luego el código que lo satisface. Es una técnica valiosa para la calidad a nivel de implementación, pero tiene un alcance limitado:

- TDD opera a nivel de **unidad de código**: funciones, métodos, clases.
- No aborda el "qué" a nivel de sistema, sino el "cómo" a nivel de componente.
- No sustituye la necesidad de saber qué comportamiento debe tener el sistema a nivel global.

SDD y TDD no son incompatibles. De hecho, son complementarios: **SDD define qué hay que construir; TDD ayuda a construirlo correctamente.** Una buena especificación alimenta mejores tests.

### SDD vs. BDD (Behavior Driven Development)

BDD está más cerca de SDD en espíritu. Propone describir el comportamiento del sistema en un lenguaje comprensible para negocio y técnicos, habitualmente con formato Given-When-Then (Gherkin). Sin embargo:

- BDD se centra en **comportamiento observable** y en la comunicación entre negocio y desarrollo.
- No aborda de forma estructurada aspectos como contratos de API, reglas de dominio, invariantes, trazabilidad o versionado de especificaciones.
- En la práctica, muchos equipos reducen BDD a "escribir `.feature` files que luego se automatizan", perdiendo el componente de descubrimiento y colaboración.

SDD engloba el espíritu de BDD (describir comportamiento de forma comprensible y verificable) pero lo extiende a **todo el espectro de la especificación**: funcional, técnica, de contrato, de interfaz y de aceptación.

### SDD vs. documentación "a posteriori"

Muchos equipos documentan después de construir. Esto produce documentación que llega tarde, se desactualiza rápidamente y rara vez refleja las decisiones reales. SDD invierte el flujo: **la especificación llega antes que el código** y se mantiene como artefacto de primera clase, no como subproducto.

### Cuadro comparativo resumido

| Enfoque | Foco principal | Alcance | ¿Quién participa? | ¿Cuándo se hace? |
|---|---|---|---|---|
| Waterfall | Documentación formal | Todo el sistema | Analistas | Al inicio |
| TDD | Corrección del código | Unidad / componente | Desarrolladores | Durante implementación |
| BDD | Comportamiento observable | Funcionalidad | Negocio + Dev + QA | Antes de sprint |
| Doc. a posteriori | Registro de lo construido | Variable | Quien toque | Después de construir |
| **SDD** | **Especificación verificable** | **Todo el sistema** | **Todos los perfiles** | **Continuo** |

---

## 1.4. El papel de la especificación como fuente de verdad compartida

### ¿Qué significa "fuente de verdad"?

En ingeniería de software, una fuente de verdad (*single source of truth*) es el artefacto al que se recurre cuando hay dudas, conflictos o discrepancias. Sin una fuente de verdad explícita, cada persona del equipo genera su propia interpretación:

- El product owner cree que el sistema hace X porque así lo pidió en una reunión.
- El desarrollador cree que hace Y porque así lo implementó según su interpretación.
- QA prueba Z porque eso es lo que entendió del ticket de Jira.
- Operaciones configura el despliegue según un correo que recibió hace tres meses.

El resultado es un sistema que no satisface completamente a nadie y cuyo comportamiento real solo se descubre en producción.

### La especificación como contrato

En SDD, la especificación funciona como un **contrato explícito** entre todos los actores:

- **Para negocio**: es la garantía de que lo que se va a construir corresponde a lo que se necesita.
- **Para desarrollo**: es la guía que define qué hay que implementar, con qué restricciones y en qué condiciones.
- **Para QA**: es la referencia contra la que validar el resultado.
- **Para operaciones**: es la documentación del comportamiento esperado del sistema en producción.
- **Para mantenimiento**: es el registro de las decisiones de diseño y las razones detrás de cada componente.

### Características de una buena fuente de verdad

Para que la especificación cumpla este rol, debe cumplir ciertas propiedades:

- **Accesible**: todo el equipo sabe dónde está y puede consultarla sin barreras.
- **Comprensible**: está escrita de forma que los distintos perfiles la entienden (no es solo para técnicos).
- **Actualizada**: refleja el estado actual del proyecto, no una versión obsoleta.
- **Versionada**: se puede rastrear qué cambió, cuándo y por qué.
- **Verificable**: cada elemento se puede comprobar de forma objetiva.
- **Modular**: se puede consultar y actualizar por partes sin necesidad de revisar todo el documento.

### El coste de no tener fuente de verdad

No definir una fuente de verdad compartida no significa que no haya especificaciones. Significa que hay **muchas, dispersas y contradictorias**: correos, actas, tickets, comentarios en el código, documentos de análisis desactualizados, conversaciones de chat... El coste de reconstruir la verdad en cada momento es enormemente superior al de mantener una especificación viva.

---

## 1.5. El ciclo SDD en la práctica

Aunque SDD no prescribe una metodología rígida, sí establece un flujo lógico que se integra con cualquier marco de trabajo (Scrum, Kanban, SAFe, etc.):

### Paso 1: Descubrimiento

Se recoge la necesidad de negocio o la solicitud de cambio. Se identifican los actores, el contexto y el objetivo. El resultado es un **enunciado de necesidad** todavía en lenguaje de negocio.

### Paso 2: Especificación

Se transforma la necesidad en una especificación estructurada: funcionalidad esperada, casos de uso, reglas de dominio, contratos, restricciones, criterios de aceptación. Se revisa con los distintos perfiles.

### Paso 3: Diseño e implementación

El equipo de desarrollo utiliza la especificación como guía para diseñar la solución técnica e implementarla. Las decisiones de diseño se contrastan con la especificación para detectar desviaciones tempranas.

### Paso 4: Verificación

La validación se realiza contra los criterios definidos en la especificación. Los tests automatizados, las pruebas manuales y las revisiones se organizan en torno a lo especificado, no a la intuición de QA.

### Paso 5: Evolución

Cuando cambian los requisitos, el ciclo se reinicia desde la especificación. El cambio se registra, se evalúa su impacto y se actualiza la especificación antes de modificar el código.

```
 ┌──────────────┐
 │ Descubrimiento│
 └──────┬───────┘
        ▼
 ┌──────────────┐
 │Especificación │◄──────────────────┐
 └──────┬───────┘                    │
        ▼                            │
 ┌──────────────┐                    │
 │   Diseño e   │                    │
 │Implementación│               Evolución
 └──────┬───────┘                    │
        ▼                            │
 ┌──────────────┐                    │
 │ Verificación │────────────────────┘
 └──────────────┘
```

---

## 1.6. Beneficios y riesgos de SDD

### Beneficios

- **Reducción de retrabajo**: al especificar bien antes de construir, se minimizan los malentendidos que generan correcciones tardías.
- **Mejor comunicación**: la especificación compartida reduce la dependencia de reuniones y conversaciones informales como único medio de alineamiento.
- **Validación objetiva**: los criterios de aceptación permiten verificar de forma clara si el software cumple lo esperado.
- **Mantenibilidad**: un sistema con especificaciones actualizadas es más fácil de entender, corregir y evolucionar.
- **Onboarding**: los nuevos miembros del equipo pueden entender el sistema leyendo las especificaciones, sin depender exclusivamente de la memoria oral del equipo.
- **Trazabilidad**: se puede recorrer el hilo desde la necesidad original hasta el test que la valida, pasando por el diseño y la implementación.

### Riesgos y precauciones

- **Burocracia excesiva**: si se confunde "especificar" con "documentar todo en detalle", SDD puede convertirse en una carga. La clave es especificar lo necesario, no lo máximo.
- **Especificaciones que nadie lee**: si el formato, la ubicación o el lenguaje no son adecuados, el equipo dejará de consultar la especificación.
- **Rigidez**: si se trata la especificación como algo inamovible, se pierde la capacidad de adaptación. SDD exige gestión del cambio, no resistencia al cambio.
- **Falsa sensación de completitud**: una especificación no garantiza que sea correcta. Sigue siendo necesario el juicio, la revisión y la validación empírica.

---

## 1.7. Cuándo y dónde aplicar SDD

SDD no es un dogma ni una metodología cerrada. Se puede adoptar de forma **gradual y adaptada** al contexto:

- **Proyectos nuevos**: es el escenario ideal para arrancar con SDD desde el inicio.
- **Proyectos en mantenimiento**: se puede empezar especificando los cambios nuevos y, progresivamente, documentar lo existente.
- **Equipos pequeños**: SDD no requiere roles específicos, pero sí disciplina. Un equipo de tres personas puede practicar SDD si acuerda que la especificación precede a la implementación.
- **Equipos grandes o distribuidos**: SDD es especialmente valioso cuando la comunicación informal no escala. La especificación actúa como interfaz entre equipos.
- **Contextos regulados**: en sectores donde la trazabilidad y la auditoría son obligatorias (sanidad, banca, administración pública), SDD aporta una estructura natural para cumplir estos requisitos.
- **Desarrollo con IA asistida**: cuando se utiliza IA para generar código, la especificación cobra aún más importancia como guía y criterio de validación, ya que sin una especificación clara, no hay forma objetiva de evaluar si lo generado es correcto.

---

## Laboratorios

### Laboratorio 1.1: Identificación de problemas en proyectos sin especificaciones claras

**Objetivo**
Reconocer los síntomas habituales de trabajar sin especificaciones y entender su impacto en la calidad, los plazos y la comunicación del equipo.

**Contexto**
Se presenta un escenario ficticio de un proyecto real con problemas típicos: requisitos ambiguos recibidos por correo, interpretaciones divergentes entre desarrolladores, bugs que se descubren en producción por falta de validación clara, etc.

**Instrucciones**

1. Lee el siguiente escenario del proyecto "GestiónDoc":

   > El equipo de GestiónDoc (4 desarrolladores, 1 analista, 1 QA) está construyendo un sistema de gestión documental para un organismo público. El analista recibió los requisitos en una reunión con el cliente hace dos meses y los anotó en un correo electrónico que reenvió al equipo. Desde entonces:
   >
   > - El cliente ha pedido tres cambios por teléfono, que el analista ha comunicado verbalmente en las dailys.
   > - Dos desarrolladores trabajan en el módulo de búsqueda, pero cada uno ha interpretado de forma distinta cómo deben funcionar los filtros avanzados.
   > - QA está probando el módulo de subida de documentos, pero no tiene criterios de aceptación escritos. Ha encontrado 12 bugs, pero el equipo discute si 5 de ellos son realmente bugs o "comportamiento no definido".
   > - El cliente tiene prevista una demo en dos semanas y espera ver funcionalidades que el equipo cree que no estaban en el alcance.

2. Identifica al menos **5 problemas concretos** que se derivan de la falta de especificaciones claras en este proyecto.

3. Para cada problema, responde:
   - ¿Qué consecuencia tiene en el proyecto? (retraso, retrabajo, conflicto, riesgo...)
   - ¿Cómo habría ayudado una especificación a prevenirlo?

4. Clasifica los problemas en tres categorías:
   - Problemas de **comunicación**
   - Problemas de **calidad**
   - Problemas de **gestión del alcance**

**Entregable**
Tabla con los problemas identificados, sus consecuencias, la categoría a la que pertenecen y la mejora que aportaría SDD en cada caso.

**Criterio de éxito**
Se han identificado al menos 5 problemas relevantes, correctamente clasificados, con una explicación coherente de cómo la especificación los habría mitigado.

---

### Laboratorio 1.2: Comparativa entre requisitos ambiguos y especificaciones verificables

**Objetivo**
Desarrollar la capacidad de distinguir entre requisitos vagos o ambiguos y especificaciones que son claras, precisas y verificables.

**Contexto**
En la práctica, los requisitos que reciben los equipos de desarrollo suelen estar formulados de forma genérica. Este laboratorio entrena la habilidad de detectar ambigüedades y transformarlas en especificaciones útiles.

**Instrucciones**

1. Analiza cada uno de los siguientes requisitos y evalúa si es verificable tal como está formulado:

   | # | Requisito | ¿Verificable? |
   |---|---|---|
   | R1 | "El sistema debe ser rápido" | |
   | R2 | "Los usuarios podrán buscar documentos" | |
   | R3 | "El sistema debe soportar muchos usuarios simultáneos" | |
   | R4 | "El formulario de alta debe validar los campos obligatorios" | |
   | R5 | "El sistema debe ser seguro" | |
   | R6 | "Cuando un usuario sube un documento PDF mayor de 10 MB, el sistema muestra un error indicando el tamaño máximo permitido" | |
   | R7 | "La interfaz debe ser intuitiva y fácil de usar" | |
   | R8 | "El sistema enviará un correo de confirmación al usuario tras registrarse, con un enlace de activación válido durante 24 horas" | |

2. Para cada requisito que consideres **no verificable**, reescríbelo como una especificación verificable. Incluye:
   - Sujeto claro (quién o qué)
   - Acción concreta (qué hace)
   - Condiciones (cuándo, con qué datos)
   - Resultado esperado (qué se observa)
   - Criterio de verificación (cómo se comprueba)

3. Compara tus reescrituras con las de otro participante (o revísalas pasados unos días). ¿Hay diferencias de interpretación? ¿Qué dice eso sobre la ambigüedad del requisito original?

**Ejemplo de transformación**

- **Requisito ambiguo**: "El sistema debe ser rápido"
- **Especificación verificable**: "El endpoint `GET /api/documentos` responde en menos de 300 ms para el percentil 95 de las peticiones, con una base de datos de 100.000 documentos y 50 usuarios concurrentes. Se mide mediante prueba de carga con JMeter."

**Entregable**
Tabla completada con la evaluación de cada requisito y las reescrituras correspondientes.

**Criterio de éxito**
Se identifican correctamente los requisitos ambiguos (al menos 5 de 8) y las reescrituras incluyen sujeto, acción, condiciones, resultado esperado y criterio de verificación.

---

### Laboratorio 1.3: Mapa conceptual de SDD dentro del ciclo de desarrollo

**Objetivo**
Situar SDD en el contexto del ciclo de vida del software, identificando en qué fases interviene la especificación y cómo se relaciona con otros enfoques y prácticas.

**Contexto**
SDD no sustituye a otras prácticas sino que las complementa y les da un marco de referencia. Este laboratorio busca que el alumno construya una visión global de cómo encaja SDD con las prácticas que ya conoce.

**Instrucciones**

1. Dibuja (en papel, pizarra o herramienta digital) un diagrama que represente el ciclo de vida de un proyecto software con al menos las siguientes fases:
   - Descubrimiento / análisis
   - Diseño
   - Implementación
   - Testing / Verificación
   - Despliegue
   - Mantenimiento / Evolución

2. Para cada fase, indica:
   - ¿Qué tipo de especificación interviene? (funcional, técnica, de contrato, de aceptación, de operación...)
   - ¿Quién la produce o la consume?
   - ¿Qué ocurre si no existe esa especificación en esa fase?

3. Sitúa en el diagrama los siguientes enfoques y prácticas, indicando en qué fases actúan y cómo se relacionan con SDD:
   - TDD
   - BDD
   - Code Review
   - CI/CD
   - Documentación técnica
   - Gestión de requisitos (Jira, Azure DevOps, etc.)

4. Añade flechas o conexiones que muestren:
   - Flujos de información entre fases
   - Puntos donde la especificación alimenta otras prácticas
   - Puntos de riesgo donde la ausencia de especificación genera problemas

**Entregable**
Mapa conceptual o diagrama (formato libre) que muestre la relación de SDD con el ciclo de desarrollo y con otros enfoques.

**Criterio de éxito**
El diagrama muestra al menos 5 fases del ciclo de vida, identifica los tipos de especificación relevantes en cada una, sitúa correctamente los enfoques complementarios y señala al menos 3 puntos de riesgo asociados a la falta de especificación.

## Tema 1 - Soluciones de los laboratorios

---

### Laboratorio 1.1: Identificación de problemas en proyectos sin especificaciones claras

#### Solución

A partir del escenario del proyecto "GestiónDoc", se identifican los siguientes problemas:

#### Tabla de problemas identificados

| # | Problema | Consecuencia | Categoría | ¿Cómo habría ayudado SDD? |
|---|---|---|---|---|
| P1 | Los requisitos se recibieron en una reunión y se transmitieron por correo electrónico, sin estructura ni formato verificable. | El equipo trabaja sobre una base imprecisa. Cada persona interpreta el correo según su contexto, lo que genera divergencias desde el inicio. | Comunicación | Una especificación estructurada y revisada con el cliente habría fijado un punto de partida común, con lenguaje preciso y formato consultable. |
| P2 | El cliente ha solicitado tres cambios por teléfono y el analista los ha comunicado verbalmente en las dailys. No hay registro escrito. | Los cambios no quedan documentados. No se puede verificar qué se pidió exactamente, quién lo aprobó ni cuándo. Si un desarrollador no estuvo en la daily, desconoce el cambio. | Gestión del alcance | En SDD, cualquier cambio se refleja en la especificación antes de implementarse. El cambio queda registrado, versionado y accesible para todo el equipo. |
| P3 | Dos desarrolladores trabajan en el mismo módulo (búsqueda con filtros avanzados) con interpretaciones distintas del comportamiento esperado. | Se produce retrabajo seguro: al menos una de las dos implementaciones (posiblemente ambas) no coincidirá con lo esperado. Además, hay riesgo de conflictos en la integración del código. | Comunicación / Calidad | Una especificación del módulo de búsqueda con casos de uso, filtros definidos, combinaciones válidas y resultados esperados habría eliminado la ambigüedad antes de escribir una sola línea de código. |
| P4 | QA no tiene criterios de aceptación escritos. Prueba según su interpretación y encuentra 12 bugs, pero 5 son discutibles ("comportamiento no definido"). | Se pierde tiempo en discusiones improductivas sobre si algo es un bug o no. QA no puede priorizar con criterio objetivo. El equipo pierde confianza en el proceso de validación. | Calidad | Con criterios de aceptación explícitos en la especificación, cada bug se puede contrastar contra un comportamiento esperado concreto. Lo que no está especificado se identifica como un hueco a cubrir, no como un debate subjetivo. |
| P5 | El cliente espera ver en la demo funcionalidades que el equipo considera fuera de alcance. No hay un documento de alcance acordado. | La demo será un fracaso de expectativas. El cliente se sentirá defraudado, el equipo se sentirá injustamente evaluado. Se genera desconfianza mutua y posiblemente retrabajo urgente. | Gestión del alcance | Una especificación de alcance firmada o validada por ambas partes habría definido claramente qué se entrega en cada iteración. Las discrepancias se habrían detectado semanas antes, no en la demo. |
| P6 | No existe trazabilidad entre lo que pidió el cliente, lo que se diseñó, lo que se implementó y lo que se probó. | Es imposible saber si el sistema construido corresponde a lo solicitado. No se puede auditar el proyecto ni justificar decisiones ante el cliente. | Calidad / Gestión del alcance | SDD establece trazabilidad desde la necesidad hasta la prueba. Cada funcionalidad tiene un hilo que conecta requisito → especificación → código → test. |
| P7 | El analista es el único que conoce el contexto completo del proyecto. Si se ausenta, el equipo pierde la fuente de información. | Dependencia de persona (*bus factor* = 1). Si el analista enferma, cambia de proyecto o simplemente olvida un detalle, no hay forma de recuperar la información. | Comunicación | La especificación escrita y accesible elimina la dependencia de la memoria de una sola persona. El conocimiento está en el artefacto, no en la cabeza del analista. |

#### Clasificación resumida

**Problemas de comunicación**: P1, P3, P7
- Origen común: la información se transmite por canales informales (correo, conversación verbal, memoria personal) en lugar de quedar registrada en un artefacto compartido.

**Problemas de calidad**: P4, P6
- Origen común: no hay una referencia objetiva contra la que validar el software. La calidad se evalúa por intuición, no por criterios.

**Problemas de gestión del alcance**: P2, P5
- Origen común: los cambios y las expectativas no se registran de forma controlada. No hay un acuerdo explícito y actualizado sobre qué se entrega.

#### Reflexión

Los siete problemas identificados son consecuencia directa de la ausencia de un artefacto central de referencia. No se trata de que el equipo sea incompetente; se trata de que trabaja sin las herramientas conceptuales para alinearse. SDD no habría eliminado todos los riesgos, pero habría convertido la mayoría de estos problemas en situaciones detectables y gestionables antes de que se convirtieran en crisis.

---

### Laboratorio 1.2: Comparativa entre requisitos ambiguos y especificaciones verificables

#### Solución

#### Evaluación de verificabilidad

| # | Requisito | ¿Verificable? | Justificación |
|---|---|---|---|
| R1 | "El sistema debe ser rápido" | No | "Rápido" es subjetivo. No indica qué operación, qué umbral de tiempo, bajo qué condiciones ni cómo se mide. |
| R2 | "Los usuarios podrán buscar documentos" | No | Demasiado genérico. No define qué campos se pueden buscar, qué tipo de búsqueda (texto libre, filtros, avanzada), qué resultados se esperan ni cómo se presentan. |
| R3 | "El sistema debe soportar muchos usuarios simultáneos" | No | "Muchos" no es una cifra. No define cuántos usuarios, qué operaciones realizan, qué nivel de degradación es aceptable ni cómo se mide. |
| R4 | "El formulario de alta debe validar los campos obligatorios" | Parcialmente | Indica una acción concreta (validar campos obligatorios), pero no especifica cuáles son esos campos, qué reglas de validación aplican, qué mensajes se muestran ni cuándo se ejecuta la validación (al enviar, al perder foco, en tiempo real). |
| R5 | "El sistema debe ser seguro" | No | "Seguro" es un término paraguas que puede significar autenticación, autorización, cifrado, auditoría, protección contra ataques, etc. Sin concretar, es inverificable. |
| R6 | "Cuando un usuario sube un documento PDF mayor de 10 MB, el sistema muestra un error indicando el tamaño máximo permitido" | Sí | Define sujeto (usuario), acción (subir PDF), condición (mayor de 10 MB), resultado esperado (mensaje de error con tamaño máximo). Se puede verificar con una prueba directa. |
| R7 | "La interfaz debe ser intuitiva y fácil de usar" | No | "Intuitiva" y "fácil de usar" son juicios subjetivos. Sin métricas de usabilidad, tareas de referencia o criterios medibles, no se puede verificar. |
| R8 | "El sistema enviará un correo de confirmación al usuario tras registrarse, con un enlace de activación válido durante 24 horas" | Sí | Define el evento desencadenante (registro), la acción (envío de correo), el contenido (enlace de activación) y la restricción temporal (24 horas de validez). Verificable mediante prueba funcional. |

**Resumen**: R6 y R8 son verificables. R4 es parcialmente verificable. R1, R2, R3, R5 y R7 no son verificables tal como están formulados.

#### Reescrituras como especificaciones verificables

##### R1: "El sistema debe ser rápido"

**Especificación verificable:**

> **ID**: PERF-001
>
> **Título**: Tiempo de respuesta del listado de documentos
>
> **Descripción**: El endpoint `GET /api/documentos` debe responder en menos de 300 ms para el percentil 95 de las peticiones, bajo las siguientes condiciones:
> - Base de datos con 100.000 documentos.
> - 50 usuarios concurrentes realizando peticiones simultáneas.
> - Servidor con la configuración de producción estándar.
>
> **Verificación**: Prueba de carga con JMeter o k6. Se ejecutan 1.000 peticiones con 50 hilos concurrentes y se mide el p95 del tiempo de respuesta. El test pasa si p95 < 300 ms.

##### R2: "Los usuarios podrán buscar documentos"

**Especificación verificable:**

> **ID**: FUNC-010
>
> **Título**: Búsqueda de documentos por texto y filtros
>
> **Descripción**: El sistema ofrece una función de búsqueda de documentos accesible desde la pantalla principal. El usuario puede:
> 1. Introducir texto libre en un campo de búsqueda. El sistema busca coincidencias en el título y en el contenido del documento.
> 2. Aplicar los siguientes filtros combinables:
>    - Tipo de documento (PDF, Word, imagen) — selección múltiple.
>    - Fecha de creación — rango con fecha inicio y fecha fin.
>    - Autor — lista desplegable con autocompletado.
> 3. Los resultados se muestran en una tabla paginada (20 resultados por página) ordenados por relevancia descendente.
> 4. Si no hay resultados, se muestra el mensaje: "No se han encontrado documentos con los criterios indicados."
>
> **Verificación**:
> - Test funcional: buscar por texto existente → se muestran documentos que contienen ese texto en título o contenido.
> - Test funcional: aplicar filtro de tipo "PDF" → solo aparecen documentos PDF.
> - Test funcional: buscar texto inexistente → se muestra el mensaje de sin resultados.
> - Test funcional: combinación de filtros → los resultados cumplen todos los filtros simultáneamente.

##### R3: "El sistema debe soportar muchos usuarios simultáneos"

**Especificación verificable:**

> **ID**: PERF-002
>
> **Título**: Capacidad de concurrencia del sistema
>
> **Descripción**: El sistema debe soportar 500 usuarios concurrentes realizando operaciones mixtas (60% lectura, 30% búsqueda, 10% subida de documentos) sin que el tiempo de respuesta medio supere los 500 ms ni se produzcan errores HTTP 5xx.
>
> **Condiciones**: Base de datos con 200.000 documentos. Infraestructura de producción estándar (2 instancias de aplicación, 1 base de datos).
>
> **Verificación**: Test de carga con k6 simulando 500 usuarios virtuales durante 15 minutos con la distribución de operaciones indicada. El test pasa si: (a) tiempo de respuesta medio < 500 ms, (b) tasa de errores 5xx < 0,1%.

##### R4: "El formulario de alta debe validar los campos obligatorios"

**Especificación verificable:**

> **ID**: FUNC-003
>
> **Título**: Validación del formulario de alta de usuario
>
> **Descripción**: El formulario de alta contiene los siguientes campos, todos obligatorios:
>
> | Campo | Regla de validación | Mensaje de error |
> |---|---|---|
> | Nombre | Texto, 2-100 caracteres, solo letras y espacios | "El nombre debe tener entre 2 y 100 caracteres" |
> | Email | Formato email válido (RFC 5322 simplificado) | "Introduce un email válido" |
> | Contraseña | Mínimo 8 caracteres, al menos 1 mayúscula, 1 minúscula y 1 dígito | "La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula y un número" |
> | Confirmación de contraseña | Debe coincidir con el campo Contraseña | "Las contraseñas no coinciden" |
>
> La validación se ejecuta al pulsar el botón "Registrarse". Los campos con error se marcan con borde rojo y el mensaje de error aparece debajo del campo correspondiente. El formulario no se envía hasta que todos los campos sean válidos.
>
> **Verificación**:
> - Test: enviar formulario con campo Nombre vacío → se muestra el mensaje de error del campo Nombre, el formulario no se envía.
> - Test: introducir email sin "@" → se muestra mensaje de email inválido.
> - Test: contraseña de 6 caracteres → se muestra mensaje de contraseña insuficiente.
> - Test: todos los campos válidos → el formulario se envía correctamente.

##### R5: "El sistema debe ser seguro"

**Especificación verificable (desglosada en varias):**

> **ID**: SEC-001 — Autenticación
>
> **Descripción**: El acceso al sistema requiere autenticación mediante usuario (email) y contraseña. Tras 5 intentos fallidos consecutivos, la cuenta se bloquea durante 15 minutos. Las contraseñas se almacenan con hash bcrypt con coste mínimo 12.
>
> **Verificación**: Test de login con credenciales incorrectas 5 veces → la cuenta se bloquea. Inspección de base de datos → las contraseñas están hasheadas.

> **ID**: SEC-002 — Autorización
>
> **Descripción**: Existen tres roles: Lector, Editor y Administrador. Un Lector solo puede consultar documentos. Un Editor puede consultar, crear y modificar documentos propios. Un Administrador tiene acceso completo.
>
> **Verificación**: Test con usuario Lector intentando crear un documento → el sistema responde con HTTP 403. Test con Editor modificando documento ajeno → HTTP 403.

> **ID**: SEC-003 — Comunicaciones
>
> **Descripción**: Toda la comunicación entre cliente y servidor se realiza sobre HTTPS (TLS 1.2 o superior). No se aceptan conexiones HTTP sin cifrar.
>
> **Verificación**: Intento de conexión HTTP al puerto 80 → redirección a HTTPS o rechazo. Inspección del certificado TLS → versión ≥ 1.2.

##### R7: "La interfaz debe ser intuitiva y fácil de usar"

**Especificación verificable:**

> **ID**: UX-001
>
> **Título**: Usabilidad de las tareas principales
>
> **Descripción**: Un usuario nuevo (sin formación previa en el sistema) debe ser capaz de completar las siguientes tareas sin ayuda externa:
>
> | Tarea | Tiempo máximo | Tasa de éxito mínima |
> |---|---|---|
> | Subir un documento | 2 minutos | 90% de los participantes |
> | Buscar un documento por título | 1 minuto | 95% de los participantes |
> | Descargar un documento encontrado | 30 segundos | 95% de los participantes |
>
> **Verificación**: Test de usabilidad con 10 usuarios representativos del perfil objetivo. Se mide el tiempo de finalización y la tasa de éxito para cada tarea. El test pasa si se cumplen los umbrales indicados.

#### Reflexión sobre el ejercicio

Los requisitos R6 y R8 demuestran que es posible formular requisitos verificables desde el inicio si se piensa en términos de sujeto, acción, condición y resultado esperado. Los demás requisitos son habituales en la práctica real y reflejan un patrón común: se describe una intención ("rápido", "seguro", "intuitivo") sin concretar qué significa en términos observables. La transformación a especificación verificable no solo mejora la calidad de la documentación, sino que obliga a tomar decisiones de diseño que de otro modo se posponen hasta la implementación (donde se toman de forma implícita y a menudo inconsistente).

---

### Laboratorio 1.3: Mapa conceptual de SDD dentro del ciclo de desarrollo

#### Solución

#### Diagrama del ciclo de vida con SDD

```
                        ┌─────────────────────────────────────────────┐
                        │           ESPECIFICACIÓN (SDD)              │
                        │         Fuente de verdad central            │
                        └────┬────┬────┬────┬────┬────┬──────────────┘
                             │    │    │    │    │    │
          Alimenta           │    │    │    │    │    │          Retroalimenta
        ┌────────────────────┘    │    │    │    │    └──────────────────────┐
        ▼                         ▼    │    ▼    │                          ▼
 ┌──────────────┐   ┌──────────────┐  │ ┌───────────────┐  ┌──────────────────┐
 │Descubrimiento│──▶│    Diseño    │──┘ │  Verificación  │  │   Mantenimiento   │
 │  / Análisis  │   │              │    │  / Testing     │  │   / Evolución     │
 └──────────────┘   └──────┬───────┘    └───────┬───────┘  └──────────────────┘
                           │                     │                    │
                           ▼                     │                    │
                    ┌──────────────┐             │                    │
                    │Implementación│─────────────┘                    │
                    └──────┬───────┘                                  │
                           │                                          │
                           ▼                                          │
                    ┌──────────────┐                                  │
                    │  Despliegue  │──────────────────────────────────┘
                    └──────────────┘
```

#### Detalle por fase

##### Fase 1: Descubrimiento / Análisis

| Aspecto | Detalle |
|---|---|
| Tipo de especificación | Especificación funcional de alto nivel, documento de visión, requisitos de negocio |
| Quién la produce | Product Owner, analista de negocio, stakeholders |
| Quién la consume | Todo el equipo (para entender el contexto y el objetivo) |
| Si no existe | El equipo construye sin entender el porqué. Se resuelven problemas que nadie pidió y se ignoran necesidades reales. Las prioridades se definen por inercia o por quien habla más alto. |

**Prácticas relacionadas:**
- Gestión de requisitos (Jira, Azure DevOps): se registran las necesidades como épicas o historias, pero en SDD estas se vinculan a especificaciones detalladas, no son la especificación en sí mismas.
- BDD (fase de descubrimiento): las sesiones de "Three Amigos" o "Example Mapping" encajan aquí como técnica de descubrimiento que alimenta la especificación.

##### Fase 2: Diseño

| Aspecto | Detalle |
|---|---|
| Tipo de especificación | Especificaciones técnicas, contratos de API, modelos de dominio, diagramas de arquitectura, reglas de negocio formalizadas |
| Quién la produce | Arquitecto, tech lead, desarrolladores senior, analista |
| Quién la consume | Equipo de desarrollo, QA (para entender la estructura interna) |
| Si no existe | El diseño queda en la cabeza del desarrollador. Dos personas pueden diseñar soluciones incompatibles para el mismo problema. Las decisiones de arquitectura no se documentan y se pierden cuando rota el equipo. |

**Prácticas relacionadas:**
- Documentación técnica: en SDD, la documentación técnica no es un subproducto del diseño sino parte de la especificación.
- Code Review: las revisiones de código se hacen contrastando la implementación contra la especificación de diseño, no solo contra el estilo o las buenas prácticas genéricas.

##### Fase 3: Implementación

| Aspecto | Detalle |
|---|---|
| Tipo de especificación | Especificaciones de componente, contratos entre módulos, precondiciones/postcondiciones, invariantes |
| Quién la produce | Se produjo en las fases anteriores. En implementación se consulta y, si se detectan huecos, se actualiza. |
| Quién la consume | Desarrolladores |
| Si no existe | El desarrollador toma decisiones de diseño implícitas que nadie revisa. Los contratos entre componentes se descubren por ensayo y error. La integración entre módulos falla porque cada equipo asumió cosas distintas. |

**Prácticas relacionadas:**
- TDD: el desarrollador escribe tests antes del código. En SDD, esos tests se derivan de la especificación: los casos de prueba unitarios reflejan las precondiciones, postcondiciones e invariantes definidos en la spec.
- CI/CD: la integración continua ejecuta los tests derivados de la especificación en cada commit. Si un test falla, se sabe exactamente qué requisito se ha roto.

##### Fase 4: Verificación / Testing

| Aspecto | Detalle |
|---|---|
| Tipo de especificación | Criterios de aceptación, escenarios de prueba, especificaciones ejecutables |
| Quién la produce | Analista + QA + desarrollo (colaborativamente, idealmente en la fase de especificación) |
| Quién la consume | QA, equipo de desarrollo (para validar antes de entregar) |
| Si no existe | QA prueba "lo que puede" sin referencia objetiva. Los bugs se discuten ("¿es bug o feature?"). La cobertura de requisitos es desconocida. No se sabe si el software cumple lo esperado hasta que el cliente lo prueba en producción. |

**Prácticas relacionadas:**
- BDD (fase de automatización): los escenarios Gherkin se derivan de la especificación y se automatizan como tests de aceptación.
- TDD: los tests unitarios validan el nivel de componente; los tests de aceptación validan el nivel funcional. Ambos se alimentan de la especificación.

##### Fase 5: Despliegue

| Aspecto | Detalle |
|---|---|
| Tipo de especificación | Especificaciones de operación: configuración esperada, requisitos de infraestructura, parámetros de entorno, comportamiento esperado en producción |
| Quién la produce | Desarrollo + operaciones |
| Quién la consume | Equipo de operaciones, SRE, DevOps |
| Si no existe | El despliegue depende del conocimiento tácito de quien lo hace. Los entornos se configuran de forma inconsistente. Los incidentes en producción se resuelven sin referencia a un comportamiento esperado documentado. |

**Prácticas relacionadas:**
- CI/CD: el pipeline de despliegue puede incluir validaciones automáticas contra la especificación (tests de humo, verificación de contratos, checks de configuración).

##### Fase 6: Mantenimiento / Evolución

| Aspecto | Detalle |
|---|---|
| Tipo de especificación | Especificaciones actualizadas que reflejan el estado real del sistema, registro de cambios, análisis de impacto |
| Quién la produce | Todo el equipo, al gestionar cada cambio |
| Quién la consume | Cualquier persona que necesite entender, corregir o evolucionar el sistema |
| Si no existe | El sistema se convierte en una "caja negra" cuyo comportamiento solo se conoce ejecutándolo. Cada cambio es una apuesta. El onboarding de nuevos miembros es lento y costoso. La deuda técnica crece de forma invisible. |

**Prácticas relacionadas:**
- Gestión de requisitos: la trazabilidad permite saber qué especificación afecta cada cambio.
- Code Review: se verifica que el cambio es consistente con la especificación actualizada.

#### Mapa de relaciones entre enfoques

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│                     SPEC DRIVEN DEVELOPMENT (SDD)                       │
│                  Especificación como fuente de verdad                    │
│                                                                         │
│  ┌──────────────────────────────────────────────────────────────────┐   │
│  │                    Fases del ciclo de vida                        │   │
│  │                                                                  │   │
│  │  Descubrimiento ──▶ Diseño ──▶ Implementación ──▶ Verificación  │   │
│  │       │                │              │                │         │   │
│  │       │                │              │                │         │   │
│  │       ▼                ▼              ▼                ▼         │   │
│  │  ┌─────────┐    ┌──────────┐   ┌──────────┐    ┌──────────┐    │   │
│  │  │  BDD    │    │   Doc    │   │   TDD    │    │   BDD    │    │   │
│  │  │(descubr)│    │ técnica  │   │  (unit)  │    │ (accept) │    │   │
│  │  └─────────┘    └──────────┘   └──────────┘    └──────────┘    │   │
│  │                                       │                │        │   │
│  │                                       ▼                ▼        │   │
│  │                                 ┌───────────────────────┐       │   │
│  │                                 │  CI/CD (ejecución     │       │   │
│  │                                 │  automática de tests   │       │   │
│  │                                 │  contra especificación)│       │   │
│  │                                 └───────────────────────┘       │   │
│  │                                                                  │   │
│  │  ┌──────────────────────────────────────────────────────────┐   │   │
│  │  │  Code Review: contraste implementación vs especificación │   │   │
│  │  └──────────────────────────────────────────────────────────┘   │   │
│  │                                                                  │   │
│  │  ┌──────────────────────────────────────────────────────────┐   │   │
│  │  │  Gestión de requisitos (Jira/Azure DevOps):              │   │   │
│  │  │  registro y trazabilidad de requisitos → especificaciones│   │   │
│  │  └──────────────────────────────────────────────────────────┘   │   │
│  └──────────────────────────────────────────────────────────────────┘   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

#### Puntos de riesgo por ausencia de especificación

| # | Punto de riesgo | Fase | Consecuencia |
|---|---|---|---|
| R1 | No hay especificación funcional validada con el cliente | Descubrimiento → Diseño | Se diseña y construye algo que no corresponde a la necesidad real. Se descubre en la demo o en producción. |
| R2 | No hay contratos definidos entre componentes o servicios | Diseño → Implementación | Los equipos que trabajan en módulos distintos integran con fricciones. Los errores de integración aparecen tarde y son costosos. |
| R3 | No hay criterios de aceptación antes de la implementación | Implementación → Verificación | QA no puede validar objetivamente. Se producen debates sobre si el software funciona correctamente. El equipo pierde tiempo en discusiones que no aportan valor. |
| R4 | No hay especificación de operación | Verificación → Despliegue | El despliegue falla por configuraciones no documentadas. Los incidentes en producción se investigan sin referencia de comportamiento esperado. |
| R5 | No hay especificación actualizada tras los cambios | Despliegue → Mantenimiento | El sistema diverge de la documentación. Nadie sabe qué comportamiento es intencionado y cuál es accidental. El mantenimiento se convierte en arqueología del código. |

#### Conclusiones del mapa conceptual

1. **SDD no sustituye a TDD, BDD, CI/CD ni a las herramientas de gestión de requisitos.** Es el marco que les da contexto y los conecta. TDD sin especificación testea lo que el desarrollador cree correcto. BDD sin especificación describe comportamientos que pueden no ser los que el negocio necesita. CI/CD sin especificación automatiza la ejecución de tests que pueden no cubrir lo importante.

2. **La especificación actúa como interfaz entre fases.** Cada fase produce o consume especificaciones. Cuando esa interfaz no existe, las fases se desacoplan y cada una opera con su propia versión de la realidad.

3. **Los puntos de riesgo se concentran en las transiciones entre fases.** Es en los "handoffs" (de análisis a diseño, de diseño a implementación, de implementación a testing, de testing a despliegue) donde la ausencia de especificación genera los mayores problemas. SDD mitiga estos riesgos haciendo que cada transición se apoye en un artefacto explícito y verificable.

4. **La especificación es el artefacto que permite escalar.** Un equipo de tres personas puede funcionar con comunicación verbal. Un equipo de treinta, o tres equipos distribuidos, no. La especificación escala la comunicación sin multiplicar las reuniones.

## Resumen del tema

Spec Driven Development es un enfoque que coloca la especificación en el centro del proceso de desarrollo. No se trata de documentar por documentar, sino de utilizar la especificación como herramienta de diseño, comunicación, validación y mantenimiento.

Los puntos clave de este tema son:

- SDD resuelve problemas reales de comunicación, calidad y trazabilidad que aparecen cuando no hay una fuente de verdad compartida.
- Los principios de SDD (fuente de verdad, especificar es diseñar, verificabilidad, evolución, accesibilidad) guían la forma de trabajar del equipo.
- SDD no compite con TDD, BDD ni con los marcos ágiles: los complementa proporcionando el "qué" que esos enfoques necesitan para funcionar bien.
- La especificación es un artefacto vivo que se gestiona con el mismo rigor que el código.
- SDD es aplicable en contextos muy diversos, desde equipos pequeños hasta organizaciones grandes, y cobra especial relevancia en entornos regulados y en el desarrollo asistido por IA.

En el siguiente tema profundizaremos en los tipos de especificaciones, su estructura y los criterios de calidad que las hacen realmente útiles.