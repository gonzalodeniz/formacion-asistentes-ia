# Plan de formación: Spec Driven Development (SDD)

## Tema 1. Fundamentos de Spec Driven Development

**Descripción**
Introducción al enfoque SDD, su propósito dentro del ciclo de vida del software y sus diferencias frente a enfoques centrados únicamente en código, pruebas o documentación. Se presenta la especificación como artefacto central para alinear negocio, diseño, desarrollo y validación.

**Objetivos**

* Comprender qué es SDD y qué problemas resuelve.
* Identificar los principios básicos del desarrollo guiado por especificaciones.
* Diferenciar SDD de TDD, BDD y enfoques tradicionales.
* Entender el papel de la especificación como fuente de verdad compartida.

**Laboratorios**

* Laboratorio: Identificación de problemas en proyectos sin especificaciones claras.
* Laboratorio: Comparativa entre requisitos ambiguos y especificaciones verificables.
* Laboratorio: Mapa conceptual de SDD dentro del ciclo de desarrollo.

---

## Tema 2. Especificaciones: tipos, estructura y calidad

**Descripción**
Estudio de los distintos tipos de especificaciones funcionales, técnicas, de interfaz, contrato y aceptación. Se trabaja cómo redactarlas con claridad, precisión, consistencia y trazabilidad para que sean útiles durante todo el desarrollo.

**Objetivos**

* Reconocer los distintos tipos de especificaciones en un proyecto software.
* Aprender a estructurar especificaciones claras, completas y verificables.
* Detectar ambigüedades, inconsistencias y huecos en una especificación.
* Definir criterios de calidad para una buena especificación.

**Laboratorios**

* Laboratorio: Reescritura de requisitos ambiguos en formato especificable.
* Laboratorio: Revisión de calidad de una especificación existente.
* Laboratorio: Creación de plantilla base para especificaciones de equipo.

---

## Tema 3. Descubrimiento y refinamiento de requisitos

**Descripción**
Se aborda cómo transformar necesidades de negocio y expectativas de usuario en especificaciones útiles para desarrollo. Incluye técnicas de análisis, refinamiento iterativo y validación temprana con stakeholders.

**Objetivos**

* Convertir necesidades de negocio en requisitos estructurados.
* Refinar requisitos de alto nivel hasta hacerlos implementables.
* Involucrar a stakeholders en la validación temprana.
* Reducir malentendidos antes de empezar a construir.

**Laboratorios**

* Laboratorio: Transformar entrevistas de negocio en especificaciones iniciales.
* Laboratorio: Taller de refinamiento incremental de requisitos.
* Laboratorio: Validación de especificaciones con roles simulados de negocio y desarrollo.

---

## Tema 4. Modelado del comportamiento y casos de uso

**Descripción**
Introducción al modelado del sistema mediante casos de uso, escenarios, flujos principales, alternativos y excepcionales. El objetivo es describir comportamiento esperado de forma comprensible y verificable.

**Objetivos**

* Modelar el comportamiento funcional del sistema.
* Escribir casos de uso y escenarios con suficiente precisión.
* Identificar flujos alternativos y casos de error.
* Relacionar comportamiento esperado con validación posterior.

**Laboratorios**

* Laboratorio: Redacción de casos de uso para una funcionalidad real.
* Laboratorio: Modelado de escenarios alternativos y excepciones.
* Laboratorio: Revisión cruzada de casos de uso entre equipos.

---

## Tema 5. Contratos, interfaces y reglas de dominio

**Descripción**
Se profundiza en la especificación de contratos entre componentes, APIs, servicios y reglas de dominio. Se introduce el diseño de entradas, salidas, precondiciones, postcondiciones e invariantes como base de implementación robusta.

**Objetivos**

* Especificar contratos claros entre módulos o servicios.
* Definir precondiciones, postcondiciones e invariantes.
* Modelar reglas de negocio de manera explícita.
* Mejorar la consistencia entre dominio e implementación.

**Laboratorios**

* Laboratorio: Definición de contratos para una API REST.
* Laboratorio: Especificación de reglas de negocio con invariantes.
* Laboratorio: Validación de contratos entre consumidor y proveedor.

---

## Tema 6. Especificaciones ejecutables y criterios de aceptación

**Descripción**
Se presenta cómo convertir especificaciones en artefactos verificables mediante ejemplos, criterios de aceptación y formatos ejecutables. Se conecta la especificación con la validación automática y la colaboración entre perfiles funcionales y técnicos.

**Objetivos**

* Traducir especificaciones a criterios de aceptación claros.
* Redactar ejemplos verificables y orientados a comportamiento.
* Relacionar especificación y automatización de validación.
* Mejorar la comunicación entre negocio, QA y desarrollo.

**Laboratorios**

* Laboratorio: Redacción de criterios de aceptación para historias funcionales.
* Laboratorio: Conversión de ejemplos de negocio en escenarios verificables.
* Laboratorio: Revisión de aceptación de una funcionalidad con base en especificación.

---

## Tema 7. Trazabilidad entre especificación, diseño, código y pruebas

**Descripción**
Tema centrado en mantener alineados los artefactos del proyecto. Se trabaja la trazabilidad desde la necesidad inicial hasta la implementación y validación final, minimizando desviaciones y facilitando auditoría y mantenimiento.

**Objetivos**

* Diseñar una estrategia de trazabilidad entre artefactos.
* Relacionar requisitos con componentes, pruebas y entregables.
* Detectar desviaciones entre especificación e implementación.
* Facilitar mantenimiento, auditoría y evolución del sistema.

**Laboratorios**

* Laboratorio: Matriz de trazabilidad requisito-diseño-prueba.
* Laboratorio: Detección de huecos entre especificación y código.
* Laboratorio: Auditoría rápida de cobertura de requisitos.

---

## Tema 8. Evolución y versionado de especificaciones

**Descripción**
Se estudia cómo gestionar cambios en las especificaciones a lo largo del tiempo sin perder coherencia. Incluye control de versiones, gestión de impacto, gobierno del cambio y sincronización con el desarrollo iterativo.

**Objetivos**

* Gestionar cambios en especificaciones de forma controlada.
* Evaluar el impacto técnico y funcional de una modificación.
* Versionar especificaciones igual que otros artefactos del proyecto.
* Mantener consistencia entre cambios funcionales y técnicos.

**Laboratorios**

* Laboratorio: Simulación de cambio de requisito con análisis de impacto.
* Laboratorio: Versionado de especificaciones en flujo colaborativo.
* Laboratorio: Resolución de conflictos entre versiones de especificación.

---

## Tema 9. Herramientas y automatización para SDD

**Descripción**
Panorámica de herramientas, repositorios, formatos y flujos de trabajo que ayudan a integrar especificaciones en el día a día del equipo. Se revisan prácticas de automatización, revisión y publicación de especificaciones vivas.

**Objetivos**

* Conocer herramientas útiles para documentar y mantener especificaciones.
* Integrar especificaciones en el flujo de trabajo del equipo.
* Automatizar validaciones, revisiones y publicación de artefactos.
* Favorecer especificaciones vivas y accesibles.

**Laboratorios**

* Laboratorio: Configuración de repositorio para especificaciones versionadas.
* Laboratorio: Flujo de revisión colaborativa de especificaciones.
* Laboratorio: Publicación automatizada de documentación viva.

---

## Tema 10. Implantación de SDD en equipos y proyectos reales

**Descripción**
Cierre del itinerario con foco en adopción organizativa. Se analizan roles, dinámicas de equipo, métricas, buenas prácticas y estrategia de implantación progresiva de SDD en proyectos reales de distinto tamaño y contexto.

**Objetivos**

* Diseñar una estrategia realista de adopción de SDD.
* Definir roles y responsabilidades en torno a la especificación.
* Identificar métricas de calidad y madurez en el uso de SDD.
* Adaptar el enfoque a contextos ágiles, corporativos o técnicos diversos.

**Laboratorios**

* Laboratorio: Plan de implantación de SDD para un equipo ficticio.
* Laboratorio: Definición de roles, ceremonias y artefactos de gobierno.
* Laboratorio: Evaluación de madurez de un proyecto respecto a SDD.
