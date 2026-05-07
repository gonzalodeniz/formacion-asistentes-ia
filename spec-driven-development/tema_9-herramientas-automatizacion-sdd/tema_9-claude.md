# Tema 9. Herramientas y automatización para SDD

## 9.1. Introducción

A lo largo de los ocho temas anteriores hemos construido un
marco completo para trabajar con especificaciones: cómo
redactarlas, cómo estructurarlas, cómo refinarlas, cómo
modelar comportamiento, cómo definir contratos y reglas,
cómo verificarlas, cómo trazarlas y cómo gestionar su
evolución. Todo ese conocimiento es valioso, pero su
aplicación práctica depende de un factor que a menudo se
subestima: **las herramientas y los flujos de trabajo** que
lo soportan.

La mejor práctica de especificación del mundo fracasa si las
especificaciones se almacenan en documentos Word que nadie
encuentra, si las revisiones se hacen por correo electrónico
sin trazabilidad, si la publicación requiere intervención
manual cada vez que algo cambia, o si los tests no están
conectados con las especificaciones que validan.

Este tema aborda el lado práctico y operativo de SDD: qué
herramientas existen, cómo configurar un flujo de trabajo
que integre las especificaciones en el día a día del equipo,
y cómo automatizar las tareas repetitivas para que mantener
las especificaciones sea sostenible a largo plazo.

El objetivo no es prescribir un stack tecnológico concreto,
sino enseñar los **principios y patrones** que permiten
elegir e integrar herramientas adecuadas al contexto de cada
equipo.

---

## 9.2. Principios para elegir herramientas

### 9.2.1. Las especificaciones son artefactos de primera clase

El primer principio es que las especificaciones merecen el
mismo tratamiento que el código fuente:

- Se almacenan en un sistema con control de versiones.
- Se revisan antes de aprobarse.
- Se publican de forma accesible para todo el equipo.
- Se validan automáticamente cuando es posible.
- Se integran en el pipeline de CI/CD.

Cualquier herramienta o flujo que trate las especificaciones
como documentos de segunda clase (almacenados en carpetas
compartidas, editados sin revisión, publicados manualmente)
socava los fundamentos de SDD.

### 9.2.2. Accesibilidad para todos los perfiles

Las herramientas deben ser utilizables por todos los perfiles
del equipo: negocio, desarrollo, QA, diseño, operaciones. Si
la herramienta de especificación solo la entienden los
desarrolladores (p. ej., un formato muy técnico en un
repositorio Git sin interfaz web), negocio queda excluido de
la revisión. Si solo la entiende negocio (p. ej., un Word en
SharePoint), desarrollo no la consulta.

La solución ideal es una herramienta que permita **edición
cómoda para negocio** y **integración técnica para
desarrollo**. El enfoque híbrido wiki más repositorio que
vimos en el Tema 8 es un buen ejemplo de este equilibrio.

### 9.2.3. Automatización sobre proceso manual

Cada paso manual en el flujo de especificación es un punto
donde la disciplina puede fallar. Si publicar la
documentación requiere que alguien ejecute un script
manualmente, algún día se olvidará. Si verificar la
consistencia entre especificaciones requiere una revisión
visual, algún día se pasará algo por alto.

El principio es: **todo lo que se pueda automatizar, se
automatiza**. La validación de formato, la generación de
la matriz de trazabilidad, la publicación de documentación,
la verificación de enlaces entre especificaciones y la
detección de especificaciones sin tests son tareas
automatizables.

### 9.2.4. Integración sobre herramientas aisladas

Una herramienta excelente que no se conecta con el resto
del ecosistema del equipo es una herramienta que se
abandonará. Las especificaciones deben integrarse con:

- El repositorio de código (Git).
- El gestor de tareas (Jira, Azure DevOps, Linear).
- El pipeline de CI/CD (GitHub Actions, GitLab CI,
  Jenkins).
- La plataforma de documentación (wiki, portal).
- Los frameworks de testing (Cucumber, Jest, pytest).

---

## 9.3. Ecosistema de herramientas

### 9.3.1. Formatos de especificación

El formato en que se escriben las especificaciones determina
qué herramientas se pueden usar para editarlas, versionarlas,
validarlas y publicarlas.

**Markdown**: texto plano con formato ligero. Se versiona
perfectamente en Git (diffs legibles), se edita con
cualquier editor de texto, se convierte a HTML, PDF o
DOCX con herramientas como Pandoc, MkDocs o Hugo. Es el
formato más versátil para equipos técnicos.

Ventajas: ligero, universal, diffable, convertible.
Desventaja: limitado en formato visual (sin tablas
complejas, sin diagramas inline nativos).

**AsciiDoc**: similar a Markdown pero más potente. Soporta
tablas complejas, admonitions (notas, avisos, peligros),
includes de archivos y generación de documentos complejos
con Asciidoctor. Buena opción para especificaciones
técnicas detalladas.

**OpenAPI / Swagger**: formato estándar (YAML/JSON) para
especificar APIs REST. Genera documentación interactiva,
mocks, SDKs de cliente y validadores automáticamente.
Imprescindible para contratos de API.

**Gherkin (.feature)**: formato para especificaciones
ejecutables en Dado-Cuando-Entonces. Se ejecuta con
Cucumber, SpecFlow o Behave. Ideal para criterios de
aceptación automatizados.

**Formato propietario de wikis** (Confluence, Notion):
cómodo para edición colaborativa y para perfiles no
técnicos. La desventaja es la dependencia del proveedor
y la dificultad de integración con CI/CD.

### 9.3.2. Almacenamiento y versionado

**Git (GitHub, GitLab, Bitbucket)**: la opción más potente
para versionado. Las especificaciones se almacenan junto
al código o en un repositorio dedicado. Cada cambio queda
registrado con autor, fecha y mensaje. Las ramas y los
pull requests soportan el flujo de revisión.

Estructura típica de un repositorio de especificaciones:

```text
specs/
  funcional/
    FUNC-027-cancelacion-pedido.md
    FUNC-100-catalogo.md
    FUNC-110-creacion-pedido.md
    ...
  dominio/
    DN-030-descuento-volumen.md
    DN-040-transiciones-estado.md
    DN-045-gastos-envio.md
    ...
  contratos/
    API-PED-001-crear-pedido.yaml  (OpenAPI)
    API-PED-002-consultar-pedido.yaml
    API-DEV-001-crear-devolucion.yaml
    ...
  aceptacion/
    features/
      cancelacion-pedido.feature
      creacion-pedido.feature
      devolucion.feature
      ...
  plantillas/
    plantilla-funcional.md
    plantilla-dominio.md
    plantilla-contrato.md
  baselines/
    release-1.0.md
    release-2.0.md
  INDICE.md
  GLOSARIO.md
```

**Wiki (Confluence, Notion, GitBook)**: para equipos donde
negocio necesita editar directamente. La wiki puede
sincronizarse con Git mediante plugins o scripts.

**Enfoque recomendado**: Git como fuente de verdad, wiki
como interfaz de consulta. Las especificaciones se editan en
Git (o en la wiki con sincronización bidireccional) y se
publican automáticamente en la wiki o en un portal web.

### 9.3.3. Herramientas de edición y autoría

**Editores de texto/código**: VS Code, IntelliJ o cualquier
editor con soporte de Markdown/AsciiDoc. Extensiones útiles:
vista previa en tiempo real, linting de Markdown
(markdownlint), plantillas de snippets para especificaciones,
spell-check.

**Editores colaborativos en tiempo real**: HackMD,
Hedgedoc, Google Docs (para borradores). Útiles para
sesiones de Example Mapping o refinamiento donde varias
personas editan simultáneamente.

**Herramientas de diagramas**: Mermaid (integrado en
Markdown, renderizado por GitHub y MkDocs), PlantUML
(diagramas UML como texto), draw.io/diagrams.net (editor
visual), Excalidraw (diagramas de pizarra).

Mermaid es especialmente potente porque los diagramas se
almacenan como texto dentro del Markdown, se versionan
con Git y se renderizan automáticamente:

```text
(ejemplo de sintaxis Mermaid para diagramas de estado)

stateDiagram-v2
    [*] --> borrador
    borrador --> confirmado
    confirmado --> en_preparacion
    confirmado --> cancelado
    en_preparacion --> enviado
    enviado --> entregado
```

### 9.3.4. Herramientas de especificación de APIs

**Swagger Editor / Swagger UI**: editor y visualizador para
especificaciones OpenAPI. Permite editar el YAML y ver la
documentación renderizada en tiempo real.

**Stoplight Studio**: editor visual de OpenAPI con soporte
de modelado, mocks y validación. Más accesible que editar
YAML directamente.

**Postman**: plataforma de desarrollo de APIs que permite
definir colecciones, ejecutar tests contra la API y generar
documentación. Puede funcionar como herramienta de
validación de contratos.

**Pact**: framework de tests de contrato (*consumer-driven
contract testing*). El consumidor define lo que espera; el
proveedor verifica que lo cumple. Los contratos se almacenan
en un Pact Broker centralizado.

**Spring Cloud Contract**: similar a Pact pero integrado en
el ecosistema Spring. Define contratos como DSL en Groovy
o YAML y genera tests automáticamente para ambos lados.

### 9.3.5. Herramientas de especificación ejecutable

**Cucumber**: el estándar para BDD. Soporta múltiples
lenguajes: Cucumber-JVM (Java), Cucumber.js (JavaScript),
Behave (Python), SpecFlow (.NET). Los archivos `.feature`
son especificaciones legibles que se ejecutan como tests.

**FitNesse**: wiki que ejecuta tests. Las especificaciones
se escriben como tablas en páginas wiki y se ejecutan
contra el sistema. Menos popular hoy pero muy potente para
reglas de negocio tabulares.

**Concordion**: especificaciones en HTML que se ejecutan
como tests. El documento HTML es simultáneamente la
documentación y el test. Produce informes visualmente
atractivos.

### 9.3.6. Herramientas de publicación

**MkDocs (con Material for MkDocs)**: generador de sitios
estáticos a partir de Markdown. Produce un portal de
documentación navegable, con búsqueda, versionado y tema
profesional. Se integra con GitHub Pages o cualquier
hosting estático.

**Docusaurus**: similar a MkDocs pero basado en React.
Buena opción si el equipo ya trabaja con el ecosistema
JavaScript.

**Asciidoctor**: convierte AsciiDoc a HTML, PDF y EPUB.
Produce documentos de alta calidad tipográfica, ideales
para especificaciones formales en contextos regulados.

**Redocly / Swagger UI**: para publicar documentación de
APIs de forma interactiva, con la posibilidad de ejecutar
peticiones desde el navegador.

**GitHub/GitLab Pages**: hosting gratuito para sitios
estáticos generados a partir del repositorio. Ideal para
publicación automática de especificaciones.

---

## 9.4. Flujos de trabajo integrados

### 9.4.1. Flujo de creación de especificación

Un flujo integrado para crear una nueva especificación
combina las herramientas anteriores:

```text
1. El analista crea una rama en Git:
   spec/FUNC-150-nueva-funcionalidad

2. Copia la plantilla correspondiente:
   cp plantillas/plantilla-funcional.md \
      funcional/FUNC-150-nombre.md

3. Redacta la especificación en su editor
   (VS Code con preview de Markdown).

4. Ejecuta el linter localmente:
   markdownlint funcional/FUNC-150-nombre.md

5. Hace commit y push. Abre un Pull Request:
   "spec(FUNC-150): crear especificación v1.0"

6. El PR asigna revisores:
   - PO: valida la funcionalidad
   - Dev: valida la viabilidad
   - QA: valida la verificabilidad

7. Los revisores comentan en el PR.
   El analista incorpora los cambios.

8. Tras aprobación, se mergea a la rama de
   desarrollo.

9. El pipeline de CI/CD:
   a. Valida el formato (markdownlint).
   b. Actualiza el índice de especificaciones.
   c. Genera y publica la documentación en el
      portal (MkDocs → GitHub Pages).
   d. Verifica que no hay enlaces rotos entre
      especificaciones.
```

### 9.4.2. Flujo de modificación de especificación

La modificación sigue un flujo similar pero incluye el
análisis de impacto:

```text
1. Se recibe la solicitud de cambio (CR-NNN).

2. El analista realiza el análisis de impacto
   consultando la matriz de trazabilidad.

3. Con la aprobación, crea una rama:
   spec/CR-NNN-descripcion-breve

4. Modifica la especificación. Incrementa la
   versión. Actualiza el historial de cambios.

5. Modifica los artefactos dependientes
   (criterios de aceptación, tests, contratos).

6. Abre un PR con todos los cambios agrupados.

7. Revisión, aprobación, merge.

8. El pipeline valida y republica.
```

### 9.4.3. Flujo de validación continua

El pipeline de CI/CD ejecuta validaciones automáticas
cada vez que cambia una especificación:

```text
PIPELINE DE VALIDACIÓN DE ESPECIFICACIONES

Trigger: push a cualquier archivo en specs/

Paso 1: Lint
  markdownlint specs/**/*.md
  → Verifica formato y estilo.

Paso 2: Enlaces internos
  Script que verifica que toda referencia a otra
  especificación (p. ej., "ver DN-030") corresponde
  a un archivo que existe.
  → Detecta enlaces rotos.

Paso 3: Índice actualizado
  Script que compara la lista de archivos en specs/
  con el contenido de INDICE.md.
  → Detecta especificaciones no indexadas.

Paso 4: OpenAPI
  swagger-cli validate specs/contratos/*.yaml
  → Verifica que los contratos de API son válidos.

Paso 5: Cobertura de trazabilidad
  Script que extrae los tags de los tests y los
  cruza con la lista de especificaciones.
  → Genera informe de cobertura.
  → Alerta si hay especificaciones sin test.

Paso 6: Publicación
  mkdocs build && mkdocs gh-deploy
  → Publica la documentación actualizada.
```

---

## 9.5. Especificaciones vivas

### 9.5.1. Qué es una especificación viva

Una especificación viva (*living documentation*) es una
especificación que **se mantiene actualizada
automáticamente** como resultado del proceso normal de
desarrollo, en lugar de requerir un esfuerzo manual
separado para actualizarla.

Los mecanismos que hacen que una especificación esté viva:

**Especificaciones ejecutables**: los archivos `.feature`
que se ejecutan como tests son documentación viva por
definición. Si el comportamiento del sistema cambia y
alguien no actualiza el `.feature`, el test falla. La
especificación no puede quedar desactualizada en silencio.

**Documentación generada a partir del código**: las APIs
documentadas con OpenAPI que se generan a partir de
anotaciones en el código son documentación viva. Si el
endpoint cambia, la documentación se regenera
automáticamente.

**Informes generados por el pipeline**: la matriz de
trazabilidad generada automáticamente a partir de los
tags de los tests es documentación viva. El informe de
cobertura de requisitos generado en cada build es
documentación viva.

### 9.5.2. Grados de viveza

No todas las especificaciones pueden ser completamente
vivas. Un espectro práctico:

**Estática mantenida**: se actualiza manualmente pero con
disciplina. Es el caso de las especificaciones funcionales
narrativas. No se puede generar automáticamente, pero el
flujo de trabajo (PR obligatorio, revisión, pipeline)
reduce el riesgo de desactualización.

**Semi-viva**: parte de la especificación se genera o
valida automáticamente, pero la narrativa se mantiene
manualmente. Ejemplo: una especificación de API cuyo
esquema JSON se valida contra el código pero cuya
descripción funcional se escribe a mano.

**Completamente viva**: toda la especificación se genera o
valida automáticamente. Ejemplo: los contratos OpenAPI
generados desde el código, los archivos `.feature` que se
ejecutan como tests, los informes de cobertura.

### 9.5.3. Estrategia de documentación viva

Una estrategia pragmática combina los tres grados:

```text
Tipo de spec         Grado          Mecanismo
─────────────        ─────          ─────────
Funcional            Estática       PR + review + lint
                     mantenida
Caso de uso          Estática       PR + review + lint
                     mantenida
Regla de dominio     Semi-viva      Narrativa manual +
                                    tests generados
                                    desde ejemplos
Contrato de API      Viva           OpenAPI generado o
                                    validado contra
                                    código
Criterios aceptación Viva           Gherkin ejecutable
Trazabilidad         Viva           Generada desde tags
                                    de tests
Cobertura            Viva           Informe de CI/CD
```

---

## 9.6. Métricas y monitorización

### 9.6.1. Métricas útiles para SDD

Las herramientas y la automatización permiten medir el
estado de las especificaciones con métricas objetivas:

**Cobertura de requisitos**: porcentaje de especificaciones
que tienen al menos un test asociado. Objetivo: 100% para
especificaciones aprobadas.

**Cobertura de tests pasando**: porcentaje de tests
vinculados a especificaciones que pasan. Objetivo: 100%
antes de cada release.

**Especificaciones sin cambios recientes**: especificaciones
que no se han modificado en los últimos N sprints pero cuyo
código asociado sí ha cambiado. Puede indicar drift.

**Tiempo medio de revisión de especificación**: cuánto tarda
un PR de especificación desde su apertura hasta su
aprobación. Si es excesivo, el flujo de revisión tiene un
cuello de botella.

**Ratio de cambios con análisis de impacto**: porcentaje de
cambios de especificación que pasaron por análisis de
impacto formal. Objetivo: 100% para cambios medios y
mayores.

**Deuda de especificación**: número de funcionalidades
implementadas que no tienen especificación completa o
actualizada.

### 9.6.2. Dashboard de salud de especificaciones

Un dashboard sencillo que muestre estas métricas en cada
build o sprint ayuda al equipo a mantener la disciplina:

```text
DASHBOARD DE ESPECIFICACIONES — Sprint 8

Especificaciones totales:          18
  Con test asociado:               16 (89%)
  Sin test:                         2 (11%) ⚠
  Tests pasando:                   15 (94%)
  Tests fallando:                   1 ( 6%) ✗

PRs de spec abiertos:               3
  > 5 días sin revisión:            1 ⚠

Specs sin cambio > 3 sprints
  con código modificado:            2 ⚠

Deuda de especificación:            3 funcionalidades
```

---

## 9.7. Resumen del tema

Las herramientas y la automatización son lo que convierte
los principios de SDD en una práctica sostenible.

Puntos clave:

- Las especificaciones son artefactos de primera clase que
  merecen versionado, revisión, publicación y validación
  automatizada.
- El formato (Markdown, OpenAPI, Gherkin) determina qué
  herramientas se pueden usar. Markdown es el más versátil
  para especificaciones narrativas; OpenAPI es imprescindible
  para APIs; Gherkin es ideal para criterios de aceptación
  ejecutables.
- Git es la base del versionado. La estructura del
  repositorio organiza las especificaciones por tipo con
  plantillas, baselines e índice.
- Los flujos de trabajo integrados (creación, modificación,
  validación continua) combinan edición, linting, revisión
  por PR, validación en CI/CD y publicación automática.
- Las especificaciones vivas se mantienen actualizadas como
  resultado del proceso normal de desarrollo: tests
  ejecutables, contratos generados, informes de CI/CD.
- Las métricas (cobertura, tests pasando, deuda de
  especificación) permiten monitorizar la salud del
  ecosistema de especificaciones.

---

## Laboratorios del Tema 9

### Laboratorio 9.1: Configuración de repositorio para especificaciones versionadas

#### Enunciado del laboratorio 9.1

**Objetivo**: diseñar y configurar la estructura completa de
un repositorio Git para las especificaciones del proyecto B2B,
incluyendo la organización de directorios, las plantillas, la
configuración de linting y el índice general.

**Contexto**: el equipo del proyecto B2B ha decidido migrar
sus especificaciones desde documentos Word dispersos en
SharePoint a un repositorio Git con Markdown. Se necesita
una estructura clara, plantillas reutilizables y validación
automatizada.

**Instrucciones**:

1. Diseña la estructura completa de directorios del
   repositorio.
2. Crea el archivo de índice general (INDICE.md) con
   todas las especificaciones existentes del proyecto.
3. Crea una plantilla base para cada tipo de especificación
   (funcional, dominio, contrato API).
4. Define la configuración de markdownlint para el
   repositorio.
5. Escribe el archivo README.md del repositorio con las
   instrucciones de uso para el equipo.
6. Define las reglas del archivo CODEOWNERS para asignar
   revisores automáticos.

#### Solución del laboratorio 9.1

##### Estructura de directorios

```text
sdd-tienda-b2b/
  README.md
  INDICE.md
  GLOSARIO.md
  .markdownlint.json
  CODEOWNERS
  mkdocs.yml
  scripts/
    validar-enlaces.sh
    generar-indice.sh
    generar-cobertura.sh
  plantillas/
    PLANTILLA-FUNCIONAL.md
    PLANTILLA-DOMINIO.md
    PLANTILLA-CONTRATO-API.md
    PLANTILLA-ACEPTACION.md
  specs/
    funcional/
      FUNC-027-cancelacion-pedido.md
      FUNC-100-catalogo.md
      FUNC-110-creacion-pedido.md
      FUNC-120-aprobacion-pedidos.md
      FUNC-130-devolucion.md
      FUNC-140-dashboard.md
    dominio/
      DN-008-politica-cancelaciones.md
      DN-020-precios-especiales.md
      DN-030-descuento-volumen.md
      DN-035-resolucion-conflictos.md
      DN-040-transiciones-estado.md
      DN-045-gastos-envio.md
      DN-055-descuento-fidelidad.md
      DN-070-codigo-promocional.md
    contratos/
      API-PED-001-crear-pedido.yaml
      API-PED-001-crear-pedido.md
      API-PED-002-consultar-pedido.yaml
      API-PED-002-consultar-pedido.md
      API-DEV-001-crear-devolucion.yaml
      API-DEV-001-crear-devolucion.md
    seguridad/
      SEC-010-consentimiento-datos.md
    rendimiento/
      PERF-010-checkout.md
      PERF-020-catalogo.md
    aceptacion/
      features/
        cancelacion-pedido.feature
        creacion-pedido.feature
        devolucion.feature
        catalogo.feature
  baselines/
    release-1.0.md
    release-2.0.md
  cambios/
    CR-085-tramos-volumen.md
    CR-090-codigo-promocional.md
  .github/
    pull_request_template.md
    workflows/
      validar-specs.yml
```

##### Archivo INDICE.md

```text
# Índice de especificaciones

## Especificaciones funcionales

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| FUNC-027 | Cancelación de pedido | v2.0 | Implementada |
| FUNC-100 | Catálogo con precios | v1.3 | Implementada |
| FUNC-110 | Creación de pedido | v1.1 | Implementada |
| FUNC-120 | Aprobación de pedidos | v1.0 | Implementada |
| FUNC-130 | Solicitud devolución | v1.2 | Implementada |
| FUNC-140 | Dashboard de ventas | v1.0 | En desarrollo |

## Reglas de dominio

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| DN-008 | Política cancelaciones | v1.1 | Aprobada |
| DN-020 | Precios especiales | v1.0 | Implementada |
| DN-030 | Descuento por volumen | v2.0 | Implementada |
| DN-035 | Resolución conflictos | v1.1 | Implementada |
| DN-040 | Transiciones de estado | v2.0 | Implementada |
| DN-045 | Gastos de envío | v1.0 | Implementada |
| DN-055 | Descuento fidelidad | v1.0 | Implementada |
| DN-070 | Código promocional | v1.0 | En desarrollo |

## Contratos de API

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| API-PED-001 | Crear pedido | v2.2 | Implementada |
| API-PED-002 | Consultar pedido | v1.0 | Implementada |
| API-DEV-001 | Crear devolución | v1.0 | Implementada |

## Seguridad y rendimiento

| ID | Título | Versión | Estado |
| --- | --- | --- | --- |
| SEC-010 | Consentimiento datos | v1.0 | Implementada |
| PERF-010 | Rendimiento checkout | v1.0 | Implementada |
| PERF-020 | Rendimiento catálogo | v1.0 | Pendiente |
```

##### Plantilla funcional (PLANTILLA-FUNCIONAL.md)

```text
# [ID]: [Título]

## Metadatos

| Campo | Valor |
| --- | --- |
| ID | [FUNC-NNN] |
| Título | [Título descriptivo] |
| Versión | [N.M] |
| Estado | [Borrador/En revisión/Aprobada/Implementada/Obsoleta] |
| Autor | [Nombre — Fecha] |
| Última mod. | [Nombre — Fecha (descripción)] |
| Prioridad | [Crítica/Alta/Media/Baja] |

## Contexto y motivación

[¿Por qué existe esta especificación? ¿Qué problema
resuelve? 2-4 frases.]

## Alcance

Cubre: [lista de lo que incluye]

No cubre: [lista de lo que excluye, con referencia
a otras specs si aplica]

## Precondiciones

- PRE-1. [Condición]
- PRE-2. [Condición]

## Descripción

[Cuerpo principal de la especificación.
Comportamiento paso a paso, reglas, flujos.]

## Postcondiciones de éxito

- POST-1. [Condición]
- POST-2. [Condición]

## Postcondiciones de fallo

- POST-F1. [Condición]

## Casos especiales y errores

| Caso | Comportamiento |
| --- | --- |
| [Caso 1] | [Qué hace el sistema] |
| [Caso 2] | [Qué hace el sistema] |

## Criterios de verificación

- CV-1. [Precondición] → [Acción] → [Resultado]
- CV-2. [Precondición] → [Acción] → [Resultado]

## Dependencias

Depende de: [lista con IDs]

Es requerida por: [lista con IDs]

## Historial de cambios

| Versión | Fecha | Autor | Cambio |
| --- | --- | --- | --- |
| 1.0 | AAAA-MM-DD | [Nombre] | Creación inicial |
```

##### Configuración de markdownlint (.markdownlint.json)

```text
{
  "default": true,
  "MD013": {
    "line_length": 72,
    "code_blocks": false,
    "tables": false
  },
  "MD024": {
    "siblings_only": true
  },
  "MD033": false,
  "MD041": false
}
```

Justificación de cada regla:

- MD013: línea máxima de 72 caracteres (legible en
  cualquier editor), pero no se aplica a bloques de código
  ni tablas que necesitan más espacio.
- MD024: permite headings duplicados si están en
  secciones distintas (misma estructura en cada
  especificación).
- MD033: desactivada para permitir HTML inline cuando sea
  necesario (algunos diagramas o anchors).
- MD041: desactivada para no forzar que el primer
  elemento sea un heading (algunos archivos empiezan con
  metadatos).

##### README.md del repositorio

```text
# Especificaciones — Tienda Online B2B

Repositorio de especificaciones del proyecto de tienda
online B2B, gestionadas siguiendo Spec Driven
Development (SDD).

## Estructura

- **specs/funcional/**: especificaciones funcionales
- **specs/dominio/**: reglas de dominio
- **specs/contratos/**: contratos de API (OpenAPI +
  narrativa)
- **specs/seguridad/**: especificaciones de seguridad
- **specs/rendimiento/**: especificaciones de
  rendimiento
- **specs/aceptacion/**: criterios de aceptación
  ejecutables (.feature)
- **plantillas/**: plantillas base para nuevas specs
- **baselines/**: baselines de cada release
- **cambios/**: solicitudes de cambio documentadas

## Cómo crear una nueva especificación

1. Crear rama: spec/[ID]-descripcion-breve
2. Copiar la plantilla correspondiente de plantillas/
3. Rellenar todos los campos
4. Ejecutar: markdownlint specs/
5. Abrir Pull Request con revisores asignados
6. Tras aprobación, mergear a develop

## Cómo modificar una especificación

1. Crear solicitud de cambio en cambios/CR-NNN.md
2. Realizar análisis de impacto
3. Obtener aprobación del PO
4. Crear rama: spec/CR-NNN-descripcion
5. Modificar spec, incrementar versión, actualizar
   historial
6. Actualizar artefactos dependientes
7. Abrir PR, revisión, merge

## Convención de commits

  spec(ID): descripción [CR-NNN]
  test(ID): descripción [CR-NNN]
  docs: descripción

## Validación local

  markdownlint specs/**/*.md
  bash scripts/validar-enlaces.sh

## Publicación

La documentación se publica automáticamente en
GitHub Pages con cada merge a main.
URL: https://equipo.github.io/sdd-tienda-b2b/

## Revisores

Ver archivo CODEOWNERS para la asignación automática
de revisores por área.
```

##### Archivo CODEOWNERS

```text
# Revisores automáticos por área

# Especificaciones funcionales: PO + Analista
specs/funcional/    @laura-po @maria-analista

# Reglas de dominio: Analista + Tech Lead
specs/dominio/      @maria-analista @carlos-techlead

# Contratos de API: Tech Lead + Dev Backend
specs/contratos/    @carlos-techlead @dev-backend-team

# Seguridad: Tech Lead + Security Champion
specs/seguridad/    @carlos-techlead @security-champion

# Rendimiento: Tech Lead + SRE
specs/rendimiento/  @carlos-techlead @sre-team

# Aceptación: QA + Analista
specs/aceptacion/   @ana-qa @maria-analista

# Plantillas y configuración: Tech Lead
plantillas/         @carlos-techlead
.markdownlint.json  @carlos-techlead
mkdocs.yml          @carlos-techlead
```

---

### Laboratorio 9.2: Flujo de revisión colaborativa de especificaciones

#### Enunciado del laboratorio 9.2

**Objetivo**: diseñar y documentar el flujo completo de
revisión colaborativa de especificaciones para el proyecto
B2B, incluyendo la plantilla de PR, los criterios de
revisión por rol y el proceso de resolución de comentarios.

**Instrucciones**:

1. Crea la plantilla de Pull Request para cambios en
   especificaciones.
2. Define los criterios de revisión específicos para cada
   rol (PO, desarrollo, QA).
3. Diseña el flujo de resolución de comentarios (cómo se
   gestionan las discrepancias entre revisores).
4. Documenta al menos 3 ejemplos de revisiones reales:
   un PR que se aprueba, uno que requiere cambios y uno
   que se rechaza.
5. Define las métricas de efectividad del proceso de
   revisión.

#### Solución del laboratorio 9.2

##### Plantilla de Pull Request

```text
## Tipo de cambio

- [ ] Nueva especificación
- [ ] Modificación de especificación existente
- [ ] Corrección menor (typo, clarificación)
- [ ] Cambio de plantilla o configuración

## Especificaciones afectadas

| ID | Versión anterior | Versión nueva |
| --- | --- | --- |
| | | |

## Solicitud de cambio asociada

CR-NNN (enlace) o "N/A" si es nueva spec.

## Descripción del cambio

[Resumen de qué se cambia y por qué, en 2-3 frases.]

## Análisis de impacto

- [ ] He verificado qué artefactos dependen de esta
  especificación.
- [ ] He actualizado o creado tickets para los
  artefactos afectados (tests, código, docs).
- Artefactos afectados: [lista]

## Checklist de calidad

- [ ] El formato pasa markdownlint sin errores.
- [ ] Los identificadores siguen la convención.
- [ ] El historial de cambios está actualizado.
- [ ] Los ejemplos numéricos están verificados.
- [ ] Las dependencias están actualizadas.
- [ ] Los criterios de verificación son concretos
  y ejecutables.

## Checklist de trazabilidad

- [ ] La spec tiene ID único.
- [ ] Las dependencias referencian specs existentes.
- [ ] Los criterios de aceptación tienen ID asignado.
- [ ] Se han creado tickets para los tests pendientes.

## Notas para los revisores

[Puntos específicos donde se necesita feedback o
decisiones abiertas.]
```

##### Criterios de revisión por rol

**Revisión del Product Owner**:

```text
1. ¿La especificación refleja correctamente la
   necesidad de negocio?
2. ¿Los casos especiales y las excepciones cubren
   los escenarios reales del negocio?
3. ¿Las reglas de negocio son correctas?
   (especialmente cálculos y umbrales)
4. ¿La prioridad y el alcance son coherentes con
   la estrategia del producto?
5. ¿El lenguaje es comprensible para un
   stakeholder no técnico?
6. ¿Falta algún caso que el negocio considere
   importante?
```

**Revisión de Desarrollo**:

```text
1. ¿La especificación es implementable tal como
   está descrita?
2. ¿Hay ambigüedades que obligarían al
   desarrollador a tomar decisiones de diseño
   no documentadas?
3. ¿Las precondiciones y postcondiciones son
   técnicamente verificables?
4. ¿Los contratos de API son coherentes con la
   arquitectura actual?
5. ¿Las dependencias técnicas están identificadas?
6. ¿Hay implicaciones de rendimiento, seguridad o
   escalabilidad no contempladas?
```

**Revisión de QA**:

```text
1. ¿Cada criterio de verificación es concreto,
   ejecutable y tiene datos específicos?
2. ¿Están cubiertos los casos negativos y los
   casos límite?
3. ¿Los escenarios GWT tienen precondiciones
   suficientes para ser reproducibles?
4. ¿Hay flujos excepcionales sin criterio de
   verificación?
5. ¿Los ejemplos numéricos son correctos?
   (recalcular manualmente al menos 2)
6. ¿Se puede estimar el esfuerzo de testing a
   partir de los criterios?
```

##### Flujo de resolución de comentarios

```text
FLUJO DE RESOLUCIÓN

1. El revisor deja un comentario en el PR
   clasificado con un prefijo:

   [BLOQUEA] → El PR no se puede mergear sin
     resolver esto. Errores de contenido, reglas
     incorrectas, huecos críticos.

   [MEJORA] → Se recomienda cambiar, pero no
     bloquea. Clarificaciones, ejemplos
     adicionales, estilo.

   [PREGUNTA] → Necesita aclaración antes de
     aprobar o rechazar.

   [NOTA] → Información para el autor, no
     requiere acción.

2. El autor responde a cada comentario:
   - Si acepta: aplica el cambio y marca como
     resuelto.
   - Si no acepta: explica por qué y solicita
     segunda opinión.

3. Si hay desacuerdo entre autor y revisor:
   - Se busca consenso en el hilo del PR.
   - Si no hay consenso, el responsable de la
     especificación (CODEOWNERS) toma la decisión.
   - Si afecta a negocio, el PO decide.
   - Si afecta a viabilidad técnica, el Tech Lead
     decide.

4. El PR se aprueba cuando:
   - Todos los comentarios [BLOQUEA] están
     resueltos.
   - Al menos un revisor de cada rol ha aprobado.
   - El checklist de calidad está completado.

5. El autor hace el merge tras la aprobación.
```

##### Ejemplos de revisiones

##### Ejemplo 1: PR aprobado sin cambios

```text
PR #42: spec(DN-070): crear especificación de
  descuento por código promocional v1.0 [CR-090]

Revisor PO (Laura):
  [NOTA] La tabla de porcentajes es clara. Los
  ejemplos numéricos coinciden con lo que acordamos.
  ✅ Aprobado.

Revisor Dev (Carlos):
  [NOTA] Implementable sin problemas. Los tramos
  se pueden externalizar en configuración.
  ✅ Aprobado.

Revisor QA (Ana):
  [NOTA] Los 5 criterios de verificación son
  suficientes y concretos. He verificado los
  ejemplos 1 y 3 manualmente: correctos.
  ✅ Aprobado.

Resultado: merge inmediato.
```

##### Ejemplo 2: PR con cambios solicitados

```text
PR #45: spec(FUNC-150): especificación de
  notificaciones push v1.0

Revisor PO (Laura):
  [MEJORA] Falta mencionar que las notificaciones
  deben poder desactivarse por el cliente. Es un
  requisito legal (opt-out).
  [PREGUNTA] ¿Las notificaciones de pedido
  cancelado son push o solo email?

Revisor Dev (Carlos):
  [BLOQUEA] No se menciona qué servicio de push se
  usará (Firebase, OneSignal). Esto afecta al
  diseño y a los costes. Necesitamos decidirlo
  antes de aprobar.
  [MEJORA] Añadir un requisito de latencia máxima
  para las notificaciones push.

Revisor QA (Ana):
  [BLOQUEA] El criterio CV-3 dice "el cliente
  recibe la notificación" pero no indica en qué
  plazo ni cómo se verifica (¿hay un servicio de
  test de push?).

Resultado: el autor resuelve los comentarios en
dos rondas. Tras la segunda revisión, se aprueba.
```

##### Ejemplo 3: PR rechazado

```text
PR #48: spec(DN-080): descuento por pronto pago

Revisor PO (Laura):
  [BLOQUEA] Esta funcionalidad no está en el
  roadmap del release 2 ni del release 3. No la
  he solicitado y no encaja con la estrategia
  comercial actual. Si es una propuesta del
  equipo, debe pasar por el proceso de solicitud
  de cambio primero.

Resultado: PR cerrado. El autor crea una
solicitud de cambio (CR-102) para evaluar la
funcionalidad en el siguiente ciclo de
planificación. No se pierde el trabajo: la rama
se conserva como borrador.
```

##### Métricas de efectividad del proceso

```text
MÉTRICAS DE REVISIÓN — Mensual

Tiempo medio de revisión:
  Desde apertura del PR hasta primera revisión
  completa (todos los roles).
  Objetivo: < 2 días laborables.

Tasa de aprobación en primera ronda:
  PRs aprobados sin necesidad de cambios / total.
  Objetivo: > 60%.
  Indica calidad del borrador inicial.

Número medio de comentarios [BLOQUEA] por PR:
  Si es alto, indica que los borradores llegan
  con huecos frecuentes. Formación o revisión
  del proceso de redacción.

Tasa de PRs abandonados:
  PRs abiertos que se cierran sin merge / total.
  Objetivo: < 10%.
  Si es alto, indica desalineación entre lo que
  se propone y lo que se necesita.

Tiempo medio de resolución de comentarios:
  Desde que se deja un comentario [BLOQUEA]
  hasta que se marca como resuelto.
  Objetivo: < 1 día laborable.
```

---

### Laboratorio 9.3: Publicación automatizada de documentación viva

#### Enunciado del laboratorio 9.3

**Objetivo**: diseñar y configurar el pipeline completo de
publicación automatizada de las especificaciones del
proyecto B2B como documentación viva accesible por todo el
equipo.

**Instrucciones**:

1. Elige la herramienta de publicación y justifica la
   elección.
2. Diseña la configuración del generador de documentación
   (estructura del sitio, navegación, tema).
3. Escribe el pipeline de CI/CD que valida y publica
   automáticamente.
4. Define qué contenido se genera automáticamente (índices,
   cobertura, informes) y qué se mantiene manualmente.
5. Diseña la página de inicio del portal de especificaciones
   con acceso rápido a las métricas clave.
6. Documenta el proceso de recuperación si la publicación
   falla.

#### Solución del laboratorio 9.3

##### Elección de herramienta: MkDocs con Material

Se elige MkDocs con el tema Material for MkDocs por las
siguientes razones:

- Los archivos fuente son Markdown puro, que es el formato
  del repositorio.
- Genera un sitio estático rápido, con búsqueda integrada.
- El tema Material ofrece navegación por pestañas, tabla
  de contenidos, modo oscuro y diseño responsive.
- Soporta Mermaid para diagramas renderizados desde
  Markdown.
- Se integra con GitHub Pages para hosting gratuito.
- Soporta versionado de documentación (mike).

##### Configuración de MkDocs (mkdocs.yml)

```text
site_name: "Especificaciones — Tienda B2B"
site_url: "https://equipo.github.io/sdd-tienda-b2b/"
repo_url: "https://github.com/equipo/sdd-tienda-b2b"

theme:
  name: material
  language: es
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.top
    - search.suggest
    - content.code.copy
  palette:
    - scheme: default
      primary: indigo

nav:
  - Inicio: index.md
  - Índice: INDICE.md
  - Glosario: GLOSARIO.md
  - Funcional:
    - FUNC-027 Cancelación: specs/funcional/FUNC-027.md
    - FUNC-100 Catálogo: specs/funcional/FUNC-100.md
    - FUNC-110 Pedido: specs/funcional/FUNC-110.md
    - FUNC-120 Aprobación: specs/funcional/FUNC-120.md
    - FUNC-130 Devolución: specs/funcional/FUNC-130.md
    - FUNC-140 Dashboard: specs/funcional/FUNC-140.md
  - Dominio:
    - DN-030 Volumen: specs/dominio/DN-030.md
    - DN-040 Estados: specs/dominio/DN-040.md
    - DN-045 Envío: specs/dominio/DN-045.md
    - DN-055 Fidelidad: specs/dominio/DN-055.md
    - DN-070 Promo: specs/dominio/DN-070.md
  - Contratos API:
    - API-PED-001: specs/contratos/API-PED-001.md
    - API-PED-002: specs/contratos/API-PED-002.md
    - API-DEV-001: specs/contratos/API-DEV-001.md
  - Seguridad: specs/seguridad/SEC-010.md
  - Rendimiento:
    - PERF-010: specs/rendimiento/PERF-010.md
    - PERF-020: specs/rendimiento/PERF-020.md
  - Baselines:
    - Release 1.0: baselines/release-1.0.md
    - Release 2.0: baselines/release-2.0.md
  - Informes:
    - Cobertura: informes/cobertura.md
    - Métricas: informes/metricas.md

plugins:
  - search
  - mermaid2

markdown_extensions:
  - tables
  - admonition
  - pymdownx.details
  - pymdownx.superfences
```

##### Pipeline de CI/CD (GitHub Actions)

```text
# .github/workflows/validar-specs.yml

name: Validar y publicar especificaciones

on:
  push:
    branches: [main, develop, "release/**"]
    paths: ["specs/**", "mkdocs.yml", "INDICE.md"]
  pull_request:
    paths: ["specs/**"]

jobs:
  validar:
    name: Validar especificaciones
    runs-on: ubuntu-latest
    steps:

      - name: Checkout
        uses: actions/checkout@v4

      - name: Instalar herramientas
        run: |
          npm install -g markdownlint-cli
          pip install mkdocs-material

      - name: Lint Markdown
        run: markdownlint specs/**/*.md

      - name: Validar enlaces internos
        run: bash scripts/validar-enlaces.sh

      - name: Validar OpenAPI
        run: |
          npm install -g @apidevtools/swagger-cli
          swagger-cli validate specs/contratos/*.yaml

      - name: Verificar índice actualizado
        run: bash scripts/generar-indice.sh --check

      - name: Generar informe de cobertura
        run: bash scripts/generar-cobertura.sh

      - name: Build de documentación (verificar)
        run: mkdocs build --strict

  publicar:
    name: Publicar documentación
    needs: validar
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:

      - name: Checkout
        uses: actions/checkout@v4

      - name: Instalar MkDocs
        run: pip install mkdocs-material

      - name: Publicar en GitHub Pages
        run: mkdocs gh-deploy --force
```

Explicación del pipeline:

- Se ejecuta en cada push que afecte a specs o en PRs.
- El job "validar" ejecuta 6 pasos de validación: lint
  de Markdown, enlaces internos, contratos OpenAPI, índice
  actualizado, informe de cobertura y build de prueba.
- El job "publicar" solo se ejecuta en la rama main (tras
  merge) y despliega la documentación en GitHub Pages.
- Si algún paso de validación falla, el PR no se puede
  mergear (con branch protection rules configuradas).

##### Contenido generado vs. manual

```text
GENERADO AUTOMÁTICAMENTE:
  - Sitio web completo (MkDocs desde Markdown)
  - Navegación y búsqueda (MkDocs)
  - Diagramas renderizados (Mermaid)
  - Informe de cobertura de requisitos
    (script desde tags de tests)
  - Verificación de enlaces internos
  - Detección de specs no indexadas

MANTENIDO MANUALMENTE:
  - Contenido de cada especificación
  - Índice general (INDICE.md)
  - Glosario (GLOSARIO.md)
  - Baselines de release
  - Solicitudes de cambio
  - Navegación en mkdocs.yml (al añadir nueva spec)
```

##### Página de inicio del portal (index.md)

```text
# Especificaciones — Tienda Online B2B

Portal de especificaciones del proyecto de tienda
online B2B para distribución de material de oficina.

## Estado del proyecto

| Métrica | Valor |
| --- | --- |
| Especificaciones totales | 18 |
| Implementadas | 16 (89%) |
| Con tests | 16 (89%) |
| Tests pasando | 58/59 (98%) |
| Último release | 2.0 (2025-05-15) |
| Próximo release | 3.0 (previsto 2025-07-01) |

## Acceso rápido

- Índice completo de especificaciones
- Glosario de términos del dominio
- Baseline del release actual (2.0)
- Informe de cobertura de requisitos
- Solicitudes de cambio pendientes

## Últimos cambios

- 2025-04-28: DN-030 v2.0 — Nuevos tramos de
  descuento por volumen (CR-085)
- 2025-04-30: DN-040 v2.0 — Aprobación exprés y
  cancelación parcial
- 2025-05-02: DN-070 v1.0 — Código promocional
  (CR-090)
- 2025-05-10: FUNC-140 v1.0 — Dashboard de ventas
  (en desarrollo)

## Cómo contribuir

Consulta el README del repositorio para
instrucciones sobre cómo crear, modificar y
revisar especificaciones.
```

##### Proceso de recuperación ante fallo

```text
PROCEDIMIENTO DE RECUPERACIÓN

Escenario 1: el lint falla en un PR
  Causa: el autor no ejecutó markdownlint local.
  Acción: el autor corrige los errores indicados
  en el log del pipeline y hace push.
  Prevención: añadir pre-commit hook que ejecute
  markdownlint antes del commit.

Escenario 2: la publicación falla
  Causa: error en MkDocs (referencia a archivo
  inexistente en mkdocs.yml, Markdown con sintaxis
  que MkDocs no soporta).
  Acción:
    1. La documentación publicada NO se actualiza
       (GitHub Pages mantiene la última versión
       correcta).
    2. El equipo recibe notificación del fallo
       (alertas de GitHub Actions).
    3. Se crea un hotfix en una rama, se corrige
       el error y se mergea.
    4. El pipeline se re-ejecuta y publica.
  Tiempo máximo de resolución: 4 horas laborables.

Escenario 3: GitHub Pages no disponible
  Causa: incidencia del servicio de GitHub.
  Acción: las especificaciones siguen disponibles
  en el repositorio Git (fuente de verdad). El
  equipo consulta los archivos Markdown directamente
  hasta que el servicio se restaure.
  Alternativa: si la indisponibilidad se prolonga,
  desplegar temporalmente en otro hosting (Netlify,
  Vercel) con un build manual de MkDocs.

Escenario 4: pérdida de datos del repositorio
  Causa: borrado accidental o corrupción.
  Acción: restaurar desde cualquier clon local del
  repositorio (cada miembro del equipo tiene una
  copia completa). Git es distribuido por diseño.
  Prevención: backup diario del repositorio en
  almacenamiento externo.
```
