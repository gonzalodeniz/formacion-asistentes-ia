# Tema 3. Descubrimiento y refinamiento de requisitos

> Los requisitos rara vez se "recopilan" como si fueran manzanas en un árbol;
> en realidad, se **descubren**. El refinamiento es el proceso de pelar las
> capas de ambigüedad de una idea de negocio hasta revelar un núcleo sólido que
> pueda programarse y probarse.

## 1. De la Necesidad a la Especificación

El desarrollo de software suele comenzar con una necesidad de negocio, a menudo
expresada de forma vaga, emocional u orientada a la solución (ej.
*"Necesitamos un botón mágico que exporte todo para el equipo de
contabilidad"*). En SDD, el primer paso es retroceder y entender el
**problema subyacente**.

Para convertir necesidades en requisitos estructurados, utilizamos técnicas de
descubrimiento:

- **Entrevistas y Cuestionarios:** Para extraer el contexto, los actores
  involucrados y el valor de negocio esperado.
- **Example Mapping (Mapeo con Ejemplos):** Una técnica altamente recomendada
  en SDD. Consiste en desglosar una historia de usuario identificando las
  **Reglas de Negocio** y asociando a cada regla **Ejemplos concretos**. Las
  dudas o bloqueos se marcan como **Preguntas** a resolver antes de empezar el
  desarrollo.
- **Event Storming:** Para sistemas complejos, ayuda a descubrir eventos de
  dominio, comandos y flujos cronológicos de forma colaborativa.

## 2. El Refinamiento Iterativo (Pelar la cebolla)

Una especificación no se escribe perfecta en el primer intento. Requiere un
proceso de refinamiento incremental donde el nivel de detalle aumenta a medida
que nos acercamos al momento del desarrollo.

1. **Nivel Épica / Visión:** "Queremos un sistema de gestión de devoluciones
   para mejorar la satisfacción del cliente." (Demasiado grande para
   desarrollar).
2. **Nivel Historia / Funcionalidad:** "Como cliente, quiero devolver un
   producto defectuoso desde la app para recuperar mi dinero." (Mejor, pero
   aún ambiguo).
3. **Nivel Especificación SDD (Refinado):** Se definen los contratos exactos:
   "Si el producto se compró hace menos de 14 días (Regla 1) y pertenece a la
   categoría 'Electrónica' (Regla 2), el sistema emitirá una etiqueta de envío
   gratuita y reembolsará el 100% al método de pago original (Postcondición)."

## 3. La regla de los "Tres Amigos" y la Validación Temprana

El mayor riesgo en el software es construir la funcionalidad incorrecta. Para
evitarlo, el SDD fomenta la validación temprana involucrando a los
*stakeholders* y al equipo técnico antes de escribir una sola línea de código.

La dinámica más efectiva es la sesión de los **"Tres Amigos"**:

- **Negocio / Producto:** Aporta la visión, las reglas funcionales y define
  *qué* valor aporta.
- **Desarrollo:** Analiza la viabilidad técnica, propone soluciones de
  arquitectura y define el *cómo* (contratos, APIs).
- **Calidad (QA):** Cuestiona los flujos alternativos, los casos límite (edge
  cases) y define *cómo se probará*.

Juntos, revisan la especificación. Si Negocio no puede responder a una pregunta
de QA (ej. *"¿Qué pasa si el cliente devuelve una caja vacía?"*), la
especificación se marca como **"No lista"** (Not Ready for Dev) y se devuelve
a la fase de descubrimiento.

---

## Soluciones a los Laboratorios (Tema 3)

### Laboratorio 1: Transformar entrevistas de negocio en especificaciones iniciales

**Dinámica:** Se proporciona la transcripción de una entrevista caótica con un
Product Manager.

*Transcripción:* "A ver, los comerciales se quejan de que tardan mucho en hacer
presupuestos. Necesito que en la web, cuando un cliente pide un presupuesto, el
sistema le asigne automáticamente el comercial que tenga menos carga de
trabajo. Ah, y si el cliente es 'Premium', tiene que ir directo a la directora
comercial. Y que envíe un PDF."

**Solución (Extracción Estructurada):**
El objetivo es limpiar el "ruido" y estructurar las entidades, actores y
reglas.

- **Actores:** Cliente (Estándar / Premium), Comercial, Directora Comercial.
- **Entidades:** Petición de Presupuesto, Carga de trabajo (KPI a definir),
  Documento PDF.
- **Reglas de Enrutamiento (El núcleo de la especificación):**
  - *Regla 1 (VIP):* SI `tipo_cliente == 'Premium'`, ENTONCES asignar petición
    a `rol: Directora_Comercial`.
  - *Regla 2 (Balanceo):* SI `tipo_cliente == 'Estándar'`, ENTONCES asignar al
    comercial con menor número de peticiones en estado "Abierto".
  - *Regla 3 (Notificación):* En ambos casos, el sistema generará un resumen en
    formato PDF y lo adjuntará al perfil de la petición.
- **Dudas a despejar (Descubiertas en el análisis):** ¿Qué ocurre si hay un
  empate a carga de trabajo entre dos comerciales? ¿Qué pasa si la directora
  está de vacaciones? *(Estas preguntas impiden que el requisito pase a
  desarrollo hasta ser respondidas).*

### Laboratorio 2: Taller de refinamiento incremental de requisitos

**Dinámica:** Partir de un requisito de alto nivel y refinarlo utilizando la
técnica de *Example Mapping* (Reglas y Ejemplos).

*Requisito inicial:* "Los usuarios deben poder usar un cupón de descuento de
bienvenida del 10%."

**Solución (Refinamiento SDD):**

- **Historia:** Aplicación de cupón "BIENVENIDA10".
- **Regla de Negocio 1:** El cupón solo es válido para la primera compra del
  usuario.
  - *Ejemplo 1.1:* Un usuario recién registrado aplica el cupón -> **Éxito (10%
    descuento).**
  - *Ejemplo 1.2:* Un usuario que ya tiene un pedido "Completado" en su
    historial intenta aplicar el cupón -> **Error: "Este cupón es solo para
    nuevos clientes".**
- **Regla de Negocio 2:** No aplica a gastos de envío.
  - *Ejemplo 2.1:* Cesta de 100€ + 5€ de envío. Se aplica cupón -> Descuento de
    10€ (10% de 100€). Total a pagar: 95€.
- **Regla de Negocio 3:** El cupón caduca a los 30 días del registro.
  - *Ejemplo 3.1:* Usuario se registró el 1 de Marzo. Intenta usarlo el 5 de
    Abril -> **Error: "El cupón ha caducado".**

Al refinarlo de esta manera, el equipo de desarrollo tiene las condiciones
lógicas exactas y el equipo de QA tiene los escenarios de prueba ya redactados.

### Laboratorio 3: Validación de especificaciones con roles simulados

**Dinámica:** Roleplay (Juego de roles). Tres personas asumen los roles de
Negocio, Desarrollo y QA para revisar la especificación refinada del
Laboratorio 2. El objetivo de QA y Dev es encontrar las "grietas" en la idea de
Negocio.

**Solución (Ejemplo del resultado de la dinámica):**

- **Desarrollo:** "Negocio, sobre la Regla 1 (solo primera compra). ¿Qué
  validamos, el email o la tarjeta de crédito? Porque un usuario podría crearse
  20 emails falsos para tener el 10% infinito."
- **Negocio:** "Buen punto. No había pensado en el fraude. Usemos la huella de
  la tarjeta o el número de teléfono para evitar duplicados."
- **QA:** "Sobre la Regla 2 (No aplica al envío). ¿Qué pasa si el 10% de
  descuento hace que el total de la cesta baje de los 50€, que es nuestro
  límite actual para 'Envío Gratis'?"
- **Negocio:** "Vaya. El descuento no debería hacer perder el envío gratis. El
  cálculo del envío gratis debe evaluarse *antes* de aplicar el cupón."

**Actualización de la Especificación tras el Roleplay:**
Se añaden dos nuevas reglas fundamentales descubiertas en la charla:

- *Nueva Invariante Técnica:* La validación de "nuevo cliente" se hará cruzando
  el hash del método de pago, no solo el correo electrónico.
- *Nueva Regla Funcional:* El umbral para promociones de envío (ej. Envío
  Gratis > 50€) se calcula sobre el subtotal bruto de la cesta, *antes* de
  deducir cupones.
