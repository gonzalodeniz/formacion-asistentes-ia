# Tema 7. Trazabilidad entre especificación, diseño, código y pruebas

## 7.1. Introducción

A lo largo de los temas anteriores hemos construido un
ecosistema de artefactos: especificaciones funcionales, casos
de uso, contratos de API, reglas de dominio, criterios de
aceptación y tests. Cada uno de estos artefactos cumple una
función, pero su valor real solo se materializa cuando están
**conectados entre sí**.

Un criterio de aceptación que no se puede rastrear hasta la
necesidad de negocio que lo originó es un criterio huérfano:
nadie sabe por qué existe ni qué pasa si se elimina. Un
componente de código que no está vinculado a ninguna
especificación es código que nadie sabe si es correcto,
innecesario o incompleto. Un test que no referencia el
requisito que valida es un test que puede eliminarse sin que
nadie detecte la pérdida de cobertura.

La trazabilidad es la disciplina que mantiene estos vínculos
explícitos y actualizados. En SDD, la trazabilidad no es un
ejercicio burocrático de auditoría: es una **herramienta
operativa** que responde a preguntas concretas del día a día:

- Si cambio esta regla de negocio, ¿qué código y qué tests
  se ven afectados?
- Si este test falla, ¿qué requisito está en riesgo?
- ¿Hay requisitos que no tienen ningún test asociado?
- ¿Hay código que no responde a ningún requisito?
- ¿Podemos demostrar que el sistema cumple todos los
  requisitos especificados?

---

## 7.2. Qué es la trazabilidad

### 7.2.1. Definición

La trazabilidad es la capacidad de **seguir el hilo** desde
cualquier artefacto del proyecto hasta sus orígenes y sus
destinos. Es bidireccional:

**Trazabilidad hacia adelante** (*forward traceability*):
desde la necesidad de negocio hasta el test que la valida.
Responde a: "¿se ha implementado y verificado este
requisito?"

**Trazabilidad hacia atrás** (*backward traceability*):
desde un test, un componente o un fragmento de código hasta
la necesidad que lo justifica. Responde a: "¿por qué existe
este artefacto? ¿Qué requisito satisface?"

### 7.2.2. La cadena de trazabilidad en SDD

En un proyecto SDD, la cadena completa tiene este aspecto:

```text
Necesidad de negocio
    │
    ▼
Especificación funcional (FUNC-NNN)
    │
    ├──► Caso de uso (CU-NNN)
    │       │
    │       ├──► Criterio de aceptación (AC-NNN-NN)
    │       │       │
    │       │       └──► Test de aceptación (TAC / TM)
    │       │
    │       └──► Escenario verificable (GWT)
    │
    ├──► Regla de dominio (DN-NNN)
    │       │
    │       ├──► Test de regla (T-DN-NNN-NN)
    │       │
    │       └──► Clase/función de dominio (código)
    │
    ├──► Contrato de API (API-NNN)
    │       │
    │       ├──► Test de contrato (proveedor)
    │       ├──► Test de contrato (consumidor)
    │       │
    │       └──► Controlador/endpoint (código)
    │
    └──► Especificación técnica (TECH-NNN)
            │
            └──► Componente/módulo (código)
```

Cada flecha es un **vínculo de trazabilidad** que debe ser
explícito, mantenido y verificable.

### 7.2.3. Granularidad de la trazabilidad

No todos los proyectos necesitan el mismo nivel de detalle
en su trazabilidad. La granularidad adecuada depende del
contexto:

**Granularidad gruesa**: se traza a nivel de funcionalidad
o épica. "La funcionalidad de cancelación de pedidos está
implementada y tiene tests." Suficiente para proyectos
pequeños o fases iniciales.

**Granularidad media**: se traza a nivel de especificación
y criterio de aceptación. "El criterio AC-027-04 (validación
de plazo) está implementado en el servicio
PedidoService.cancelar() y validado por el test
TAC-027-04." Es el nivel más habitual en equipos que
practican SDD.

**Granularidad fina**: se traza a nivel de regla de negocio
y línea de código. "La regla DN-030 (descuento por volumen)
está implementada en DescuentoCalculator.calcularVolumen()
y validada por los tests T-DN-030-01 a T-DN-030-08." Necesario
en contextos regulados o sistemas críticos.

---

## 7.3. Artefactos de trazabilidad

### 7.3.1. La matriz de trazabilidad

El artefacto más clásico es la **matriz de trazabilidad**
(*traceability matrix*): una tabla que relaciona artefactos
de distintos niveles. Existen varias variantes según los
niveles que se conectan.

Matriz requisito-test (la más básica):

```text
Especificación   Criterio      Test          Estado
──────────────   ────────      ────          ──────
FUNC-027         AC-027-01     TAC-027-01    Auto/OK
FUNC-027         AC-027-02     TAC-027-02    Auto/OK
FUNC-027         AC-027-03     TAC-027-03    Auto/OK
FUNC-027         AC-027-04     TAC-027-04    Auto/Fallo
FUNC-027         AC-027-05     TM-027-05     Manual/OK
FUNC-027         AC-027-06     TAC-027-06    Auto/OK
FUNC-027         AC-027-07     —             Pendiente
```

Matriz requisito-diseño-código-test (completa):

```text
Spec       Componente            Test          Estado
────       ──────────            ────          ──────
FUNC-027   PedidoService         TAC-027-01    OK
DN-030     DescuentoCalculator   T-DN-030-*    OK
DN-040     PedidoStateMachine    T-DN-040-*    OK
API-PED-1  PedidoController      TC-PED-1-*    OK
CU-010     (integración)         TAC-010-*     OK
DN-045     EnvioCalculator       T-DN-045-*    OK
FUNC-120   AprobacionService     TAC-120-*     Parcial
```

### 7.3.2. Identificadores como vínculo

La base de la trazabilidad es el sistema de identificadores
establecido en el Tema 2. Cada artefacto tiene un ID único
y estable que permite referenciarlo sin ambigüedad:

- La especificación FUNC-027 referencia la regla DN-008.
- El caso de uso CU-010 referencia la especificación
  FUNC-027.
- El criterio AC-027-04 referencia el caso de uso CU-010.
- El test TAC-027-04 referencia el criterio AC-027-04.
- El código del servicio incluye un comentario o anotación
  que referencia FUNC-027 y DN-008.

Esta cadena de referencias es lo que permite recorrer la
trazabilidad en ambas direcciones.

### 7.3.3. Trazabilidad en el código

La trazabilidad no solo vive en documentos y matrices.
También puede (y debería) estar presente en el código:

**Comentarios con referencia a especificación**:

```text
// Implementa DN-030: Descuento por volumen
// Ver especificación para tramos y reglas
// de conflicto con precios especiales (DN-035)
public BigDecimal calcularDescuentoVolumen(
    Producto producto, int cantidad) {
    ...
}
```

**Nombres de tests con referencia al criterio**:

```text
@Test
// AC-027-04: Cancelación fuera de plazo
void cancelarPedido_despuesDe2Horas_rechaza() {
    ...
}
```

**Anotaciones o metadatos**:

```text
@Requirement("FUNC-027")
@AcceptanceCriteria("AC-027-04")
@Test
void testCancelacionFueraDePlazo() {
    ...
}
```

**Tags en archivos de especificación ejecutable**:

```text
@FUNC-027 @AC-027-04
Scenario: Cancelación fuera del plazo de 2 horas
  Given ...
```

### 7.3.4. Herramientas para trazabilidad

La trazabilidad se puede mantener con distintos niveles
de sofisticación:

**Nivel manual**: una hoja de cálculo o un documento
Markdown con la matriz. Funciona para proyectos pequeños
pero se desactualiza fácilmente.

**Nivel semi-automático**: los IDs de especificación se
usan como etiquetas en el gestor de tareas (Jira, Azure
DevOps) y en los tests. Se pueden generar informes
cruzando datos de ambas fuentes.

**Nivel automatizado**: herramientas especializadas
(Jama Connect, IBM DOORS, Polarion) que mantienen los
vínculos de forma nativa y generan matrices y reportes
automáticamente. Habitual en sectores regulados.

**Nivel integrado en CI/CD**: los tests etiquetados con
IDs de requisito generan automáticamente un informe de
cobertura de requisitos en cada build. Si un test falla,
el informe indica qué requisito está en riesgo.

---

## 7.4. Detección de desviaciones

### 7.4.1. Tipos de desviaciones

La trazabilidad no solo documenta qué está conectado;
también revela **qué no lo está**. Las desviaciones más
comunes son:

**Requisito sin implementación** (*missing implementation*):
existe una especificación aprobada pero no hay código que
la implemente. Puede ser un olvido, un requisito pospuesto
sin registrar o una funcionalidad que se creía incluida
en otra.

**Requisito sin test** (*missing coverage*): existe una
especificación implementada pero no hay test que la valide.
El requisito puede estar correctamente implementado, pero
no hay forma de verificarlo ni de detectar regresiones.

**Código sin requisito** (*gold plating* o *orphan code*):
existe código que no responde a ningún requisito
especificado. Puede ser una funcionalidad añadida por
iniciativa del desarrollador, código residual de una
funcionalidad eliminada o una dependencia técnica legítima
que debería documentarse como especificación técnica.

**Test sin requisito** (*orphan test*): existe un test que
no está vinculado a ningún criterio de aceptación ni
especificación. Puede ser un test útil (de regresión por
un bug) o un test obsoleto que ya no valida nada relevante.

**Implementación que contradice la especificación**
(*drift*): el código hace algo diferente de lo que dice la
especificación. Puede ser un bug o una decisión tomada
durante la implementación que no se reflejó en la
especificación.

### 7.4.2. Cómo detectar desviaciones

**Revisión de la matriz de trazabilidad**: buscar celdas
vacías. Una fila sin test indica falta de cobertura. Una
columna de código sin fila de especificación indica código
huérfano.

**Revisión cruzada de artefactos**: comparar la lista de
especificaciones aprobadas con la lista de funcionalidades
implementadas. Comparar la lista de criterios de aceptación
con la lista de tests. Las discrepancias son desviaciones.

**Ejecución de tests etiquetados**: si los tests están
etiquetados con IDs de requisito, se puede generar un
informe de qué requisitos tienen todos sus tests pasando,
cuáles tienen tests fallando y cuáles no tienen tests.

**Auditoría de código**: revisar el código buscando
funcionalidades que no aparecen en ninguna especificación.
Los endpoints de API son un buen punto de partida: cada
endpoint debería corresponder a un contrato especificado.

**Comparación spec-vs-comportamiento**: ejecutar los
escenarios de los casos de uso contra el sistema real y
verificar que el comportamiento coincide paso a paso. Las
discrepancias son drift.

### 7.4.3. Gestión de desviaciones

No toda desviación es un problema. La clave es hacerla
visible y tomar una decisión consciente:

**Requisito sin implementar**: si es intencional (pospuesto),
documentar la decisión. Si es un olvido, planificar la
implementación.

**Requisito sin test**: evaluar el riesgo. Los requisitos
críticos necesitan test. Los requisitos de baja criticidad
pueden validarse manualmente. Documentar la decisión en
cualquier caso.

**Código sin requisito**: si es funcionalidad legítima, crear
la especificación retroactivamente. Si es código muerto,
eliminarlo. Si es una dependencia técnica, documentarla como
TECH-NNN.

**Drift**: decidir qué es correcto. Si la implementación es
mejor que la especificación, actualizar la especificación. Si
la especificación es correcta, corregir la implementación.
Nunca dejar ambos en estado contradictorio.

---

## 7.5. Trazabilidad y mantenimiento

### 7.5.1. Análisis de impacto

Cuando un requisito cambia, la trazabilidad permite
responder a: "¿qué más hay que cambiar?"

```text
Cambio solicitado:
  DN-030 v1.2: el tramo de 5% empieza en 150 ud.
  (antes: 100 ud.)

Análisis de impacto (vía trazabilidad):

  DN-030 (regla de dominio)
    │
    ├─► DescuentoCalculator.java
    │     → Actualizar tabla de tramos
    │
    ├─► T-DN-030-01 a T-DN-030-08
    │     → Actualizar ejemplos de los tramos
    │       afectados (100-149 ud. pasan de 5% a 3%)
    │
    ├─► API-PED-001 (contrato de crear pedido)
    │     → Sin cambio en el contrato (el descuento
    │       se calcula internamente)
    │
    ├─► FUNC-110 (crear pedido)
    │     → Sin cambio funcional (el flujo es el
    │       mismo, solo cambia el cálculo)
    │
    ├─► CU-010 (realizar pedido)
    │     → Sin cambio en los flujos
    │
    ├─► AC-010-07 (descuento recalculado en repetir
    │   pedido)
    │     → Actualizar ejemplo: 120 ud. ahora es
    │       tramo 3%, no 5%
    │
    └─► Documentación del catálogo para clientes
          → Actualizar tabla de descuentos publicada
```

Sin trazabilidad, este análisis requiere que alguien
recuerde de memoria todos los puntos afectados. Con
trazabilidad, es un recorrido sistemático de los vínculos.

### 7.5.2. Regresión controlada

Cuando se hace un cambio en el sistema, los tests vinculados
a los requisitos afectados son los primeros candidatos a
ejecutar. La trazabilidad permite ejecutar un **subconjunto
dirigido de tests** en lugar de toda la suite:

```text
Cambio: DN-030 tramos modificados

Tests a ejecutar (prioridad alta):
  T-DN-030-01 a T-DN-030-08 (tests de la regla)
  TAC-010-01 (pedido con tarjeta, verifica total)
  TAC-010-02 (pedido con crédito, verifica total)

Tests a ejecutar (prioridad media):
  TAC-045-07 (repetir pedido, recálculo descuentos)
  T-DN-055-02 (fidelidad con subtotal afectado)

Tests no afectados (se ejecutan en suite completa):
  TAC-027-* (cancelación, no depende de descuentos)
  TAC-052-* (panel devoluciones, no depende)
```

### 7.5.3. Onboarding y transferencia de conocimiento

Cuando un nuevo miembro se incorpora al equipo, la
trazabilidad le permite navegar el proyecto:

- "¿Qué hace el servicio DescuentoCalculator?" → Implementa
  DN-030. Lee la especificación para entender la lógica.
- "¿Por qué existe este test?" → Valida AC-027-04 de
  FUNC-027. Lee el criterio para entender qué verifica.
- "¿Qué pasa si cambio este endpoint?" → Mira el contrato
  API-PED-001 y los consumidores que dependen de él.

Sin trazabilidad, las respuestas a estas preguntas requieren
preguntar a los compañeros (si están disponibles y recuerdan)
o leer el código (que no explica el "porqué").

---

## 7.6. Trazabilidad y auditoría

### 7.6.1. Contextos que exigen trazabilidad formal

Algunos contextos requieren trazabilidad como requisito
regulatorio o contractual:

**Sector sanitario**: los sistemas que procesan datos de
pacientes o apoyan decisiones clínicas deben demostrar que
cada requisito regulatorio está implementado y validado
(ISO 13485, FDA 21 CFR Part 11).

**Sector financiero**: los sistemas de banca, pagos y
seguros deben demostrar cumplimiento normativo con
trazabilidad auditada (PCI DSS, SOX, Basel III).

**Administración pública**: los proyectos para organismos
públicos suelen exigir trazabilidad completa como parte
del contrato de desarrollo (ENS, Esquema Nacional de
Seguridad).

**Sector aeroespacial y defensa**: estándares como DO-178C
exigen trazabilidad completa desde requisitos hasta código
y tests, con evidencia de cobertura.

### 7.6.2. Evidencia de trazabilidad

En contextos de auditoría, la trazabilidad debe producir
**evidencia documentada**:

**Matriz de trazabilidad completa**: que muestre cada
requisito vinculado a su diseño, código y test.

**Informe de cobertura de requisitos**: porcentaje de
requisitos con test asociado, porcentaje de tests que pasan,
requisitos sin cobertura.

**Historial de cambios**: para cada requisito, quién lo
creó, quién lo modificó, cuándo y por qué. Para cada
vínculo de trazabilidad, cuándo se estableció.

**Evidencia de ejecución de tests**: registros de ejecución
con fecha, resultado, entorno y versión del software.

### 7.6.3. Trazabilidad pragmática vs. burocrática

La diferencia entre trazabilidad útil y burocracia
improductiva está en la **proporcionalidad**:

**Burocrática**: una matriz de 500 filas mantenida
manualmente en un documento Word que nadie consulta, se
desactualiza en la segunda semana y solo se actualiza
la víspera de la auditoría.

**Pragmática**: IDs de requisito en los nombres de tests,
tags en los archivos `.feature`, un script que genera la
matriz automáticamente a partir de los tags, y un informe
de cobertura integrado en el pipeline de CI/CD.

El objetivo es que la trazabilidad sea un **subproducto
natural** del flujo de trabajo, no una carga adicional.

---

## 7.7. Estrategia de trazabilidad para un proyecto

### 7.7.1. Pasos para diseñar la estrategia

Diseñar la estrategia de trazabilidad de un proyecto
implica responder a cinco preguntas:

**1. ¿Qué artefactos se trazan?** Definir los niveles de
la cadena que se van a vincular. En un proyecto típico
con SDD: especificación funcional, regla de dominio,
contrato de API, criterio de aceptación, test y componente
de código.

**2. ¿Con qué granularidad?** Decidir si se traza a nivel
de funcionalidad, de criterio de aceptación o de regla
individual. La granularidad debe ser proporcional al riesgo
y al contexto regulatorio.

**3. ¿Cómo se establecen los vínculos?** Definir el
mecanismo: IDs en comentarios de código, tags en tests,
campos en el gestor de tareas, herramienta especializada.

**4. ¿Cómo se mantienen actualizados?** Definir el proceso:
quién actualiza los vínculos cuando un artefacto cambia,
cuándo se revisa la matriz, cómo se detectan vínculos
rotos.

**5. ¿Cómo se consulta y se reporta?** Definir los
informes necesarios: matriz completa, cobertura de
requisitos, requisitos en riesgo, impacto de cambios.

### 7.7.2. Ejemplo de estrategia para el proyecto B2B

```text
ESTRATEGIA DE TRAZABILIDAD
Proyecto: Tienda online B2B

ARTEFACTOS TRAZADOS
  Nivel 1: Especificaciones (FUNC, DN, API, SEC, PERF)
  Nivel 2: Criterios de aceptación (AC-NNN-NN)
  Nivel 3: Tests (TAC, TM, T-DN, TC)
  Nivel 4: Componentes de código (servicios, controllers)

GRANULARIDAD
  Media: a nivel de criterio de aceptación y regla
  de dominio.

MECANISMO DE VÍNCULOS
  - Cada test incluye un tag con el ID del criterio
    o la regla que valida.
    Ejemplo: @AC-027-04, @DN-030
  - Cada componente de código incluye un comentario
    Javadoc/JSDoc con las especificaciones que
    implementa.
  - El gestor de tareas (Jira) vincula cada ticket
    de implementación con el ID de la especificación.

MANTENIMIENTO
  - Al crear un test, el desarrollador añade el tag
    del criterio.
  - Al modificar una especificación, el analista
    actualiza los vínculos afectados.
  - Cada sprint, QA ejecuta el script de generación
    de matriz y revisa huecos.

REPORTES
  - Matriz de trazabilidad (generada semanalmente).
  - Informe de cobertura de requisitos (generado en
    cada build de CI/CD).
  - Dashboard de requisitos en riesgo (criterios con
    tests fallando).
```

---

## 7.8. Resumen del tema

La trazabilidad es el tejido conectivo que mantiene
alineados todos los artefactos de un proyecto SDD.

Puntos clave:

- La trazabilidad es bidireccional: hacia adelante (de
  la necesidad al test) y hacia atrás (del test a la
  necesidad).
- La cadena de trazabilidad conecta necesidades,
  especificaciones, casos de uso, criterios de aceptación,
  tests, código y componentes.
- La matriz de trazabilidad es el artefacto central, pero
  los vínculos también viven en el código (comentarios,
  tags de tests) y en el gestor de tareas.
- Las desviaciones (requisito sin test, código sin
  requisito, drift entre spec e implementación) se detectan
  revisando la matriz y se gestionan con decisiones
  conscientes.
- La trazabilidad facilita el análisis de impacto, la
  regresión dirigida, el onboarding y la auditoría.
- La estrategia de trazabilidad debe ser proporcional al
  contexto: pragmática en proyectos ágiles, rigurosa en
  contextos regulados, pero nunca burocrática.

---

## Laboratorios del Tema 7

### Laboratorio 7.1: Matriz de trazabilidad requisito-diseño-prueba

#### Enunciado del laboratorio 7.1

**Objetivo**: construir una matriz de trazabilidad completa
para un subconjunto de funcionalidades del proyecto B2B,
conectando especificaciones con componentes de diseño, tests
y estado de implementación.

**Contexto**: el equipo del proyecto B2B ha completado la
implementación de varias funcionalidades del primer release.
Se necesita una matriz de trazabilidad que permita evaluar
el estado de cobertura y detectar huecos.

Se proporciona el inventario de artefactos existentes.

**Inventario de especificaciones**:

```text
FUNC-027  Cancelación de pedido por el cliente
FUNC-100  Catálogo con precios personalizados
FUNC-110  Creación de pedido online
FUNC-120  Flujo de aprobación de pedidos
FUNC-130  Solicitud de devolución
DN-030    Descuento por volumen
DN-040    Transiciones de estado de pedido
DN-045    Cálculo de gastos de envío
DN-055    Descuento por fidelidad
API-PED-001  Crear pedido
API-PED-002  Consultar pedido
API-DEV-001  Crear solicitud de devolución
SEC-010   Consentimiento para datos personales
PERF-010  Tiempo de respuesta del checkout
```

**Inventario de componentes de código**:

```text
PedidoService
PedidoController
PedidoStateMachine
DescuentoCalculator
EnvioCalculator
FidelidadCalculator
CatalogoService
CatalogoController
DevolucionService
DevolucionController
AprobacionService
ConsentimientoService
```

**Inventario de tests**:

```text
TAC-027-01 a TAC-027-06   (cancelación)
TAC-110-01 a TAC-110-05   (creación pedido)
TAC-120-01 a TAC-120-02   (aprobación)
TAC-130-01 a TAC-130-04   (devolución)
T-DN-030-01 a T-DN-030-08 (descuento volumen)
T-DN-040-01 a T-DN-040-06 (transiciones estado)
T-DN-045-01 a T-DN-045-05 (gastos envío)
TC-PED-001-01 a TC-PED-001-04 (contrato crear pedido)
TC-PED-002-01 a TC-PED-002-02 (contrato consultar)
TC-DEV-001-01 a TC-DEV-001-03 (contrato devolución)
PERF-010-01    (test de rendimiento checkout)
```

**Instrucciones**:

1. Construye la matriz de trazabilidad completa que
   relacione cada especificación con sus componentes
   de código y sus tests.
2. Identifica todos los huecos: especificaciones sin
   test, especificaciones sin componente, componentes
   sin especificación.
3. Calcula las métricas de cobertura.
4. Propón acciones para cada hueco detectado.

#### Solución del laboratorio 7.1

##### Matriz de trazabilidad

```text
Spec         Componentes           Tests              Estado
────         ───────────           ─────              ──────
FUNC-027     PedidoService         TAC-027-01..06     OK
             PedidoStateMachine

FUNC-100     CatalogoService       —                  SIN TEST
             CatalogoController

FUNC-110     PedidoService         TAC-110-01..05     OK
             PedidoController
             DescuentoCalculator
             EnvioCalculator

FUNC-120     AprobacionService     TAC-120-01..02     PARCIAL
                                   (solo 2 tests,
                                   flujo completo
                                   tiene 5 criterios)

FUNC-130     DevolucionService     TAC-130-01..04     OK
             DevolucionController

DN-030       DescuentoCalculator   T-DN-030-01..08    OK

DN-040       PedidoStateMachine    T-DN-040-01..06    OK

DN-045       EnvioCalculator       T-DN-045-01..05    OK

DN-055       FidelidadCalculator   —                  SIN TEST

API-PED-001  PedidoController      TC-PED-001-01..04  OK

API-PED-002  PedidoController      TC-PED-002-01..02  OK

API-DEV-001  DevolucionController  TC-DEV-001-01..03  OK

SEC-010      ConsentimientoService —                  SIN TEST

PERF-010     (transversal)         PERF-010-01        OK
```

##### Huecos detectados

##### Hueco 1: FUNC-100 sin tests

El catálogo con precios personalizados está implementado
(CatalogoService, CatalogoController) pero no tiene tests
de aceptación. Esto significa que no hay verificación
automatizada de que los precios personalizados se muestran
correctamente, que las restricciones geográficas se aplican
ni que la búsqueda funciona según lo especificado.

Riesgo: alto. El catálogo es la funcionalidad que ve el
cliente en cada visita. Un error en precios personalizados
puede tener impacto económico directo.

Acción: crear tests de aceptación para FUNC-100 con
prioridad alta. Mínimo: verificar precios personalizados,
restricciones geográficas, búsqueda por texto y filtrado
por familia.

##### Hueco 2: DN-055 sin tests

La regla de descuento por fidelidad está implementada
(FidelidadCalculator) pero no tiene tests. Dado que la
fidelidad interactúa con el descuento por volumen (DN-030)
y con los gastos de envío (DN-045), un error en su cálculo
puede propagarse.

Riesgo: medio-alto. Afecta al cálculo de totales de
pedido, que es una funcionalidad crítica.

Acción: crear tests T-DN-055-01 a T-DN-055-NN usando los
ejemplos numéricos de la especificación DN-055 (del
Laboratorio 5.2). Verificar la interacción con DN-030
y DN-045.

##### Hueco 3: SEC-010 sin tests

La funcionalidad de consentimiento para datos personales
está implementada (ConsentimientoService) pero no tiene
tests automatizados. Dado que es un requisito regulatorio
(RGPD), la ausencia de tests es un riesgo de cumplimiento.

Riesgo: alto (regulatorio). Un fallo en el consentimiento
puede tener consecuencias legales.

Acción: crear tests de aceptación para SEC-010 con
prioridad alta. Verificar que el checkbox no está
premarcado, que el registro no se completa sin
consentimiento y que se registra el timestamp del
consentimiento.

##### Hueco 4: FUNC-120 cobertura parcial

La funcionalidad de aprobación tiene solo 2 tests pero
la especificación define al menos 5 criterios de
aceptación (aprobar, rechazar, solicitar info, timeout,
notificaciones).

Riesgo: medio. Los flujos no cubiertos pueden fallar sin
detección.

Acción: completar los tests TAC-120-03 a TAC-120-05 para
cubrir los criterios pendientes.

##### Hueco 5: FidelidadCalculator sin spec de diseño

El componente FidelidadCalculator existe pero no hay
especificación técnica (TECH-NNN) que documente su diseño
interno, sus dependencias ni sus decisiones de
implementación.

Riesgo: bajo a medio. Dificulta el mantenimiento si el
autor original no está disponible.

Acción: crear TECH-015 documentando el diseño del
FidelidadCalculator. Baja prioridad.

##### Métricas de cobertura

```text
Especificaciones totales:       14
  Con tests:                    10  (71%)
  Sin tests:                     3  (21%)
  Con cobertura parcial:         1  ( 7%)

Tests totales:                  ~50
  Automatizados:                ~49 (98%)
  Manuales:                       0 ( 0%)
  Pendientes de crear:          ~15

Componentes de código:          12
  Con especificación vinculada: 12 (100%)
  Sin especificación:            0 ( 0%)

Requisitos regulatorios:         1 (SEC-010)
  Con test:                      0 ( 0%) ← ALERTA
```

##### Plan de acción priorizado

```text
Prioridad 1 (bloquea el release):
  - Crear tests para SEC-010 (regulatorio).
    Responsable: QA. Plazo: esta semana.

Prioridad 2 (riesgo funcional alto):
  - Crear tests para FUNC-100 (catálogo).
    Responsable: QA + Dev. Plazo: próximo sprint.
  - Crear tests para DN-055 (fidelidad).
    Responsable: Dev. Plazo: próximo sprint.

Prioridad 3 (completar cobertura):
  - Completar tests para FUNC-120 (aprobación).
    Responsable: QA. Plazo: 2 sprints.

Prioridad 4 (documentación técnica):
  - Crear TECH-015 para FidelidadCalculator.
    Responsable: Dev. Plazo: backlog.
```

---

### Laboratorio 7.2: Detección de huecos entre especificación y código

#### Enunciado del laboratorio 7.2

**Objetivo**: comparar un conjunto de especificaciones con
su implementación real para detectar desviaciones (drift),
funcionalidad no especificada y especificaciones no
implementadas.

**Contexto**: se proporcionan las especificaciones y el
pseudocódigo de implementación del módulo de descuentos del
proyecto B2B. El alumno debe comparar ambos y documentar
todas las discrepancias.

**Especificaciones relevantes (resumen)**:

```text
DN-030 (Descuento por volumen):
  - Se aplica por producto, no por pedido total.
  - Tramos: 50-99 (3%), 100-499 (5%), 500+ (8%).
  - Se aplica sobre precio base, antes de IVA.
  - Redondeo bancario a 2 decimales.
  - No acumulable con precio especial: se aplica
    el más favorable para el cliente.

DN-055 (Descuento por fidelidad):
  - Se aplica sobre el subtotal del pedido (después
    de descuentos por línea).
  - Tramos según compra acumulada 12 meses:
    < 5.000 (0%), 5.000-14.999 (1%),
    15.000-49.999 (2%), 50.000+ (3%).
  - El pedido actual NO cuenta para la compra
    acumulada.
  - Acumulable con otros descuentos (se aplica
    después).

DN-045 (Gastos de envío):
  - Envío gratuito si subtotal > 200 € (evaluado
    ANTES del descuento de fidelidad).
  - Tabla: Península (4,50/7,90/12,50 €),
    Baleares (6,90/11,50/18,00 €),
    Canarias (9,90/16,50/25,00 €).
  - Tramos de peso: hasta 5 kg, 5-20 kg, más de
    20 kg.
```

**Pseudocódigo de la implementación**:

```text
class DescuentoCalculator:

  function calcularPrecioLinea(producto, cantidad,
      cliente):
    precioBase = producto.precioBase
    precioEspecial = cliente.getPrecioEspecial(
      producto.id)

    // Descuento por volumen
    if cantidad >= 500:
      descuentoVol = 0.08
    elif cantidad >= 100:
      descuentoVol = 0.05
    elif cantidad >= 50:
      descuentoVol = 0.03
    else:
      descuentoVol = 0

    precioConVolumen = precioBase * (1 - descuentoVol)
    precioConVolumen = truncar2decimales(
      precioConVolumen)

    // Aplicar el mejor precio
    if precioEspecial != null:
      precioFinal = min(precioConVolumen,
        precioEspecial)
    else:
      precioFinal = precioConVolumen

    return precioFinal * cantidad


class FidelidadCalculator:

  function calcularDescuentoFidelidad(cliente,
      subtotal):
    compraAcumulada = cliente.compraUltimos12Meses()
      // incluye pedidos confirmados y entregados

    if compraAcumulada >= 50000:
      porcentaje = 0.03
    elif compraAcumulada >= 15000:
      porcentaje = 0.02
    elif compraAcumulada >= 5000:
      porcentaje = 0.01
    else:
      porcentaje = 0

    return subtotal * porcentaje


class EnvioCalculator:

  function calcularGastosEnvio(zona, pesoKg,
      subtotalConFidelidad):

    // Envío gratuito
    if subtotalConFidelidad > 200:
      return 0

    // Tabla de tarifas
    tarifas = {
      "peninsula": [4.50, 7.90, 12.50],
      "baleares":  [6.90, 11.50, 18.00],
      "canarias":  [9.90, 16.50, 25.00]
    }

    if pesoKg <= 5:
      indice = 0
    elif pesoKg <= 20:
      indice = 1
    else:
      indice = 2

    return tarifas[zona][indice]
```

**Instrucciones**:

1. Compara cada especificación con su implementación en
   el pseudocódigo.
2. Identifica todas las discrepancias (errores, omisiones,
   decisiones no documentadas).
3. Clasifica cada discrepancia por gravedad (crítica,
   importante, menor).
4. Para cada discrepancia, indica si debe corregirse el
   código, la especificación o ambos.
5. Propón los tests que habrían detectado cada
   discrepancia.

#### Solución del laboratorio 7.2

##### Discrepancia 1: Redondeo incorrecto en DN-030

Especificación DN-030 dice: "Redondeo bancario a 2
decimales." El código usa `truncar2decimales()` en lugar
de redondeo bancario.

Ejemplo del impacto: precio base 0,50 €, descuento 3%.
Cálculo: 0,50 x 0,97 = 0,485. Con redondeo bancario:
0,48 €. Con truncamiento: 0,48 €. En este caso coinciden,
pero con otros valores no. Ejemplo: precio 1,15 €, 5%
descuento. Cálculo: 1,15 x 0,95 = 1,0925. Redondeo
bancario: 1,09 €. Truncamiento: 1,09 €. Otro ejemplo:
precio 0,75 €, 3%. Cálculo: 0,75 x 0,97 = 0,7275.
Redondeo bancario: 0,73 €. Truncamiento: 0,72 €.
Diferencia: 0,01 € por unidad.

Gravedad: importante. En pedidos grandes, las diferencias
de céntimos se acumulan. Un pedido de 500 unidades con
0,01 € de diferencia son 5,00 € de discrepancia. Además,
puede generar inconsistencias con la facturación del ERP
si este usa redondeo bancario.

Acción: corregir el código para usar redondeo bancario.

Test que lo habría detectado:

```text
Test: precio 0,75 €, cantidad 100, descuento 3%
  Esperado: 0,73 € × 100 = 73,00 €
  Con truncamiento: 0,72 € × 100 = 72,00 €
  → Test falla, discrepancia detectada.
```

##### Discrepancia 2: Compra acumulada incluye el pedido actual

Especificación DN-055 dice: "El pedido actual NO cuenta
para la compra acumulada." El código usa
`cliente.compraUltimos12Meses()` sin excluir el pedido
en curso. Si esta función incluye pedidos en cualquier
estado (incluido el que se está creando), el cálculo
es incorrecto.

Gravedad: importante. Un cliente que está justo debajo de
un umbral podría saltar al tramo superior por su propio
pedido, generando un descuento circular (el pedido se
beneficia de sí mismo).

Acción: verificar la implementación de
`compraUltimos12Meses()`. Si incluye el pedido actual,
corregir para excluirlo. Si lo excluye, documentar esa
decisión en un comentario de código.

Test que lo habría detectado:

```text
Test: cliente con compra acumulada 4.900 €,
  pedido actual 200 €
  Esperado: tramo 0% (4.900 < 5.000)
  Si incluye pedido: 5.100 → tramo 1% (incorrecto)
  → Test falla si la función incluye el pedido.
```

##### Discrepancia 3: Evaluación de envío gratuito sobre subtotal incorrecto

Especificación DN-045 dice: "Envío gratuito si subtotal
mayor que 200 € (evaluado ANTES del descuento de
fidelidad)." El código evalúa contra
`subtotalConFidelidad` (el subtotal después de aplicar
el descuento de fidelidad).

Gravedad: crítica. Un cliente con subtotal 210 € y
fidelidad 3% tendría un subtotal con fidelidad de
203,70 €. Según la spec, el envío es gratuito (210 >
200). Según el código, el envío es gratuito (203,70 >
200), así que en este caso coincide. Pero un cliente con
subtotal 205 € y fidelidad 3% tendría subtotal con
fidelidad de 198,85 €. Según la spec, envío gratuito
(205 > 200). Según el código, envío NO gratuito (198,85
< 200). Diferencia real para el cliente.

Acción: corregir el código para evaluar el envío gratuito
contra el subtotal antes de fidelidad.

Test que lo habría detectado:

```text
Test: subtotal 205 €, fidelidad 3%, zona Península
  Esperado: envío gratuito (205 > 200, antes de
    fidelidad)
  Código actual: envío 4,50 € (198,85 < 200,
    después de fidelidad)
  → Test falla, discrepancia detectada.
```

##### Discrepancia 4: Retorno de calcularPrecioLinea

La función `calcularPrecioLinea` devuelve
`precioFinal * cantidad`, es decir, devuelve el subtotal
de la línea, no el precio unitario. Sin embargo, la
especificación y los contratos de API esperan el precio
unitario por separado (para mostrarlo en el carrito y en
la factura).

Gravedad: menor (es un problema de diseño de la interfaz
interna, no de cálculo). Sin embargo, si otro componente
necesita el precio unitario, tendría que recalcularlo,
lo que viola el principio de no duplicar lógica.

Acción: refactorizar para devolver un objeto con precio
unitario y subtotal. Documentar como decisión de diseño
en TECH-NNN.

Test que lo habría detectado: un test de contrato interno
que verifique que el servicio devuelve tanto el precio
unitario como el subtotal por separado.

##### Discrepancia 5: Compra acumulada incluye pedidos confirmados

La especificación DN-055 dice que la compra acumulada
incluye "pedidos confirmados y entregados". El comentario
del código dice lo mismo. Sin embargo, la especificación
también dice que los pedidos cancelados y las devoluciones
se restan. No hay evidencia en el pseudocódigo de que la
función `compraUltimos12Meses()` excluya cancelados ni
reste devoluciones.

Gravedad: importante. Un cliente que haya cancelado
pedidos por valor de 10.000 € podría estar en un tramo
de fidelidad superior al que le corresponde.

Acción: verificar que la consulta subyacente excluye
pedidos cancelados y resta importes de devoluciones
completadas. Si no lo hace, corregir. Si lo hace,
documentar.

Test que lo habría detectado:

```text
Test: cliente con 20.000 € en pedidos entregados
  y 6.000 € en pedidos cancelados
  Esperado: compra acumulada = 14.000 € → tramo 1%
  Si no excluye cancelados: 20.000 € → tramo 2%
  → Test falla.
```

##### Discrepancia 6: Peso exactamente 5 kg

La especificación DN-045 dice que el tramo "hasta 5 kg"
incluye el valor 5. El código usa `pesoKg <= 5`, lo cual
es correcto para este caso. Sin embargo, el tramo
"5-20 kg" de la especificación es ambiguo: ¿5 está en
el primer tramo o en el segundo?

Gravedad: menor (el código es consistente consigo mismo
y con una interpretación razonable).

Acción: clarificar la especificación DN-045 para
indicar que los límites inferiores son exclusivos y
los superiores inclusivos (es decir, 5 kg está en
"hasta 5 kg", no en "5-20 kg"). Añadir un ejemplo
con peso exacto de 5 kg.

##### Resumen de discrepancias

```text
#   Discrepancia          Gravedad    Acción
─   ─────────────         ────────    ──────
1   Truncamiento vs       Importante  Corregir código
    redondeo bancario
2   Pedido actual en      Importante  Verificar y
    compra acumulada                  corregir código
3   Envío gratuito        Crítica     Corregir código
    evaluado después
    de fidelidad
4   Retorno subtotal      Menor       Refactorizar
    en vez de precio                  código
    unitario
5   Cancelados y          Importante  Verificar y
    devoluciones en                   corregir código
    compra acumulada
6   Ambigüedad en         Menor       Clarificar spec
    límite de peso
```

---

### Laboratorio 7.3: Auditoría rápida de cobertura de requisitos

#### Enunciado del laboratorio 7.3

**Objetivo**: realizar una auditoría rápida del estado de
cobertura de requisitos del proyecto B2B, generando un
informe ejecutivo con métricas, riesgos y recomendaciones.

**Contexto**: el equipo prepara el primer release del
proyecto B2B. El Product Owner necesita un informe que
responda a: "¿Estamos listos para producción? ¿Qué riesgos
tenemos?"

Se proporcionan los datos actualizados del proyecto tras
resolver algunos de los huecos del Laboratorio 7.1.

**Datos actualizados**:

```text
ESPECIFICACIONES FUNCIONALES (6):
  FUNC-027 Cancelación:     implementada, 6 tests, OK
  FUNC-100 Catálogo:        implementada, 4 tests, OK
  FUNC-110 Creación pedido: implementada, 5 tests, OK
  FUNC-120 Aprobación:      implementada, 4 tests, OK
  FUNC-130 Devolución:      implementada, 4 tests, OK
  FUNC-140 Dashboard:       NO implementada

REGLAS DE DOMINIO (4):
  DN-030 Volumen:     implementada, 8 tests, OK
  DN-040 Transiciones: implementada, 6 tests, OK
  DN-045 Envío:       implementada, 5 tests, 1 FALLO
  DN-055 Fidelidad:   implementada, 4 tests, OK

CONTRATOS DE API (3):
  API-PED-001 Crear pedido:    4 tests, OK
  API-PED-002 Consultar pedido: 2 tests, OK
  API-DEV-001 Crear devolución: 3 tests, OK

SEGURIDAD (1):
  SEC-010 Consentimiento: implementada, 3 tests, OK

RENDIMIENTO (1):
  PERF-010 Checkout:      1 test, OK

TESTS TOTALES: 59
  Pasando: 58
  Fallando: 1 (T-DN-045-03: gastos de envío con
    peso exacto en frontera de tramo)

FUNCIONALIDADES EN PRODUCCIÓN DE COMPETIDORES
QUE NO ESTÁN EN NUESTRO RELEASE:
  - Repetir pedido anterior (HU-045, no planificada)
  - Notificaciones push (no especificada)
  - Integración con ERP en tiempo real (parcial:
    sincronización batch cada 15 min)
```

**Instrucciones**:

1. Calcula las métricas de cobertura por categoría.
2. Identifica los riesgos clasificados por gravedad.
3. Evalúa cada riesgo con probabilidad e impacto.
4. Redacta un informe ejecutivo de una página con la
   recomendación sobre si el proyecto está listo para
   producción.
5. Incluye un plan de acciones previas al release y un
   plan de acciones post-release.

#### Solución del laboratorio 7.3

##### Métricas de cobertura del release

```text
COBERTURA POR CATEGORÍA

Funcionales (6 especificaciones):
  Implementadas:            5 de 6  (83%)
  Con tests:                5 de 6  (83%)
  Tests pasando:            5 de 5  (100%)
  Sin implementar:          1 (FUNC-140 Dashboard)

Reglas de dominio (4 especificaciones):
  Implementadas:            4 de 4  (100%)
  Con tests:                4 de 4  (100%)
  Tests pasando:            3 de 4  ( 75%)
  Con test fallando:        1 (DN-045, test 03)

Contratos de API (3 especificaciones):
  Con tests:                3 de 3  (100%)
  Tests pasando:            3 de 3  (100%)

Seguridad (1 especificación):
  Implementada:             1 de 1  (100%)
  Con tests:                1 de 1  (100%)
  Tests pasando:            1 de 1  (100%)

Rendimiento (1 especificación):
  Con test:                 1 de 1  (100%)
  Test pasando:             1 de 1  (100%)

MÉTRICAS GLOBALES
  Especificaciones totales: 15
  Implementadas:            14 de 15 (93%)
  Con tests:                14 de 15 (93%)
  Tests totales:            59
  Tests pasando:            58 de 59 (98,3%)
  Tests fallando:           1 de 59  (1,7%)
```

##### Análisis de riesgos

##### Riesgo 1: Test fallando en DN-045

Descripción: el test T-DN-045-03 falla. Según la
descripción, es el caso de peso exacto en frontera de
tramo. Puede ser un bug en el cálculo de gastos de envío
para pesos en la frontera (exactamente 5 kg o 20 kg).

Probabilidad: media. Los pedidos con peso exacto en la
frontera no son frecuentes, pero tampoco improbables.

Impacto: medio. El cliente podría ver un coste de envío
incorrecto. Si el error es a favor del cliente, la empresa
pierde margen. Si es en contra, el cliente puede reclamar.

Decisión: **bloquea el release**. Un error en cálculo
económico, por pequeño que sea, afecta a la confianza del
cliente y puede tener implicaciones legales.

Acción: corregir antes del release. Estimación: medio día.

##### Riesgo 2: FUNC-140 no implementada

Descripción: la funcionalidad de dashboard de ventas para
gestores no está implementada. Estaba en el alcance del
primer release según la directora comercial.

Probabilidad: cierta (100%). No está implementada.

Impacto: medio para el negocio (la directora comercial
pierde visibilidad de ventas), bajo para los clientes
(no afecta a la experiencia de compra).

Decisión: **no bloquea el release**, pero debe comunicarse
al stakeholder y planificarse para el siguiente sprint.

Acción: informar a Laura (PO) de que el dashboard no
estará en el release 1. Planificar para el release 2.

##### Riesgo 3: Sincronización ERP batch

Descripción: la sincronización de pedidos con el ERP se
realiza cada 15 minutos (batch), no en tiempo real. Esto
significa que el stock visible en la tienda puede tener
hasta 15 minutos de retraso respecto al stock real.

Probabilidad: alta. Con 400 clientes activos y ~3.000
productos, es probable que haya pedidos concurrentes que
agoten stock entre sincronizaciones.

Impacto: medio. Un cliente podría hacer un pedido de un
producto que ya no tiene stock. El pedido se confirmaría
y luego habría que notificar al cliente de la falta de
stock, lo que genera mala experiencia.

Decisión: **no bloquea el release**, pero debe
documentarse como limitación conocida y planificarse la
mejora.

Acción: documentar la limitación. Implementar un
mecanismo de validación de stock en el momento de la
confirmación (aunque el stock del catálogo tenga retraso).
Planificar sincronización en tiempo real para release 3.

##### Riesgo 4: Sin repetir pedido

Descripción: HU-045 (repetir pedido anterior) no está
implementada ni planificada. Es funcionalidad estándar
en tiendas online B2B y los competidores la ofrecen.

Probabilidad: cierta (no existe).

Impacto: bajo a medio. Reduce la eficiencia del cliente
(tiene que buscar y añadir productos uno a uno cada vez)
pero no impide el uso del sistema.

Decisión: no bloquea el release. Planificar para un
sprint cercano.

##### Riesgo 5: Sin tests de rendimiento catálogo

Descripción: hay test de rendimiento para el checkout
(PERF-010) pero no para el catálogo ni la búsqueda. Con
3.000 productos y precios personalizados, la consulta del
catálogo puede ser lenta.

Probabilidad: media.

Impacto: alto si se materializa. Un catálogo lento
frustra a los clientes y reduce las ventas.

Decisión: no bloquea el release pero es acción prioritaria
post-release.

Acción: crear PERF-020 (rendimiento del catálogo) y
ejecutar tests de carga antes de abrir al 100% de
clientes. Considerar un lanzamiento progresivo (10% de
clientes primero).

##### Informe ejecutivo

```text
═══════════════════════════════════════════════════
INFORME DE PREPARACIÓN PARA RELEASE 1
Proyecto: Tienda Online B2B
Fecha: 2025-04-28
Autor: Equipo de QA / Análisis
═══════════════════════════════════════════════════

ESTADO GENERAL: LISTO CON CONDICIONES

Resumen de cobertura:
  93% de especificaciones implementadas y con tests.
  98,3% de tests pasando (1 fallo activo).
  100% de requisitos regulatorios cubiertos.
  1 funcionalidad no implementada (Dashboard).

CONDICIÓN BLOQUEANTE PARA EL RELEASE:
  Corregir T-DN-045-03 (cálculo de gastos de envío
  en frontera de tramo de peso). Estimación: 0,5 día.

ACCIONES PREVIAS AL RELEASE:
  1. Corregir bug DN-045 y verificar.
  2. Comunicar a Laura que FUNC-140 (Dashboard) no
     estará en release 1.
  3. Documentar la limitación de sincronización con
     ERP (batch 15 min) en las notas del release.
  4. Preparar script de monitorización de errores
     de stock para las primeras 48 horas.

ACCIONES POST-RELEASE (próximos 2 sprints):
  1. FUNC-140 Dashboard (sprint 2).
  2. PERF-020 Tests de rendimiento del catálogo.
  3. HU-045 Repetir pedido anterior.
  4. Mejora de sincronización con ERP.

RIESGOS ACEPTADOS:
  - Dashboard ausente: impacto en gestión interna,
    no en clientes. Mitigación: informes manuales
    hasta su implementación.
  - Stock con retraso de hasta 15 min: riesgo de
    pedidos con stock insuficiente. Mitigación:
    validación de stock en confirmación.
  - Sin repetir pedido: impacto en eficiencia del
    cliente. Mitigación: ninguna necesaria, es
    funcionalidad de conveniencia.

RECOMENDACIÓN:
  Proceder con el release tras corregir el bug
  DN-045. Lanzamiento progresivo recomendado:
  10% de clientes la primera semana, 50% la
  segunda, 100% la tercera, con monitorización
  activa.

FIRMAS:
  QA Lead:       _______ (recomienda con condición)
  Dev Lead:      _______ (acepta corrección DN-045)
  Product Owner: _______ (aprueba plan de release)
═══════════════════════════════════════════════════
```
