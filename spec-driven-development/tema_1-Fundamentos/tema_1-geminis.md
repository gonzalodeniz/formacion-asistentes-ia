Aquí tienes el desarrollo completo del **Tema 1: Fundamentos de Spec Driven Development**, estructurado para ser impartido como material de estudio o guion para una sesión formativa.

---

## Tema 1: Fundamentos de Spec Driven Development (SDD)

> El Spec Driven Development (SDD) no trata de escribir más documentos, sino de escribir el documento correcto. Consiste en elevar la especificación a la categoría de código, convirtiéndola en el eje central que alinea a todo el equipo antes, durante y después de la construcción del software.

### ¿Qué es el SDD y qué problemas resuelve?

El Spec Driven Development es una metodología de ingeniería de software donde la creación, el refinamiento y la validación de las especificaciones dirigen todo el ciclo de vida del desarrollo. En lugar de tratar los requisitos como un trámite inicial o una transcripción de lo que ya se ha programado, el SDD utiliza la especificación como el contrato definitivo que guía el diseño, el código y las pruebas.

Este enfoque nace para resolver problemas endémicos en la industria del software:
* **El teléfono escacharrado:** Negocio pide "A", análisis diseña "B", desarrollo programa "C" y calidad prueba "D".
* **El coste del retrabajo:** Descubrir que una funcionalidad no cumple con la expectativa del cliente cuando ya está programada y desplegada en entornos de prueba.
* **La documentación muerta:** Wikis y documentos de texto que se desactualizan el mismo día que el equipo empieza a escribir código.
* **La parálisis por análisis:** Bloqueos en el desarrollo debido a la falta de definiciones claras sobre casos límite o reglas de negocio complejas.

### Principios Básicos del Desarrollo Guiado por Especificaciones

Para aplicar SDD correctamente, el equipo debe interiorizar los siguientes principios fundamentales:

* **La Especificación es el artefacto de primer nivel:** Tiene tanta o más importancia que el código fuente. Si el código hace algo distinto a la especificación, el código es incorrecto (incluso si "funciona").
* **Fuente de Verdad Única (SSOT):** Negocio, Desarrollo, QA y Diseño acuden al mismo lugar para entender qué debe hacer el sistema. No hay múltiples versiones de la verdad repartidas en correos o chats.
* **Verificabilidad intrínseca:** Una especificación en SDD no es una lista de deseos ("El sistema debe ser rápido"). Debe estar redactada de tal forma que se pueda comprobar de manera objetiva y, preferiblemente, automatizada.
* **Evolución síncrona:** Si el comportamiento del sistema debe cambiar, primero se cambia la especificación, se aprueba, y luego se actualiza el código y las pruebas para cumplir con la nueva especificación.

### SDD frente a otros enfoques de desarrollo

Es habitual confundir el SDD con otras prácticas ágiles o de calidad. La siguiente tabla aclara las diferencias fundamentales, mostrando que no son necesariamente excluyentes, pero sí tienen focos distintos.

| Enfoque | Foco Principal | Artefacto Central | Momento de Validación |
| :--- | :--- | :--- | :--- |
| **Tradicional (Cascada)** | Fases secuenciales y exhaustivas | Documento de requisitos (estático) | Al final del ciclo (Fase de QA) |
| **TDD (Test Driven Dev.)** | Diseño técnico y código limpio | Pruebas unitarias | Durante el desarrollo (ciclo Red-Green-Refactor) |
| **BDD (Behavior Driven Dev.)** | Comportamiento del usuario final | Ejemplos en lenguaje natural (Gherkin) | Antes y durante el desarrollo |
| **SDD (Spec Driven Dev.)** | Alineación global e interfaces | Especificación formal, contratos y APIs | Continua (Diseño, Desarrollo y QA) |

### La Especificación como Fuente de Verdad Compartida

El éxito del SDD radica en cómo los diferentes perfiles interactúan con la especificación a lo largo del tiempo. 

* **Para Negocio y Producto:** Es la garantía de que sus necesidades han sido comprendidas sin ambigüedades y el contrato que asegura el retorno de inversión.
* **Para Diseño (UX/UI):** Establece los límites funcionales, los estados del sistema y los datos disponibles para construir las interfaces.
* **Para Desarrollo:** Es la hoja de ruta exacta. Elimina la necesidad de tomar decisiones funcionales o inventar reglas de negocio durante la codificación. Especifica los contratos (API, esquemas de datos) antes de escribir la lógica.
* **Para Calidad (QA):** Es la base inmutable sobre la que se construyen los planes de prueba y los criterios de aceptación automatizados.

---

## Guía de Laboratorios Prácticos (Tema 1)

A continuación, se detallan los ejercicios prácticos para consolidar los conocimientos teóricos.

### Laboratorio 1: Identificación de problemas en proyectos sin especificaciones claras
**Dinámica:** Análisis de caso práctico.
**Instrucciones:** Lee el siguiente escenario: *"El equipo de e-commerce ha lanzado un nuevo sistema de descuentos. Negocio pidió 'descuentos acumulables para clientes VIP'. Desarrollo programó que todos los descuentos de la base de datos se sumaran. En producción, un cliente VIP combinó un descuento del 50% por Black Friday con un 60% por liquidación, obteniendo un 110% de descuento y llevándose productos gratis."*
**Entregable:** Un documento breve identificando en qué punto del ciclo de vida falló la comunicación y cómo el enfoque SDD (una regla de negocio especificada y verificada antes del código) habría evitado el impacto económico.

### Laboratorio 2: Comparativa entre requisitos ambiguos y especificaciones verificables
**Dinámica:** Taller de reescritura.
**Instrucciones:** Toma la siguiente lista de "requisitos tradicionales" y transformálos en especificaciones verificables que un desarrollador y un tester puedan utilizar sin hacer preguntas adicionales.
* *Requisito ambiguo 1:* "La contraseña debe ser segura."
* *Requisito ambiguo 2:* "El sistema debe avisar si hay un error al pagar."
* *Requisito ambiguo 3:* "Los usuarios inactivos serán borrados."
**Entregable:** Una tabla contrastando el requisito original con su versión SDD (incluyendo condiciones exactas, umbrales temporales, formatos requeridos y flujos de error explícitos).

### Laboratorio 3: Mapa conceptual de SDD dentro del ciclo de desarrollo
**Dinámica:** Modelado visual.
**Instrucciones:** Utilizando una herramienta de pizarra virtual (como Miro, FigJam o draw.io), diseña un diagrama de flujo de un ciclo de desarrollo ágil (desde la ideación de la historia de usuario hasta el despliegue).
**Entregable:** Un mapa conceptual donde se ubique exactamente en qué momentos se crea, se revisa, se automatiza y se consulta la especificación, demostrando visualmente que no es un paso aislado, sino un proceso continuo.

Aquí tienes una propuesta de soluciones para los tres laboratorios del Tema 1. Estas respuestas están diseñadas para ilustrar la mentalidad exacta que el Spec Driven Development (SDD) exige a los equipos.

-----

### Solución Laboratorio 1: Identificación de problemas en proyectos sin especificaciones

**El fallo en el ciclo de vida:**
El error ocurrió en la transición directa entre la **ideación de negocio** y la **implementación técnica**. Hubo una ausencia total de la fase de descubrimiento y definición de reglas de dominio. El desarrollador interpretó literalmente la frase "acumulables", asumiendo una suma matemática simple ($A + B$), sin tener en cuenta las invariantes lógicas del negocio (nadie te paga por llevarte un producto).

**Cómo lo habría evitado el enfoque SDD:**
En un entorno SDD, la frase "descuentos acumulables para clientes VIP" no se habría aceptado como un requisito listo para desarrollo. Antes de escribir código, el equipo habría definido y validado la especificación mediante casos límite.

El documento de especificación habría incluido reglas explícitas (contratos) como:

  * **Regla de negocio (Invariante):** El porcentaje máximo de descuento aplicado a una cesta nunca podrá ser superior al 99% del valor total de los productos.
  * **Criterio de aceptación verificable:** \* *Dado* un cliente VIP con un producto de 100€ en el carrito.
      * *Y* que tiene un cupón de Black Friday del 50%.
      * *Y* que el producto tiene una rebaja de liquidación del 60%.
      * *Cuando* se aplican ambos descuentos.
      * *Entonces* el sistema suma los descuentos hasta el tope permitido (99%), dejando el precio final en 1€, y muestra el mensaje: *"Se ha aplicado el descuento máximo permitido"*.

Al tener esto especificado, el desarrollador habría implementado obligatoriamente una condición de límite máximo, y el equipo de QA habría diseñado un test automatizado exacto para este escenario antes de salir a producción.

-----

### Solución Laboratorio 2: Comparativa entre requisitos ambiguos y especificaciones verificables

A continuación se muestra cómo se transforma un "deseo" en un contrato ejecutable y sin margen a la interpretación subjetiva.

| Requisito Ambiguo (Tradicional) | Especificación Verificable (Enfoque SDD) |
| :--- | :--- |
| **1.** "La contraseña debe ser segura." | **Regla de validación de credenciales:**<br>La contraseña debe contener un mínimo de 12 caracteres. Debe incluir obligatoriamente: al menos una letra mayúscula (A-Z), una letra minúscula (a-z), un número (0-9) y un carácter especial (`!@#$%^&*`). Si no cumple, el sistema mostrará el error HTTP 400 con el mensaje exacto: *"La contraseña no cumple los requisitos mínimos de seguridad"*. |
| **2.** "El sistema debe avisar si hay un error al pagar." | **Flujo de excepción en pasarela de pago:**<br>Si la API del proveedor de pagos (ej. Stripe) devuelve un código de error `5xx` (Timeout o Caída), el sistema cancelará la reserva en base de datos, liberará el stock del carrito y mostrará al usuario un modal de error rojo (\#FF0000) con el texto: *"Problemas de conexión con el banco. Tu tarjeta no ha sido cargada. Inténtalo en 5 minutos"*, registrando el `TransactionID` en el log del servidor. |
| **3.** "Los usuarios inactivos serán borrados." | **Política de retención de datos (Proceso Batch):**<br>Un proceso automatizado (Cron) se ejecutará diariamente a las 02:00 AM UTC. Este proceso identificará a los usuarios cuyo campo `last_login_date` sea anterior a exactamente 365 días. <br> - A los 335 días de inactividad: Enviará un email automático con el asunto "Tu cuenta caducará en 30 días".<br> - A los 365 días: Aplicará un *soft-delete* (marcará `is_active = false` y anonimizará el email) en la base de datos. Nunca realizará un borrado físico (*hard-delete*). |

-----

### Solución Laboratorio 3: Mapa conceptual de SDD dentro del ciclo de desarrollo

Dado que el entregable es visual, aquí tienes la estructura textual detallada de cómo debe quedar representado ese diagrama de flujo, demostrando que la especificación es el centro del ciclo iterativo:

**1. Ideación (Punto de entrada)**

  * **Acción:** Negocio identifica una necesidad o mejora.
  * **Artefacto:** Se redacta un borrador inicial del requisito.

**2. Descubrimiento y Refinamiento (El momento clave)**

  * **Acción:** Sesión colaborativa (ej. dinámica de los *Tres Amigos*: Negocio, Desarrollo, QA).
  * **Transformación:** El borrador se traduce a **La Especificación Oficial** (Reglas, Contratos de API, Criterios de Aceptación, Casos límite).
  * **Estado:** La especificación se aprueba y se convierte en la única fuente de verdad.

**3. Bifurcación paralela (Desarrollo y Pruebas)**
A partir de la especificación aprobada, el trabajo fluye en paralelo:

  * *Camino A (Desarrollo):* Escribe el código arquitectónico y la lógica de negocio guiándose **únicamente** por los contratos e invariantes definidos.
  * *Camino B (Calidad / QA):* Escribe los scripts de automatización de pruebas basados **literalmente** en los criterios de aceptación de la especificación.

**4. Validación continua (CI/CD)**

  * **Acción:** El código de Desarrollo se cruza con las pruebas de QA.
  * **Chequeo:** ¿El software hace exactamente lo que dice La Especificación?
      * *Si falla:* Se devuelve a Desarrollo.
      * *Si el comportamiento esperado cambió:* Se vuelve a la Fase 2 (modificar especificación primero).

**5. Despliegue y Documentación Viva**

  * **Acción:** El software pasa a producción.
  * **Artefacto:** La Especificación se consolida en el repositorio de conocimiento del equipo (Living Documentation) y queda como manual técnico y funcional actualizado del sistema, listo para futuras evoluciones.