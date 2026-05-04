# Tema 8. Evolución y versionado de especificaciones

## 8.1. Introducción

En todos los temas anteriores hemos trabajado con
especificaciones como si fueran estáticas: se redactan,
se aprueban, se implementan. Pero la realidad de cualquier
proyecto software es que **los requisitos cambian**.

Las razones son múltiples y legítimas: el mercado evoluciona,
la regulación se actualiza, los usuarios descubren nuevas
necesidades, el equipo técnico identifica restricciones que
obligan a replantear decisiones, un competidor lanza una
funcionalidad que cambia las prioridades. En un proyecto de
duración media, entre el 30% y el 50% de los requisitos
iniciales sufren alguna modificación antes de llegar a
producción.

El problema no es que los requisitos cambien. El problema es
que cambien **sin control**: sin registrar qué se modificó,
sin evaluar el impacto, sin actualizar los artefactos
dependientes y sin que todo el equipo trabaje sobre la misma
versión de la verdad.

En SDD, las especificaciones son la fuente de verdad. Si esa
fuente cambia de forma descontrolada, todo el sistema de
alineación se desmorona. Este tema aborda cómo gestionar la
evolución de las especificaciones con la misma disciplina con
la que se gestiona el código fuente: con versionado, control
de cambios, análisis de impacto y gobierno.

---

## 8.2. Por qué cambian las especificaciones

### 8.2.1. Fuentes de cambio

Los cambios en las especificaciones provienen de distintas
fuentes que conviene identificar porque cada una requiere
un tratamiento diferente:

**Cambio de negocio**: el stakeholder modifica una regla,
añade una funcionalidad o cambia una prioridad. Ejemplo:
"El descuento por volumen ahora empieza en 75 unidades en
lugar de 50." Es el tipo de cambio más frecuente y suele
venir con urgencia.

**Descubrimiento técnico**: durante la implementación, el
equipo descubre que una decisión de la especificación es
inviable, ineficiente o tiene consecuencias no previstas.
Ejemplo: "La sincronización en tiempo real con el ERP
requiere una licencia adicional de 50.000 € que no estaba
presupuestada."

**Cambio regulatorio**: una nueva normativa o una
actualización de la existente obliga a modificar el
comportamiento del sistema. Ejemplo: "La nueva directiva
de facturación electrónica exige un formato de factura
diferente a partir del 1 de julio."

**Feedback de usuarios**: tras un release o una demo, los
usuarios proporcionan información que revela necesidades no
contempladas o comportamientos inadecuados. Ejemplo: "Los
clientes no encuentran el botón de repetir pedido; debería
estar más visible en el historial."

**Corrección de errores en la especificación**: se detecta
que la especificación original contenía un error, una
ambigüedad o una inconsistencia con otra especificación.
Ejemplo: "DN-030 dice que el descuento se aplica sobre el
precio base, pero DN-035 asume que se aplica sobre el
precio con IVA."

**Optimización y mejora continua**: el equipo propone
mejoras basadas en datos de uso, métricas de rendimiento
o prácticas del sector. Ejemplo: "Los datos muestran que
el 80% de los pedidos tienen menos de 5 líneas; optimizar
la interfaz de checkout para ese caso."

### 8.2.2. Impacto según el momento del cambio

El coste de un cambio depende enormemente del momento en
que se produce:

```text
Momento del cambio         Coste relativo   Artefactos
                                            afectados
─────────────────          ──────────────   ──────────
Durante especificación     1x               Solo la spec
Antes de implementar       2-3x             Spec + diseño
Durante implementación     5-10x            Spec + código +
                                            tests
Después del release        20-50x           Todo + datos en
                                            producción +
                                            comunicación a
                                            usuarios
```

Esta es la razón fundamental por la que SDD invierte en
especificar bien antes de construir: cada hora invertida
en la especificación ahorra días de retrabajo posterior.
Pero esto no significa que los cambios tardíos deban
rechazarse; significa que deben gestionarse con conciencia
de su coste.

---

## 8.3. Versionado de especificaciones

### 8.3.1. Por qué versionar

Versionar las especificaciones permite:

- **Saber qué versión está implementada**: si el código
  implementa la versión 1.2 de FUNC-027 pero la versión
  actual es la 1.4, sabemos que hay dos cambios pendientes
  de implementar.
- **Rastrear la historia**: qué cambió, cuándo y por qué.
  Esencial para auditoría y para entender decisiones
  pasadas.
- **Gestionar la concurrencia**: si dos personas modifican
  la misma especificación, el versionado permite detectar
  y resolver conflictos.
- **Coordinar releases**: cada release se vincula a una
  versión concreta de cada especificación, creando una
  "foto" del comportamiento esperado del sistema en ese
  momento.

### 8.3.2. Esquema de versionado

El esquema más práctico para especificaciones usa dos
niveles, inspirado en el versionado semántico del software:

**Versión mayor** (1.0 → 2.0): cambio sustancial que
modifica el comportamiento observable del sistema o que
rompe la compatibilidad con la implementación existente.
Ejemplo: cambiar la política de cancelaciones de 2 horas
a 24 horas, añadir un flujo completamente nuevo.

**Versión menor** (1.0 → 1.1): cambio que añade detalle,
corrige una ambigüedad o precisa un caso no contemplado
sin modificar el comportamiento principal. Ejemplo: añadir
un caso límite, clarificar el mensaje de error, corregir
un ejemplo numérico.

Regla práctica: si el cambio puede requerir modificación
de código, es versión mayor. Si solo afecta a la
documentación o a los tests, es versión menor.

### 8.3.3. Registro de cambios

Cada especificación debe incluir un historial de cambios
que registre:

```text
HISTORIAL DE CAMBIOS

Versión  Fecha       Autor     Cambio
───────  ─────       ─────     ──────
1.0      2025-03-15  María L.  Creación inicial
1.1      2025-03-22  Carlos R. Añadido caso límite:
                               producto descatalogado
1.2      2025-04-02  Carlos R. Añadido límite temporal
                               de 2 horas (CR-042)
2.0      2025-04-20  María L.  Ampliado plazo de
                               cancelación a 4 horas
                               y añadida cancelación
                               parcial (CR-067)
```

El campo "Cambio" incluye una referencia a la solicitud
de cambio (CR-NNN, *change request*) que originó la
modificación, lo que permite trazar el cambio hasta su
causa.

### 8.3.4. Almacenamiento y herramientas

Las especificaciones se pueden versionar con las mismas
herramientas que el código:

**Git**: las especificaciones en Markdown se almacenan
en el repositorio junto al código. Cada cambio se registra
con un commit que incluye el motivo. Las ramas y los pull
requests permiten revisión colaborativa.

Ventajas: trazabilidad completa, integración con CI/CD,
revisión por pares, diff visual.

Desventaja: barrera de entrada para perfiles no técnicos.

**Wiki o plataforma colaborativa** (Confluence, Notion,
GitBook): las especificaciones se editan en una plataforma
web con historial de versiones integrado.

Ventajas: accesible para todos los perfiles, edición
visual, comentarios en línea.

Desventaja: el historial es menos granular que Git,
difícil de integrar con CI/CD.

**Enfoque híbrido**: las especificaciones se editan en la
wiki para facilitar la colaboración y se exportan a
Markdown en el repositorio Git como parte del pipeline de
documentación. El repositorio es la fuente de verdad
versionada; la wiki es la interfaz de edición.

---

## 8.4. Gestión de cambios

### 8.4.1. Proceso de gestión de cambios

Un cambio en una especificación no es simplemente "editar
el documento". En SDD, un cambio sigue un proceso que
garantiza que se evalúa, se aprueba, se implementa y se
verifica de forma controlada:

```text
  ┌────────────────┐
  │ 1. Solicitud   │  Alguien identifica la
  │    de cambio   │  necesidad de modificar
  └───────┬────────┘  una especificación
          ▼
  ┌────────────────┐
  │ 2. Análisis    │  Se evalúa el impacto
  │    de impacto  │  técnico y funcional
  └───────┬────────┘
          ▼
  ┌────────────────┐
  │ 3. Decisión    │  Se aprueba, se rechaza
  │                │  o se pospone
  └───────┬────────┘
          ▼
  ┌────────────────┐
  │ 4. Actualización│  Se modifica la
  │    de la spec  │  especificación
  └───────┬────────┘
          ▼
  ┌────────────────┐
  │ 5. Propagación │  Se actualizan artefactos
  │                │  dependientes
  └───────┬────────┘
          ▼
  ┌────────────────┐
  │ 6. Verificación│  Se confirma que todo
  │                │  es consistente
  └────────────────┘
```

### 8.4.2. Solicitud de cambio (Change Request)

La solicitud de cambio es el artefacto que registra la
petición formal de modificar una especificación. Incluye:

```text
SOLICITUD DE CAMBIO

ID:            CR-067
Fecha:         2025-04-18
Solicitante:   Laura (Directora Comercial)
Especificaciones afectadas: FUNC-027, DN-008, CU-010

DESCRIPCIÓN DEL CAMBIO
  Ampliar el plazo de cancelación de pedidos de 2
  horas a 4 horas. Además, permitir la cancelación
  parcial: el cliente puede cancelar productos
  individuales del pedido sin cancelar todo el pedido.

MOTIVO
  Los clientes se quejan de que 2 horas es
  insuficiente para darse cuenta de un error en el
  pedido. La competencia ofrece 24 horas. Se
  propone 4 horas como compromiso entre la
  flexibilidad para el cliente y la operativa del
  almacén.

URGENCIA: Media
  No bloquea ningún release inmediato, pero debe
  implementarse antes del release 2.

ESTADO: Pendiente de análisis de impacto
```

### 8.4.3. Análisis de impacto

El análisis de impacto es el paso más importante del
proceso. Utiliza la trazabilidad (Tema 7) para identificar
todos los artefactos afectados por el cambio:

```text
ANÁLISIS DE IMPACTO PARA CR-067

Especificaciones afectadas:
  FUNC-027 v1.2 → v2.0
    Cambios: plazo de 2h a 4h, añadir cancelación
    parcial
  DN-008 v1.0 → v1.1
    Cambios: actualizar política de cancelaciones
  CU-010 → añadir flujo alternativo FA-N
    (cancelación parcial)

Código afectado:
  PedidoService.cancelar()
    → Añadir parámetro de líneas a cancelar
    → Modificar validación de plazo (2h → 4h)
  PedidoController (endpoint PATCH /pedidos/{id})
    → Añadir body con líneas a cancelar (opcional)
  PedidoStateMachine
    → Nuevo estado parcial: "parcialmente_cancelado"

Contratos afectados:
  API-PED-003 (nuevo endpoint o modificación de
    endpoint existente para cancelación parcial)

Tests afectados:
  TAC-027-04 → actualizar plazo esperado (2h → 4h)
  TAC-027-01..06 → revisar todos para compatibilidad
    con cancelación parcial
  T-DN-040-* → añadir transición a estado
    "parcialmente_cancelado"
  Nuevos tests: cancelación parcial (al menos 4
    escenarios)

Documentación afectada:
  Guía de usuario (sección de cancelaciones)
  FAQ del cliente

ESTIMACIÓN DE ESFUERZO
  Análisis y spec:        4 horas
  Desarrollo:             2 días
  Tests:                  1 día
  Documentación:          0,5 días
  Total:                  ~4 días
```

### 8.4.4. Decisión y aprobación

Con el análisis de impacto en mano, se toma una decisión:

**Aprobar**: el cambio se incluye en la planificación.
Se asigna a un sprint y se ejecuta el proceso completo.

**Rechazar**: el cambio no se implementa. Se documenta el
motivo (coste excesivo, riesgo inaceptable, contradicción
con la estrategia).

**Posponer**: el cambio es válido pero no prioritario. Se
registra en el backlog con la referencia a la solicitud
y al análisis de impacto para no perder el trabajo
realizado.

**Negociar**: se propone una alternativa al solicitante.
"No podemos hacer cancelación parcial por coste, pero
podemos ampliar el plazo a 4 horas ya."

El criterio de decisión combina valor de negocio, coste
de implementación, riesgo y momento del proyecto.

### 8.4.5. Propagación del cambio

Una vez aprobado el cambio, la actualización no se limita
a modificar la especificación. Hay que **propagar** el
cambio a todos los artefactos dependientes:

1. Actualizar la especificación con nueva versión.
2. Actualizar los casos de uso afectados.
3. Actualizar los criterios de aceptación.
4. Actualizar o crear los tests.
5. Actualizar el código.
6. Actualizar los contratos de API si aplica.
7. Actualizar la documentación de usuario.
8. Actualizar la matriz de trazabilidad.

La trazabilidad del Tema 7 es lo que hace posible esta
propagación de forma completa y sin olvidos. Sin
trazabilidad, la propagación depende de la memoria del
equipo, que es insuficiente en proyectos de tamaño medio
o grande.

---

## 8.5. Gobierno del cambio

### 8.5.1. Qué es el gobierno del cambio

El gobierno del cambio define **quién puede solicitar
cambios, quién los evalúa, quién los aprueba y cómo se
priorizan**. Sin gobierno, los cambios entran por
cualquier canal (un correo, una conversación de pasillo,
un comentario en Jira) y se ejecutan sin evaluación.

### 8.5.2. Roles en el gobierno del cambio

**Solicitante**: cualquier persona puede solicitar un
cambio. Stakeholders, usuarios, desarrolladores, QA,
operaciones. La barrera de entrada debe ser baja: si
pedir un cambio es burocráticamente costoso, la gente
dejará de hacerlo y los problemas se acumularán.

**Analista de impacto**: la persona que evalúa qué
artefactos se ven afectados y estima el esfuerzo. Suele
ser un analista, un tech lead o un desarrollador senior
con visión del sistema completo.

**Aprobador**: la persona que decide si el cambio se
implementa. Para cambios funcionales suele ser el Product
Owner. Para cambios técnicos, el tech lead o el arquitecto.
Para cambios que afectan a ambos, la decisión es conjunta.

**Implementador**: el equipo que ejecuta el cambio en
todos los artefactos afectados.

### 8.5.3. Niveles de gobierno según el impacto

No todos los cambios requieren el mismo nivel de
formalismo:

**Cambio menor** (corrección de error, clarificación,
caso límite): el analista o el desarrollador puede
aplicarlo directamente con un commit y una revisión por
pares. No necesita solicitud formal ni aprobación del PO.

**Cambio medio** (nueva regla de negocio, modificación
de flujo existente): requiere solicitud de cambio,
análisis de impacto y aprobación del PO. Se planifica
en el sprint.

**Cambio mayor** (nueva funcionalidad completa, cambio
de arquitectura, cambio que afecta a múltiples
especificaciones): requiere solicitud formal, análisis
de impacto detallado, aprobación del PO y del tech lead,
y planificación específica. Puede requerir una sesión de
refinamiento dedicada.

```text
Tipo de cambio      Aprobación   Análisis   Plazo
──────────────      ──────────   ────────   ─────
Menor               Peer review  No formal  Inmediato
Medio                PO           Sí         Sprint
Mayor                PO + Tech    Detallado  Planific.
                     Lead                    específica
```

### 8.5.4. Antipatrones del gobierno del cambio

**El cambio por pasillo**: alguien le dice al desarrollador
"cambia esto" en la máquina de café. El desarrollador lo
cambia sin actualizar la especificación. Resultado:
especificación y código divergen.

**El comité de cambios**: todo cambio, por pequeño que sea,
requiere aprobación de un comité que se reúne cada dos
semanas. Resultado: los cambios se acumulan, el equipo se
frustra y empieza a saltarse el proceso.

**El cambio silencioso**: el desarrollador modifica el
comportamiento del sistema para "mejorar" algo sin
comunicarlo. Nadie sabe que el cambio ocurrió hasta que
un test falla o un usuario se queja.

**El cambio incompleto**: se modifica la especificación
pero no se actualizan los tests, el código ni la
documentación. Resultado: inconsistencia acumulada.

---

## 8.6. Sincronización con desarrollo iterativo

### 8.6.1. Especificaciones en Scrum

En un marco Scrum, las especificaciones SDD se integran
en las ceremonias existentes:

**Refinamiento**: las especificaciones se revisan y
actualizan durante las sesiones de refinamiento. Los
cambios aprobados se incorporan a la especificación antes
de que la historia entre en el sprint. El criterio de
"Definition of Ready" incluye: "la especificación está
actualizada en su última versión aprobada."

**Sprint Planning**: cada historia de usuario se vincula
a la versión concreta de la especificación que implementa.
Si la especificación cambia durante el sprint (cosa que
debería evitarse), el cambio se gestiona como un cambio
de alcance del sprint con las consecuencias habituales.

**Sprint Review**: se verifica que lo implementado
corresponde a la versión de la especificación planificada.
Las discrepancias se registran como bugs o como
solicitudes de cambio para el siguiente sprint.

**Retrospectiva**: se revisa si el proceso de gestión de
cambios funcionó bien. ¿Hubo cambios no controlados?
¿Los análisis de impacto fueron precisos? ¿La propagación
fue completa?

### 8.6.2. Especificaciones en Kanban

En un flujo Kanban, las especificaciones se gestionan como
ítems más del tablero:

- Una solicitud de cambio entra en la columna "Solicitado".
- El análisis de impacto la mueve a "Analizado".
- La aprobación la mueve a "Aprobado".
- La actualización de la especificación la mueve a
  "Spec actualizada".
- La implementación completa la mueve a "Implementado".
- La verificación la mueve a "Verificado".

El límite de WIP (*work in progress*) se aplica también a
los cambios de especificación: no se puede tener demasiados
cambios en vuelo simultáneamente sin arriesgar la
consistencia.

### 8.6.3. Baseline y snapshots

Un concepto clave para sincronizar especificaciones con
releases es el **baseline** (línea base): una "foto" del
estado de todas las especificaciones en un momento
determinado.

```text
BASELINE: Release 1.0 (2025-05-01)

Especificación   Versión en baseline
──────────────   ──────────────────
FUNC-027         v2.0
FUNC-100         v1.3
FUNC-110         v1.1
FUNC-120         v1.0
FUNC-130         v1.2
DN-030           v1.0
DN-040           v1.1
DN-045           v1.0
DN-055           v1.0
API-PED-001      v2.1
API-PED-002      v1.0
API-DEV-001      v1.0
SEC-010          v1.0
PERF-010         v1.0
```

El baseline permite:

- Saber exactamente qué comportamiento corresponde a
  cada release.
- Comparar dos releases para ver qué cambió.
- Revertir a un estado anterior si es necesario.
- Auditar qué se entregó en cada release.

Si las especificaciones están en Git, el baseline es
un tag o una rama de release. Si están en una wiki, es
un snapshot exportado.

---

## 8.7. Resolución de conflictos

### 8.7.1. Cuándo surgen los conflictos

Los conflictos entre versiones de especificación aparecen
cuando dos o más personas modifican la misma especificación
o especificaciones relacionadas de forma independiente y
simultánea:

- El analista actualiza FUNC-027 para añadir cancelación
  parcial mientras el desarrollador está actualizando
  DN-040 para añadir un nuevo estado.
- Dos equipos trabajan en funcionalidades que comparten
  una regla de dominio y cada uno la modifica según sus
  necesidades.
- Un stakeholder solicita un cambio en la regla de
  descuentos al mismo tiempo que otro stakeholder solicita
  un cambio contradictorio.

### 8.7.2. Tipos de conflictos

**Conflicto textual**: dos personas han modificado la misma
sección de la misma especificación. Si las especificaciones
están en Git, el sistema de control de versiones detecta el
conflicto automáticamente. Si están en una wiki, la
detección depende de la herramienta.

**Conflicto semántico**: dos especificaciones definen
comportamientos contradictorios para el mismo caso. No se
detecta automáticamente porque afecta a documentos
diferentes. Ejemplo: FUNC-027 permite cancelar pedidos en
estado "en_preparacion" pero DN-040 no incluye la transición
de "en_preparacion" a "cancelado" para el rol "cliente".

**Conflicto de prioridad**: dos cambios aprobados compiten
por los mismos recursos (tiempo del equipo) y no pueden
implementarse simultáneamente. No es un conflicto técnico
sino de planificación.

### 8.7.3. Estrategias de resolución

**Para conflictos textuales**: el mecanismo estándar de
merge. Si las especificaciones están en Git, se resuelve
como cualquier conflicto de código: se revisan ambos
cambios, se decide qué se conserva y se crea una versión
que integre ambos.

**Para conflictos semánticos**: se requiere una revisión
cruzada de las especificaciones afectadas. La trazabilidad
(Tema 7) permite identificar qué especificaciones se
relacionan. La resolución implica una decisión de negocio
(qué comportamiento es correcto) y una actualización
coordinada de todas las especificaciones afectadas.

**Para conflictos de prioridad**: el Product Owner decide
qué cambio se implementa primero, basándose en valor de
negocio, urgencia y dependencias. El cambio pospuesto se
documenta en el backlog con su solicitud de cambio y su
análisis de impacto ya realizados.

### 8.7.4. Prevención de conflictos

La mejor estrategia es prevenir los conflictos antes de
que ocurran:

- **Comunicación proactiva**: cuando alguien va a
  modificar una especificación, lo anuncia al equipo.
  En Git, abrir un pull request pronto (aunque esté en
  borrador) hace visible el cambio.
- **Propiedad clara**: cada especificación tiene un
  responsable que coordina los cambios. No significa que
  solo esa persona pueda modificarla, sino que es el
  punto de contacto para evitar colisiones.
- **Revisión cruzada**: los cambios que afectan a
  especificaciones de otros equipos se revisan con esos
  equipos antes de aprobarlos.
- **Reunión de sincronización**: en proyectos con
  múltiples equipos, una reunión breve semanal donde cada
  equipo anuncia los cambios de especificación en curso
  reduce drásticamente los conflictos.

---

## 8.8. Resumen del tema

Las especificaciones no son documentos estáticos. Evolucionan
a lo largo de la vida del proyecto y esa evolución debe
gestionarse con disciplina.

Puntos clave:

- Los cambios en las especificaciones provienen de múltiples
  fuentes (negocio, técnica, regulación, feedback, errores)
  y su coste crece con el tiempo.
- El versionado de especificaciones (mayor/menor) con
  historial de cambios permite rastrear la evolución y
  coordinar con el desarrollo.
- El proceso de gestión de cambios (solicitud, análisis de
  impacto, decisión, actualización, propagación,
  verificación) garantiza que los cambios se evalúan y se
  propagan completamente.
- El gobierno del cambio define roles y niveles de
  formalismo proporcionales al impacto del cambio.
- La sincronización con marcos iterativos (Scrum, Kanban)
  integra las especificaciones en las ceremonias existentes
  y usa baselines para vincular releases con versiones.
- Los conflictos se resuelven con merge, decisiones de
  negocio o priorización, y se previenen con comunicación,
  propiedad clara y revisión cruzada.

---

## Laboratorios del Tema 8

### Laboratorio 8.1: Simulación de cambio de requisito con análisis de impacto

#### Enunciado del laboratorio 8.1

**Objetivo**: simular el proceso completo de gestión de
un cambio de requisito, desde la solicitud hasta la
verificación, aplicando análisis de impacto sobre los
artefactos del proyecto B2B.

**Contexto**: la directora comercial del proyecto B2B envía
la siguiente solicitud por correo electrónico:

```text
Hola equipo,

Necesito un cambio urgente en los descuentos por volumen.
A partir del mes que viene, los tramos cambian:

  - De 75 a 149 unidades: 4% de descuento
  - De 150 a 499 unidades: 7% de descuento
  - De 500 en adelante: 10% de descuento

El tramo actual de 50-99 unidades al 3% desaparece
porque no aportaba valor comercial.

Además, quiero que el descuento por volumen sea
acumulable con el descuento de fidelidad (antes no lo
era, creo, o sí lo era, no me acuerdo).

Esto es prioritario para el release 2.

Gracias,
Laura
```

**Instrucciones**:

1. Redacta la solicitud de cambio formal (CR-NNN).
2. Identifica y corrige las imprecisiones o errores del
   correo de Laura.
3. Realiza el análisis de impacto completo: especificaciones
   afectadas, código, tests, contratos y documentación.
4. Estima el esfuerzo.
5. Redacta la especificación actualizada (nueva versión de
   DN-030) con los cambios incorporados.
6. Identifica los tests que deben modificarse y escribe al
   menos 3 nuevos escenarios de verificación para los
   tramos actualizados.

#### Solución del laboratorio 8.1

##### Corrección de imprecisiones del correo

Antes de formalizar la solicitud, hay que identificar los
problemas del correo de Laura:

**Imprecisión 1**: Laura dice que el descuento por volumen
"no era acumulable con el descuento de fidelidad". Esto es
incorrecto. Según DN-030 y DN-055 actuales, el descuento
por volumen y el de fidelidad SÍ son acumulables (el
volumen se aplica por línea sobre el precio unitario; la
fidelidad se aplica después sobre el subtotal). Lo que NO
es acumulable es el volumen con el precio especial: se
aplica el más favorable. Laura está confundiendo dos
reglas.

**Imprecisión 2**: Laura dice "creo, o sí lo era, no me
acuerdo". Esto confirma que necesita una aclaración antes
de tomar una decisión. Si la solicitud se implementase
literalmente, podría cambiarse algo que ya funciona
correctamente.

**Imprecisión 3**: Laura dice "urgente" y "prioritario para
release 2". "Urgente" sugiere inmediato; "release 2" sugiere
planificado. Hay que clarificar la prioridad real.

Acción: responder a Laura antes de formalizar:

```text
Hola Laura,

Antes de procesar el cambio, necesito aclarar:

1. Los tramos nuevos: confirmados. Desaparece el
   tramo 50-99 (3%) y los nuevos son 75-149 (4%),
   150-499 (7%), 500+ (10%). ¿Correcto?

2. Acumulabilidad: actualmente el descuento por
   volumen YA es acumulable con el de fidelidad.
   Son independientes (volumen va por línea,
   fidelidad va sobre el subtotal). Lo que NO es
   acumulable es volumen con precio especial:
   se aplica el mejor. ¿Quieres cambiar algo de
   esto o mantenemos la lógica actual?

3. Plazo: ¿lo necesitas antes del release 2
   (urgente) o como parte del release 2
   (planificado)?

Gracias,
Equipo de análisis
```

Respuesta simulada de Laura:

```text
Gracias por la aclaración. Los tramos son correctos.
La acumulabilidad la mantenemos como está, perdona
la confusión. Y sí, lo necesito como parte del
release 2, no antes.
```

##### Solicitud de cambio formal

```text
SOLICITUD DE CAMBIO

ID:            CR-085
Fecha:         2025-04-25
Solicitante:   Laura (Directora Comercial)
Especificaciones afectadas: DN-030

DESCRIPCIÓN DEL CAMBIO
  Modificar los tramos de descuento por volumen:
    Tramos actuales (v1.0):
      50-99 ud:   3%
      100-499 ud: 5%
      500+ ud:    8%
    Tramos nuevos (v2.0):
      75-149 ud:   4%
      150-499 ud:  7%
      500+ ud:    10%

  Se elimina el tramo de 50-99 ud.
  El umbral mínimo sube de 50 a 75 unidades.
  Los porcentajes de todos los tramos cambian.

  No hay cambios en la lógica de acumulabilidad:
  el descuento por volumen sigue sin ser acumulable
  con precio especial (se aplica el más favorable)
  y sigue siendo acumulable con fidelidad.

MOTIVO
  El tramo 50-99 (3%) no aportaba valor comercial
  y complicaba la comunicación a clientes. Los
  nuevos tramos son más agresivos para incentivar
  pedidos grandes.

URGENCIA: Planificada (Release 2)
ESTADO: Pendiente de análisis de impacto
```

##### Análisis de impacto

```text
ANÁLISIS DE IMPACTO PARA CR-085

ESPECIFICACIONES AFECTADAS:

  DN-030 v1.0 → v2.0
    - Actualizar tabla de tramos
    - Actualizar todos los ejemplos numéricos
    - Actualizar casos límite (fronteras cambian)
    Esfuerzo spec: 2 horas

  DN-035 v1.0 (sin cambio de versión)
    - Verificar que la regla de resolución de
      conflictos entre volumen y precio especial
      sigue siendo consistente con los nuevos
      porcentajes.
    - Puede haber más casos donde volumen supere
      al precio especial (porcentajes mayores).
    Esfuerzo: 1 hora de revisión

  DN-055 v1.0 (sin cambio)
    - La fidelidad no cambia, pero los ejemplos
      de interacción con volumen deben actualizarse
      si se usan en documentación cruzada.
    Esfuerzo: 0,5 horas

CÓDIGO AFECTADO:

  DescuentoCalculator.calcularPrecioLinea()
    - Actualizar la tabla de tramos en el código.
    - Verificar que la estructura de datos soporta
      los nuevos valores sin cambio de lógica.
    Esfuerzo: 0,5 horas

  (No hay cambio de lógica, solo de datos de
  configuración. Si los tramos están externalizados
  en configuración, el cambio es aún más simple.)

CONTRATOS AFECTADOS:

  API-PED-001 (crear pedido): sin cambio.
    El descuento se calcula internamente; el
    contrato no expone los tramos.
  API-PED-002 (consultar pedido): sin cambio.
    La respuesta incluye el descuento aplicado
    pero no los tramos.

TESTS AFECTADOS:

  T-DN-030-01 a T-DN-030-08:
    TODOS deben revisarse. Los ejemplos numéricos
    cambian porque los tramos cambian.
    - Tests con 50-99 ud: ya no tienen descuento
      (antes 3%), ahora 0% si < 75 o 4% si 75-149.
    - Tests con 100-499 ud: pasan de 5% a 7%
      (si 150+) o a 4% (si 100-149).
    - Tests con 500+ ud: pasan de 8% a 10%.
    Esfuerzo: 3 horas

  TAC-110-* (creación de pedido):
    - Los tests que verifican el total del pedido
      con descuentos deben actualizarse.
    Esfuerzo: 1 hora

  TAC-045-07 (repetir pedido, recálculo descuentos):
    - Si existe, actualizar valores esperados.
    Esfuerzo: 0,5 horas

DOCUMENTACIÓN AFECTADA:

  - Tabla de descuentos publicada para clientes.
  - FAQ o guía comercial (si existe).
  Esfuerzo: 1 hora

ESTIMACIÓN TOTAL:
  Análisis y spec:        3,5 horas
  Desarrollo:             0,5-2 horas
  Tests:                  4,5 horas
  Documentación:          1 hora
  Total:                  ~1,5-2 días
```

##### Especificación actualizada (DN-030 v2.0)

```text
ID:      DN-030
Título:  Descuento por volumen en pedidos B2B
Versión: 2.0
Estado:  Aprobada
Autor:   Equipo de análisis — 2025-03-15
Última modificación: 2025-04-28 (v2.0, CR-085)

HISTORIAL DE CAMBIOS
  1.0  2025-03-15  Creación inicial
  2.0  2025-04-28  CR-085: nuevos tramos de
                   descuento (75/150/500) y nuevos
                   porcentajes (4%/7%/10%).

DESCRIPCIÓN
(se mantiene toda la estructura de la v1.0 con los
siguientes cambios)

TRAMOS DE DESCUENTO (por defecto, familia genérica):

  Desde (ud.)  Hasta (ud.)  Descuento
  ───────────  ───────────  ─────────
  1            74           0%
  75           149          4%
  150          499          7%
  500          sin límite   10%

(Resto de la especificación sin cambios:
fórmula, interacción con otros descuentos,
visualización en carrito, reflejo en factura,
recálculo dinámico.)

EJEMPLOS ACTUALIZADOS

  Ejemplo 1 (antes: 120 ud, 5% → ahora: 4%)
    Producto: Bolígrafo BIC, precio base: 0,50 €
    Cantidad: 120 unidades
    Tramo: 75-149 → 4%
    Precio descontado: 0,50 × 0,96 = 0,48 €
    Total línea: 0,48 × 120 = 57,60 €

  Ejemplo 2 (nuevo tramo intermedio)
    Producto: Bolígrafo BIC, precio base: 0,50 €
    Cantidad: 200 unidades
    Tramo: 150-499 → 7%
    Precio descontado: 0,50 × 0,93 = 0,465
      → redondeado: 0,46 €
    Total línea: 0,46 × 200 = 92,00 €

  Ejemplo 3 (tramo máximo actualizado)
    Producto: Bolígrafo BIC, precio base: 0,50 €
    Cantidad: 500 unidades
    Tramo: 500+ → 10%
    Precio descontado: 0,50 × 0,90 = 0,45 €
    Total línea: 0,45 × 500 = 225,00 €

  Ejemplo 4 (sin descuento, nuevo umbral)
    Producto: Bolígrafo BIC, precio base: 0,50 €
    Cantidad: 60 unidades
    Tramo: 1-74 → 0%
    Precio: 0,50 € (sin descuento)
    Total línea: 0,50 × 60 = 30,00 €
    Nota: en v1.0, 60 ud. tenían descuento 3%.
    En v2.0 no tienen descuento.

CASOS LÍMITE ACTUALIZADOS
  - 74 unidades: sin descuento (0%).
  - 75 unidades: descuento 4%.
  - 149 unidades: descuento 4%.
  - 150 unidades: descuento 7%.
  - 499 unidades: descuento 7%.
  - 500 unidades: descuento 10%.
```

##### Nuevos escenarios de verificación

```text
Escenario V1: Frontera inferior del primer tramo nuevo
  Dado producto Bolígrafo BIC a 0,50 €
    y cantidad 74 unidades
  Cuando se calcula el precio con descuento
  Entonces el precio unitario es 0,50 € (0%)
    y el total es 37,00 €.

  Dado el mismo producto y cantidad 75 unidades
  Cuando se calcula el precio con descuento
  Entonces el precio unitario es 0,48 € (4%)
    y el total es 36,00 €.

Escenario V2: Frontera entre primer y segundo tramo
  Dado producto Bolígrafo BIC a 0,50 €
    y cantidad 149 unidades
  Cuando se calcula el precio con descuento
  Entonces el precio unitario es 0,48 € (4%)
    y el total es 71,52 €.

  Dado el mismo producto y cantidad 150 unidades
  Cuando se calcula el precio con descuento
  Entonces el precio unitario es 0,46 € (7%)
    y el total es 69,00 €.
  Nota: el cliente paga MENOS por 150 ud. que
  por 149 ud. Esto es correcto e intencional
  (incentivo para alcanzar el siguiente tramo).

Escenario V3: Conflicto con precio especial bajo
nuevos tramos
  Dado producto Bolígrafo BIC a 0,50 €
    y cliente con precio especial: 0,47 €
    y cantidad 150 unidades
  Cuando se calcula el precio con descuento
  Entonces precio con volumen 7%: 0,46 €
    y precio especial: 0,47 €
    y se aplica 0,46 € (volumen más favorable)
    y el carrito muestra "Descuento volumen: -7%".

Escenario V4: Cantidad que antes tenía descuento
y ahora no
  Dado producto Bolígrafo BIC a 0,50 €
    y cantidad 60 unidades
  Cuando se calcula el precio con descuento
  Entonces el precio unitario es 0,50 € (0%)
    y el total es 30,00 €
    y NO se muestra etiqueta de descuento.
  Nota: en v1.0, 60 ud. tenían 3% de descuento.
  Este escenario verifica que el tramo eliminado
  ya no se aplica.
```

---

### Laboratorio 8.2: Versionado de especificaciones en flujo colaborativo

#### Enunciado del laboratorio 8.2

**Objetivo**: practicar el flujo completo de versionado de
una especificación en un entorno colaborativo, incluyendo
la creación de la nueva versión, la revisión, la aprobación
y la actualización del baseline.

**Contexto**: el equipo del proyecto B2B trabaja con
especificaciones en Markdown almacenadas en un repositorio
Git. Se acaba de aprobar el cambio CR-085 (nuevos tramos de
descuento por volumen) y se debe actualizar el baseline para
el release 2.

Además, hay otro cambio aprobado (CR-090: añadir descuento
por código promocional) que afecta a una nueva
especificación DN-070 y modifica DN-035 (resolución de
conflictos entre descuentos).

**Instrucciones**:

1. Diseña el flujo Git para gestionar estos dos cambios
   simultáneamente (ramas, commits, pull requests,
   revisiones).
2. Redacta los mensajes de commit siguiendo una convención
   coherente que incluya la referencia a la solicitud de
   cambio.
3. Define el nuevo baseline para el release 2.
4. Documenta las dependencias entre ambos cambios y el
   orden de merge recomendado.
5. Describe qué haría el equipo si, justo antes del merge,
   se descubre que CR-085 y CR-090 tienen un conflicto
   semántico en DN-035.

#### Solución del laboratorio 8.2

##### Flujo Git propuesto

```text
main (baseline release 1)
  │
  ├── release/2.0 (rama de release 2)
  │     │
  │     ├── spec/CR-085-tramos-volumen
  │     │     Commits:
  │     │     1. spec(DN-030): actualizar tramos
  │     │        de descuento v1.0→v2.0 [CR-085]
  │     │     2. spec(DN-030): actualizar ejemplos
  │     │        y casos límite [CR-085]
  │     │     3. test(DN-030): actualizar tests
  │     │        T-DN-030-01..08 [CR-085]
  │     │     4. docs: actualizar tabla descuentos
  │     │        para clientes [CR-085]
  │     │
  │     └── spec/CR-090-codigo-promocional
  │           Commits:
  │           1. spec(DN-070): crear especificación
  │              descuento por código promocional
  │              v1.0 [CR-090]
  │           2. spec(DN-035): actualizar resolución
  │              de conflictos con código promo
  │              v1.0→v1.1 [CR-090]
  │           3. spec(API-PED-001): añadir campo
  │              codigo_promo al contrato v2.1→v2.2
  │              [CR-090]
  │           4. test(DN-070): crear tests
  │              T-DN-070-01..05 [CR-090]
  │           5. test(DN-035): actualizar tests de
  │              resolución de conflictos [CR-090]
  │
  (tras merge de ambas ramas a release/2.0
   y verificación, se hace merge a main
   y se crea el tag v2.0)
```

##### Convención de mensajes de commit

```text
Formato:
  tipo(alcance): descripción breve [CR-NNN]

Tipos:
  spec   → cambio en especificación
  test   → cambio en tests
  code   → cambio en código
  docs   → cambio en documentación
  fix    → corrección de error
  chore  → tarea de mantenimiento

Alcance:
  ID de la especificación afectada (DN-030,
  API-PED-001, etc.) o módulo de código.

Ejemplos:
  spec(DN-030): actualizar tramos v1.0→v2.0 [CR-085]
  test(DN-030): actualizar T-DN-030-01..08 [CR-085]
  spec(DN-070): crear spec código promo v1.0 [CR-090]
  spec(DN-035): añadir promo a conflictos [CR-090]
  code(DescuentoCalculator): nuevos tramos [CR-085]
  docs: actualizar tabla descuentos clientes [CR-085]
```

##### Pull requests y revisiones

```text
PR #1: CR-085 — Nuevos tramos de descuento por volumen
  Rama: spec/CR-085-tramos-volumen → release/2.0
  Revisor spec: Product Owner (Laura)
  Revisor técnico: Tech Lead
  Checklist:
    [ ] DN-030 actualizada a v2.0
    [ ] Ejemplos numéricos verificados
    [ ] Casos límite actualizados
    [ ] Tests actualizados y pasando
    [ ] Documentación de cliente actualizada
    [ ] Sin conflictos con otras specs del release 2
  Estado: aprobado tras revisión

PR #2: CR-090 — Descuento por código promocional
  Rama: spec/CR-090-codigo-promocional → release/2.0
  Revisor spec: Product Owner (Laura)
  Revisor técnico: Tech Lead
  Checklist:
    [ ] DN-070 creada (v1.0)
    [ ] DN-035 actualizada (v1.1)
    [ ] API-PED-001 actualizada (v2.2)
    [ ] Tests creados y pasando
    [ ] Consistencia con DN-030 v2.0 verificada
  Estado: pendiente de revisión
  Nota: debe mergearse DESPUÉS de PR #1 porque
  DN-035 depende de los nuevos tramos de DN-030.
```

##### Baseline del release 2

```text
BASELINE: Release 2.0 (2025-05-15)

Especificación   Versión R1   Versión R2   Cambio
──────────────   ──────────   ──────────   ──────
FUNC-027         v2.0         v2.0         Sin cambio
FUNC-100         v1.3         v1.3         Sin cambio
FUNC-110         v1.1         v1.1         Sin cambio
FUNC-120         v1.0         v1.0         Sin cambio
FUNC-130         v1.2         v1.2         Sin cambio
FUNC-140         —            v1.0         NUEVA
DN-030           v1.0         v2.0         CR-085
DN-035           v1.0         v1.1         CR-090
DN-040           v1.1         v1.1         Sin cambio
DN-045           v1.0         v1.0         Sin cambio
DN-055           v1.0         v1.0         Sin cambio
DN-070           —            v1.0         CR-090 NUEVA
API-PED-001      v2.1         v2.2         CR-090
API-PED-002      v1.0         v1.0         Sin cambio
API-DEV-001      v1.0         v1.0         Sin cambio
SEC-010          v1.0         v1.0         Sin cambio
PERF-010         v1.0         v1.0         Sin cambio

Tag Git: v2.0
Fecha: 2025-05-15
Aprobado por: Laura (PO), Carlos (Tech Lead)
```

##### Dependencias y orden de merge

```text
DEPENDENCIAS ENTRE CAMBIOS

CR-085 (tramos volumen):
  Modifica: DN-030
  NO modifica: DN-035

CR-090 (código promo):
  Crea: DN-070
  Modifica: DN-035, API-PED-001
  DEPENDE DE: DN-030 v2.0 (los nuevos tramos
    afectan a la resolución de conflictos)

ORDEN DE MERGE RECOMENDADO:
  1. Primero CR-085 (tramos volumen) a release/2.0
  2. Después CR-090 (código promo) a release/2.0
  3. Finalmente release/2.0 a main con tag v2.0

JUSTIFICACIÓN:
  CR-090 modifica DN-035 (resolución de conflictos)
  y esa resolución depende de los tramos de DN-030.
  Si se mergea CR-090 primero, la actualización de
  DN-035 se basaría en los tramos antiguos y habría
  que re-actualizar tras CR-085.
```

##### Gestión del conflicto semántico

Supongamos que justo antes del merge se descubre que
CR-085 y CR-090 tienen un conflicto semántico en DN-035:

```text
CONFLICTO DETECTADO EN DN-035

CR-085 establece:
  "Si coexisten descuento por volumen y precio
   especial, se aplica el que resulte en menor
   precio para el cliente."
  (Sin cambio respecto a v1.0, pero los nuevos
  porcentajes más altos hacen que el volumen gane
  con más frecuencia.)

CR-090 añade:
  "Si coexisten descuento por código promocional
   y descuento por volumen, se aplica el mayor de
   los dos. No son acumulables."
  "Si coexisten código promocional y precio
   especial, se aplica el código promocional
   (tiene prioridad)."

CONFLICTO:
  ¿Qué pasa si coexisten los TRES: volumen (10%),
  precio especial (0,47 €) y código promocional
  (15%)? DN-035 v1.1 no define este caso de triple
  conflicto.

RESOLUCIÓN:

  1. Convocar sesión de 30 minutos con PO, analista
     y tech lead.

  2. Decisión: se aplica el precio más favorable
     para el cliente entre las tres opciones,
     evaluando cada una de forma independiente:
       a. Precio con volumen: 0,50 × 0,90 = 0,45 €
       b. Precio especial: 0,47 €
       c. Precio con promo: 0,50 × 0,85 = 0,425 €
       Resultado: se aplica 0,425 € (promo 15%)

  3. Actualizar DN-035 v1.1 para incluir la regla
     de triple conflicto con ejemplo.

  4. Añadir test T-DN-035-NN para el caso de triple
     conflicto.

  5. Hacer el merge de CR-085 primero, luego re-
     basar CR-090 sobre release/2.0, actualizar
     DN-035 con la regla de triple conflicto, y
     hacer el merge de CR-090.
```

---

### Laboratorio 8.3: Resolución de conflictos entre versiones de especificación

#### Enunciado del laboratorio 8.3

**Objetivo**: resolver un conflicto real entre dos versiones
de una especificación que han divergido, reconstruir la
versión correcta y documentar la resolución.

**Contexto**: dos equipos del proyecto B2B han trabajado
simultáneamente en cambios que afectan a la especificación
de transiciones de estado del pedido (DN-040). Ninguno
sabía que el otro estaba modificando la misma especificación.

**Versión del equipo A** (rama spec/aprobacion-express):

Ha añadido un nuevo estado "aprobacion_express" para
pedidos de clientes VIP que no necesitan aprobación
manual. La transición va directamente de "confirmado"
a "en_preparacion" sin pasar por "pendiente_aprobacion".

```text
DN-040 v1.2-A

Estados: borrador, confirmado, pendiente_aprobacion,
  aprobacion_express, en_preparacion, enviado,
  entregado, cancelado

Nuevas transiciones:
  confirmado → aprobacion_express
    (automática, si cliente es VIP)
  aprobacion_express → en_preparacion
    (automática, inmediata)
```

**Versión del equipo B** (rama spec/cancelacion-parcial):

Ha añadido el estado "parcialmente_cancelado" para
soportar la cancelación de líneas individuales de un
pedido sin cancelar todo el pedido. También ha modificado
la transición de "en_preparacion" → "cancelado" para
restringirla solo a administradores.

```text
DN-040 v1.2-B

Estados: borrador, confirmado, pendiente_aprobacion,
  en_preparacion, enviado, entregado, cancelado,
  parcialmente_cancelado

Nuevas transiciones:
  confirmado → parcialmente_cancelado
    (cliente cancela líneas, no todo)
  en_preparacion → parcialmente_cancelado
    (cliente cancela líneas)
  en_preparacion → cancelado
    (solo admin, no cliente — CAMBIO)

Nuevo invariante:
  INV-8. Un pedido parcialmente_cancelado mantiene
  al menos una línea activa. Si se cancelan todas,
  pasa a "cancelado".
```

**Instrucciones**:

1. Identifica todos los conflictos entre ambas versiones
   (textuales y semánticos).
2. Propón la versión unificada (DN-040 v2.0) que integre
   ambos cambios de forma coherente.
3. Identifica cualquier interacción no prevista entre
   "aprobacion_express" y "parcialmente_cancelado".
4. Redacta el diagrama de estados unificado.
5. Define los tests necesarios para verificar las
   interacciones entre ambos cambios.
6. Documenta el proceso de resolución como referencia
   para futuros conflictos.

#### Solución del laboratorio 8.3

##### Conflictos identificados

**Conflicto 1 — Lista de estados (textual)**:
Ambas versiones añaden estados a la misma lista. A añade
"aprobacion_express". B añade "parcialmente_cancelado".
La resolución es aditiva: la versión unificada debe
incluir ambos estados nuevos.

**Conflicto 2 — Transición en_preparacion → cancelado
(semántico)**: la versión original de DN-040 v1.1
permitía que tanto el cliente como el admin cancelasen
un pedido en preparación. La versión B restringe esta
transición solo a admin. La versión A no modifica esta
transición. El conflicto es: ¿se aplica la restricción
de B? Decisión: sí, la restricción de B es intencional
(el equipo B la añadió tras consultar con operaciones,
que se quejaba de cancelaciones tardías que
desperdiciaban trabajo de almacén). El cliente en estado
"en_preparacion" puede usar la cancelación parcial en
lugar de la cancelación total.

**Conflicto 3 — Interacción no prevista**: ¿puede un
pedido que pasó por "aprobacion_express" ser
parcialmente cancelado? Ninguno de los dos equipos
contempló este caso porque no sabían del cambio del
otro. Análisis: sí, debería poder. Un pedido VIP que
pasó por aprobación exprés y está en "confirmado" o
"en_preparacion" debería poder tener líneas canceladas
igual que cualquier otro pedido.

**Conflicto 4 — Interacción aprobacion_express +
cancelación total**: ¿se puede cancelar totalmente un
pedido que pasó por aprobación exprés? Análisis: sí,
con las mismas reglas que un pedido normal. Si está
en "confirmado" (post-aprobación), el cliente puede
cancelar. Si está en "en_preparacion", solo admin.

##### Especificación unificada: DN-040 v2.0

```text
ID:      DN-040
Título:  Transiciones de estado de un pedido
Versión: 2.0
Estado:  Aprobada
Autor:   Equipo de análisis — 2025-03-15
Última mod.: 2025-04-30 (v2.0, merge de spec/
  aprobacion-express + spec/cancelacion-parcial)

HISTORIAL
  1.0  2025-03-15  Creación inicial
  1.1  2025-04-02  Añadida restricción admin en
                   cancelación de enviado
  2.0  2025-04-30  Merge: aprobacion_express (A)
                   + cancelación parcial (B) +
                   resolución de interacciones

ESTADOS

  borrador
  confirmado
  pendiente_aprobacion
  aprobacion_express
  en_preparacion
  enviado
  entregado
  cancelado
  parcialmente_cancelado

DIAGRAMA DE ESTADOS

  [borrador]
      │
      ▼
  [confirmado]─────────────────────┐
      │          │         │       │
      │          │         │       ▼
      │          │         │  [parcialmente_
      │          │         │   cancelado]
      │          │         │       │
      │          │         ▼       │
      │          │    [cancelado]◄─┘
      │          │         ▲
      │          ▼         │
      │  [pendiente_       │
      │   aprobacion]      │
      │       │            │
      ▼       ▼            │
  [aprobacion_express]     │
      │                    │
      ▼                    │
  [en_preparacion]────────┘
      │       │
      │       ▼
      │  [parcialmente_cancelado]
      │
      ▼
  [enviado]
      │
      ▼
  [entregado]

TABLA DE TRANSICIONES

  Origen                  Destino                Quién
  ──────                  ───────                ─────
  borrador                confirmado             cliente
  confirmado              pendiente_aprobacion   sistema
    (si cliente tiene flujo de aprobación y no es VIP)
  confirmado              aprobacion_express     sistema
    (si cliente es VIP, automática)
  confirmado              en_preparacion         sistema
    (si no requiere aprobación)
  confirmado              cancelado              cliente
  confirmado              parcialmente_cancelado  cliente
  pendiente_aprobacion    confirmado             aprobador
    (tras aprobación, continúa flujo normal)
  pendiente_aprobacion    cancelado              aprobador
    (rechaza el pedido)
  aprobacion_express      en_preparacion         sistema
    (automática, inmediata)
  en_preparacion          enviado                almacen
  en_preparacion          cancelado              admin
  en_preparacion          parcialmente_cancelado  cliente
                                                  admin
  parcialmente_cancelado  cancelado              sistema
    (si se cancelan todas las líneas)
  parcialmente_cancelado  en_preparacion         sistema
    (si se mantienen líneas activas, continúa)
  enviado                 entregado              logistica
  cancelado               (terminal)             —
  entregado               (terminal)             —

INVARIANTES

  INV-4. Un pedido "cancelado" no cambia de estado.
  INV-6. Un pedido "entregado" no cambia de estado.
  INV-7. Las transiciones avanzan hacia la derecha
    del diagrama salvo cancelación y canc. parcial.
  INV-8. Un pedido "parcialmente_cancelado" mantiene
    al menos una línea activa. Si todas las líneas
    se cancelan, el estado pasa a "cancelado"
    automáticamente.
  INV-9. La transición a "aprobacion_express" solo
    se produce para clientes con flag VIP activo.
  INV-10. Un pedido "en_preparacion" solo puede ser
    cancelado totalmente por un administrador, no
    por el cliente. El cliente puede usar cancelación
    parcial.

INTERACCIONES ENTRE CAMBIOS

  Caso 1: Pedido VIP + cancelación parcial
    Un pedido de cliente VIP pasa por
    aprobacion_express → en_preparacion. En ese
    estado, el cliente puede solicitar cancelación
    parcial (mismas reglas que cualquier pedido).

  Caso 2: Pedido VIP + cancelación total
    Un pedido de cliente VIP en "confirmado"
    (después de aprobacion_express) puede ser
    cancelado totalmente por el cliente. Si ya
    está en "en_preparacion", solo admin puede
    cancelar totalmente.

  Caso 3: Cancelación parcial que elimina todo
    Si un cliente con pedido "parcialmente_cancelado"
    cancela la última línea activa, el pedido
    transiciona automáticamente a "cancelado"
    (INV-8).
```

##### Tests para las interacciones

```text
Test INT-1: Pedido VIP con cancelación parcial
  Dado un pedido de cliente VIP que pasó por
    aprobacion_express y está en en_preparacion
    con 3 líneas de producto
  Cuando el cliente cancela 1 línea
  Entonces el pedido pasa a parcialmente_cancelado
    y las 2 líneas restantes siguen activas
    y el stock de la línea cancelada se restaura.

Test INT-2: Pedido VIP con cancelación total
en_preparacion
  Dado un pedido VIP en estado en_preparacion
  Cuando el cliente intenta cancelar todo el pedido
  Entonces el sistema rechaza la cancelación
    y muestra: "Los pedidos en preparación solo
    pueden ser cancelados por un administrador.
    Puedes cancelar productos individuales."

Test INT-3: Cancelación parcial que elimina todo
  Dado un pedido parcialmente_cancelado con 1 línea
    activa
  Cuando el cliente cancela esa última línea
  Entonces el pedido pasa a cancelado (INV-8)
    y se aplican todas las postcondiciones de
    cancelación total (stock, devolución, correo).

Test INT-4: Aprobación exprés con flujo normal
  Dado un pedido de cliente VIP
  Cuando se confirma el pedido
  Entonces pasa por aprobacion_express
    automáticamente (sin intervención del aprobador)
    y transiciona a en_preparacion inmediatamente
    y el tiempo entre confirmado y en_preparacion
    es menor a 5 segundos.

Test INT-5: Conflicto VIP + aprobación manual
  Dado un cliente marcado como VIP
    y que pertenece a organización con flujo de
    aprobación manual activado
  Cuando se confirma un pedido
  Entonces la aprobación exprés (VIP) tiene
    prioridad sobre el flujo manual
    y el pedido NO pasa por pendiente_aprobacion.
  Nota: esta regla de prioridad debe validarse
  con negocio. Si el flujo manual es obligatorio
  por política corporativa del cliente, debe
  prevalecer sobre el VIP.
```

##### Documentación del proceso de resolución

```text
ACTA DE RESOLUCIÓN DE CONFLICTO

Fecha: 2025-04-30
Participantes: Equipo A (aprobación exprés),
  Equipo B (cancelación parcial), Tech Lead,
  Product Owner.

CONFLICTO
  Dos equipos modificaron DN-040 simultáneamente
  sin conocimiento mutuo. El equipo A añadió el
  estado aprobacion_express. El equipo B añadió
  el estado parcialmente_cancelado y restringió
  transiciones de cancelación.

CAUSA RAÍZ
  Ausencia de comunicación proactiva sobre cambios
  en especificaciones compartidas. DN-040 no tenía
  un responsable asignado que coordinase los
  cambios.

RESOLUCIÓN
  Se creó DN-040 v2.0 unificando ambos cambios.
  Se identificaron 3 interacciones no previstas y
  se documentaron con reglas y tests específicos.
  El merge se realizó con el siguiente orden:
  1. Equipo A mergeó su rama a release/2.0.
  2. Equipo B rebasó su rama sobre release/2.0.
  3. Se resolvieron los conflictos textuales.
  4. Se redactaron las reglas de interacción.
  5. Se crearon 5 tests de interacción.
  6. Se mergeó la rama del equipo B a release/2.0.

ACCIONES PREVENTIVAS
  1. Asignar un responsable a cada especificación
     de dominio (DN-*). El responsable debe ser
     notificado antes de cualquier cambio.
  2. Añadir un check en el PR: "¿Este cambio
     afecta a especificaciones de otro equipo?
     Si sí, ¿se ha comunicado?"
  3. Incluir las especificaciones en la reunión
     de sincronización semanal entre equipos.
  4. Revisar la lista de specs compartidas al
     inicio de cada sprint para detectar cambios
     en curso que puedan colisionar.
```
