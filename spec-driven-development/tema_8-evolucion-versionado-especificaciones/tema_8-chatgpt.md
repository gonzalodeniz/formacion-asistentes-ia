# Tema 8. Evolución y versionado de especificaciones

## Descripción

En este tema se estudia cómo gestionar la evolución de las
especificaciones a lo largo del tiempo. Una especificación no es un documento
estático. Cambia cuando cambia el producto, el negocio, la regulación, la
arquitectura técnica o el conocimiento del equipo.

Gestionar estos cambios de forma controlada permite mantener coherencia entre
lo que negocio espera, lo que desarrollo implementa, lo que QA valida y lo que
queda documentado como comportamiento aceptado.

La evolución de especificaciones requiere aplicar prácticas similares a las
usadas con el código fuente: control de versiones, revisión colaborativa,
trazabilidad, gestión de impacto, resolución de conflictos y gobierno del
cambio.

## Objetivos

Al finalizar este tema, el participante será capaz de:

* Gestionar cambios en especificaciones de forma controlada.
* Evaluar el impacto técnico y funcional de una modificación.
* Versionar especificaciones igual que otros artefactos del proyecto.
* Mantener consistencia entre cambios funcionales y técnicos.
* Identificar conflictos entre versiones de una especificación.
* Proponer estrategias para revisar, aprobar y comunicar cambios.
* Relacionar cambios de especificación con pruebas y entregas iterativas.

## 1. Por qué evolucionan las especificaciones

Las especificaciones evolucionan porque el producto y su contexto cambian. En
un proyecto real, rara vez todos los requisitos son conocidos desde el inicio.

Algunas causas habituales de cambio son:

* Nueva información de negocio.
* Cambios legales o regulatorios.
* Feedback de usuarios.
* Resultados de pruebas de aceptación.
* Restricciones técnicas descubiertas durante el desarrollo.
* Cambios en integraciones externas.
* Nuevas prioridades de producto.
* Corrección de ambigüedades.
* Defectos detectados en producción.
* Mejora de procesos internos.

Ejemplo inicial:

> El cliente podrá cancelar un pedido antes de su envío.

Cambio posterior:

> El cliente podrá cancelar un pedido antes de su preparación logística. Si el
> pedido ya está en preparación, deberá solicitar cancelación manual.

El cambio parece pequeño, pero puede afectar a reglas de negocio, estados del
pedido, interfaz, pruebas, notificaciones y procesos internos.

## 2. Riesgos de no controlar los cambios

Cuando una especificación cambia sin control, aparecen problemas como:

* Desarrollo basado en versiones distintas del requisito.
* Pruebas que validan comportamientos antiguos.
* Documentación desactualizada.
* Discusiones sobre cuál era la regla vigente.
* Funcionalidades parcialmente adaptadas.
* Defectos por inconsistencias entre módulos.
* Dificultad para auditar decisiones.
* Pérdida de confianza en la documentación.

Ejemplo de riesgo:

Un equipo modifica la regla de descuentos para clientes premium, pero no
actualiza las pruebas de aceptación. En la siguiente entrega, QA detecta un
fallo que en realidad se debe a que las pruebas siguen validando la regla
antigua.

La causa no es solo técnica. Es una falta de sincronización entre
especificación, implementación y validación.

## 3. Especificaciones como artefactos versionables

Una especificación debe tratarse como un artefacto del proyecto. Esto significa
que debe poder identificarse, revisarse, comparar cambios y recuperar versiones
anteriores.

Algunos artefactos versionables son:

* Historias de usuario.
* Criterios de aceptación.
* Escenarios BDD.
* Reglas de negocio.
* Modelos de dominio.
* Contratos de API.
* Diagramas de flujo.
* Decisiones funcionales.
* Matrices de trazabilidad.
* Documentos de definición de producto.

Versionar no significa complicar el proceso. Significa que cada cambio debe
quedar claro, justificado y conectado con el resto del trabajo.

## 4. Qué significa versionar una especificación

Versionar una especificación consiste en mantener un historial ordenado de sus
cambios.

Cada versión debería permitir responder a estas preguntas:

* Qué cambió.
* Quién propuso el cambio.
* Quién lo revisó.
* Cuándo se aprobó.
* Por qué se hizo.
* Qué impacto tuvo.
* Qué pruebas se actualizaron.
* Qué versión fue implementada.
* Qué versión está vigente.

Ejemplo de historial simple:

| Versión | Fecha      | Cambio                       | Estado      |
| ------- | ---------- | ---------------------------- | ----------- |
| 1.0     | 2026-02-01 | Regla inicial de cancelación | Aprobada    |
| 1.1     | 2026-02-10 | Añadida cancelación manual   | Aprobada    |
| 1.2     | 2026-02-18 | Ajustado mensaje de error    | En revisión |

Este historial ayuda a evitar confusiones durante el desarrollo iterativo.

## 5. Niveles de versionado

No todas las especificaciones necesitan el mismo nivel de formalidad. El nivel
de versionado debe adaptarse al riesgo, tamaño y criticidad del producto.

### 5.1 Versionado informal

Se usa en equipos pequeños o fases tempranas.

Características:

* Cambios registrados en historias o tareas.
* Comentarios en herramientas colaborativas.
* Revisión ligera por el equipo.
* Poca documentación adicional.

Puede ser suficiente para cambios de bajo riesgo.

### 5.2 Versionado estructurado

Se usa cuando hay varias áreas afectadas o entregas frecuentes.

Características:

* Especificaciones en repositorio.
* Cambios mediante ramas o propuestas de cambio.
* Revisión por pares.
* Historial de versiones.
* Trazabilidad con tareas y pruebas.

Es recomendable para productos digitales con desarrollo continuo.

### 5.3 Versionado formal

Se usa en contextos regulados o de alta criticidad.

Características:

* Aprobaciones explícitas.
* Control documental.
* Auditoría.
* Firmas o validaciones formales.
* Gestión estricta de versiones.
* Matriz de impacto obligatoria.

Es habitual en banca, salud, administración pública, seguros o sistemas
críticos.

## 6. Semántica de versiones

Una forma práctica de versionar es usar números con significado.

Formato habitual:

```text
MAYOR.MENOR.PARCHE
```

Ejemplo:

```text
2.1.3
```

Interpretación posible:

* Versión mayor: cambio incompatible o cambio relevante de regla.
* Versión menor: ampliación compatible de comportamiento.
* Parche: corrección menor, aclaración o ajuste editorial.

Ejemplo aplicado a una especificación:

| Versión | Tipo   | Descripción                            |
| ------- | ------ | -------------------------------------- |
| 1.0.0   | Mayor  | Primera versión aprobada               |
| 1.1.0   | Menor  | Añadido caso de usuario premium        |
| 1.1.1   | Parche | Corregida redacción de un criterio     |
| 2.0.0   | Mayor  | Cambiada la regla principal de cálculo |

No es obligatorio usar versionado semántico, pero ayuda a comunicar el alcance
de los cambios.

## 7. Estados de una especificación

Una especificación puede pasar por distintos estados antes de ser vigente.

Estados recomendados:

* Borrador.
* En revisión.
* Aprobada.
* Implementada.
* Validada.
* Obsoleta.
* Reemplazada.

Ejemplo de flujo:

```text
Borrador -> En revisión -> Aprobada -> Implementada -> Validada
```

También puede ocurrir:

```text
Aprobada -> Obsoleta
```

O bien:

```text
Aprobada -> Reemplazada por versión 2.0
```

Los estados permiten saber qué especificación puede usarse como referencia y
cuál no.

## 8. Gobierno del cambio

El gobierno del cambio define cómo se proponen, revisan, aprueban y comunican
las modificaciones.

No todos los cambios necesitan el mismo proceso. Un cambio menor puede aprobarse
dentro del equipo. Un cambio crítico puede requerir validación de producto,
negocio, seguridad, legal o arquitectura.

Un proceso básico puede incluir:

* Solicitud de cambio.
* Descripción del motivo.
* Análisis de impacto.
* Propuesta de modificación.
* Revisión colaborativa.
* Aprobación.
* Actualización de pruebas.
* Comunicación al equipo.
* Seguimiento de implementación.

El objetivo no es burocratizar, sino evitar cambios invisibles.

## 9. Solicitud de cambio

Una solicitud de cambio describe una modificación propuesta antes de aplicarla.

Debe incluir:

* Identificador del cambio.
* Especificación afectada.
* Versión actual.
* Cambio solicitado.
* Motivo.
* Urgencia.
* Áreas afectadas.
* Riesgos conocidos.
* Responsable de decisión.

Ejemplo:

```markdown
# Solicitud de cambio CR-017

## Especificación afectada

Consulta de pedidos recientes, versión 1.2.0.

## Cambio solicitado

Cambiar el periodo de pedidos recientes de 90 días a 180 días.

## Motivo

Atención al cliente necesita reducir consultas manuales sobre pedidos antiguos.

## Impacto esperado

- Pantalla de pedidos.
- Servicio de consulta.
- Índices de base de datos.
- Pruebas de aceptación.
- Mensajes de ayuda.

## Urgencia

Media.

## Responsable de decisión

Product Owner.
```

## 10. Análisis de impacto

El análisis de impacto evalúa qué elementos se ven afectados por un cambio.

Debe considerar varias dimensiones.

### 10.1 Impacto funcional

Preguntas útiles:

* ¿Qué reglas de negocio cambian?
* ¿Qué usuarios se ven afectados?
* ¿Qué casos de uso cambian?
* ¿Qué criterios de aceptación deben actualizarse?
* ¿Qué escenarios dejan de ser válidos?
* ¿Aparecen nuevos casos límite?
* ¿Hay cambios en mensajes o flujos?

### 10.2 Impacto técnico

Preguntas útiles:

* ¿Qué servicios o módulos cambian?
* ¿Qué contratos de API se modifican?
* ¿Hay migración de datos?
* ¿Cambia el modelo de dominio?
* ¿Afecta al rendimiento?
* ¿Cambia una integración externa?
* ¿Hay impacto en seguridad?

### 10.3 Impacto en pruebas

Preguntas útiles:

* ¿Qué pruebas deben cambiar?
* ¿Qué pruebas deben eliminarse?
* ¿Qué pruebas nuevas son necesarias?
* ¿Hay pruebas automatizadas afectadas?
* ¿Deben actualizarse datos de prueba?
* ¿Hay regresiones que cubrir?

### 10.4 Impacto operativo

Preguntas útiles:

* ¿Hay que comunicar el cambio a soporte?
* ¿Hay que actualizar manuales o formación?
* ¿Hay cambios en métricas o informes?
* ¿Hay que activar una bandera de funcionalidad?
* ¿Se requiere despliegue coordinado?

## 11. Matriz de impacto

Una matriz de impacto ayuda a visualizar las consecuencias de un cambio.

Ejemplo:

| Área                | Impacto | Acción                    |
| ------------------- | ------- | ------------------------- |
| Reglas de negocio   | Alto    | Actualizar especificación |
| API de pedidos      | Medio   | Revisar contrato          |
| Interfaz de usuario | Bajo    | Cambiar texto informativo |
| Pruebas BDD         | Alto    | Actualizar escenarios     |
| Base de datos       | Medio   | Revisar índices           |
| Soporte             | Bajo    | Comunicar nueva regla     |

Esta matriz facilita la decisión de aprobar, aplazar o rechazar el cambio.

## 12. Trazabilidad entre especificación y desarrollo

La trazabilidad permite seguir un cambio desde su origen hasta su validación.

Una trazabilidad mínima conecta:

* Solicitud de cambio.
* Historia o tarea.
* Versión de especificación.
* Pull request o cambio técnico.
* Pruebas asociadas.
* Resultado de validación.
* Versión desplegada.

Ejemplo:

| Elemento       | Referencia                |
| -------------- | ------------------------- |
| Cambio         | CR-017                    |
| Especificación | Pedidos recientes v1.3.0  |
| Historia       | US-245                    |
| Pull request   | PR-812                    |
| Prueba BDD     | pedidos_recientes.feature |
| Entrega        | Release 2026.03           |

Con esta trazabilidad se puede saber qué se implementó y por qué.

## 13. Especificaciones en repositorio

Una práctica recomendable es guardar las especificaciones en un repositorio
versionado.

Posibles formatos:

* Markdown.
* AsciiDoc.
* Gherkin.
* YAML.
* JSON Schema.
* OpenAPI.
* PlantUML.
* Mermaid.

Ejemplo de estructura:

```text
specs/
  pedidos/
    consulta-pedidos.md
    cancelacion-pedidos.md
    pedidos-recientes.feature
  usuarios/
    cambio-contrasena.md
    recuperacion-contrasena.feature
  decisiones/
    adr-001-versionado-especificaciones.md
```

Esta estructura acerca la especificación al desarrollo y facilita revisiones.

## 14. Flujo colaborativo con ramas

Cuando las especificaciones están en un repositorio, se puede trabajar con un
flujo similar al del código.

Ejemplo de flujo:

```text
main
  feature/cambio-periodo-pedidos
  feature/nueva-regla-cupones
  fix/aclaracion-mensaje-error
```

Pasos habituales:

* Crear una rama para el cambio.
* Modificar la especificación.
* Actualizar escenarios y ejemplos.
* Abrir una revisión.
* Resolver comentarios.
* Aprobar el cambio.
* Fusionar a la rama principal.
* Sincronizar desarrollo y pruebas.

Este flujo permite revisar cambios antes de que sean vigentes.

## 15. Revisión de cambios

Toda modificación relevante de una especificación debería revisarse.

La revisión debe comprobar:

* Coherencia con reglas existentes.
* Claridad del lenguaje.
* Ausencia de ambigüedad.
* Impacto en criterios de aceptación.
* Impacto en pruebas.
* Compatibilidad con decisiones anteriores.
* Viabilidad técnica.
* Trazabilidad con una necesidad real.

Ejemplo de preguntas para revisión:

* ¿El cambio contradice alguna regla vigente?
* ¿Se han actualizado los escenarios afectados?
* ¿El comportamiento anterior sigue existiendo?
* ¿Hay migración o transición entre versiones?
* ¿La nueva regla está suficientemente ejemplificada?

## 16. Conflictos entre versiones

Un conflicto ocurre cuando dos o más cambios afectan a la misma parte de una
especificación de forma incompatible o ambigua.

Ejemplo de conflicto:

Versión A:

> Los pedidos pueden cancelarse hasta que entren en preparación.

Versión B:

> Los pedidos pueden cancelarse hasta que sean enviados.

Ambas reglas no son equivalentes. Si el pedido está en preparación, pero no ha
sido enviado, la versión B permite cancelar y la versión A no.

El conflicto debe resolverse antes de implementar.

## 17. Tipos de conflictos

### 17.1 Conflicto textual

Dos cambios modifican las mismas líneas de un documento.

Ejemplo:

```text
El periodo de consulta será de 90 días.
```

Cambio A:

```text
El periodo de consulta será de 180 días.
```

Cambio B:

```text
El periodo de consulta será de 365 días.
```

### 17.2 Conflicto funcional

Dos cambios no modifican el mismo texto, pero generan comportamientos
incompatibles.

Ejemplo:

* Una regla permite cancelar pedidos en preparación.
* Otra regla indica que todo pedido en preparación bloquea cambios.

### 17.3 Conflicto de prioridad

Dos áreas proponen cambios válidos, pero con objetivos distintos.

Ejemplo:

* Producto quiere reducir pasos en el registro.
* Legal exige añadir aceptación explícita de condiciones.

### 17.4 Conflicto de versión

Un equipo implementa una versión anterior mientras otro valida una versión
nueva.

Ejemplo:

* Desarrollo implementa especificación v1.2.0.
* QA prepara pruebas para especificación v1.3.0.

## 18. Estrategias de resolución de conflictos

Para resolver conflictos se puede seguir un proceso ordenado:

* Identificar las versiones en conflicto.
* Comparar las reglas afectadas.
* Revisar la intención de cada cambio.
* Consultar a los responsables funcionales.
* Evaluar impacto técnico y de negocio.
* Decidir una regla final.
* Actualizar la especificación.
* Actualizar pruebas y trazabilidad.
* Comunicar la decisión.

El resultado debe quedar registrado para evitar que el conflicto reaparezca.

## 19. Registro de decisiones

Un registro de decisiones permite documentar por qué se eligió una alternativa.

Ejemplo:

```markdown
# Decisión funcional DF-009

## Contexto

Existen dos propuestas sobre el límite de cancelación de pedidos.

## Opciones

- Permitir cancelación hasta preparación.
- Permitir cancelación hasta envío.

## Decisión

Se permite cancelación hasta preparación logística.

## Motivo

Una vez iniciada la preparación, el operador logístico puede incurrir en costes.

## Consecuencias

- Se actualiza la especificación de cancelación.
- Se añade mensaje para solicitud manual.
- Se actualizan pruebas de aceptación.
```

Este registro no sustituye a la especificación, pero explica decisiones clave.

## 20. Sincronización con desarrollo iterativo

En desarrollo iterativo, los cambios deben coordinarse con sprints, releases y
entornos de validación.

Una especificación puede estar en uno de estos momentos:

* Propuesta para una iteración futura.
* Aprobada para la iteración actual.
* Implementada parcialmente.
* Pendiente de validación.
* Desplegada en producción.
* Sustituida por una versión posterior.

Es importante no mezclar reglas futuras con reglas vigentes sin señalarlo.

Ejemplo:

```markdown
## Regla vigente en producción

El cliente puede consultar pedidos de los últimos 90 días.

## Regla aprobada para próxima entrega

El cliente podrá consultar pedidos de los últimos 180 días.
```

Esta separación evita errores durante soporte y validación.

## 21. Cambios compatibles e incompatibles

No todos los cambios tienen el mismo impacto.

### 21.1 Cambio compatible

Un cambio compatible amplía o aclara el comportamiento sin romper lo existente.

Ejemplo:

> Añadir un nuevo estado visible en la consulta de pedidos.

Si los estados anteriores siguen funcionando, el impacto puede ser moderado.

### 21.2 Cambio incompatible

Un cambio incompatible modifica una regla existente de forma que el
comportamiento anterior deja de ser válido.

Ejemplo:

> Cambiar el plazo de devolución de 30 días a 14 días.

Este cambio afecta a usuarios, soporte, pruebas, mensajes y quizá condiciones
legales.

### 21.3 Cambio editorial

Un cambio editorial mejora la redacción sin alterar comportamiento.

Ejemplo:

> Cambiar "pedido reciente" por "pedido realizado en los últimos 90 días".

Aunque parezca menor, puede ser muy útil para eliminar ambigüedad.

## 22. Versionado de escenarios BDD

Los escenarios BDD también deben evolucionar con la especificación.

Ejemplo inicial:

```gherkin
Scenario: Consultar pedidos recientes
  Given el cliente tiene pedidos de los últimos 90 días
  When consulta sus pedidos recientes
  Then el sistema muestra esos pedidos
```

Nueva versión:

```gherkin
Scenario: Consultar pedidos recientes
  Given el cliente tiene pedidos de los últimos 180 días
  When consulta sus pedidos recientes
  Then el sistema muestra esos pedidos
```

Si se conserva la historia del cambio, se entiende por qué cambió el valor.

También puede mantenerse un escenario específico para el caso límite:

```gherkin
Scenario: Incluir pedido realizado hace 180 días
  Given el cliente tiene un pedido realizado hace 180 días
  When consulta sus pedidos recientes
  Then el sistema muestra el pedido
```

## 23. Deprecación de especificaciones

A veces una especificación no desaparece de inmediato, sino que queda
deprecada. Esto significa que sigue existiendo durante una transición, pero ya
no debe usarse para nuevos desarrollos.

Ejemplo:

```markdown
# Especificación de API de clientes v1

Estado: deprecada.

Esta versión se mantiene hasta el 30 de junio de 2026 para compatibilidad con
integraciones existentes. Las nuevas integraciones deben usar la versión v2.
```

La deprecación es útil cuando hay consumidores externos o varios equipos
dependientes.

## 24. Gestión de compatibilidad

Cuando una especificación cambia, puede ser necesario mantener compatibilidad
con versiones anteriores.

Ejemplo en API:

* `GET /api/v1/orders` mantiene el contrato antiguo.
* `GET /api/v2/orders` incorpora nuevos campos y reglas.

Ejemplo en reglas de negocio:

* Contratos antiguos mantienen condiciones anteriores.
* Nuevos contratos usan condiciones actualizadas.

La compatibilidad debe decidirse de forma explícita. Mantener varias versiones
aumenta el coste de mantenimiento.

## 25. Comunicación de cambios

Un cambio aprobado debe comunicarse a las personas afectadas.

La comunicación puede incluir:

* Resumen del cambio.
* Fecha de entrada en vigor.
* Versión afectada.
* Impacto funcional.
* Impacto técnico.
* Acciones requeridas.
* Enlaces a especificaciones y pruebas.
* Contacto responsable.

Ejemplo:

```markdown
# Cambio aprobado: pedidos recientes v1.3.0

Desde la próxima entrega, la consulta de pedidos recientes incluirá pedidos de
los últimos 180 días en lugar de 90 días.

## Afecta a

- Frontend de pedidos.
- Servicio de pedidos.
- Pruebas de aceptación.
- Documentación de ayuda.

## Acción requerida

Actualizar implementación y pruebas antes de la release 2026.03.
```

## 26. Checklist de control de cambios

Antes de aprobar un cambio, se puede revisar lo siguiente:

* ¿El cambio tiene una justificación clara?
* ¿La versión anterior está identificada?
* ¿La nueva versión está identificada?
* ¿Se ha evaluado el impacto funcional?
* ¿Se ha evaluado el impacto técnico?
* ¿Se han actualizado criterios de aceptación?
* ¿Se han actualizado escenarios de prueba?
* ¿Se han identificado conflictos?
* ¿Se ha definido fecha de entrada en vigor?
* ¿Se ha comunicado a los equipos afectados?
* ¿Existe trazabilidad con la tarea o historia?
* ¿Se ha registrado la decisión?

## 27. Ejemplo completo de evolución

### 27.1 Especificación inicial

Historia:

> Como cliente, quiero cancelar un pedido para evitar recibir productos que ya
> no necesito.

Regla inicial:

> El cliente puede cancelar un pedido mientras no haya sido enviado.

Criterios iniciales:

* Un pedido pendiente puede cancelarse.
* Un pedido enviado no puede cancelarse.
* Al cancelar, el pedido pasa a estado cancelado.
* El cliente recibe una confirmación.

Escenario inicial:

```gherkin
Feature: Cancelación de pedidos

  Scenario: Cancelar un pedido pendiente
    Given existe un pedido en estado "pendiente"
    When el cliente cancela el pedido
    Then el pedido queda en estado "cancelado"
    And el cliente recibe una confirmación
```

### 27.2 Cambio solicitado

Cambio:

> El pedido no debe poder cancelarse cuando ya está en preparación logística.

Motivo:

> El operador logístico puede haber iniciado tareas con coste asociado.

### 27.3 Análisis de impacto

| Área                 | Impacto | Acción                     |
| -------------------- | ------- | -------------------------- |
| Regla de cancelación | Alto    | Cambiar criterio principal |
| Estados de pedido    | Medio   | Revisar estado preparación |
| Interfaz             | Medio   | Mostrar nueva restricción  |
| Pruebas BDD          | Alto    | Añadir escenario negativo  |
| Soporte              | Bajo    | Comunicar nueva regla      |
| Logística            | Medio   | Confirmar punto de bloqueo |

### 27.4 Nueva especificación

Nueva regla:

> El cliente puede cancelar un pedido mientras esté pendiente. Si el pedido está
> en preparación, no puede cancelarlo de forma automática.

Criterios actualizados:

* Un pedido pendiente puede cancelarse.
* Un pedido en preparación no puede cancelarse automáticamente.
* Un pedido enviado no puede cancelarse.
* Al cancelar, el pedido pasa a estado cancelado.
* Si no se puede cancelar, el sistema informa del motivo.
* El cliente puede contactar con soporte si requiere una revisión manual.

Escenarios actualizados:

```gherkin
Feature: Cancelación de pedidos

  Rule: Solo se cancelan automáticamente pedidos pendientes

    Scenario: Cancelar un pedido pendiente
      Given existe un pedido en estado "pendiente"
      When el cliente cancela el pedido
      Then el pedido queda en estado "cancelado"
      And el cliente recibe una confirmación

    Scenario: Rechazar cancelación de pedido en preparación
      Given existe un pedido en estado "en preparación"
      When el cliente cancela el pedido
      Then el sistema rechaza la cancelación automática
      And muestra el mensaje "El pedido ya está en preparación"
      And informa de que puede contactar con soporte

    Scenario: Rechazar cancelación de pedido enviado
      Given existe un pedido en estado "enviado"
      When el cliente cancela el pedido
      Then el sistema rechaza la cancelación
      And muestra el mensaje "El pedido ya ha sido enviado"
```

### 27.5 Resultado del cambio

Nueva versión:

```text
Cancelación de pedidos v2.0.0
```

Razón del cambio mayor:

> La regla principal de cancelación cambia y el comportamiento anterior deja de
> ser válido para pedidos en preparación.

## 28. Laboratorio 1: Simulación de cambio de requisito

### 28.1 Enunciado

Se dispone de la siguiente especificación vigente:

> Como cliente autenticado, quiero consultar mis pedidos recientes para revisar
> el estado de mis compras.

Regla vigente:

> Se consideran recientes los pedidos realizados en los últimos 90 días.

Criterios actuales:

* El sistema muestra pedidos de los últimos 90 días.
* Los pedidos se muestran de más reciente a más antiguo.
* Si no hay pedidos recientes, se muestra un mensaje informativo.
* Solo se muestran pedidos del cliente autenticado.

Cambio solicitado:

> Atención al cliente solicita ampliar el periodo de pedidos recientes a 180
> días para reducir consultas manuales.

Realizar un análisis de impacto y proponer la nueva versión de la
especificación.

### 28.2 Análisis de impacto

| Área              | Impacto | Justificación           | Acción              |
| ----------------- | ------- | ----------------------- | ------------------- |
| Regla de negocio  | Alto    | Cambia el periodo       | Actualizar regla    |
| Criterios         | Alto    | Cambia valor esperado   | Cambiar criterios   |
| Escenarios BDD    | Alto    | Datos de prueba cambian | Actualizar ejemplos |
| Consulta de datos | Medio   | Más registros           | Revisar rendimiento |
| Base de datos     | Medio   | Puede requerir índice   | Revisar plan        |
| Interfaz          | Bajo    | Puede no cambiar        | Revisar textos      |
| Soporte           | Bajo    | Debe conocer regla      | Comunicar           |
| Analítica         | Medio   | Cambian métricas        | Revisar informes    |

### 28.3 Riesgos identificados

* La consulta puede devolver más registros.
* El tiempo de respuesta puede aumentar.
* Las pruebas automatizadas existentes pueden fallar.
* El mensaje "pedidos recientes" puede seguir siendo ambiguo.
* Informes basados en 90 días pueden quedar inconsistentes.
* Puede haber más paginación o carga en la interfaz.

### 28.4 Decisión de versionado

El cambio modifica una regla funcional relevante. Puede considerarse una versión
menor si el sistema solo amplía resultados y no elimina comportamiento anterior.

Versión propuesta:

```text
Consulta de pedidos recientes v1.3.0
```

Si existían contratos o expectativas estrictas basadas en 90 días, podría
tratarse como versión mayor.

### 28.5 Especificación actualizada

Historia:

> Como cliente autenticado, quiero consultar mis pedidos recientes para revisar
> el estado de mis compras.

Regla actualizada:

> Se consideran recientes los pedidos realizados en los últimos 180 días.

Criterios actualizados:

* El sistema muestra pedidos realizados en los últimos 180 días.
* Los pedidos se muestran de más reciente a más antiguo.
* Solo se muestran pedidos del cliente autenticado.
* Si no hay pedidos en los últimos 180 días, se muestra un mensaje informativo.
* Un pedido realizado hace exactamente 180 días debe incluirse.
* Un pedido realizado hace más de 180 días no debe incluirse.

### 28.6 Escenarios actualizados

```gherkin
Feature: Consulta de pedidos recientes

  Rule: Los pedidos recientes son los realizados en los últimos 180 días

    Scenario: Mostrar pedidos dentro del periodo reciente
      Given existe un cliente autenticado
      And el cliente tiene un pedido realizado hace 30 días
      And el cliente tiene un pedido realizado hace 120 días
      When consulta sus pedidos recientes
      Then el sistema muestra ambos pedidos

    Scenario: Incluir pedido realizado exactamente hace 180 días
      Given existe un cliente autenticado
      And el cliente tiene un pedido realizado hace 180 días
      When consulta sus pedidos recientes
      Then el sistema muestra el pedido

    Scenario: Excluir pedido anterior al periodo reciente
      Given existe un cliente autenticado
      And el cliente tiene un pedido realizado hace 181 días
      When consulta sus pedidos recientes
      Then el sistema no muestra el pedido

    Scenario: Mostrar pedidos ordenados por fecha descendente
      Given existe un cliente autenticado
      And el cliente tiene un pedido realizado hace 10 días
      And el cliente tiene un pedido realizado hace 90 días
      When consulta sus pedidos recientes
      Then el pedido de hace 10 días aparece antes que el de hace 90 días
```

### 28.7 Plan de actualización

| Paso | Acción                             |
| ---- | ---------------------------------- |
| 1    | Registrar solicitud de cambio      |
| 2    | Actualizar especificación a v1.3.0 |
| 3    | Revisar consulta y rendimiento     |
| 4    | Actualizar pruebas BDD             |
| 5    | Ejecutar pruebas de regresión      |
| 6    | Comunicar cambio a soporte         |
| 7    | Validar en entorno de aceptación   |
| 8    | Marcar versión como implementada   |

### 28.8 Solución resumida

El cambio se acepta como ampliación funcional. La especificación pasa de 90 a
180 días, se añaden casos de borde y se actualizan pruebas de aceptación. El
impacto principal está en criterios, escenarios, rendimiento y comunicación a
soporte.

## 29. Laboratorio 2: Versionado en flujo colaborativo

### 29.1 Enunciado

Un equipo mantiene las especificaciones en un repositorio. La rama principal
contiene la especificación aprobada de recuperación de contraseña en versión
1.0.0.

Dos cambios se proponen en paralelo:

* Cambio A: el enlace de recuperación caduca en 15 minutos en lugar de 30.
* Cambio B: el mensaje para correo inexistente debe ser genérico por seguridad.

Diseñar un flujo colaborativo de versionado para incorporar ambos cambios.

### 29.2 Situación inicial

Especificación vigente:

```markdown
# Recuperación de contraseña

Versión: 1.0.0
Estado: aprobada

## Reglas

- El usuario puede solicitar recuperación mediante su correo.
- Si el correo existe, se envía un enlace de recuperación.
- El enlace caduca en 30 minutos.
- Si el correo no existe, se informa de que no hay cuenta asociada.
```

### 29.3 Ramas propuestas

```text
main
  change/caducidad-enlace-15-minutos
  change/mensaje-generico-seguridad
```

Cada rama modifica una parte distinta de la especificación.

### 29.4 Cambio A

Nueva regla:

```markdown
- El enlace caduca en 15 minutos.
```

Justificación:

> Reducir la ventana de exposición ante accesos no autorizados.

Impacto:

* Pruebas de caducidad.
* Texto de ayuda.
* Configuración del token.
* Soporte.

Versión propuesta:

```text
1.1.0
```

### 29.5 Cambio B

Nueva regla:

```markdown
- El sistema muestra siempre un mensaje genérico tras la solicitud.
```

Justificación:

> Evitar revelar si un correo está registrado.

Impacto:

* Mensajes de interfaz.
* Pruebas de seguridad.
* Pruebas de aceptación.
* Documentación de soporte.

Versión propuesta:

```text
1.1.0
```

Como ambos cambios se integran juntos, la versión final puede ser `1.1.0` si se
consideran cambios compatibles dentro de la misma evolución funcional.

### 29.6 Flujo colaborativo propuesto

```text
main
  |
  |-- change/caducidad-enlace-15-minutos
  |
  |-- change/mensaje-generico-seguridad
```

Pasos:

* Crear una rama por cada cambio.
* Asociar cada rama a una solicitud de cambio.
* Actualizar especificación y pruebas en cada rama.
* Abrir revisión para cada cambio.
* Revisar impacto funcional y de seguridad.
* Fusionar primero el cambio menos conflictivo.
* Actualizar la segunda rama con los cambios de `main`.
* Resolver posibles conflictos.
* Fusionar la segunda rama.
* Publicar especificación final como v1.1.0.

### 29.7 Especificación final

```markdown
# Recuperación de contraseña

Versión: 1.1.0
Estado: aprobada

## Reglas

- El usuario puede solicitar recuperación mediante su correo.
- Si el correo existe, se envía un enlace de recuperación.
- El enlace de recuperación caduca en 15 minutos.
- El sistema muestra siempre un mensaje genérico tras la solicitud.
- El mensaje no debe revelar si el correo está registrado.
```

### 29.8 Criterios de aceptación actualizados

* El usuario puede solicitar recuperación introduciendo un correo.
* Si el correo existe, el sistema envía un enlace de recuperación.
* El enlace caduca a los 15 minutos.
* Si el correo no existe, no se envía enlace.
* En ambos casos, el sistema muestra el mismo mensaje genérico.
* El mensaje no permite deducir si el correo está registrado.

### 29.9 Escenarios actualizados

```gherkin
Feature: Recuperación de contraseña

  Rule: La recuperación no revela si el correo está registrado

    Scenario: Solicitar recuperación con correo registrado
      Given existe una cuenta con correo "ana@example.com"
      When solicita recuperar la contraseña con "ana@example.com"
      Then el sistema envía un enlace de recuperación
      And muestra el mensaje "Si el correo existe, recibirás instrucciones"

    Scenario: Solicitar recuperación con correo no registrado
      Given no existe una cuenta con correo "nadie@example.com"
      When solicita recuperar la contraseña con "nadie@example.com"
      Then el sistema no envía ningún enlace
      And muestra el mensaje "Si el correo existe, recibirás instrucciones"

    Scenario: Rechazar enlace caducado
      Given existe un enlace de recuperación generado hace 16 minutos
      When el usuario intenta usar el enlace
      Then el sistema rechaza la operación
      And muestra el error "El enlace ha caducado"
```

### 29.10 Solución resumida

Los dos cambios pueden integrarse mediante ramas separadas y revisión
colaborativa. La versión final `1.1.0` incorpora la reducción de caducidad y el
mensaje genérico. También se actualizan criterios y escenarios para mantener la
coherencia entre especificación, seguridad y pruebas.

## 30. Laboratorio 3: Resolución de conflictos

### 30.1 Enunciado

Existen dos versiones propuestas para la especificación de cancelación de
pedidos.

Versión propuesta A:

> El cliente puede cancelar un pedido hasta que el pedido entre en preparación.

Versión propuesta B:

> El cliente puede cancelar un pedido hasta que el pedido sea enviado.

Resolver el conflicto y redactar la especificación final.

### 30.2 Identificación del conflicto

Las dos versiones definen límites distintos para la cancelación.

Estados posibles del pedido:

```text
pendiente -> confirmado -> en preparación -> enviado -> entregado
```

Comparación:

| Estado         | Versión A           | Versión B           |
| -------------- | ------------------- | ------------------- |
| Pendiente      | Permite cancelar    | Permite cancelar    |
| Confirmado     | Permite cancelar    | Permite cancelar    |
| En preparación | No permite cancelar | Permite cancelar    |
| Enviado        | No permite cancelar | No permite cancelar |

El conflicto aparece en el estado `en preparación`.

### 30.3 Análisis funcional

La versión A es más restrictiva. Protege al proceso logístico cuando el pedido
ya está siendo preparado.

La versión B es más flexible para el cliente. Permite cancelar durante más
tiempo, pero puede generar costes o incidencias operativas.

Preguntas de decisión:

* ¿Cuándo se generan costes logísticos?
* ¿Es reversible la preparación?
* ¿Qué espera el cliente en ese punto?
* ¿Hay obligaciones legales de cancelación?
* ¿Puede existir cancelación manual?
* ¿Debe diferenciarse producto físico y digital?

### 30.4 Decisión propuesta

Se adopta una regla intermedia:

> El cliente puede cancelar automáticamente un pedido hasta que entre en
> preparación. Si el pedido está en preparación, puede solicitar cancelación
> manual, pero el sistema no garantiza su aceptación.

Esta decisión resuelve el conflicto porque:

* Mantiene control operativo.
* Ofrece una alternativa al cliente.
* Evita prometer una cancelación automática inviable.
* Diferencia cancelación automática de solicitud manual.

### 30.5 Especificación final

```markdown
# Cancelación de pedidos

Versión: 2.0.0
Estado: aprobada

## Regla principal

El cliente puede cancelar automáticamente un pedido mientras el pedido no haya
entrado en preparación.

## Reglas complementarias

- Un pedido pendiente puede cancelarse automáticamente.
- Un pedido confirmado puede cancelarse automáticamente.
- Un pedido en preparación no puede cancelarse automáticamente.
- Para un pedido en preparación, el cliente puede solicitar revisión manual.
- Un pedido enviado no puede cancelarse.
- Un pedido entregado no puede cancelarse desde este flujo.
```

### 30.6 Criterios de aceptación

* Un pedido pendiente puede cancelarse automáticamente.
* Un pedido confirmado puede cancelarse automáticamente.
* Un pedido en preparación no puede cancelarse automáticamente.
* Para un pedido en preparación, el sistema permite solicitar revisión manual.
* Un pedido enviado no puede cancelarse.
* Un pedido entregado no puede cancelarse desde este flujo.
* Cuando la cancelación automática se acepta, el pedido pasa a cancelado.
* Cuando la cancelación se rechaza, el estado del pedido no cambia.

### 30.7 Escenarios verificables

```gherkin
Feature: Cancelación de pedidos

  Rule: La cancelación automática solo aplica antes de la preparación

    Scenario: Cancelar automáticamente un pedido pendiente
      Given existe un pedido en estado "pendiente"
      When el cliente cancela el pedido
      Then el pedido queda en estado "cancelado"
      And el sistema muestra una confirmación

    Scenario: Cancelar automáticamente un pedido confirmado
      Given existe un pedido en estado "confirmado"
      When el cliente cancela el pedido
      Then el pedido queda en estado "cancelado"
      And el sistema muestra una confirmación

    Scenario: Solicitar revisión manual para pedido en preparación
      Given existe un pedido en estado "en preparación"
      When el cliente intenta cancelar el pedido
      Then el sistema no cancela el pedido automáticamente
      And ofrece solicitar revisión manual
      And el pedido sigue en estado "en preparación"

    Scenario: Rechazar cancelación de pedido enviado
      Given existe un pedido en estado "enviado"
      When el cliente intenta cancelar el pedido
      Then el sistema rechaza la cancelación
      And muestra el mensaje "El pedido ya ha sido enviado"
      And el pedido sigue en estado "enviado"
```

### 30.8 Registro de decisión

```markdown
# Decisión funcional DF-014

## Contexto

Hay dos propuestas para definir hasta cuándo puede cancelarse un pedido.

## Opciones

- Permitir cancelación hasta preparación.
- Permitir cancelación hasta envío.

## Decisión

Se permite cancelación automática hasta preparación. En preparación se permite
solicitar revisión manual.

## Motivo

La preparación puede generar costes logísticos, pero se desea ofrecer una vía
de atención al cliente.

## Consecuencias

- La especificación pasa a versión 2.0.0.
- Se añaden escenarios para preparación y envío.
- Se actualizan mensajes de interfaz.
- Soporte debe conocer el flujo de revisión manual.
```

### 30.9 Solución resumida

El conflicto se resuelve distinguiendo entre cancelación automática y solicitud
manual. La versión final mantiene una regla clara, cubre el caso conflictivo y
documenta la decisión para evitar futuras interpretaciones contradictorias.

## 31. Plantilla para gestionar cambios

La siguiente plantilla puede usarse para controlar la evolución de una
especificación.

````markdown
# Solicitud de cambio

## Identificación

- Código:
- Fecha:
- Solicitante:
- Especificación afectada:
- Versión actual:

## Descripción del cambio

[Describir el cambio solicitado.]

## Motivo

[Explicar por qué se solicita.]

## Análisis de impacto

| Área | Impacto | Acción requerida |
| --- | --- | --- |
| Funcional |  |  |
| Técnico |  |  |
| Pruebas |  |  |
| Operación |  |  |
| Seguridad |  |  |

## Riesgos

- [Riesgo 1]
- [Riesgo 2]

## Decisión

- Estado:
- Responsable:
- Fecha de decisión:

## Nueva versión

- Versión:
- Estado:
- Fecha de entrada en vigor:

## Cambios en criterios de aceptación

- [Criterio actualizado 1]
- [Criterio actualizado 2]

## Escenarios afectados

```gherkin
Scenario: [Nombre del escenario]
  Given [contexto]
  When [acción]
  Then [resultado]
```

## Comunicación

- Equipos afectados:
- Acciones de comunicación:
````

## 32. Checklist de revisión de especificaciones versionadas

Antes de cerrar una versión, conviene comprobar:

* La versión tiene identificador único.
* El estado de la especificación es claro.
* El cambio tiene justificación.
* La versión anterior puede identificarse.
* Las reglas modificadas están localizadas.
* Los criterios de aceptación están actualizados.
* Los escenarios afectados están actualizados.
* Los casos de borde están cubiertos.
* Los conflictos se han resuelto.
* Las decisiones relevantes están registradas.
* Las pruebas asociadas están sincronizadas.
* La documentación relacionada se ha revisado.
* Los equipos afectados han sido informados.

## 33. Buenas prácticas

Para gestionar bien la evolución de especificaciones:

* Versionar las especificaciones junto al resto de artefactos.
* Evitar cambios informales sin trazabilidad.
* Separar cambios editoriales de cambios funcionales.
* Revisar el impacto antes de aprobar.
* Mantener criterios y pruebas alineados.
* Registrar decisiones importantes.
* Comunicar cambios con claridad.
* Identificar la versión vigente.
* No mezclar reglas futuras con reglas actuales.
* Resolver conflictos antes de implementar.
* Usar ejemplos concretos para validar cambios.
* Mantener una relación clara entre cambio, código y prueba.

## 34. Antipatrones frecuentes

### 34.1 Cambiar sin registrar

Problema:

> Se modifica una regla en una reunión, pero nadie actualiza la especificación.

Consecuencia:

El equipo trabaja con información inconsistente.

### 34.2 Sobrescribir la historia

Problema:

> Se edita el documento y se elimina la regla anterior sin dejar rastro.

Consecuencia:

No se puede explicar por qué cambió el comportamiento.

### 34.3 Versionar solo el código

Problema:

> El repositorio muestra cambios técnicos, pero no cambios funcionales.

Consecuencia:

La documentación queda desconectada de la implementación.

### 34.4 No actualizar pruebas

Problema:

> La especificación cambia, pero las pruebas siguen validando la versión previa.

Consecuencia:

Aparecen falsos fallos o falsas validaciones.

### 34.5 Aprobar cambios sin impacto

Problema:

> Se acepta un cambio aparentemente pequeño sin analizar dependencias.

Consecuencia:

El cambio provoca efectos no previstos en otras áreas.

## 35. Resumen

Las especificaciones evolucionan constantemente. Por ello deben gestionarse como
artefactos versionables, revisables y trazables.

Versionar una especificación permite saber qué cambió, por qué cambió, quién lo
aprobó y qué impacto tuvo. El análisis de impacto ayuda a anticipar efectos
funcionales, técnicos, operativos y de validación.

El gobierno del cambio no busca ralentizar al equipo. Su propósito es evitar
ambigüedades, inconsistencias y pérdida de conocimiento. En un desarrollo
iterativo, una buena gestión de versiones permite que negocio, desarrollo y QA
trabajen sobre la misma realidad.

Una especificación bien evolucionada mantiene coherencia entre reglas de
negocio, criterios de aceptación, escenarios ejecutables, pruebas y producto
implementado.
