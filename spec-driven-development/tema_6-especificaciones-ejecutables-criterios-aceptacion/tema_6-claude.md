# Tema 6. Especificaciones ejecutables y criterios de aceptación

## 6.1. Introducción

En los temas anteriores hemos construido un arsenal de
artefactos: especificaciones funcionales, casos de uso con
flujos detallados, contratos de API, reglas de dominio con
invariantes. Todos ellos describen qué debe hacer el sistema.
Pero queda una pregunta esencial: **¿cómo sabemos que lo que
se ha construido cumple realmente lo que se especificó?**

La respuesta en SDD no es "lo revisamos al final" ni
"confiamos en que el desarrollador lo hizo bien". La respuesta
es que las especificaciones deben ser **verificables por
diseño**: cada elemento especificado debe poder comprobarse
de forma objetiva, idealmente automatizada.

Este tema cierra el puente entre la especificación y la
validación. Se centra en tres conceptos interconectados:

- **Criterios de aceptación**: las condiciones concretas
  que determinan si una funcionalidad está "hecha".
- **Ejemplos verificables**: instancias concretas con datos
  reales que ilustran el comportamiento esperado y sirven
  como base directa para tests.
- **Especificaciones ejecutables**: artefactos que son
  simultáneamente documentación y tests, eliminando la
  brecha entre lo que se documenta y lo que se valida.

El objetivo último es que la especificación y la validación
sean **el mismo artefacto**, o al menos estén tan conectados
que sea imposible que uno se desactualice sin que el otro lo
detecte.

---

## 6.2. Criterios de aceptación

### 6.2.1. Qué es un criterio de aceptación

Un criterio de aceptación es una **condición verificable**
que debe cumplirse para que una funcionalidad se considere
completa y correcta. No es una descripción del comportamiento
(eso lo hace el caso de uso), sino un **juicio binario**:
se cumple o no se cumple.

La diferencia entre una especificación funcional y un criterio
de aceptación es la misma que entre "el sistema permite
cancelar pedidos" y "dado un pedido en estado confirmado,
cuando el cliente pulsa cancelar y confirma, entonces el
pedido pasa a estado cancelado y el stock se restaura". La
primera describe; la segunda verifica.

### 6.2.2. Características de un buen criterio de aceptación

**Verificable**: se puede comprobar de forma objetiva, sin
juicio subjetivo. "La interfaz es atractiva" no es verificable.
"El formulario muestra un mensaje de error bajo cada campo
inválido" sí lo es.

**Independiente**: cada criterio se puede verificar sin
depender de que otros criterios se hayan verificado antes
(salvo precondiciones explícitas).

**Concreto**: usa datos específicos, no abstracciones. "El
descuento se aplica correctamente" es abstracto. "120
unidades a 0,50 €/ud con descuento del 5% resultan en un
total de 57,60 €" es concreto.

**Completo**: cubre el flujo principal, los flujos alternativos
y las excepciones. Un conjunto de criterios que solo valida
el camino feliz es incompleto.

**Negociable en detalle, no en intención**: el stakeholder y
el equipo pueden ajustar los detalles de cómo se verifica
un criterio, pero la intención (qué se está verificando) es
fija.

### 6.2.3. Quién escribe los criterios de aceptación

Los criterios de aceptación no son responsabilidad exclusiva
de ningún perfil. Son el resultado de una **colaboración**:

- **Negocio / Product Owner**: define qué resultado espera
  y qué condiciones son importantes desde el punto de vista
  del valor.
- **Desarrollo**: valida que los criterios son técnicamente
  verificables y detecta huecos o ambigüedades.
- **QA**: amplía los criterios con escenarios negativos,
  casos límite y combinaciones que negocio y desarrollo
  suelen pasar por alto.

La práctica de los "Three Amigos" (Tema 3) es el momento
natural para redactar y revisar criterios de aceptación.

### 6.2.4. Errores comunes en criterios de aceptación

**El criterio vago**: "El sistema funciona correctamente."
Esto no dice nada. ¿Qué significa "correctamente"? ¿Bajo qué
condiciones? ¿Con qué datos?

**El criterio técnico**: "El sistema hace un INSERT en la
tabla pedidos con los campos correctos." Esto es una
verificación de implementación, no de comportamiento. Si se
cambia la base de datos, el criterio falla aunque el
comportamiento sea correcto.

**El criterio incompleto**: solo cubre el camino feliz. "El
usuario puede crear un pedido." ¿Y si no hay stock? ¿Y si el
pago falla? ¿Y si el usuario no está autenticado?

**El criterio duplicado**: repite con otras palabras lo que
ya dice la especificación funcional sin añadir verificabilidad.
"El sistema permite buscar documentos" como criterio de
aceptación de una historia cuya descripción es "como usuario
quiero buscar documentos".

**El criterio enciclopédico**: un solo criterio que intenta
verificar todo a la vez. "Dado un cliente con crédito, con
productos en el carrito, con descuento por volumen, con
dirección en Canarias y con flujo de aprobación, cuando
confirma el pedido, entonces..." Esto no es un criterio; son
cinco. Cada combinación significativa merece su propio
criterio.

---

## 6.3. Ejemplos como especificación

### 6.3.1. El poder de los ejemplos concretos

Los seres humanos entienden mejor los conceptos a través de
ejemplos que a través de reglas abstractas. Cuando un analista
dice "se aplica descuento por volumen a pedidos grandes",
cada persona del equipo imagina algo diferente. Cuando dice
"120 unidades de bolígrafo a 0,50 €, descuento 5%, total
57,60 €", todos entienden exactamente lo mismo.

Los ejemplos concretos tienen tres funciones simultáneas:

**Comunicación**: eliminan la ambigüedad. Un ejemplo bien
elegido transmite más que un párrafo de reglas.

**Validación**: cada ejemplo es un caso de prueba listo para
ejecutar. Si el sistema produce un resultado diferente al del
ejemplo, hay un bug (o la especificación está mal).

**Documentación viva**: si los ejemplos se mantienen
actualizados y se ejecutan como tests, son documentación que
no puede quedar obsoleta: si la documentación miente, el test
falla.

### 6.3.2. Cómo elegir buenos ejemplos

No cualquier ejemplo es útil. Un buen conjunto de ejemplos
debe cubrir:

**El caso típico**: el escenario más frecuente, con datos
normales. Es el ejemplo que verifica que el camino feliz
funciona.

**Los límites de los tramos o reglas**: si hay umbrales
(más de 100 unidades, más de 200 €, plazo de 15 días),
se necesitan ejemplos justo por debajo, justo en el límite
y justo por encima.

**Los casos negativos**: qué pasa cuando la operación no
puede completarse (datos inválidos, estado incorrecto,
permisos insuficientes).

**Las combinaciones significativas**: cuando varias reglas
interactúan (descuento por volumen + precio especial +
descuento de fidelidad), se necesitan ejemplos que muestren
cómo se resuelven los conflictos.

**Los valores extremos**: cero, uno, máximo, vacío, nulo.

### 6.3.3. Tablas de ejemplos

Una forma eficaz de presentar múltiples ejemplos de una
misma regla es la **tabla de ejemplos**: cada fila es un
escenario con datos de entrada y resultado esperado.

```text
Regla: Descuento por volumen (DN-030)
Producto: Bolígrafo BIC (precio base: 0,50 €)

  Cantidad   Tramo       Descuento   Precio ud.   Total
  ────────   ─────       ─────────   ──────────   ─────
  30         0-49        0%          0,50 €       15,00 €
  49         0-49        0%          0,50 €       24,50 €
  50         50-99       3%          0,49 €       24,50 €
  99         50-99       3%          0,49 €       48,51 €
  100        100-499     5%          0,48 €       48,00 €
  499        100-499     5%          0,48 €      239,52 €
  500        500+        8%          0,46 €      230,00 €
  1          0-49        0%          0,50 €        0,50 €
```

Esta tabla es simultáneamente:

- Documentación de la regla (legible por negocio).
- Conjunto de tests (ejecutable por QA/desarrollo).
- Verificación de casos límite (fronteras 49/50,
  99/100, 499/500).

---

## 6.4. Formato Dado-Cuando-Entonces

### 6.4.1. Estructura del formato

El formato Dado-Cuando-Entonces (*Given-When-Then*),
popularizado por BDD, es la notación más extendida para
expresar criterios de aceptación y escenarios verificables:

```text
Dado [contexto: estado inicial del sistema]
Cuando [acción: lo que hace el actor]
Entonces [resultado: lo que se observa]
```

Cada parte tiene un propósito claro:

- **Dado**: establece las precondiciones. Define el estado
  del sistema antes de la acción. Incluye datos concretos.
- **Cuando**: describe la acción que desencadena el
  comportamiento. Es una única acción (si hay dos acciones,
  son dos escenarios).
- **Entonces**: describe el resultado observable. Es lo que
  se verifica. Puede incluir múltiples aserciones.

### 6.4.2. Ejemplo detallado

```text
Escenario: Cancelación de pedido dentro del plazo

  Dado un cliente autenticado con email
    "cliente@empresa.com"
    y un pedido PED-2025-00042 en estado "confirmado"
      con 2 líneas:
      - Bolígrafo BIC x50 (subtotal: 25,00 €)
      - Carpeta A4 x10 (subtotal: 15,00 €)
    y el pedido fue confirmado hace 1 hora

  Cuando el cliente accede al detalle del pedido
    y pulsa "Cancelar pedido"
    y confirma la cancelación

  Entonces el pedido PED-2025-00042 pasa a estado
      "cancelado"
    y el stock de Bolígrafo BIC se incrementa en 50
    y el stock de Carpeta A4 se incrementa en 10
    y se inicia la devolución del cobro de 40,00 €
    y el cliente recibe un correo de confirmación
      de cancelación en "cliente@empresa.com"
    y el botón "Cancelar pedido" ya no aparece
      en el detalle del pedido
```

### 6.4.3. Buenas prácticas del formato

**Un escenario, una acción.** Si el "Cuando" contiene dos
acciones independientes ("el cliente crea un pedido y luego
lo cancela"), son dos escenarios. La excepción es cuando
las acciones son pasos de un mismo flujo ("accede al
checkout y confirma el pedido").

**Datos concretos, no genéricos.** "Dado un cliente con un
pedido" es genérico. "Dado un cliente con pedido
PED-2025-00042 en estado confirmado con 50 bolígrafos a
0,50 €" es concreto. Los datos concretos eliminan la
ambigüedad y facilitan la reproducción del test.

**Resultado observable, no interno.** "Entonces el sistema
inserta un registro en la base de datos" no es observable
por el usuario. "Entonces el pedido aparece en el historial
con estado cancelado" sí lo es.

**Incluir los efectos secundarios.** La cancelación de un
pedido no solo cambia el estado; también restaura stock,
inicia devolución y envía correo. Todos estos efectos son
parte del resultado verificable.

**Nombrar los escenarios de forma descriptiva.** "Escenario
1" no dice nada. "Cancelación de pedido dentro del plazo"
permite identificar qué se está verificando sin leer los
detalles.

### 6.4.4. Cuándo no usar Dado-Cuando-Entonces

El formato GWT es excelente para comportamiento funcional
con flujos claros. No es el mejor formato para todo:

- **Requisitos no funcionales**: "El endpoint responde en
  menos de 300 ms" se expresa mejor como una métrica con
  condiciones de medición que como un escenario GWT.
- **Reglas de cálculo complejas**: una tabla de ejemplos
  (sección 6.3.3) es más clara que diez escenarios GWT
  que solo varían en los números.
- **Restricciones de diseño**: "Toda comunicación se
  realiza sobre HTTPS" es una restricción, no un
  escenario.

La regla práctica es: si el criterio describe una
**interacción** (actor hace algo, sistema responde), GWT
es ideal. Si describe una **propiedad** (algo que siempre
es cierto), una aserción directa o una tabla es mejor.

---

## 6.5. Especificaciones ejecutables

### 6.5.1. Qué es una especificación ejecutable

Una especificación ejecutable es un artefacto que cumple
**dos funciones simultáneamente**: documenta el
comportamiento esperado del sistema y se ejecuta como
test automatizado para verificar que el sistema lo cumple.

La idea es eliminar la brecha clásica entre documentación
y tests:

```text
Enfoque tradicional:
  Documentación ──(se desactualiza)──► Irrelevante
  Tests ──────────(sin contexto)────► Código opaco

Especificaciones ejecutables:
  Especificación = Test
  Si el comportamiento cambia, el test falla.
  Si el test se actualiza, la documentación se
  actualiza.
```

### 6.5.2. Herramientas y formatos

Existen diversas herramientas que soportan especificaciones
ejecutables. Las más relevantes en el ecosistema actual:

**Gherkin / Cucumber**: el formato más extendido. Los
escenarios se escriben en archivos `.feature` usando la
sintaxis Dado-Cuando-Entonces en lenguaje natural. Cada
paso se vincula a una función de código (step definition)
que ejecuta la acción o la verificación. Disponible en
múltiples lenguajes (Java, JavaScript, Python, Ruby, .NET).

```text
Feature: Cancelación de pedido

  Scenario: Cancelación dentro del plazo
    Given un cliente autenticado
    And un pedido "PED-2025-00042" en estado
      "confirmado" creado hace 1 hora
    When el cliente cancela el pedido
    Then el pedido pasa a estado "cancelado"
    And el stock se restaura
    And el cliente recibe email de confirmación
```

**Concordion / FIT**: formatos que usan documentos HTML o
Markdown como especificación, con marcadores que vinculan
fragmentos del texto a código de verificación. La
especificación es un documento legible que se ejecuta como
test.

**Doctest (Python)**: incluye ejemplos ejecutables dentro
de la documentación del código. Más limitado en alcance
pero muy efectivo para reglas de cálculo y funciones puras.

**Contratos ejecutables (Pact, Spring Cloud Contract)**:
los contratos de API (Tema 5) se convierten en tests que
verifican automáticamente que proveedor y consumidor
cumplen el contrato. La especificación del contrato es
el test.

### 6.5.3. Niveles de automatización

No todas las especificaciones necesitan (ni deben) ser
ejecutables. Un enfoque pragmático distingue tres niveles:

**Nivel 1 — Especificación con criterios manuales**:
la especificación define criterios de aceptación claros
que un tester puede ejecutar manualmente. Es el mínimo
aceptable en SDD. Adecuado para funcionalidades de baja
frecuencia de cambio o difíciles de automatizar (flujos
con intervención humana, validaciones visuales).

**Nivel 2 — Especificación con tests automatizados
derivados**: la especificación define criterios, y el
equipo de QA o desarrollo escribe tests automatizados
que verifican esos criterios. Los tests están separados
de la especificación, pero hay trazabilidad entre ellos
(el test referencia el ID del criterio).

**Nivel 3 — Especificación ejecutable**: la especificación
es el test. Gherkin, Concordion o contratos ejecutables.
El mayor nivel de alineación entre documentación y
validación. Adecuado para reglas de negocio críticas,
contratos de API y flujos funcionales de alto valor.

### 6.5.4. Beneficios y costes

**Beneficios**:

- Eliminan la desincronización entre documentación y
  realidad.
- Detectan regresiones automáticamente.
- Facilitan el refactoring con confianza.
- Sirven como documentación para nuevos miembros del equipo.
- Formalizan la comunicación entre negocio, desarrollo y QA.

**Costes**:

- Requieren inversión inicial en infraestructura de tests.
- Los step definitions (en Gherkin) necesitan mantenimiento.
- Si se abusa del nivel de detalle, los tests se vuelven
  frágiles (fallan por cambios de UI, no de comportamiento).
- No sustituyen otros tipos de test (unitarios, de
  rendimiento, de seguridad).

### 6.5.5. Errores al implementar especificaciones ejecutables

**El escenario imperator**: un escenario Gherkin de 40 líneas
que cubre todo el proceso de compra, incluyendo registro,
login, búsqueda, carrito, checkout, pago, confirmación y
recepción de correo. Es inmantenible y falla por cualquier
cambio en cualquier parte del flujo.

**El step definition frágil**: pasos vinculados a elementos
de UI específicos ("When I click the button with id
submit-order"). Si la UI cambia, todos los tests fallan
aunque el comportamiento sea correcto. Los pasos deben
describir intenciones ("When the customer confirms the
order"), no acciones de UI.

**La especificación que nadie lee**: archivos `.feature`
escritos por desarrolladores en lenguaje técnico que negocio
no entiende. Si negocio no puede leer la especificación
ejecutable, se pierde la mitad de su valor.

**La automatización de todo**: no todo merece una
especificación ejecutable. Los flujos triviales, las
validaciones de formato y los CRUD simples se cubren mejor
con tests unitarios o de integración convencionales.

---

## 6.6. Comunicación entre perfiles

### 6.6.1. El problema de los lenguajes diferentes

Uno de los obstáculos más persistentes en el desarrollo de
software es que cada perfil habla un lenguaje diferente:

- Negocio habla de "clientes", "pedidos", "facturación",
  "descuentos".
- Desarrollo habla de "endpoints", "payloads", "queries",
  "migrations".
- QA habla de "casos de prueba", "cobertura", "regresión",
  "smoke test".

Cuando un perfil redacta un artefacto en su propio lenguaje,
los otros lo interpretan con pérdida de información. Los
criterios de aceptación y las especificaciones ejecutables
resuelven este problema creando un **lenguaje compartido**
que todos los perfiles pueden leer, escribir y validar.

### 6.6.2. Lenguaje ubicuo

El concepto de lenguaje ubicuo (*ubiquitous language*),
tomado de Domain-Driven Design, propone que todo el equipo
(negocio, desarrollo, QA, diseño, operaciones) use los
**mismos términos** para referirse a los mismos conceptos,
tanto en la conversación como en el código y la
documentación.

Si el negocio llama "pedido" a lo que desarrollo llama
"order" y QA llama "solicitud de compra", hay tres nombres
para el mismo concepto, y cada traducción introduce riesgo
de malentendido.

En SDD, el lenguaje ubicuo se establece mediante:

- Un **glosario de dominio** que define los términos clave
  (ver Tema 2, especificación de dominio).
- El uso de esos términos en **todos los artefactos**:
  especificaciones, código (nombres de clases, métodos y
  variables), tests, documentación y conversaciones.
- La revisión sistemática de artefactos para detectar
  **términos no alineados**.

### 6.6.3. Prácticas de comunicación

**Example Mapping**: sesión de 25 minutos donde negocio,
desarrollo y QA exploran una historia de usuario usando
cuatro tipos de tarjetas: historia (amarilla), reglas
(azul), ejemplos (verde), preguntas (roja). El resultado
son los criterios de aceptación y los ejemplos verificables
de la historia.

Flujo de una sesión de Example Mapping:

```text
1. Se presenta la historia (tarjeta amarilla).
2. Negocio enuncia la primera regla (tarjeta azul).
3. El equipo genera ejemplos que ilustran la regla
   (tarjetas verdes bajo la azul).
4. Si surge una pregunta que no se puede resolver,
   se apunta (tarjeta roja).
5. Se repite para cada regla.
6. Al final: si hay más rojas que verdes, la
   historia no está lista.
```

**Specification Workshop**: sesión más larga (1-2 horas)
para funcionalidades complejas. Se trabajan los escenarios
en formato GWT, se revisan en grupo, se identifican huecos
y se priorizan. El resultado es un conjunto de escenarios
validados por los tres perfiles.

**Revisión de aceptación anticipada**: antes de dar por
terminada la implementación, el equipo recorre los
criterios de aceptación con el stakeholder usando datos
reales o realistas. No es un "pase de QA" formal; es una
conversación donde se verifica que el resultado coincide
con la expectativa.

---

## 6.7. De la especificación al test: trazabilidad

### 6.7.1. Mapeo entre artefactos

En SDD, cada criterio de aceptación debe poder rastrearse
hasta su origen (la especificación funcional, el caso de
uso o la regla de dominio) y hasta su destino (el test que
lo verifica).

```text
  Necesidad de negocio
      │
      ▼
  Especificación funcional (FUNC-027)
      │
      ▼
  Caso de uso (CU-010)
      │
      ├──► Criterio de aceptación (AC-010-01)
      │        │
      │        ▼
      │    Test automatizado (TAC-010-01)
      │
      ├──► Criterio de aceptación (AC-010-02)
      │        │
      │        ▼
      │    Test manual (TM-010-02)
      │
      └──► Regla de dominio (DN-030)
               │
               ▼
           Tests de regla (T-DN-030-01..06)
```

### 6.7.2. Matriz de trazabilidad ligera

Una tabla simple que conecta especificaciones con criterios
y tests:

```text
  Spec       Criterio     Test         Tipo    Estado
  ────       ────────     ────         ────    ──────
  FUNC-027   AC-027-01    TAC-027-01   Auto    OK
  FUNC-027   AC-027-02    TAC-027-02   Auto    OK
  FUNC-027   AC-027-03    TM-027-03    Manual  Pend.
  CU-010     AC-010-01    TAC-010-01   Auto    OK
  CU-010     AC-010-02    TAC-010-02   Auto    Fallo
  DN-030     AC-030-01    T-DN-030-01  Auto    OK
  DN-030     AC-030-02    T-DN-030-02  Auto    OK
```

Esta matriz responde a preguntas críticas:

- ¿Hay especificaciones sin criterios de aceptación?
  (huecos de verificabilidad)
- ¿Hay criterios sin test asociado? (huecos de cobertura)
- ¿Qué porcentaje de criterios están automatizados?
- ¿Qué criterios están fallando? ¿A qué especificación
  afectan?

---

## 6.8. Resumen del tema

Las especificaciones ejecutables y los criterios de
aceptación son el mecanismo que conecta la especificación
con la validación en SDD.

Puntos clave:

- Los criterios de aceptación son condiciones verificables
  y binarias que determinan si una funcionalidad está
  completa. Se escriben colaborativamente entre negocio,
  desarrollo y QA.
- Los ejemplos concretos son la forma más eficaz de
  comunicar reglas de negocio, eliminar ambigüedades y
  generar tests. Las tablas de ejemplos cubren casos
  típicos, límites y combinaciones.
- El formato Dado-Cuando-Entonces es ideal para
  interacciones actor-sistema. Las tablas de ejemplos
  y las aserciones directas son mejores para reglas de
  cálculo y propiedades.
- Las especificaciones ejecutables (Gherkin, Concordion,
  contratos ejecutables) eliminan la brecha entre
  documentación y tests, pero requieren inversión y
  disciplina.
- El lenguaje ubicuo, el Example Mapping y las revisiones
  de aceptación anticipada son prácticas que mejoran la
  comunicación entre perfiles.
- La trazabilidad entre especificación, criterio de
  aceptación y test es lo que convierte estos artefactos
  en un sistema coherente en lugar de documentos aislados.

---

## Laboratorios del Tema 6

### Laboratorio 6.1: Redacción de criterios de aceptación para historias funcionales

#### Enunciado del laboratorio 6.1

**Objetivo**: redactar criterios de aceptación completos
para historias de usuario reales del proyecto B2B,
aplicando las buenas prácticas del tema.

**Contexto**: el equipo tiene las siguientes historias
de usuario pendientes de refinamiento para el próximo
sprint del proyecto de tienda online B2B. Cada historia
necesita criterios de aceptación claros antes de entrar
en implementación.

**Historias a trabajar**:

```text
Historia 1 (HU-045):
  Como cliente B2B autenticado
  quiero repetir un pedido anterior
  para no tener que buscar y añadir los mismos
  productos uno a uno.

Historia 2 (HU-052):
  Como gestor comercial
  quiero ver un resumen de devoluciones pendientes
  para priorizar cuáles revisar primero.

Historia 3 (HU-061):
  Como administrador del sistema
  quiero configurar los tramos de descuento por
  volumen por familia de producto
  para adaptar la política comercial sin intervención
  de desarrollo.
```

**Instrucciones**:

1. Para cada historia, redacta al menos 5 criterios de
   aceptación en formato Dado-Cuando-Entonces.
2. Incluye al menos un criterio para el camino feliz,
   uno para un flujo alternativo y uno para un caso de
   error.
3. Añade al menos un criterio con datos concretos
   (tabla de ejemplos o valores específicos).
4. Indica para cada criterio si es candidato a
   automatización (nivel 2 o 3) o si requiere
   verificación manual.

#### Solución del laboratorio 6.1

##### Historia 1: Repetir pedido anterior (HU-045)

```text
AC-045-01: Repetir pedido completo con stock disponible
Tipo: Automatizable (nivel 3, Gherkin)

  Dado un cliente autenticado con un pedido anterior
    PED-2025-00030 en estado "entregado" que contenía:
      - Bolígrafo BIC x50 (stock actual: 200)
      - Carpeta A4 x20 (stock actual: 100)
      - Grapadora x5 (stock actual: 30)
  Cuando el cliente accede al historial de pedidos
    y pulsa "Repetir pedido" en PED-2025-00030
  Entonces se crea un nuevo carrito con los mismos 3
    productos y las mismas cantidades
    y los precios corresponden a los precios vigentes
    actuales (no a los del pedido original)
    y el cliente es redirigido a la pantalla del carrito
    y puede modificar cantidades antes de confirmar.

AC-045-02: Repetir pedido con producto sin stock
Tipo: Automatizable (nivel 3)

  Dado un pedido anterior con 3 líneas:
      - Bolígrafo BIC x50 (stock actual: 200)
      - Carpeta A4 x20 (stock actual: 0)
      - Grapadora x5 (stock actual: 30)
  Cuando el cliente pulsa "Repetir pedido"
  Entonces se crea el carrito con Bolígrafo y Grapadora
    y Carpeta A4 NO se incluye en el carrito
    y se muestra un aviso: "El producto Carpeta A4
    no está disponible actualmente y se ha excluido
    del pedido."

AC-045-03: Repetir pedido con producto descatalogado
Tipo: Automatizable (nivel 3)

  Dado un pedido anterior que contenía un producto
    que ya no existe en el catálogo
  Cuando el cliente pulsa "Repetir pedido"
  Entonces el producto descatalogado se excluye
    y se muestra: "[Producto] ya no está disponible
    en el catálogo y se ha excluido del pedido."

AC-045-04: Repetir pedido con precios actualizados
Tipo: Automatizable (nivel 3)

  Dado un pedido anterior donde el Bolígrafo BIC
    costaba 0,45 € y ahora cuesta 0,50 €
  Cuando el cliente pulsa "Repetir pedido"
  Entonces el carrito muestra el precio actual
    (0,50 €) para el Bolígrafo BIC
    y NO muestra el precio del pedido original.

AC-045-05: Repetir pedido cuando todos los productos
están sin stock
Tipo: Automatizable (nivel 3)

  Dado un pedido anterior donde todos los productos
    tienen stock 0
  Cuando el cliente pulsa "Repetir pedido"
  Entonces NO se crea carrito
    y se muestra: "Ninguno de los productos de este
    pedido está disponible actualmente."

AC-045-06: Botón "Repetir pedido" solo en pedidos
entregados
Tipo: Automatizable (nivel 2)

  Dado un pedido en estado "en_preparacion"
  Cuando el cliente ve el detalle del pedido
  Entonces el botón "Repetir pedido" NO aparece.

  Dado un pedido en estado "entregado"
  Cuando el cliente ve el detalle del pedido
  Entonces el botón "Repetir pedido" SÍ aparece.

AC-045-07: Descuentos se recalculan con las nuevas
condiciones
Tipo: Automatizable (nivel 3)

  Dado un pedido anterior con 120 ud. de Bolígrafo BIC
    (descuento volumen 5% aplicado en aquel momento)
    y actualmente los tramos de descuento han cambiado
    (el 5% ahora empieza en 150 ud.)
  Cuando el cliente pulsa "Repetir pedido"
  Entonces el carrito aplica el tramo actual
    (120 ud. = 3%, no 5%)
    y el precio unitario refleja el nuevo descuento.
```

##### Historia 2: Resumen de devoluciones pendientes (HU-052)

```text
AC-052-01: Panel con devoluciones pendientes
Tipo: Automatizable (nivel 2)

  Dado un gestor comercial autenticado
    y existen 12 solicitudes de devolución en estado
    "pendiente_revision" asignadas a este gestor
  Cuando el gestor accede a "Devoluciones pendientes"
  Entonces se muestra una lista con las 12 solicitudes
    ordenadas por antigüedad descendente (la más
    antigua primero)
    y cada elemento muestra: referencia, cliente,
    fecha de solicitud, número de productos, importe
    estimado y días transcurridos.

AC-052-02: Indicador de urgencia por antigüedad
Tipo: Automatizable (nivel 2)

  Tabla de ejemplos:
    Días desde solicitud   Indicador visual
    ────────────────────   ────────────────
    0-2                    Normal (sin marca)
    3-5                    Amarillo (atención)
    6+                     Rojo (urgente)

  Dado solicitudes con 1, 4 y 8 días de antigüedad
  Cuando el gestor ve el panel
  Entonces la de 1 día aparece sin marca
    y la de 4 días aparece con indicador amarillo
    y la de 8 días aparece con indicador rojo.

AC-052-03: Filtro por estado
Tipo: Automatizable (nivel 2)

  Dado solicitudes en estados "pendiente_revision"
    e "info_solicitada" asignadas al gestor
  Cuando el gestor filtra por "info_solicitada"
  Entonces solo se muestran las solicitudes en ese
    estado
    y el contador se actualiza al total filtrado.

AC-052-04: Sin devoluciones pendientes
Tipo: Automatizable (nivel 2)

  Dado un gestor sin solicitudes asignadas
  Cuando accede a "Devoluciones pendientes"
  Entonces se muestra: "No tienes devoluciones
    pendientes de revisión."

AC-052-05: Acceso directo al detalle
Tipo: Automatizable (nivel 2)

  Dado una solicitud DEV-2025-00015 en la lista
  Cuando el gestor pulsa sobre la solicitud
  Entonces se abre la pantalla de detalle de
    DEV-2025-00015 con toda la información y las
    opciones de resolución (aprobar, rechazar,
    solicitar info).

AC-052-06: Solo devoluciones del propio gestor
Tipo: Automatizable (nivel 3)

  Dado un gestor "Ana" con 5 solicitudes asignadas
    y un gestor "Carlos" con 8 solicitudes asignadas
  Cuando Ana accede al panel
  Entonces ve solo sus 5 solicitudes
    y NO ve las 8 de Carlos.
```

##### Historia 3: Configurar tramos de descuento (HU-061)

```text
AC-061-01: Crear tramos para una familia de producto
Tipo: Automatizable (nivel 2)

  Dado un administrador autenticado
    y la familia "Escritura" no tiene tramos
    de descuento configurados
  Cuando el admin accede a Configuración > Descuentos
    > Familia "Escritura"
    y define los tramos:
      - 50-99 ud: 3%
      - 100-499 ud: 5%
      - 500+ ud: 8%
    y guarda los cambios
  Entonces los tramos quedan registrados para la
    familia "Escritura"
    y los pedidos futuros de productos de esa familia
    aplican los nuevos tramos.

AC-061-02: Validación de tramos solapados
Tipo: Automatizable (nivel 2)

  Dado un administrador configurando tramos para
    la familia "Papelería"
  Cuando intenta crear un tramo "80-120 ud: 4%"
    y ya existe un tramo "50-99 ud: 3%"
  Entonces el sistema muestra: "El tramo 80-120
    se solapa con el tramo existente 50-99."
    y no guarda el nuevo tramo.

AC-061-03: Validación de porcentaje fuera de rango
Tipo: Automatizable (nivel 2)

  Tabla de ejemplos:
    Porcentaje   Resultado
    ──────────   ─────────
    0            Error: mínimo 0,1%
    0,1          Aceptado
    50           Aceptado
    100          Error: máximo 99%
    -5           Error: debe ser positivo

AC-061-04: Modificar tramos existentes
Tipo: Automatizable (nivel 2)

  Dado la familia "Escritura" con tramos configurados:
      - 50-99 ud: 3%
      - 100-499 ud: 5%
  Cuando el admin cambia el tramo 50-99 a 4%
    y guarda
  Entonces el tramo actualizado muestra 4%
    y los pedidos futuros aplican el 4%.

AC-061-05: Eliminar todos los tramos de una familia
Tipo: Automatizable (nivel 2)

  Dado la familia "Escritura" con 3 tramos configurados
  Cuando el admin elimina todos los tramos y guarda
  Entonces la familia "Escritura" no tiene tramos
    propios
    y los pedidos de esa familia usan los tramos por
    defecto (familia genérica).

AC-061-06: Historial de cambios en tramos
Tipo: Verificación manual (nivel 1)

  Dado que el admin modifica los tramos de "Escritura"
  Cuando se guardan los cambios
  Entonces queda registrado en el log de auditoría:
    quién cambió, cuándo, valores anteriores y nuevos.

AC-061-07: Solo administradores pueden configurar
Tipo: Automatizable (nivel 2)

  Dado un usuario con rol "gestor_comercial"
  Cuando intenta acceder a Configuración > Descuentos
  Entonces el sistema muestra "No tienes permisos"
    o la opción no aparece en el menú.
```

---

### Laboratorio 6.2: Conversión de ejemplos de negocio en escenarios verificables

#### Enunciado del laboratorio 6.2

**Objetivo**: tomar ejemplos informales proporcionados por
el equipo de negocio y convertirlos en escenarios
verificables formales, identificando los huecos y las
ambigüedades que los ejemplos informales no cubren.

**Contexto**: la directora comercial del proyecto B2B ha
enviado un correo al equipo con los siguientes ejemplos
de cómo debería funcionar el cálculo de totales de un
pedido. Los ejemplos son reales pero informales.

**Correo de la directora comercial**:

```text
Hola equipo,

Os pongo unos ejemplos de cómo deberían calcularse
los pedidos para que os hagáis una idea:

1) Cliente Papelería López (tiene precio especial
   en bolígrafos: 0,42 €). Pide 200 bolígrafos BIC.
   Como tiene precio especial y además le tocaría
   descuento por volumen (5% de 0,50 = 0,475 → 0,48),
   se le aplica el mejor: 0,42 €. Total: 84,00 €.

2) Cliente Oficinas del Sur (sin precio especial).
   Pide 60 bolígrafos BIC. Le toca 3% de descuento
   por volumen. 0,50 × 0,97 = 0,485 → 0,49.
   Total: 29,40 €.

3) Cliente Distribuciones Norte (compra acumulada
   12 meses: 52.000 €, tramo fidelidad 3%). Pide
   80 carpetas A4 a 1,20 €. No le llega para
   descuento por volumen en carpetas. Subtotal:
   96,00 €. Descuento fidelidad 3%: 2,88 €.
   Total antes de envío: 93,12 €. Envío a
   Península, 3 kg: 4,50 €. Total final: 97,62 €.

4) Mismo cliente Distribuciones Norte. Pide 200
   bolígrafos (descuento volumen 5%, precio 0,48 €)
   + 80 carpetas A4 (sin descuento volumen, 1,20 €).
   Subtotal: 96,00 + 96,00 = 192,00 €. Fidelidad
   3%: 5,76 €. Total antes envío: 186,24 €.
   Envío... hmm, como no llega a 200 €, no es
   gratuito. Destino Península, 8 kg: 7,90 €.
   Total final: 194,14 €. ¿O el envío gratuito
   se mira antes del descuento de fidelidad?
   Creo que sí, pero confirmadme.

Espero que os sirva. Si tenéis dudas, me decís.

Laura
```

**Instrucciones**:

1. Analiza cada ejemplo e identifica los problemas:
   errores de cálculo, ambigüedades, huecos, preguntas
   sin resolver.
2. Convierte cada ejemplo en un escenario verificable
   formal (formato GWT) con todos los datos explícitos.
3. Identifica al menos 4 escenarios adicionales que
   Laura no ha cubierto pero que son necesarios.
4. Responde a la pregunta que Laura plantea en el
   ejemplo 4 y justifica la decisión.

#### Solución del laboratorio 6.2

##### Análisis de los ejemplos

##### Ejemplo 1 de Laura: Papelería López

Verificación del cálculo:

```text
Precio base: 0,50 €
Precio especial: 0,42 €
Cantidad: 200 ud. → tramo 100-499 → descuento 5%
Precio con descuento volumen: 0,50 × 0,95 = 0,475
  → redondeado: 0,48 €
Se compara: min(0,42 , 0,48) = 0,42 € (especial)
Total: 200 × 0,42 = 84,00 € ✓
```

El cálculo es correcto. Observaciones: Laura calcula
correctamente el redondeo de 0,475 a 0,48 y la
comparación entre descuentos. Falta indicar si se
aplica descuento de fidelidad (depende de la compra
acumulada de este cliente) y los gastos de envío.

##### Ejemplo 2 de Laura: Oficinas del Sur

Verificación del cálculo:

```text
Precio base: 0,50 €
Cantidad: 60 ud. → tramo 50-99 → descuento 3%
Precio con descuento: 0,50 × 0,97 = 0,485
  → redondeado: 0,49 €
Total: 60 × 0,49 = 29,40 € ✓
```

Correcto. Falta información sobre fidelidad y envío.
Al ser un ejemplo parcial, no podemos verificar el
total final del pedido.

##### Ejemplo 3 de Laura: Distribuciones Norte

Verificación del cálculo:

```text
Precio carpeta A4: 1,20 €
Cantidad: 80 ud. → tramo 50-99 → descuento 3%
  Espera: ¿realmente no le llega para descuento
  por volumen? 80 unidades SÍ están en el tramo
  50-99 (3%). Laura dice "no le llega" pero según
  la regla DN-030, 80 ud. corresponden al tramo
  50-99 con 3% de descuento.

  ERROR DETECTADO: Laura ha omitido el descuento
  por volumen de las carpetas.

Cálculo correcto:
  Precio carpeta con vol.: 1,20 × 0,97 = 1,164
    → redondeado: 1,16 €
  Subtotal: 80 × 1,16 = 92,80 € (no 96,00 €)
  Fidelidad 3%: 92,80 × 0,03 = 2,784
    → redondeado: 2,78 €
  Total antes envío: 92,80 - 2,78 = 90,02 €
  ¿Envío gratuito? Subtotal antes de fidelidad
    (92,80 €) < 200 € → NO gratuito.
  Envío Península 3 kg: 4,50 €
  Total final: 90,02 + 4,50 = 94,52 €
```

##### Ejemplo 4 de Laura: Distribuciones Norte combinado

Verificación del cálculo:

```text
Bolígrafo BIC: 200 ud. × 0,48 € (vol. 5%) = 96,00 €
Carpeta A4: 80 ud. → tramo 50-99 → 3% descuento
  Precio: 1,20 × 0,97 = 1,164 → 1,16 €
  Subtotal carpetas: 80 × 1,16 = 92,80 €

  ERROR: Laura calcula 80 × 1,20 = 96,00 €
  (mismo error: omite descuento volumen carpetas)

Cálculo correcto:
  Subtotal: 96,00 + 92,80 = 188,80 €
  Fidelidad 3%: 188,80 × 0,03 = 5,664
    → redondeado: 5,66 €
  Total antes envío: 188,80 - 5,66 = 183,14 €

Respecto a la pregunta de Laura sobre el envío
gratuito: según DN-045, el umbral de 200 € se
evalúa sobre el subtotal ANTES del descuento
de fidelidad. Subtotal = 188,80 € < 200 €
→ NO tiene envío gratuito.

  Envío Península 8 kg: 7,90 €
  Total final: 183,14 + 7,90 = 191,04 €
```

**Respuesta a la pregunta de Laura**:

Sí, el envío gratuito se evalúa sobre el subtotal
antes del descuento de fidelidad. La razón es que el
descuento de fidelidad es un beneficio adicional que
no debería penalizar al cliente quitándole el envío
gratuito. Si el subtotal antes de fidelidad supera
200 €, el envío es gratuito aunque el descuento de
fidelidad reduzca el total por debajo de 200 €. Esta
decisión está documentada en DN-045 y DN-055.

##### Escenarios verificables formales

```text
Escenario 1: Precio especial más favorable que volumen
(basado en ejemplo 1 de Laura)

  Dado un cliente "Papelería López" autenticado
    con precio especial para Bolígrafo BIC: 0,42 €
    y compra acumulada 12 meses: 3.800 €
      (tramo fidelidad: 0%)
    y el precio base del Bolígrafo BIC es 0,50 €
  Cuando añade 200 ud. de Bolígrafo BIC al carrito
    y procede al checkout
  Entonces el precio unitario aplicado es 0,42 €
    (precio especial, más favorable que 0,48 €
    por volumen)
    y el subtotal es 84,00 €
    y el descuento de fidelidad es 0,00 € (tramo 0%)
    y el carrito muestra "Precio especial" junto al
    producto.

Escenario 2: Solo descuento por volumen, sin especial
(basado en ejemplo 2 de Laura)

  Dado un cliente "Oficinas del Sur" autenticado
    sin precio especial para Bolígrafo BIC
    y compra acumulada 12 meses: 1.200 €
      (tramo fidelidad: 0%)
    y el precio base del Bolígrafo BIC es 0,50 €
  Cuando añade 60 ud. de Bolígrafo BIC al carrito
  Entonces el precio unitario es 0,49 €
    (descuento volumen 3%)
    y el subtotal es 29,40 €
    y el carrito muestra "Descuento volumen: -3%".

Escenario 3: Volumen + fidelidad + envío
(corrección del ejemplo 3 de Laura)

  Dado un cliente "Distribuciones Norte" autenticado
    sin precio especial para Carpeta A4
    y compra acumulada 12 meses: 52.000 €
      (tramo fidelidad: 3%)
    y precio base Carpeta A4: 1,20 €
    y dirección de envío: Península
    y peso total estimado: 3 kg
  Cuando añade 80 ud. de Carpeta A4 al carrito
    y procede al checkout
  Entonces el precio unitario carpeta es 1,16 €
    (descuento volumen 3%: tramo 50-99)
    y el subtotal es 92,80 €
    y el descuento fidelidad es 2,78 € (3%)
    y el subtotal con fidelidad es 90,02 €
    y el envío NO es gratuito (92,80 < 200 €)
    y los gastos de envío son 4,50 € (Península,
    hasta 5 kg)
    y el total final es 94,52 €.

Escenario 4: Pedido combinado con fidelidad y envío
no gratuito
(corrección del ejemplo 4 de Laura)

  Dado un cliente "Distribuciones Norte" autenticado
    sin precios especiales
    y compra acumulada 12 meses: 52.000 €
      (tramo fidelidad: 3%)
    y precio base Bolígrafo BIC: 0,50 €
    y precio base Carpeta A4: 1,20 €
    y dirección de envío: Península
    y peso total estimado: 8 kg
  Cuando añade 200 ud. Bolígrafo BIC
    y 80 ud. Carpeta A4 al carrito
    y procede al checkout
  Entonces el desglose es:
    - Bolígrafo: 200 × 0,48 € (vol. 5%) = 96,00 €
    - Carpeta: 80 × 1,16 € (vol. 3%) = 92,80 €
    - Subtotal: 188,80 €
    - Fidelidad 3%: -5,66 €
    - Subtotal con fidelidad: 183,14 €
    - Envío gratuito: NO (188,80 < 200)
    - Gastos envío (Península, 5-20 kg): 7,90 €
    - Total final: 191,04 €
```

##### Escenarios adicionales no cubiertos por Laura

```text
Escenario 5: Subtotal justo en el umbral de envío
gratuito

  Dado un cliente con fidelidad 3%
    y un pedido con subtotal exactamente 200,00 €
    y dirección Península, 4 kg
  Cuando procede al checkout
  Entonces el envío NO es gratuito
    (la condición es estrictamente mayor: > 200)
    y los gastos de envío son 4,50 €
    y el descuento fidelidad es 6,00 €
    y el total es 200,00 - 6,00 + 4,50 = 198,50 €.

Escenario 6: Subtotal supera 200 € antes de fidelidad
pero no después

  Dado un cliente con fidelidad 3%
    y un pedido con subtotal 210,00 €
    y dirección Canarias, 2 kg
  Cuando procede al checkout
  Entonces el envío SÍ es gratuito (210 > 200,
    evaluado antes de fidelidad)
    y el descuento fidelidad es 6,30 €
    y el total es 210,00 - 6,30 + 0,00 = 203,70 €.

Escenario 7: Cliente sin fidelidad, sin descuento
volumen, sin precio especial

  Dado un cliente nuevo (compra acumulada: 0 €)
    sin precios especiales
    y precio base Grapadora: 8,50 €
    y dirección Baleares, 6 kg
  Cuando añade 3 grapadoras al carrito
  Entonces el precio unitario es 8,50 € (sin
    descuento: 3 ud. < 50)
    y el subtotal es 25,50 €
    y el descuento fidelidad es 0,00 €
    y el envío NO es gratuito (25,50 < 200)
    y los gastos envío son 11,50 € (Baleares,
    5-20 kg)
    y el total final es 37,00 €.

Escenario 8: Conflicto volumen vs especial donde
volumen gana

  Dado un cliente con precio especial para Bolígrafo
    BIC: 0,49 €
    y precio base: 0,50 €
  Cuando añade 500 ud. (tramo 500+, descuento 8%)
  Entonces precio con volumen: 0,50 × 0,92 = 0,46 €
    y precio especial: 0,49 €
    y se aplica 0,46 € (volumen más favorable)
    y el carrito muestra "Descuento volumen: -8%"
    y NO muestra "Precio especial".
```

---

### Laboratorio 6.3: Revisión de aceptación de una funcionalidad con base en especificación

#### Enunciado del laboratorio 6.3

**Objetivo**: simular una revisión de aceptación completa
de una funcionalidad ya implementada, verificando cada
criterio de aceptación contra el resultado real, documentando
las discrepancias y tomando la decisión de aceptar, aceptar
con observaciones o rechazar.

**Contexto**: el equipo de desarrollo ha completado la
implementación de la funcionalidad "Cancelación de pedido
por el cliente" (FUNC-027, CU-010 FE). QA ha ejecutado los
tests y ha documentado los resultados. El Product Owner debe
decidir si acepta la funcionalidad.

Se proporcionan los criterios de aceptación originales y
los resultados observados por QA.

**Criterios de aceptación de FUNC-027**:

```text
AC-027-01: Cancelación exitosa de pedido confirmado
  Dado pedido en estado "confirmado", creado hace
    1 hora
  Cuando el cliente cancela y confirma
  Entonces estado = "cancelado", stock restaurado,
    devolución iniciada, correo enviado.

AC-027-02: Cancelación de pedido en preparación
  Dado pedido en estado "en_preparacion", creado
    hace 1 hora
  Cuando el cliente cancela
  Entonces mismo resultado que AC-027-01.

AC-027-03: Intento de cancelar pedido enviado
  Dado pedido en estado "enviado"
  Cuando el cliente ve el detalle
  Entonces el botón "Cancelar" no aparece.

AC-027-04: Intento de cancelar fuera de plazo
  Dado pedido confirmado hace 3 horas
  Cuando el cliente ve el detalle
  Entonces el botón "Cancelar" no aparece
    y se muestra "El plazo de cancelación ha
    expirado (2 horas desde la confirmación)."

AC-027-05: Correo de confirmación de cancelación
  Dado cancelación exitosa
  Entonces el cliente recibe correo con referencia
    del pedido, fecha de cancelación e información
    sobre la devolución en menos de 5 minutos.

AC-027-06: Restauración de stock tras cancelación
  Dado pedido con Bolígrafo x50, stock antes: 200
  Cuando se cancela el pedido
  Entonces stock después: 250.

AC-027-07: Cancelación concurrente (condición de
carrera)
  Dado pedido confirmado hace 1 hora
    y el almacén cambia el estado a "enviado"
    en el mismo momento en que el cliente pulsa
    "Cancelar"
  Entonces el sistema detecta el cambio de estado
    y muestra: "Este pedido ya ha sido enviado y
    no puede cancelarse."
    y el pedido permanece en estado "enviado".
```

**Resultados de QA**:

```text
AC-027-01: PASA ✓
  Probado con 3 pedidos. Estado, stock, devolución
  y correo verificados correctamente.

AC-027-02: PASA ✓
  Probado con 2 pedidos en preparación. Funciona
  igual que con confirmado.

AC-027-03: PASA ✓
  Botón no visible para pedidos enviados. Verificado
  con 3 pedidos en distintos momentos.

AC-027-04: FALLA ✗
  El botón SÍ aparece en pedidos con más de 2 horas.
  Al pulsarlo, la cancelación se ejecuta exitosamente.
  No hay validación de plazo en el backend.
  Nota: el mensaje de plazo expirado no se muestra
  en ningún caso.

AC-027-05: PASA CON OBSERVACIÓN ⚠
  El correo se envía y contiene la referencia y la
  fecha. Sin embargo, no incluye información sobre
  la devolución (plazo estimado, importe). El correo
  llega en menos de 2 minutos (dentro del SLA de
  5 minutos).

AC-027-06: PASA ✓
  Stock verificado antes y después de la cancelación
  con 4 productos diferentes. Incremento correcto
  en todos los casos.

AC-027-07: NO PROBADO ⊘
  QA no ha podido reproducir la condición de carrera
  de forma manual. Solicita test automatizado o
  revisión de código para verificar la lógica de
  concurrencia.
```

**Instrucciones**:

1. Analiza cada resultado y clasifícalo en: aceptado,
   aceptado con observaciones, o rechazado.
2. Para los criterios que no pasan, documenta la
   discrepancia y su impacto.
3. Para los criterios no probados, propón cómo
   verificarlos.
4. Toma la decisión global: ¿se acepta la funcionalidad
   para producción? ¿Con condiciones? ¿Se rechaza?
5. Redacta el acta de aceptación con la decisión y los
   compromisos.

#### Solución del laboratorio 6.3

##### Análisis criterio por criterio

**AC-027-01: ACEPTADO** ✓

La funcionalidad central funciona correctamente. Estado,
stock, devolución y correo verificados con múltiples
pedidos. Sin observaciones.

**AC-027-02: ACEPTADO** ✓

Comportamiento coherente con AC-027-01 para pedidos en
preparación. Sin observaciones.

**AC-027-03: ACEPTADO** ✓

Control de visibilidad del botón correcto para pedidos
enviados. Sin observaciones.

**AC-027-04: RECHAZADO** ✗

Discrepancia crítica. La especificación establece un
plazo máximo de 2 horas para cancelar. La implementación
no valida este plazo ni en el frontend (el botón aparece
siempre) ni en el backend (la cancelación se ejecuta
sin verificar el tiempo transcurrido).

Impacto: un cliente podría cancelar un pedido que lleva
horas en preparación, cuando el almacén ya ha invertido
recursos en prepararlo. Esto genera coste operativo y
potencial conflicto con el flujo de almacén.

Gravedad: alta. Es una regla de negocio definida en
DN-008 (política de cancelaciones) que no se ha
implementado.

Acción requerida: implementar la validación de plazo
tanto en frontend (ocultar botón o deshabilitarlo tras
2 horas) como en backend (rechazar la petición con
error 409 si han pasado más de 2 horas). Mostrar el
mensaje de plazo expirado.

**AC-027-05: ACEPTADO CON OBSERVACIÓN** ⚠

El correo se envía dentro del SLA y contiene la
información básica. Sin embargo, falta la información
sobre la devolución (plazo estimado, importe), que la
especificación exige.

Impacto: menor. El cliente recibe confirmación de la
cancelación pero no sabe cuándo recibirá el reembolso.
Puede generar llamadas a atención al cliente.

Gravedad: media-baja. No impide el uso de la
funcionalidad pero degrada la experiencia.

Acción requerida: añadir al correo la información de
devolución. Puede hacerse en un sprint posterior
sin bloquear el despliegue, siempre que se documente
como deuda y se planifique.

**AC-027-06: ACEPTADO** ✓

Restauración de stock verificada con múltiples productos.
Sin observaciones.

**AC-027-07: NO EVALUABLE — PENDIENTE** ⊘

La condición de carrera no se ha podido verificar
manualmente, lo cual es esperable (las condiciones de
carrera son difíciles de reproducir de forma manual).

Impacto potencial: si no se gestiona correctamente, un
cliente podría cancelar un pedido que ya ha sido enviado,
lo que generaría una inconsistencia grave entre el estado
del pedido y la realidad operativa.

Gravedad: alta (si falla) pero probabilidad baja (requiere
coincidencia temporal exacta).

Propuesta de verificación:

```text
Opción A — Test automatizado de concurrencia:
  1. Crear un pedido en estado "confirmado".
  2. Lanzar dos operaciones simultáneas:
     a. Hilo 1: PATCH /pedidos/{id} con
        estado = "enviado" (simula almacén).
     b. Hilo 2: POST /pedidos/{id}/cancelar
        (simula cliente).
  3. Verificar que solo una operación tiene
     éxito y la otra recibe error 409.
  4. Verificar que el estado final es consistente
     (o cancelado o enviado, no un estado
     intermedio).

Opción B — Revisión de código:
  Verificar que la operación de cancelación usa
  un mecanismo de bloqueo optimista (versión del
  registro o lock) que impide la modificación
  concurrente.
```

##### Decisión global

**Decisión: ACEPTACIÓN CONDICIONAL.**

La funcionalidad se acepta para despliegue en el entorno
de staging pero NO para producción hasta que se resuelva
el criterio AC-027-04 (validación de plazo de
cancelación).

Justificación:

```text
Criterios aceptados:      4 de 7 (01, 02, 03, 06)
Aceptados con observación: 1 de 7 (05)
Rechazados:                1 de 7 (04)
No evaluables:             1 de 7 (07)
```

El criterio rechazado (AC-027-04) afecta a una regla de
negocio documentada en DN-008 y su ausencia puede causar
impacto operativo real. No es aceptable desplegarlo sin
esta validación.

##### Acta de aceptación

```text
ACTA DE REVISIÓN DE ACEPTACIÓN

Funcionalidad:   FUNC-027 — Cancelación de pedido
                 por el cliente
Fecha:           2025-04-22
Participantes:   Laura (PO), Carlos (Dev Lead),
                 Ana (QA Lead)

DECISIÓN: ACEPTACIÓN CONDICIONAL

CONDICIONES PARA PRODUCCIÓN:

  Bloquante (debe resolverse antes del despliegue):
  1. [AC-027-04] Implementar validación de plazo
     de 2 horas para cancelación, tanto en frontend
     como en backend. Incluir mensaje de plazo
     expirado. Estimación: 1 día de desarrollo +
     0,5 días de QA.

  No bloquante (puede resolverse después):
  2. [AC-027-05] Añadir información de devolución
     al correo de cancelación. Se planifica para
     el sprint siguiente. Ticket: BUG-412.
  3. [AC-027-07] Implementar test automatizado de
     concurrencia para validar la condición de
     carrera. Se planifica como tarea técnica.
     Ticket: TECH-089.

COMPROMISOS:
  - Dev: corregir AC-027-04 antes del viernes 25/04.
  - QA: re-verificar AC-027-04 el viernes 25/04.
  - PO: si AC-027-04 pasa, aprobar despliegue a
    producción el lunes 28/04.
  - Dev: crear tickets BUG-412 y TECH-089 antes
    del fin del sprint actual.

FIRMA:
  Laura (PO):       Aprueba condicionalmente
  Carlos (Dev Lead): Acepta compromisos
  Ana (QA Lead):     Acepta plan de verificación
```

##### Reflexión sobre el ejercicio

Esta simulación ilustra varios puntos clave del Tema 6:

Los criterios de aceptación claros y verificables hacen
que la revisión sea **objetiva**. No hay discusión sobre
si "funciona bien" o no: cada criterio se cumple o no se
cumple, con evidencia concreta.

La decisión de aceptación no es binaria ("todo o nada").
La aceptación condicional permite avanzar con lo que
funciona mientras se corrige lo que falta, siempre con
compromisos explícitos y fechas.

Los criterios no probados (AC-027-07) no se ignoran. Se
documentan, se propone un método de verificación y se
planifican. Un criterio no verificado es un riesgo
conocido, no un riesgo ignorado.

El acta de aceptación es un artefacto de trazabilidad
que conecta la especificación original (FUNC-027) con
el resultado de la validación y con las acciones
pendientes. Cualquier persona puede consultarla semanas
después para saber qué se aceptó, qué quedó pendiente
y quién se comprometió a resolverlo.
