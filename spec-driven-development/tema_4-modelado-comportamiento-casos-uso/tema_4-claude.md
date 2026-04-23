# Tema 4. Modelado del comportamiento y casos de uso

## 4.1. Introducción

En los temas anteriores hemos trabajado cómo descubrir necesidades, estructurar
requisitos y redactar especificaciones con calidad. Pero hay un paso intermedio
que muchos equipos descuidan: **modelar el comportamiento** del sistema antes de
especificarlo en detalle.

Modelar el comportamiento significa describir **qué hace el sistema** en respuesta
a las acciones de sus usuarios y a los eventos de su entorno, de forma
estructurada, completa y comprensible. No se trata de describir cómo está
construido internamente (eso es diseño técnico), sino de describir su
comportamiento observable desde fuera.

El instrumento clásico para este modelado es el **caso de uso**: una descripción
narrativa de la interacción entre un actor y el sistema para lograr un objetivo.
Los casos de uso llevan décadas en la ingeniería de software, pero su calidad
varía enormemente: desde descripciones vagas de una línea hasta documentos
detallados que cubren todos los flujos posibles.

En el contexto de SDD, el caso de uso no es un fin en sí mismo, sino un
**vehículo para descubrir, comunicar y verificar** el comportamiento esperado.
Un buen caso de uso:

- Ayuda al equipo a entender qué debe hacer el sistema antes de diseñar cómo.
- Sirve como base para derivar criterios de aceptación y tests.
- Es comprensible tanto para perfiles técnicos como para negocio.
- Revela flujos alternativos y excepciones que de otro modo se descubrirían
  en producción.

Este tema enseña a escribir casos de uso con la precisión que SDD exige,
a modelar escenarios alternativos y excepcionales, y a conectar el modelado
del comportamiento con la validación posterior.

---

## 4.2. Conceptos fundamentales

### 4.2.1. Actor

Un actor es cualquier entidad que interactúa con el sistema desde fuera de
sus límites. Puede ser una persona (con un rol concreto), otro sistema o un
proceso automatizado.

Tipos de actores:

**Actor primario**: el que inicia la interacción y obtiene un resultado de
valor. Ejemplo: el cliente que realiza un pedido.

**Actor secundario**: el que participa en la interacción sin haberla
iniciado, normalmente proporcionando un servicio al sistema. Ejemplo: la
pasarela de pago que procesa el cobro, o el servicio de correo que envía
la confirmación.

**Actor temporal**: un evento programado o un reloj que dispara una acción.
Ejemplo: un cron que ejecuta la generación de pedidos recurrentes cada día
a las 06:00.

Buenas prácticas al definir actores:

- Nombrar al actor por su **rol**, no por su nombre o puesto.
  "Gestor comercial" es mejor que "Laura" o "Directora comercial".
- Un mismo individuo puede actuar con distintos roles en distintos casos
  de uso. El administrador que también es gestor comercial es dos actores
  diferentes según el caso.
- No confundir el actor con el sistema. El sistema no es actor de sí
  mismo. Si el sistema hace algo "solo", el actor es el evento o el
  temporizador que lo desencadena.

### 4.2.2. Caso de uso

Un caso de uso describe una secuencia de interacciones entre un actor y el
sistema para alcanzar un **objetivo concreto** del actor. Es una unidad de
comportamiento funcional con valor propio.

Características de un buen caso de uso:

- Tiene un **objetivo claro**: "Realizar un pedido", "Cancelar una
  suscripción", "Generar un informe de ventas". Si el objetivo no se
  puede expresar en una frase, probablemente no es un caso de uso sino
  varios.
- Describe **comportamiento observable**, no implementación interna.
  "El sistema muestra un mensaje de confirmación" es observable.
  "El sistema inserta un registro en la tabla pedidos" es implementación.
- Tiene un **inicio y un fin definidos**. Empieza cuando el actor realiza
  una acción y termina cuando el actor obtiene un resultado (exitoso o no).
- Cubre el **flujo principal** y los **flujos alternativos y
  excepcionales**.

### 4.2.3. Escenario

Un escenario es una **instancia concreta** de un caso de uso: un camino
específico a través de los flujos del caso de uso, con datos concretos.

Si el caso de uso "Realizar un pedido" tiene un flujo principal, tres
flujos alternativos y dos excepciones, cada combinación posible de esos
flujos es un escenario distinto:

- Escenario 1: el cliente hace un pedido de 3 productos, paga con
  tarjeta, todo sale bien.
- Escenario 2: el cliente hace un pedido pero uno de los productos
  no tiene stock.
- Escenario 3: el cliente hace un pedido, el pago es rechazado.
- Escenario 4: el cliente hace un pedido que requiere aprobación interna.

Los escenarios son la materia prima de los tests de aceptación.

### 4.2.4. Flujos

El comportamiento descrito en un caso de uso se organiza en tres tipos de
flujos:

**Flujo principal** (camino feliz o *happy path*): la secuencia de pasos
que ocurre cuando todo va bien. Es el camino más directo desde el inicio
hasta el objetivo cumplido. Todo caso de uso tiene exactamente un flujo
principal.

**Flujos alternativos**: variaciones legítimas del flujo principal que
conducen a un resultado exitoso pero por un camino diferente. Ejemplo:
el cliente paga con crédito en lugar de con tarjeta; el resultado es el
mismo (pedido confirmado) pero el camino es diferente.

**Flujos excepcionales**: situaciones de error o condiciones inesperadas
que impiden alcanzar el objetivo. Ejemplo: el pago es rechazado, el
stock es insuficiente, el servicio externo no responde.

---

## 4.3. Estructura de un caso de uso

### 4.3.1. Plantilla de caso de uso para SDD

La siguiente plantilla es compatible con la plantilla de especificación del
Tema 2 y añade los elementos específicos del modelado de comportamiento:

**Metadatos**:

- ID (formato: CU-NNN)
- Título (objetivo del actor en forma verbal: "Realizar pedido",
  "Cancelar suscripción")
- Actor primario
- Actores secundarios
- Estado y versión
- Autor y fecha

**Cuerpo**:

- Descripción breve (1-2 frases que resuman el objetivo y el contexto)
- Precondiciones (qué debe ser cierto antes de que comience el caso de uso)
- Postcondiciones de éxito (qué es cierto cuando el caso de uso termina
  con éxito)
- Postcondiciones de fallo (qué es cierto cuando el caso de uso termina
  sin éxito)
- Flujo principal (secuencia numerada de pasos)
- Flujos alternativos (variaciones del flujo principal, referenciadas por
  el paso donde divergen)
- Flujos excepcionales (errores y condiciones de fallo)
- Reglas de negocio aplicables (referencia a especificaciones de dominio)
- Requisitos no funcionales asociados (rendimiento, seguridad, usabilidad)
- Dependencias (otros casos de uso, especificaciones, contratos)
- Escenarios de verificación (instancias concretas para testing)

### 4.3.2. Ejemplo completo: caso de uso "Realizar pedido"

```text
ID:               CU-010
Título:           Realizar pedido online
Actor primario:   Cliente B2B (autenticado)
Actores secundarios:
  - Pasarela de pago (para cobro con tarjeta)
  - Servicio de correo (para confirmación)
  - ERP (para registro del pedido y reserva de stock)
Estado:           Aprobada (v2.1)
Autor:            Equipo de análisis — 2025-03-20
Última mod.:      2025-04-12 (v2.1: añadido flujo de aprobación)

DESCRIPCIÓN
El cliente selecciona productos del catálogo, los añade al carrito,
elige dirección de envío y método de pago, y confirma el pedido.
El sistema procesa el pago (si aplica), registra el pedido en el
ERP y envía confirmación al cliente.

PRECONDICIONES
  PRE-1. El cliente está autenticado en el sistema.
  PRE-2. El cliente tiene al menos una dirección de envío registrada.
  PRE-3. El carrito contiene al menos un producto con stock disponible.

POSTCONDICIONES DE ÉXITO
  POST-1. El pedido está registrado en el sistema con estado
           "confirmado" (o "pendiente de aprobación" si aplica).
  POST-2. El stock de cada producto se ha decrementado en la
           cantidad pedida.
  POST-3. Si el pago es con tarjeta, el cobro se ha realizado.
  POST-4. El cliente ha recibido un correo de confirmación.
  POST-5. El pedido se ha sincronizado con el ERP.

POSTCONDICIONES DE FALLO
  POST-F1. No se ha creado ningún pedido.
  POST-F2. No se ha modificado el stock.
  POST-F3. No se ha realizado ningún cobro.
  POST-F4. El carrito permanece intacto.

FLUJO PRINCIPAL

  1. El cliente accede a la pantalla de checkout desde el carrito.
  2. El sistema muestra el resumen del carrito: productos, cantidades,
     precios unitarios (con descuentos aplicados si corresponde),
     subtotal por línea e importe total.
  3. El cliente selecciona una dirección de envío de entre sus
     direcciones registradas.
  4. El sistema calcula los gastos de envío según la dirección y el
     peso total, y actualiza el importe total.
  5. El cliente selecciona el método de pago:
     a. Si tiene crédito aprobado: selecciona "Pago a crédito (30/60
        días)".
     b. Si no: selecciona "Pago con tarjeta" e introduce los datos
        de la tarjeta.
  6. El cliente pulsa "Confirmar pedido".
  7. El sistema valida el stock de todos los productos del carrito.
  8. El sistema procesa el pago (si es con tarjeta).
  9. El sistema registra el pedido con estado "confirmado", genera
     un número de referencia y decrementa el stock.
  10. El sistema sincroniza el pedido con el ERP.
  11. El sistema envía un correo de confirmación al cliente con el
      resumen del pedido y el número de referencia.
  12. El sistema muestra la pantalla de confirmación: "Tu pedido
      #[REF] ha sido confirmado."

FLUJOS ALTERNATIVOS

  FA-1: Pago a crédito (diverge en paso 5)
    5a. El cliente selecciona "Pago a crédito (30 días)" o
        "Pago a crédito (60 días)".
    5b. El sistema verifica que el crédito disponible del cliente
        es suficiente para cubrir el importe del pedido.
    5c. Si el crédito es suficiente: se continúa en el paso 6
        sin procesar pago inmediato.
    5d. Si el crédito es insuficiente: ver FE-3.

  FA-2: Pedido con flujo de aprobación (diverge en paso 9)
    9a. Si el cliente pertenece a una organización con flujo de
        aprobación activado:
    9b. El pedido se registra con estado "pendiente de aprobación"
        en lugar de "confirmado".
    9c. No se decrementa el stock (se reserva temporalmente
        durante 48 horas).
    9d. Se notifica al aprobador designado.
    9e. El sistema muestra: "Tu pedido #[REF] está pendiente de
        aprobación por [nombre del aprobador]."
    9f. Se continúa en paso 11 (correo con estado "pendiente").

  FA-3: Cliente añade nueva dirección durante el checkout (diverge
  en paso 3)
    3a. El cliente pulsa "Añadir nueva dirección".
    3b. El sistema muestra el formulario de nueva dirección.
    3c. El cliente completa y guarda la dirección.
    3d. La nueva dirección queda seleccionada.
    3e. Se continúa en paso 4.

FLUJOS EXCEPCIONALES

  FE-1: Stock insuficiente (detectado en paso 7)
    7a. El sistema detecta que uno o más productos no tienen stock
        suficiente.
    7b. El sistema muestra un aviso por cada producto afectado:
        "[Producto]: solo quedan [N] unidades disponibles."
    7c. El sistema ofrece al cliente dos opciones:
        - Ajustar cantidades al stock disponible y continuar.
        - Volver al carrito para modificar el pedido.
    7d. No se procesa el pago ni se registra el pedido.

  FE-2: Pago rechazado (detectado en paso 8)
    8a. La pasarela de pago rechaza la transacción.
    8b. El sistema muestra: "El pago no ha podido procesarse.
        Verifica los datos de tu tarjeta o prueba con otro medio
        de pago."
    8c. El cliente puede reintentar con otros datos o seleccionar
        otro método de pago.
    8d. No se registra el pedido ni se modifica el stock.

  FE-3: Crédito insuficiente (detectado en paso 5b de FA-1)
    5e. El sistema muestra: "Tu crédito disponible ([X] €) es
        insuficiente para este pedido ([Y] €). Contacta con tu
        comercial o selecciona otro método de pago."
    5f. El cliente puede seleccionar pago con tarjeta o volver
        al carrito.

  FE-4: Error en la sincronización con el ERP (detectado en paso 10)
    10a. La sincronización con el ERP falla.
    10b. El pedido se registra en el sistema con una marca de
         "pendiente de sincronización".
    10c. Se reintenta la sincronización automáticamente (hasta 3
         veces, con intervalos de 5, 15 y 30 minutos).
    10d. Si persiste el fallo, se genera una alerta al equipo de
         operaciones.
    10e. El cliente NO ve el error; su pedido está confirmado.

  FE-5: Error en el envío de correo (detectado en paso 11)
    11a. El servicio de correo no está disponible.
    11b. El envío se encola para reintento automático.
    11c. El pedido sigue confirmado; el correo es informativo,
         no bloqueante.

REGLAS DE NEGOCIO APLICABLES
  - DN-030: Descuento por volumen.
  - DN-020: Precios especiales por acuerdo comercial.
  - DN-022: Política de crédito y formas de pago.
  - DN-035: Resolución de conflictos entre descuentos.

REQUISITOS NO FUNCIONALES
  - PERF-010: El proceso de checkout (pasos 6 a 12) debe completarse
    en menos de 5 segundos para el p95.
  - SEC-005: Los datos de tarjeta no se almacenan en el sistema;
    se envían directamente a la pasarela (PCI DSS compliance).

DEPENDENCIAS
  - CU-005: Gestionar carrito de compra (precondición: carrito con
    productos).
  - CU-020: Aprobar pedido (continuación si aplica FA-2).
  - FUNC-100: Catálogo de productos (precios y stock).
  - API-PAGOS-001: Contrato de la pasarela de pago.
```

### 4.3.3. Cómo escribir buenos pasos

Los pasos del flujo son la columna vertebral del caso de uso. Su calidad
determina si el caso de uso es útil o decorativo.

**Cada paso debe indicar quién hace qué.** El sujeto de cada paso es
siempre el actor o el sistema, nunca ambiguo. Si el paso empieza con
"Se valida el formulario", no queda claro quién valida: ¿el navegador?
¿el servidor? Mejor: "El sistema valida los campos del formulario según
las reglas de la especificación FUNC-003."

**Cada paso debe describir una acción observable.** "El sistema procesa
la solicitud" no es observable. ¿Qué significa "procesar"? Mejor: "El
sistema verifica que el crédito disponible del cliente cubre el importe
del pedido."

**Evitar pasos de implementación.** "El sistema ejecuta un INSERT en la
tabla pedidos" es implementación. "El sistema registra el pedido con
estado confirmado y genera un número de referencia" es comportamiento
observable.

**Numerar los pasos secuencialmente.** Los flujos alternativos y
excepcionales referencian el paso del flujo principal donde divergen,
lo que exige una numeración estable.

**Mantener el nivel de detalle uniforme.** Si un paso dice "El cliente
rellena el formulario" y el siguiente dice "El sistema valida que el
campo email cumple el formato RFC 5322, que la contraseña tiene al
menos 8 caracteres con una mayúscula, una minúscula y un dígito, y que
la confirmación de contraseña coincide", hay un desequilibrio. O se
agrupa el detalle de validación en una referencia a otra especificación,
o se desglosan ambos pasos al mismo nivel.

---

## 4.4. Flujos alternativos

### 4.4.1. Qué son y por qué importan

Los flujos alternativos describen caminos válidos que difieren del flujo
principal pero conducen a un resultado igualmente exitoso (o a un
resultado aceptable diferente). No son errores; son **variaciones
legítimas** del comportamiento.

En la práctica, los flujos alternativos representan la mayor parte de la
complejidad funcional de un sistema. El flujo principal suele ser sencillo;
son las alternativas las que generan trabajo de implementación, pruebas y
mantenimiento.

### 4.4.2. Cómo identificarlos

Para cada paso del flujo principal, formular estas preguntas:

- ¿Hay otra forma de hacer esto? (otro método de pago, otra forma de
  autenticación, otro canal de entrada).
- ¿El usuario puede elegir entre opciones? (dirección nueva vs.
  existente, envío estándar vs. urgente).
- ¿Hay condiciones que cambien el camino? (cliente con crédito vs. sin
  crédito, pedido con aprobación vs. sin aprobación).
- ¿El usuario puede deshacer o volver atrás en este punto?

### 4.4.3. Cómo documentarlos

Los flujos alternativos se documentan referenciando el paso del flujo
principal donde divergen:

```text
FA-[N]: [Nombre descriptivo] (diverge en paso [X])
  [X]a. [Primer paso alternativo]
  [X]b. [Segundo paso alternativo]
  ...
  [X]z. Se continúa en paso [Y] del flujo principal.
```

Si el flujo alternativo es extenso o tiene valor suficiente para ser
tratado de forma independiente, puede convertirse en un caso de uso
separado referenciado con la etiqueta *incluye* o *extiende*.

---

## 4.5. Flujos excepcionales

### 4.5.1. Qué son

Los flujos excepcionales describen situaciones en las que algo **sale
mal**: un error técnico, una validación que falla, un recurso que no
está disponible, una condición de negocio que no se cumple. El resultado
no es el objetivo del actor, sino un estado de error gestionado.

### 4.5.2. Categorías de excepciones

**Errores de validación**: los datos proporcionados por el actor no
cumplen las reglas. Ejemplo: email con formato incorrecto, cantidad
fuera de rango, campo obligatorio vacío.

**Errores de estado**: la operación no puede ejecutarse porque el
sistema no está en el estado esperado. Ejemplo: intentar cancelar un
pedido que ya ha sido enviado, intentar pagar un pedido que ya fue
pagado.

**Errores de disponibilidad**: un recurso necesario no está disponible.
Ejemplo: stock insuficiente, servicio externo caído, límite de
crédito superado.

**Errores técnicos**: fallos de infraestructura o componentes. Ejemplo:
base de datos no responde, timeout en la pasarela de pago, error de
red.

**Errores de autorización**: el actor no tiene permisos para la
operación. Ejemplo: un lector intenta crear un documento, un empleado
intenta aprobar su propio pedido.

### 4.5.3. Cómo documentarlos

Los flujos excepcionales siguen la misma convención que los alternativos,
pero indicando la condición de error y el comportamiento del sistema ante
ella:

```text
FE-[N]: [Nombre descriptivo] (detectado en paso [X])
  [X]a. [Condición de error detectada]
  [X]b. El sistema muestra: "[Mensaje de error]"
  [X]c. [Opciones para el actor: reintentar, corregir, cancelar]
  [X]d. [Estado final: qué queda y qué no queda en el sistema]
```

### 4.5.4. Principios para el manejo de excepciones

**Toda excepción debe dejar el sistema en un estado consistente.** Si
el pago falla después de decrementar el stock, hay un problema. El
orden de las operaciones y los mecanismos de compensación deben estar
definidos.

**El usuario debe recibir información accionable.** "Ha ocurrido un
error" no es accionable. "El pago ha sido rechazado. Verifica los datos
de tu tarjeta o prueba con otro medio de pago" sí lo es.

**Distinguir entre errores del usuario y errores del sistema.** Los
errores del usuario (datos incorrectos) deben resolverse por el propio
usuario. Los errores del sistema (servicio caído) deben gestionarse
internamente con reintentos, compensaciones o alertas.

**No toda excepción es bloqueante.** Si el correo de confirmación no
se puede enviar, ¿debe fallar todo el pedido? Generalmente no: el
correo se encola y se reintenta. Definir qué es bloqueante y qué no
es una decisión de diseño que debe estar en la especificación.

---

## 4.6. Relaciones entre casos de uso

### 4.6.1. Inclusión (include)

Un caso de uso **incluye** a otro cuando parte de su comportamiento
se delega en otro caso de uso que siempre se ejecuta.

Ejemplo: el caso de uso "Realizar pedido" siempre incluye "Procesar
pago" (si el método es tarjeta). El caso incluido es una pieza
reutilizable que puede aparecer en otros casos de uso (p. ej.,
"Renovar suscripción" también incluye "Procesar pago").

### 4.6.2. Extensión (extend)

Un caso de uso **extiende** a otro cuando añade comportamiento
opcional bajo ciertas condiciones.

Ejemplo: el caso de uso "Solicitar aprobación" extiende "Realizar
pedido", pero solo cuando el cliente tiene flujo de aprobación
activado. No siempre ocurre; es condicional.

### 4.6.3. Generalización

Un actor o caso de uso es una **generalización** de otros cuando
comparte comportamiento común con variantes especializadas.

Ejemplo: "Cliente B2B" es una generalización de "Cliente con crédito"
y "Cliente sin crédito". Ambos pueden realizar pedidos, pero el flujo
de pago difiere.

### 4.6.4. Cuándo usar relaciones y cuándo no

Las relaciones entre casos de uso son útiles para evitar la duplicación
y para modelar comportamiento reutilizable. Sin embargo, un exceso de
relaciones convierte el modelo en un diagrama innavegable. Reglas
prácticas:

- Usar **include** solo cuando el caso incluido tiene valor propio y
  se usa en más de un caso de uso.
- Usar **extend** solo cuando la extensión es claramente opcional y
  condicional, no cuando es un flujo alternativo normal.
- No forzar relaciones para cumplir un formalismo. Si un caso de uso
  se entiende perfectamente con flujos alternativos internos, no hace
  falta extraer un caso separado.

---

## 4.7. De los casos de uso a la validación

### 4.7.1. Derivar escenarios de prueba

Cada camino posible a través de un caso de uso (flujo principal, cada
alternativo, cada excepcional) es un escenario candidato a test de
aceptación. La derivación sistemática consiste en:

1. Identificar el flujo principal como escenario base.
2. Para cada flujo alternativo, crear un escenario que lo recorra.
3. Para cada flujo excepcional, crear un escenario que lo provoque.
4. Combinar flujos cuando la combinación sea relevante (p. ej.,
   alternativo + excepcional).

### 4.7.2. Formato de escenario para verificación

Cada escenario se puede expresar en formato Dado-Cuando-Entonces
(*Given-When-Then*), que conecta directamente con BDD y con los
criterios de aceptación de SDD:

```text
Escenario: [nombre descriptivo]
  Dado [precondiciones concretas con datos]
  Cuando [acción del actor]
  Entonces [resultado esperado observable]
```

Ejemplo:

```text
Escenario: Pedido con tarjeta exitoso
  Dado un cliente autenticado con 3 productos en el carrito
    (Bolígrafo x50, Carpeta x10, Grapadora x2),
    una dirección de envío seleccionada
    y una tarjeta de crédito válida
  Cuando el cliente confirma el pedido
  Entonces el pedido se registra con estado "confirmado",
    el stock de cada producto se decrementa,
    se realiza el cobro por el importe total
    y el cliente recibe un correo de confirmación
    con el número de referencia del pedido.
```

### 4.7.3. Cobertura de comportamiento

Un modelo de casos de uso bien hecho permite medir la **cobertura de
comportamiento**: qué porcentaje de los escenarios derivados del modelo
tienen un test asociado. Esto es más significativo que la cobertura de
código, porque mide si estamos validando lo que el sistema debe hacer,
no solo lo que el código ejecuta.

La matriz de cobertura relaciona cada escenario con su test:

| Escenario | Derivado de | Test | Estado |
| --- | --- | --- | --- |
| Pedido tarjeta OK | CU-010 principal | TAC-010-01 | Auto |
| Pedido crédito | CU-010 FA-1 | TAC-010-02 | Auto |
| Con aprobación | CU-010 FA-2 | TAC-010-03 | Manual |
| Stock insuficiente | CU-010 FE-1 | TAC-010-04 | Auto |
| Pago rechazado | CU-010 FE-2 | TAC-010-05 | Auto |

---

## 4.8. Errores comunes en el modelado de casos de uso

### El caso de uso CRUD

Escribir un caso de uso llamado "Gestionar usuarios" que contenga
crear, leer, actualizar y eliminar como pasos del mismo caso. Cada
operación CRUD tiene precondiciones, postcondiciones y excepciones
diferentes. Deben ser casos de uso separados: "Dar de alta usuario",
"Modificar perfil de usuario", "Desactivar usuario".

### El caso de uso interfaz

Describir los pasos en términos de componentes de UI: "El usuario
pulsa el botón Enviar, se abre un modal con un spinner, aparece un
toast de confirmación." Esto es un diseño de interfaz, no un caso de
uso. El caso de uso debe describir la interacción en términos de
objetivos y resultados, dejando el detalle de UI para la
especificación de interfaz.

### El caso de uso incompleto

Escribir solo el flujo principal y decir que "los errores se gestionan
de forma estándar". No hay forma estándar: cada error tiene un contexto,
un mensaje y unas opciones diferentes. Los flujos excepcionales son tan
importantes como el principal.

### El caso de uso novela

Un caso de uso de 50 pasos que cubre todo el proceso de venta, desde
la búsqueda del producto hasta la entrega y la facturación. Un caso de
uso de más de 12-15 pasos en su flujo principal probablemente debería
dividirse en varios casos de uso relacionados.

### El caso de uso huérfano

Un caso de uso que no está vinculado a ninguna especificación,
requisito ni test. Existe en el documento de análisis pero nadie lo
consulta, nadie lo implementa a consciencia y nadie lo valida. En SDD,
todo caso de uso debe estar trazado a sus especificaciones origen y a
sus tests destino.

---

## 4.9. Resumen del tema

El modelado del comportamiento mediante casos de uso es una herramienta
fundamental en SDD para describir qué hace el sistema de forma
comprensible, completa y verificable.

Puntos clave:

- Un caso de uso describe la interacción entre un actor y el sistema
  para lograr un objetivo, con flujo principal, flujos alternativos y
  flujos excepcionales.
- Los actores se definen por rol, no por persona. Pueden ser humanos,
  sistemas o eventos temporales.
- Los flujos alternativos representan variaciones legítimas; los
  excepcionales representan errores y condiciones de fallo.
- Cada paso debe indicar quién actúa, qué acción realiza y qué
  resultado observable produce.
- Los casos de uso se relacionan mediante inclusión, extensión y
  generalización, pero sin abusar de estas relaciones.
- Los escenarios derivados de los casos de uso son la base de los
  tests de aceptación, expresables en formato Dado-Cuando-Entonces.
- Los errores más comunes son el caso de uso CRUD, el caso de uso
  interfaz, el incompleto, el excesivamente largo y el huérfano.

---

## Laboratorios del Tema 4

---

### Laboratorio 4.1: Redacción de casos de uso para una funcionalidad real

#### Enunciado del laboratorio 4.1

**Objetivo**: escribir casos de uso completos (flujo principal, alternativos
y excepcionales) para una funcionalidad real del proyecto B2B de distribución
de material de oficina.

**Funcionalidad**: Solicitud de devolución de un pedido por el cliente.

**Contexto**:

El proyecto de tienda online B2B (introducido en el Tema 3) necesita un
proceso de devoluciones. Según lo descubierto en la entrevista con la
directora comercial:

- El cliente debe poder solicitar la devolución de productos de un pedido
  ya entregado.
- Las devoluciones actuales se gestionan informalmente y sin control.
- Se necesita un proceso trazable con aprobación por parte del equipo
  comercial.
- La política de devoluciones permite devolver productos hasta 15 días
  después de la entrega, siempre que estén en su embalaje original.

**Instrucciones**:

1. Identifica los actores involucrados.
2. Define las precondiciones y postcondiciones (éxito y fallo).
3. Escribe el flujo principal completo.
4. Identifica y documenta al menos 3 flujos alternativos.
5. Identifica y documenta al menos 3 flujos excepcionales.
6. Deriva al menos 5 escenarios de verificación en formato
   Dado-Cuando-Entonces.

#### Solución del laboratorio 4.1

```text
ID:               CU-030
Título:           Solicitar devolución de productos de un pedido
Actor primario:   Cliente B2B (autenticado)
Actores secundarios:
  - Gestor comercial (revisa y aprueba/rechaza la solicitud)
  - Servicio de correo (notificaciones)
  - Sistema de logística (gestión de recogida)
Estado:           Borrador (v1.0)
Autor:            Equipo de análisis — 2025-04-15

DESCRIPCIÓN
El cliente solicita la devolución de uno o varios productos de un
pedido entregado. La solicitud es revisada por un gestor comercial
que puede aprobarla, rechazarla o solicitar información adicional.
Si se aprueba, se coordina la recogida y se emite un abono.

PRECONDICIONES
  PRE-1. El cliente está autenticado.
  PRE-2. El pedido tiene estado "entregado".
  PRE-3. Han pasado 15 días naturales o menos desde la fecha de
         entrega del pedido.
  PRE-4. El pedido no tiene ya una solicitud de devolución activa
         (en estado "pendiente" o "en proceso") para los mismos
         productos.

POSTCONDICIONES DE ÉXITO
  POST-1. Existe una solicitud de devolución registrada con
          estado "pendiente de revisión".
  POST-2. La solicitud contiene: productos y cantidades a devolver,
          motivo, fecha de solicitud, referencia del pedido original.
  POST-3. El gestor comercial asignado ha recibido una notificación.
  POST-4. El cliente ha recibido un correo de confirmación con el
          número de referencia de la solicitud.

POSTCONDICIONES DE FALLO
  POST-F1. No se ha creado ninguna solicitud de devolución.
  POST-F2. No se ha notificado a ningún gestor.
  POST-F3. El pedido original no se ha modificado.

FLUJO PRINCIPAL

  1. El cliente accede a la pantalla de detalle del pedido desde
     su historial de pedidos.
  2. El sistema muestra los datos del pedido, incluyendo un botón
     "Solicitar devolución" (visible solo si se cumplen las
     precondiciones PRE-2 y PRE-3).
  3. El cliente pulsa "Solicitar devolución".
  4. El sistema muestra la lista de productos del pedido con
     checkbox de selección y campo de cantidad a devolver
     (por defecto, la cantidad total pedida).
  5. El cliente selecciona los productos que desea devolver y
     ajusta las cantidades si no devuelve todas las unidades.
  6. El cliente selecciona el motivo de devolución de una lista
     predefinida:
       - Producto dañado o defectuoso
       - Producto incorrecto (no coincide con lo pedido)
       - Producto no necesario (cambio de necesidades)
       - Error en la cantidad recibida
       - Otro (campo de texto obligatorio)
  7. El cliente puede añadir un comentario adicional (campo de
     texto libre, opcional, máximo 500 caracteres).
  8. El cliente puede adjuntar fotografías como evidencia
     (opcional, máximo 5 imágenes, formatos JPG/PNG, máximo
     5 MB por imagen).
  9. El cliente pulsa "Enviar solicitud".
  10. El sistema valida que se ha seleccionado al menos un
      producto, que las cantidades son válidas y que se ha
      indicado un motivo.
  11. El sistema registra la solicitud con estado "pendiente de
      revisión" y genera un número de referencia (formato:
      DEV-AAAA-NNNNN).
  12. El sistema asigna la solicitud al gestor comercial
      responsable de la cuenta del cliente.
  13. El sistema envía una notificación al gestor (email e
      in-app) con el resumen de la solicitud.
  14. El sistema envía un correo de confirmación al cliente:
      "Tu solicitud de devolución DEV-[REF] ha sido registrada.
      Te informaremos cuando sea revisada."
  15. El sistema muestra la pantalla de confirmación con el
      número de referencia y el estado "pendiente de revisión".

FLUJOS ALTERNATIVOS

  FA-1: Devolución parcial (variación en paso 5)
    5a. El cliente selecciona solo algunos de los productos del
        pedido (no todos).
    5b. Para un producto seleccionado, reduce la cantidad a
        devolver (p. ej., pidió 50 y devuelve 20).
    5c. Se continúa en paso 6.
    Nota: la solicitud registra solo los productos y cantidades
    seleccionados. El resto del pedido no se ve afectado.

  FA-2: Devolución con motivo "Otro" (variación en paso 6)
    6a. El cliente selecciona "Otro" como motivo.
    6b. El campo de texto libre pasa a ser obligatorio (mínimo
        20 caracteres).
    6c. Se continúa en paso 7.

  FA-3: Cliente consulta el estado de una solicitud existente
  (camino alternativo completo)
    1a. El cliente accede a "Mis devoluciones" desde el menú
        principal.
    1b. El sistema muestra una lista de solicitudes de devolución
        con su estado (pendiente, aprobada, rechazada, completada).
    1c. El cliente selecciona una solicitud para ver el detalle:
        productos, cantidades, motivo, fechas, estado actual e
        historial de cambios de estado.
    Nota: este flujo no crea una nueva solicitud; solo consulta.

  FA-4: Gestor solicita información adicional (tras paso 15,
  actor secundario)
    16a. El gestor revisa la solicitud y considera que necesita
         más información.
    16b. El gestor escribe una pregunta o solicitud de
         información.
    16c. El sistema cambia el estado a "información solicitada"
         y notifica al cliente por email.
    16d. El cliente accede a la solicitud y responde con texto
         y/o fotografías.
    16e. El estado cambia a "pendiente de revisión" de nuevo y
         se notifica al gestor.

FLUJOS EXCEPCIONALES

  FE-1: Plazo de devolución expirado (detectado en paso 2)
    2a. Han pasado más de 15 días desde la entrega.
    2b. El botón "Solicitar devolución" no aparece en la pantalla
        de detalle del pedido.
    2c. En su lugar se muestra el texto: "El plazo para solicitar
        la devolución de este pedido ha expirado (15 días desde
        la entrega)."
    2d. El caso de uso termina sin crear solicitud.

  FE-2: Ningún producto seleccionado (detectado en paso 10)
    10a. El cliente no ha seleccionado ningún producto.
    10b. El sistema muestra: "Selecciona al menos un producto
         para devolver."
    10c. El cliente puede corregir la selección y reintentar.

  FE-3: Cantidad a devolver inválida (detectado en paso 10)
    10a. La cantidad a devolver para un producto es 0, negativa
         o superior a la cantidad pedida.
    10b. El sistema muestra: "[Producto]: la cantidad a devolver
         debe estar entre 1 y [cantidad pedida]."
    10c. El cliente corrige y reintenta.

  FE-4: Solicitud duplicada (detectado en paso 10)
    10a. Ya existe una solicitud de devolución activa para
         alguno de los productos seleccionados.
    10b. El sistema muestra: "Ya existe una solicitud de
         devolución activa para [Producto] (referencia
         DEV-[REF]). No puedes solicitar otra devolución
         del mismo producto mientras la anterior esté en
         curso."
    10c. El cliente puede deseleccionar el producto afectado
         y continuar con los demás, o cancelar.

  FE-5: Error en el servicio de notificaciones (detectado en
  pasos 13-14)
    13a/14a. El servicio de correo no responde.
    13b/14b. La solicitud se registra igualmente (las
             notificaciones no son bloqueantes).
    13c/14c. Los correos se encolan para reintento automático.
    13d/14d. Se registra el fallo en el log de errores.

  FE-6: Gestor comercial no asignado a la cuenta (detectado
  en paso 12)
    12a. La cuenta del cliente no tiene un gestor comercial
         asignado.
    12b. La solicitud se asigna al gestor comercial por defecto
         del sistema.
    12c. Se genera una alerta interna para que se asigne un
         gestor a la cuenta.

REGLAS DE NEGOCIO APLICABLES
  - DN-025: Política de devoluciones (plazo de 15 días, condición
    de embalaje original, productos no retornables).
  - DN-026: Cálculo de abono en devoluciones.

DEPENDENCIAS
  - CU-010: Realizar pedido (genera el pedido que se devuelve).
  - CU-035: Revisar solicitud de devolución (caso de uso del
    gestor, continuación).
  - FUNC-130: Especificación funcional de devoluciones.
```

#### Escenarios de verificación

```text
Escenario 1: Devolución completa exitosa
  Dado un cliente autenticado con un pedido entregado hace 5 días
    que contiene Bolígrafo x50, Carpeta x20 y Grapadora x5,
  Cuando el cliente selecciona todos los productos, indica motivo
    "Producto no necesario" y envía la solicitud,
  Entonces se crea la solicitud con referencia DEV-2025-XXXXX
    en estado "pendiente de revisión",
    el gestor comercial recibe notificación,
    y el cliente recibe correo de confirmación.

Escenario 2: Devolución parcial (algunos productos, cantidad reducida)
  Dado un cliente autenticado con un pedido entregado hace 3 días
    que contiene Bolígrafo x50 y Carpeta x20,
  Cuando el cliente selecciona solo Bolígrafo con cantidad 30
    (de 50), indica motivo "Error en la cantidad recibida" y envía,
  Entonces se crea la solicitud solo para Bolígrafo x30,
    Carpeta no aparece en la solicitud,
    y el pedido original no se modifica.

Escenario 3: Plazo de devolución expirado
  Dado un cliente autenticado con un pedido entregado hace 20 días,
  Cuando el cliente accede a la pantalla de detalle del pedido,
  Entonces el botón "Solicitar devolución" no aparece
    y se muestra el mensaje de plazo expirado.

Escenario 4: Producto con solicitud de devolución ya activa
  Dado un cliente con un pedido entregado hace 5 días que contiene
    Bolígrafo x50 y Carpeta x20,
    y ya existe una solicitud activa para Bolígrafo x50,
  Cuando el cliente intenta crear una nueva solicitud seleccionando
    Bolígrafo y Carpeta,
  Entonces el sistema muestra un error indicando que Bolígrafo ya
    tiene una solicitud activa,
    y permite al cliente continuar solo con Carpeta.

Escenario 5: Motivo "Otro" sin texto descriptivo
  Dado un cliente creando una solicitud de devolución,
  Cuando selecciona motivo "Otro" y deja el campo de texto vacío
    e intenta enviar,
  Entonces el sistema muestra "Describe el motivo de la devolución
    (mínimo 20 caracteres)"
    y no envía la solicitud.

Escenario 6: Devolución con fotografías adjuntas
  Dado un cliente creando una solicitud de devolución por
    "Producto dañado o defectuoso",
  Cuando adjunta 3 fotografías (JPG, < 5 MB cada una), completa
    el formulario y envía,
  Entonces la solicitud se crea con las 3 imágenes adjuntas
    visibles en el detalle,
    y el gestor puede ver las fotografías al revisar la solicitud.

Escenario 7: Gestor solicita información adicional
  Dado una solicitud de devolución en estado "pendiente de revisión",
  Cuando el gestor solicita información adicional al cliente,
  Entonces el estado cambia a "información solicitada",
    el cliente recibe un email con la pregunta del gestor,
    y la solicitud queda a la espera de respuesta del cliente.
```

---

### Laboratorio 4.2: Modelado de escenarios alternativos y excepciones

#### Enunciado del laboratorio 4.2

**Objetivo**: dado un caso de uso con solo el flujo principal, identificar
y documentar todos los flujos alternativos y excepcionales relevantes.

**Contexto**: se proporciona un caso de uso parcialmente redactado (solo
flujo principal) para la funcionalidad "Modificar pedido antes del envío"
del mismo proyecto B2B. El alumno debe completarlo con los flujos
alternativos y excepcionales.

**Caso de uso parcial proporcionado**:

```text
ID:               CU-015
Título:           Modificar pedido antes del envío
Actor primario:   Cliente B2B (autenticado)
Actores secundarios:
  - ERP (actualización del pedido)

PRECONDICIONES
  PRE-1. El cliente está autenticado.
  PRE-2. El pedido tiene estado "confirmado" o "en preparación".
  PRE-3. El cliente es el titular del pedido.

POSTCONDICIONES DE ÉXITO
  POST-1. El pedido refleja las modificaciones realizadas.
  POST-2. El stock se ha ajustado según los cambios.
  POST-3. El importe del pedido se ha recalculado.
  POST-4. El ERP se ha actualizado.

FLUJO PRINCIPAL

  1. El cliente accede a la pantalla de detalle del pedido
     desde su historial.
  2. El sistema muestra los datos del pedido con un botón
     "Modificar pedido" (visible si se cumplen PRE-2 y PRE-3).
  3. El cliente pulsa "Modificar pedido".
  4. El sistema muestra el pedido en modo edición: productos,
     cantidades y dirección de envío son editables.
  5. El cliente realiza los cambios deseados:
     - Modificar la cantidad de un producto existente.
     - Eliminar un producto del pedido.
     - Añadir un nuevo producto al pedido.
     - Cambiar la dirección de envío.
  6. El sistema recalcula el importe total con cada cambio.
  7. El cliente pulsa "Guardar cambios".
  8. El sistema valida los cambios, actualiza el pedido,
     ajusta el stock y sincroniza con el ERP.
  9. El sistema envía un correo al cliente con el resumen
     del pedido actualizado.
  10. El sistema muestra la pantalla de detalle del pedido
      actualizado.
```

**Instrucciones**:

1. Para cada paso del flujo principal, analiza qué puede ir diferente
   (alternativa) o qué puede fallar (excepción).
2. Documenta al menos 4 flujos alternativos.
3. Documenta al menos 5 flujos excepcionales.
4. Para cada flujo excepcional, define el mensaje de error y el estado
   final del sistema.

#### Solución del laboratorio 4.2

##### Flujos alternativos

```text
FA-1: Modificación de cantidad (variación del paso 5)
  5a. El cliente modifica la cantidad de un producto existente.
  5b. Si la nueva cantidad es superior a la original, el sistema
      verifica stock adicional en tiempo real.
  5c. Si hay stock suficiente, la cantidad se actualiza y el
      sistema recalcula importes (incluyendo posibles cambios
      en el descuento por volumen si se cruzan umbrales).
  5d. Se continúa en paso 6.

FA-2: Eliminación de producto (variación del paso 5)
  5a. El cliente elimina un producto del pedido (icono de
      papelera junto a la línea).
  5b. El sistema solicita confirmación: "¿Eliminar [Producto]
      del pedido?"
  5c. Si confirma: la línea se elimina del pedido, el stock
      del producto eliminado se libera, el importe se
      recalcula.
  5d. Se continúa en paso 6.

FA-3: Añadir producto nuevo al pedido (variación del paso 5)
  5a. El cliente pulsa "Añadir producto".
  5b. El sistema muestra un buscador de productos (subconjunto
      del catálogo, misma funcionalidad que FUNC-100).
  5c. El cliente busca, selecciona un producto e indica la
      cantidad.
  5d. El sistema verifica stock y precio actual, añade la línea
      al pedido y recalcula importes.
  5e. Se continúa en paso 6.

FA-4: Cambio de dirección de envío (variación del paso 5)
  5a. El cliente pulsa "Cambiar dirección" junto a la dirección
      de envío actual.
  5b. El sistema muestra las direcciones registradas del cliente
      y la opción "Añadir nueva dirección".
  5c. El cliente selecciona otra dirección o crea una nueva.
  5d. El sistema recalcula los gastos de envío si dependen de
      la zona geográfica.
  5e. Se continúa en paso 6.

FA-5: Modificación de pedido con flujo de aprobación (variación
del paso 8)
  8a. Si el cliente pertenece a una organización con flujo de
      aprobación activado y la modificación incrementa el
      importe total en más de un 10%:
  8b. Los cambios se guardan con estado "modificación pendiente
      de aprobación".
  8c. Se notifica al aprobador designado con el resumen de los
      cambios (valores anteriores y nuevos).
  8d. El pedido mantiene su contenido original hasta que el
      aprobador apruebe la modificación.
  8e. Se muestra al cliente: "Tus cambios están pendientes
      de aprobación por [aprobador]."

FA-6: Cliente cancela la edición (variación tras paso 4)
  4a. El cliente pulsa "Cancelar" o navega fuera de la pantalla
      de edición sin guardar.
  4b. El sistema muestra: "¿Descartar los cambios? Los cambios
      no guardados se perderán." [Descartar] [Seguir editando]
  4c. Si descarta: el pedido vuelve a su estado original, sin
      ninguna modificación.
  4d. Si sigue editando: vuelve a la pantalla de edición.
```

##### Flujos excepcionales

```text
FE-1: Stock insuficiente para cantidad incrementada (detectado
en paso 5b de FA-1 o paso 5d de FA-3)
  5x-a. El stock disponible es inferior a la cantidad solicitada.
  5x-b. El sistema muestra: "[Producto]: solo quedan [N] unidades
        disponibles. Tu cantidad actual es [M]."
  5x-c. El sistema ofrece ajustar la cantidad al máximo disponible
        o mantener la cantidad original.
  5x-d. Los demás cambios del pedido no se ven afectados.

FE-2: Pedido cambia de estado durante la edición (detectado
en paso 8)
  8a. Entre que el cliente abrió la edición (paso 3) y guarda
      (paso 7), el pedido ha cambiado de estado a "enviado"
      (p. ej., el almacén lo procesó mientras el cliente editaba).
  8b. El sistema muestra: "Este pedido ya ha sido enviado y no
      puede modificarse."
  8c. No se aplica ningún cambio.
  8d. El cliente es redirigido a la pantalla de detalle del
      pedido con su nuevo estado.

FE-3: Eliminación del último producto del pedido (detectado
en paso 5b de FA-2)
  5x-a. El cliente intenta eliminar el único producto que queda
        en el pedido.
  5x-b. El sistema muestra: "No puedes eliminar todos los
        productos del pedido. Si deseas cancelarlo, utiliza
        la opción 'Cancelar pedido'."
  5x-c. La eliminación no se ejecuta. El producto permanece
        en el pedido.

FE-4: Error en la sincronización con el ERP (detectado en paso 8)
  8a. La sincronización con el ERP falla.
  8b. Los cambios se guardan localmente en el sistema con marca
      "pendiente de sincronización".
  8c. Se programa un reintento automático (hasta 3 veces: 5, 15
      y 30 minutos).
  8d. Si persiste el fallo, se genera una alerta al equipo de
      operaciones.
  8e. El cliente ve el pedido actualizado (la sincronización
      con el ERP es transparente para el cliente).

FE-5: Precio de producto ha cambiado desde la confirmación
original (detectado en paso 5d de FA-3 o en paso 8)
  8a. Al guardar, el sistema detecta que el precio vigente de
      algún producto difiere del precio registrado en el pedido.
  8b. Para productos existentes (no añadidos en esta edición):
      se mantiene el precio original del pedido.
  8c. Para productos añadidos nuevos: se aplica el precio vigente
      al momento de la edición.
  8d. El sistema muestra un aviso si el total varía: "El importe
      del pedido ha cambiado a [nuevo total] € debido a precios
      actualizados en los productos añadidos."
  8e. El cliente confirma o cancela.

FE-6: Descuento por volumen cambia al modificar cantidades
(detectado en paso 6)
  6a. Al recalcular, el sistema detecta que las nuevas cantidades
      modifican los tramos de descuento por volumen (p. ej., se
      pasa de 120 unidades a 40, perdiendo el descuento del 5%).
  6b. El sistema muestra un aviso junto a la línea afectada:
      "Al reducir a [N] unidades, se pierde el descuento por
      volumen (-5%). Precio unitario: [nuevo precio]."
  6c. El aviso es informativo; el cliente decide si mantiene
      la nueva cantidad o la ajusta.

FE-7: Sesión del cliente expira durante la edición (detectado
en cualquier paso)
  Xa. La sesión del cliente expira por inactividad mientras
      edita el pedido.
  Xb. Al intentar guardar, el sistema detecta que la sesión
      no es válida.
  Xc. El sistema redirige al login con el mensaje: "Tu sesión
      ha expirado. Inicia sesión de nuevo para continuar."
  Xd. Los cambios no guardados se pierden. El pedido mantiene
      su estado original.
  Nota para diseño: valorar guardado automático de borrador
  cada 60 segundos para mitigar este escenario.
```

##### Postcondiciones de fallo ampliadas

```text
  POST-F1. El pedido mantiene su estado y contenido original
           (anterior a la edición).
  POST-F2. El stock no se ha modificado.
  POST-F3. El ERP no se ha actualizado.
  POST-F4. No se ha enviado correo de actualización al cliente.
  POST-F5. Si el fallo es por cambio de estado (FE-2), el pedido
           refleja su nuevo estado real (p. ej., "enviado").
```

---

### Laboratorio 4.3: Revisión cruzada de casos de uso entre equipos

#### Enunciado del laboratorio 4.3

**Objetivo**: practicar la revisión de un caso de uso escrito por otro
equipo, aplicando las perspectivas de negocio, desarrollo y QA para
detectar problemas, huecos e inconsistencias.

**Contexto**: un equipo ficticio ha redactado el siguiente caso de uso
para la funcionalidad "Buscar productos en el catálogo". Otro equipo
(o el alumno asumiendo los tres roles) debe revisarlo y documentar los
hallazgos.

**Caso de uso a revisar**:

```text
ID:               CU-003
Título:           Buscar productos en el catálogo
Actor primario:   Cliente B2B
Actores secundarios: ninguno

PRECONDICIONES
  PRE-1. El usuario ha accedido a la tienda.

POSTCONDICIONES DE ÉXITO
  POST-1. Se muestran los resultados de búsqueda.

FLUJO PRINCIPAL

  1. El usuario escribe un texto en la barra de búsqueda.
  2. El sistema busca en el catálogo.
  3. El sistema muestra los resultados.
  4. El usuario selecciona un producto.
  5. El sistema muestra la ficha del producto.

FLUJOS ALTERNATIVOS
  FA-1: Sin resultados
    3a. No hay resultados.
    3b. Se muestra un mensaje.

FLUJOS EXCEPCIONALES
  (No se han identificado)

CRITERIOS DE VERIFICACIÓN
  1. Buscar un producto existente y verificar que aparece.
```

**Instrucciones**:

1. Revisa el caso de uso desde la perspectiva de **negocio**: ¿refleja
   la funcionalidad real? ¿Falta algo importante para el usuario?
2. Revisa desde la perspectiva de **desarrollo**: ¿es implementable?
   ¿Hay ambigüedades técnicas? ¿Faltan detalles?
3. Revisa desde la perspectiva de **QA**: ¿es verificable? ¿Los
   criterios son suficientes? ¿Qué escenarios faltan?
4. Para cada problema detectado, clasifícalo por gravedad (crítico,
   importante, menor) y propón una corrección.
5. Escribe una versión mejorada del caso de uso.

#### Solución del laboratorio 4.3

##### Revisión como Negocio

**B1** (Crítico). El actor dice "Cliente B2B" pero la
precondición dice "el usuario ha accedido a la tienda" sin
mencionar autenticación. Los clientes B2B tienen precios
personalizados y restricciones geográficas. Sin autenticación,
no se puede personalizar el catálogo. Corregir: PRE-1 debe
ser "El cliente está autenticado".

**B2** (Crítico). No se menciona que los resultados deben
respetar las restricciones del cliente (zona geográfica,
productos restringidos). Un cliente de Canarias no debería ver
productos restringidos a la península. Añadir regla de negocio
sobre filtrado por perfil del cliente.

**B3** (Importante). No se especifica qué campos se buscan
(título, descripción, referencia, familia). El cliente puede
buscar por referencia interna ("BIC-CR-050") o por nombre
genérico ("bolígrafo azul"). Ambos usos deben funcionar.

**B4** (Importante). No se menciona la posibilidad de filtrar
resultados. Con 3.000 referencias, los resultados sin filtros
son inmanejables. Los clientes necesitan filtrar por familia,
rango de precio y disponibilidad.

**B5** (Importante). No se menciona el precio en los
resultados. El precio es información esencial para el cliente
B2B. Los resultados deben mostrar el precio personalizado
del cliente.

**B6** (Menor). No se define el orden de los resultados.
¿Por relevancia? ¿Por nombre? ¿Por precio? El orden afecta
directamente a la experiencia del usuario.

##### Revisión como Desarrollo

**D1** (Importante). "El sistema busca en el catálogo" no
define el mecanismo de búsqueda. ¿Coincidencia exacta,
parcial, con stemming, con tolerancia a errores tipográficos?
¿Motor de búsqueda (Elasticsearch) o consulta directa a base
de datos? Esto impacta la arquitectura.

**D2** (Importante). No hay paginación definida. Si una
búsqueda devuelve 500 resultados, ¿se muestran todos? Definir
paginación (p. ej., 20 por página).

**D3** (Importante). No hay requisito de rendimiento. ¿Cuánto
puede tardar la búsqueda? Con 3.000 productos y precios
personalizados, la consulta puede ser costosa. Necesario:
"resultados en < 500 ms para p95".

**D4** (Menor). No se define cuándo se ejecuta la búsqueda.
¿Al pulsar Enter? ¿Al pulsar un botón? ¿Con autocompletado
mientras escribe (con debounce)? Esto afecta al diseño
frontend y a la carga del backend.

**D5** (Menor). No se define la longitud mínima de búsqueda.
Buscar "a" devolvería casi todos los productos. Definir
mínimo (p. ej., 2 caracteres).

**D6** (Menor). Faltan actores secundarios. Si se usa un motor
de búsqueda externo (Elasticsearch, Algolia), es un actor
secundario del que depende el caso de uso.

##### Revisión como QA

**Q1** (Crítico). Solo hay 1 criterio de verificación, y es
incompleto. "Buscar un producto existente y verificar que
aparece" no dice qué se busca, cómo se busca, qué datos se
verifican ni qué precondiciones se configuran.

**Q2** (Importante). No hay escenario para búsqueda sin
resultados con datos concretos. FA-1 dice "se muestra un
mensaje" pero no dice qué mensaje ni qué datos de búsqueda
lo provocan.

**Q3** (Importante). Faltan escenarios: búsqueda parcial,
búsqueda por referencia, caracteres especiales, búsqueda con
filtros, búsqueda con texto muy largo. La cobertura con un
solo escenario es insuficiente.

**Q4** (Importante). No hay escenarios excepcionales. ¿Qué
pasa si el servicio de búsqueda está caído? ¿Si la base de
datos no responde? ¿Si el catálogo está vacío?

**Q5** (Importante). No se define qué información muestra
cada resultado. Sin saber qué se muestra, QA no puede
verificar que la información es correcta ni completa.

**Q6** (Menor). Las postcondiciones de éxito son genéricas.
"Se muestran los resultados" no indica cuántos, en qué orden,
con qué información.

##### Caso de uso mejorado

```text
ID:               CU-003
Título:           Buscar productos en el catálogo
Actor primario:   Cliente B2B (autenticado)
Actores secundarios:
  - Motor de búsqueda (Elasticsearch)
Estado:           En revisión (v2.0)
Autor:            Equipo A — 2025-04-15
Revisado por:     Equipo B — 2025-04-18

DESCRIPCIÓN
El cliente busca productos en el catálogo introduciendo texto
libre. Los resultados se muestran filtrados según el perfil del
cliente (zona geográfica, productos restringidos) y con precios
personalizados.

PRECONDICIONES
  PRE-1. El cliente está autenticado en el sistema.
  PRE-2. El catálogo contiene al menos un producto activo
         accesible para el cliente.

POSTCONDICIONES DE ÉXITO
  POST-1. Se muestran los productos que coinciden con la
          búsqueda, filtrados por el perfil del cliente.
  POST-2. Los precios mostrados corresponden al acuerdo
          comercial del cliente.
  POST-3. Los resultados están ordenados por relevancia
          descendente y paginados.

POSTCONDICIONES DE FALLO
  POST-F1. Se muestra un mensaje informativo (sin resultados
           o error de servicio).
  POST-F2. El cliente puede reintentar o modificar la búsqueda.

FLUJO PRINCIPAL

  1. El cliente escribe un texto de búsqueda en la barra de
     búsqueda principal (mínimo 2 caracteres).
  2. El cliente pulsa Enter o el icono de búsqueda (o el
     sistema inicia la búsqueda con autocompletado tras
     300 ms de inactividad de escritura, mostrando hasta
     5 sugerencias).
  3. El sistema busca coincidencias en: título del producto
     (peso x3), descripción (peso x1), referencia del
     producto (peso x4) y familia de producto (peso x2).
  4. El sistema filtra los resultados según el perfil del
     cliente: se excluyen productos no disponibles en su
     zona geográfica y productos restringidos.
  5. El sistema muestra los resultados ordenados por
     puntuación de relevancia descendente, paginados en
     grupos de 20 resultados por página.
  6. Cada resultado muestra: imagen (miniatura), título
     (con términos de búsqueda resaltados), referencia,
     familia de producto, precio unitario personalizado
     (con IVA desglosado), indicador de disponibilidad
     (en stock / bajo stock / sin stock) y botón "Añadir
     al carrito".
  7. En la parte superior se muestra: total de resultados
     encontrados y filtros aplicables (familia, rango de
     precio, disponibilidad).
  8. El cliente selecciona un producto de los resultados.
  9. El sistema muestra la ficha completa del producto.

FLUJOS ALTERNATIVOS

  FA-1: Búsqueda sin resultados (diverge en paso 5)
    5a. La búsqueda no devuelve ningún resultado tras
        aplicar los filtros del perfil del cliente.
    5b. El sistema muestra: "No se encontraron productos
        para '[texto de búsqueda]'. Intenta con otros
        términos."
    5c. Se sugieren 3 términos de búsqueda alternativos
        basados en corrección ortográfica o productos
        populares.

  FA-2: Búsqueda con filtros (diverge tras paso 7)
    7a. El cliente aplica uno o más filtros (familia de
        producto, rango de precio, solo con stock disponible).
    7b. El sistema recalcula los resultados aplicando los
        filtros adicionales.
    7c. Se actualiza el total de resultados y la lista.
    7d. Los filtros activos se muestran como etiquetas
        removibles.

  FA-3: Búsqueda por referencia exacta (variación del paso 3)
    3a. El texto de búsqueda coincide exactamente con una
        referencia de producto (p. ej., "BIC-CR-050").
    3b. El sistema muestra directamente la ficha del producto
        en lugar de la lista de resultados.

  FA-4: Autocompletado (variación del paso 2)
    2a. Tras 300 ms de inactividad de escritura (y mínimo
        2 caracteres), el sistema muestra un desplegable con
        hasta 5 sugerencias de productos (título y referencia).
    2b. El cliente puede seleccionar una sugerencia (va
        directamente a la ficha) o pulsar Enter para ver
        la lista completa.

FLUJOS EXCEPCIONALES

  FE-1: Texto de búsqueda demasiado corto (detectado en paso 1)
    1a. El cliente escribe menos de 2 caracteres y pulsa Enter.
    1b. El sistema muestra: "Introduce al menos 2 caracteres
        para buscar."
    1c. No se ejecuta la búsqueda.

  FE-2: Motor de búsqueda no disponible (detectado en paso 3)
    3a. El servicio de Elasticsearch no responde en 2 segundos.
    3b. El sistema ejecuta una búsqueda de fallback directa
        a base de datos (solo por título, sin ponderación).
    3c. Se muestra un aviso sutil: "Algunos resultados pueden
        no estar disponibles temporalmente."
    3d. Se registra el error para el equipo de operaciones.

  FE-3: Catálogo vacío para el cliente (detectado en paso 4)
    4a. Tras aplicar los filtros de perfil, no queda ningún
        producto accesible para el cliente (p. ej., restricción
        geográfica total).
    4b. El sistema muestra: "No hay productos disponibles en
        tu zona. Contacta con tu comercial."

  FE-4: Texto de búsqueda excesivamente largo (detectado
  en paso 1)
    1a. El campo de búsqueda acepta un máximo de 200 caracteres.
    1b. Si el cliente pega texto más largo, se trunca a 200
        caracteres sin mensaje de error.

REGLAS DE NEGOCIO APLICABLES
  - DN-020: Precios especiales por acuerdo comercial.
  - DN-021: Restricciones geográficas de producto.

REQUISITOS NO FUNCIONALES
  - PERF-015: La búsqueda devuelve resultados en menos de
    500 ms para el p95, con un catálogo de 5.000 productos
    y 100 usuarios concurrentes.
  - ACC-001: La barra de búsqueda es accesible por teclado
    y compatible con lectores de pantalla (WCAG 2.1 AA).

DEPENDENCIAS
  - FUNC-100: Catálogo de productos.
  - CU-005: Gestionar carrito (botón "Añadir al carrito" en
    resultados).

ESCENARIOS DE VERIFICACIÓN

Escenario 1: Búsqueda por nombre con resultados
  Dado un cliente autenticado de zona "Península" y un
    catálogo con el producto "Bolígrafo BIC Cristal azul"
    (referencia BIC-CR-050, familia Escritura, precio
    personalizado 0,45 €, en stock),
  Cuando el cliente busca "bolígrafo azul",
  Entonces el producto aparece en los resultados con título
    resaltado, referencia BIC-CR-050, precio 0,45 €, indicador
    "En stock" y botón "Añadir al carrito".

Escenario 2: Búsqueda sin resultados
  Dado un cliente autenticado,
  Cuando busca "impresora 3D industrial" y no existe ningún
    producto con esos términos,
  Entonces se muestra "No se encontraron productos para
    'impresora 3D industrial'" con sugerencias alternativas.

Escenario 3: Búsqueda por referencia exacta
  Dado un cliente autenticado y el producto con referencia
    BIC-CR-050,
  Cuando busca exactamente "BIC-CR-050",
  Entonces se muestra directamente la ficha del producto.

Escenario 4: Producto restringido por zona
  Dado un cliente de zona "Canarias" y un producto disponible
    solo en "Península",
  Cuando el cliente busca un término que coincide con ese
    producto,
  Entonces el producto NO aparece en los resultados.

Escenario 5: Búsqueda con filtro de familia
  Dado un cliente que busca "bolígrafo" y obtiene 80 resultados
    de 3 familias (Escritura, Oficina, Escolar),
  Cuando aplica el filtro "familia: Escritura",
  Entonces solo se muestran los resultados de la familia
    Escritura y el total se actualiza.

Escenario 6: Motor de búsqueda caído
  Dado que Elasticsearch no está disponible,
  Cuando un cliente busca "carpeta",
  Entonces se muestran resultados de fallback (búsqueda básica
    por título) con el aviso de servicio degradado.

Escenario 7: Texto demasiado corto
  Dado un cliente autenticado,
  Cuando escribe "a" y pulsa Enter,
  Entonces se muestra "Introduce al menos 2 caracteres para
    buscar" y no se ejecuta la búsqueda.
```

##### Resumen comparativo: caso original vs. caso mejorado

| Aspecto | Original | Mejorado |
| --- | --- | --- |
| Precondiciones | 1 (vaga) | 2 (concretas) |
| Postcondiciones éxito | 1 (genérica) | 3 (detalladas) |
| Postcondiciones fallo | 0 | 2 |
| Pasos flujo principal | 5 (vagos) | 9 (detallados) |
| Flujos alternativos | 1 (incompleto) | 4 (con detalle) |
| Flujos excepcionales | 0 | 4 |
| Criterios de verificación | 1 (genérico) | 7 (con datos concretos) |
| Reglas de negocio | 0 | 2 referenciadas |
| Requisitos no funcionales | 0 | 2 (rendimiento, accesibilidad) |
| Dependencias | 0 | 2 |

El caso de uso original tiene 5 pasos vagos y 1 escenario de prueba.
El mejorado tiene 9 pasos precisos, 4 flujos alternativos, 4
excepcionales y 7 escenarios de verificación con datos concretos. La
diferencia entre ambos es la diferencia entre un caso de uso decorativo
y uno que realmente guía la implementación y la validación.

La revisión cruzada es una de las prácticas más rentables en SDD: con
una inversión de 30-60 minutos por caso de uso, se detectan huecos que
de otro modo se descubrirían semanas después durante la implementación
o, peor aún, en producción.
