# Tema 4. Modelado del comportamiento y casos de uso

## Descripción ampliada

El modelado del comportamiento permite describir qué debe hacer un sistema
desde la perspectiva de sus actores, sus objetivos y las respuestas
esperadas del propio sistema ante distintas situaciones. En un enfoque de
Spec Driven Development (SDD), este modelado no se limita a narrar
interacciones de forma informal, sino que se convierte en una base para
alinear negocio, análisis, desarrollo y validación.

Los casos de uso son una técnica especialmente útil para capturar el
comportamiento funcional de manera estructurada. Ayudan a representar qué
quiere conseguir un actor, qué pasos sigue, qué decisiones toma el sistema,
qué variantes pueden producirse y qué errores o excepciones deben
gestionarse. Bien redactados, permiten entender el comportamiento esperado
sin bajar aún al nivel del diseño técnico o de la implementación.

Este tema introduce los conceptos de actor, objetivo, caso de uso,
escenario, flujo principal, flujo alternativo y flujo de excepción. También
trabaja cómo redactar casos de uso con precisión suficiente para que sean
comprensibles, revisables y verificables, y cómo conectarlos con criterios
de aceptación y pruebas posteriores.

---

## Objetivos de aprendizaje

Al finalizar este tema, el alumnado será capaz de:

* Modelar el comportamiento funcional del sistema.
* Escribir casos de uso y escenarios con suficiente precisión.
* Identificar flujos alternativos y casos de error.
* Relacionar comportamiento esperado con validación posterior.
* Distinguir entre objetivo del actor, pasos del flujo y reglas aplicables.
* Detectar omisiones habituales en la redacción de casos de uso.
* Revisar casos de uso de forma sistemática y proponer mejoras.

---

## Resultados de aprendizaje esperados

Al terminar el tema, el participante podrá:

* Explicar qué es un caso de uso y para qué sirve dentro de SDD.
* Identificar actores principales y secundarios de una funcionalidad.
* Redactar un caso de uso con flujo principal, alternativos y excepciones.
* Modelar escenarios que cubran éxito, variaciones y errores.
* Detectar ambigüedades, huecos e inconsistencias en casos de uso.
* Relacionar casos de uso con validación funcional y pruebas de aceptación.

---

## Contenidos

## 1. Qué es modelar el comportamiento del sistema

Modelar el comportamiento consiste en describir cómo responde el sistema
cuando un actor intenta alcanzar un objetivo. No se centra todavía en cómo
está implementado internamente, sino en qué ocurre desde el punto de vista
funcional.

Este modelado responde preguntas como las siguientes:

* ¿Quién interactúa con el sistema?
* ¿Qué objetivo intenta conseguir?
* ¿Qué pasos sigue para lograrlo?
* ¿Cómo responde el sistema?
* ¿Qué variantes pueden producirse?
* ¿Qué errores o situaciones excepcionales deben contemplarse?

En SDD, este modelado es importante porque transforma expectativas difusas
en descripciones más estructuradas, comprensibles y verificables.

---

## 2. Qué es un caso de uso

Un caso de uso es una descripción estructurada de la interacción entre uno
o varios actores y el sistema para lograr un objetivo concreto con valor de
negocio o de operación.

Un caso de uso no describe pantallas con detalle visual, ni clases, ni
tablas de base de datos, ni endpoints concretos. Describe comportamiento
funcional observable.

### Características de un buen caso de uso

Un buen caso de uso:

* tiene un objetivo claro;
* identifica al actor principal;
* describe un flujo principal de éxito;
* contempla variantes relevantes;
* incluye excepciones y errores significativos;
* usa lenguaje claro y orientado a comportamiento;
* permite derivar pruebas o criterios de validación.

### Ejemplo breve

Caso de uso: `Registrar pedido`

Actor principal: Cliente

Objetivo: Confirmar una compra y generar un pedido válido.

Este ejemplo ya muestra tres piezas básicas: nombre, actor y objetivo.

---

## 3. Elementos principales de un caso de uso

Aunque las plantillas pueden variar, un caso de uso suele incluir las
siguientes secciones.

### 3.1. Identificador y nombre

Permiten localizar y referenciar el caso de uso.

Ejemplo:

* ID: `CU-ORD-01`
* Nombre: `Registrar pedido`

### 3.2. Objetivo

Explica qué quiere conseguir el actor.

Ejemplo:

* Objetivo: Confirmar la compra de los productos del carrito.

### 3.3. Actor principal

Es quien inicia la interacción para lograr el objetivo.

Ejemplo:

* Actor principal: Cliente autenticado

### 3.4. Actores secundarios

Participan de forma indirecta o colaboran con el proceso.

Ejemplos:

* Pasarela de pago
* Sistema de inventario
* Servicio de notificaciones

### 3.5. Disparador

Indica qué evento inicia el caso de uso.

Ejemplo:

* Disparador: El cliente pulsa el botón `Confirmar compra`.

### 3.6. Precondiciones

Condiciones que deben cumplirse antes de iniciar el caso de uso.

Ejemplos:

* El cliente tiene una sesión válida.
* El carrito contiene al menos un producto.
* El sistema de pagos está disponible.

### 3.7. Postcondiciones

Estado esperado tras la ejecución del caso de uso.

Ejemplos:

* Se genera un pedido con identificador único.
* Se registra la transacción de pago.
* El carrito queda vaciado.

### 3.8. Flujo principal

Secuencia de pasos esperada en el escenario de éxito.

### 3.9. Flujos alternativos

Variantes del flujo principal que siguen siendo válidas, pero cambian la
ruta normal.

### 3.10. Flujos de excepción

Situaciones de error o fallo que impiden completar el objetivo principal o
requieren tratamiento especial.

---

## 4. Diferencia entre caso de uso, escenario y flujo

Estos conceptos se relacionan, pero no son equivalentes.

### Caso de uso

Es la unidad completa que describe una interacción orientada a un objetivo.

### Escenario

Es una instancia concreta o recorrido específico dentro del caso de uso.

### Flujo

Es la secuencia de pasos que compone una parte del caso de uso.

### Relación entre ellos

Un caso de uso puede contener:

* un flujo principal;
* varios flujos alternativos;
* varios flujos de excepción.

Cada combinación concreta de esos recorridos da lugar a un escenario.

### Ejemplo

Caso de uso: `Iniciar sesión`

Escenario 1:
Usuario introduce credenciales válidas y accede correctamente.

Escenario 2:
Usuario introduce contraseña incorrecta y el sistema muestra error.

Escenario 3:
Usuario introduce credenciales válidas, pero debe completar un segundo
factor.

El caso de uso es uno. Los escenarios son varios.

---

## 5. Flujo principal, alternativos y excepcionales

## 5.1. Flujo principal

Describe la secuencia esperada de éxito sin incidencias relevantes.

Debe redactarse como una sucesión clara de interacciones entre actor y
sistema.

### Ejemplo

1. El cliente accede al checkout.
2. El sistema muestra el resumen del carrito.
3. El cliente introduce la dirección de entrega.
4. El cliente selecciona el método de pago.
5. El sistema valida los datos.
6. El sistema solicita el cobro a la pasarela de pago.
7. La pasarela confirma la operación.
8. El sistema genera el pedido.
9. El sistema muestra la confirmación de compra.

## 5.2. Flujos alternativos

Describen variantes válidas del comportamiento que no constituyen un fallo.

### Ejemplo

* Si el cliente tiene una dirección guardada, el sistema la propone por
  defecto en el paso 3.
* Si el cliente dispone de un cupón válido, el sistema recalcula el importe
  antes del pago.

## 5.3. Flujos de excepción

Describen errores, bloqueos o condiciones anómalas.

### Ejemplo

* Si el pago es rechazado, el sistema no genera el pedido y muestra el
  motivo del rechazo.
* Si no hay stock suficiente, el sistema impide continuar y actualiza la
  disponibilidad mostrada.

---

## 6. Cómo redactar casos de uso con calidad

## 6.1. Centrarse en el objetivo del actor

El caso de uso debe responder a una meta funcional relevante.

Mala formulación:

* `Pantalla de checkout`

Mejor formulación:

* `Confirmar compra`

El primer ejemplo nombra una pantalla. El segundo nombra un objetivo.

## 6.2. Usar lenguaje observable

Debe describirse lo que el actor hace y lo que el sistema responde.

Menos útil:

* El backend procesa la entidad y persiste el agregado.

Más útil:

* El sistema registra el pedido y muestra su identificador al cliente.

## 6.3. Mantener un nivel de detalle coherente

No conviene mezclar reglas funcionales de alto nivel con detalles técnicos
muy específicos si no son necesarios para comprender el comportamiento.

## 6.4. Evitar ambigüedades

Expresiones como `si procede`, `rápidamente`, `de forma correcta` o
`según corresponda` deben concretarse.

## 6.5. Incluir variantes y errores significativos

Un caso de uso incompleto suele ignorar rutas alternativas o situaciones de
error que después aparecen en pruebas o en producción.

## 6.6. Asegurar que puede validarse

Cada flujo importante del caso de uso debería poder relacionarse con
escenarios de prueba o criterios de aceptación.

---

## 7. Estructura recomendada de un caso de uso

A continuación se propone una plantilla base útil para equipos de
desarrollo.

```markdown
# [ID] Nombre del caso de uso

## Objetivo
...

## Actor principal
...

## Actores secundarios
- ...

## Disparador
...

## Precondiciones
- ...

## Postcondiciones
- ...

## Flujo principal
1. ...
2. ...
3. ...

## Flujos alternativos
### FA-01
...

### FA-02
...

## Flujos de excepción
### FE-01
...

### FE-02
...

## Reglas de negocio relacionadas
- RB-01:
- RB-02:

## Criterios de validación asociados
- CV-01:
- CV-02:
```

Esta estructura es simple, legible y suficiente para muchos contextos.

---

## 8. Relación entre casos de uso y validación

Un caso de uso bien redactado permite derivar validación funcional de forma
mucho más directa.

### Del caso de uso a la prueba

Cada uno de estos elementos puede dar lugar a pruebas:

* flujo principal;
* variantes relevantes;
* errores y excepciones;
* reglas de negocio asociadas;
* precondiciones y restricciones.

### Ejemplo

Caso de uso: `Recuperar contraseña`

De él podrían derivarse pruebas como:

* recuperación con correo registrado;
* intento con correo inexistente;
* token caducado;
* contraseña nueva que incumple política de seguridad.

Esto conecta el modelado del comportamiento con la verificación posterior.

---

## 9. Errores frecuentes al redactar casos de uso

## 9.1. Nombrar interfaces en lugar de objetivos

Incorrecto:

* `Formulario de pago`

Mejor:

* `Pagar pedido`

## 9.2. Omitir actores secundarios

A veces un caso de uso depende de un sistema externo, pero no se explicita.
Esto dificulta comprender el comportamiento completo.

## 9.3. No incluir precondiciones

Sin ellas, el lector no sabe desde qué situación parte el flujo.

## 9.4. Describir solo el caso feliz

Muchos defectos nacen de no considerar errores, límites o variantes.

## 9.5. Mezclar diseño técnico con comportamiento

Un caso de uso no debería convertirse en una explicación de arquitectura.

## 9.6. Usar pasos demasiado vagos

Ejemplo deficiente:

1. El usuario realiza la operación.
2. El sistema hace lo necesario.
3. Se completa el proceso.

Esto no permite comprensión ni validación.

## 9.7. No mantener consistencia con reglas de negocio

Si una regla de negocio limita una acción, esa limitación debe reflejarse en
los casos de uso relacionados.

---

## 10. Desarrollo teórico para material del alumno

## 10.1. Por qué modelar comportamiento antes de implementar

Modelar comportamiento ayuda a descubrir huecos funcionales antes de tomar
decisiones técnicas. Obliga a pensar en objetivos, pasos, decisiones y
errores, reduciendo malentendidos tempranos.

## 10.2. Casos de uso como puente entre negocio y desarrollo

Negocio suele pensar en objetivos y resultados. Desarrollo necesita
secuencias claras y condiciones operativas. Los casos de uso sirven de
puente entre ambas perspectivas.

## 10.3. El valor de los escenarios alternativos

Muchas funcionalidades parecen sencillas hasta que aparecen descuentos,
permisos, estados previos, sistemas externos o datos incompletos. Los
flujos alternativos permiten modelar esa complejidad sin perder estructura.

## 10.4. El valor de las excepciones

No modelar errores no elimina los errores. Solo los desplaza a fases más
costosas. Las excepciones deben describirse con la misma seriedad que los
casos de éxito.

## 10.5. Relación con SDD

En SDD, un caso de uso no es solo una ayuda de análisis. Es un artefacto de
especificación del comportamiento que puede conectarse con contratos,
criterios de aceptación, pruebas y trazabilidad.

---

## 11. Ejemplo didáctico completo

## Caso de uso: `CU-ACC-01 - Iniciar sesión`

### Objetivo

Permitir que un usuario autenticado acceda a su área privada.

### Actor principal

Usuario registrado

### Actores secundarios

* Servicio de autenticación
* Servicio de segundo factor, si aplica

### Disparador

El usuario selecciona la opción `Iniciar sesión`.

### Precondiciones

* El usuario dispone de una cuenta registrada y activa.
* El sistema de autenticación está operativo.

### Postcondiciones

* Si el proceso finaliza con éxito, el usuario accede a su área privada.
* Si falla la autenticación, no se crea sesión válida.

### Flujo principal

1. El usuario accede a la pantalla de inicio de sesión.
2. El sistema solicita identificador y contraseña.
3. El usuario introduce sus credenciales.
4. El sistema valida el formato de los datos.
5. El sistema verifica las credenciales.
6. El sistema crea la sesión del usuario.
7. El sistema redirige al área privada.

### Flujos alternativos

#### FA-01. Usuario con segundo factor obligatorio

Se inserta después del paso 5 del flujo principal.

1. El sistema detecta que el usuario requiere segundo factor.
2. El sistema solicita el código de verificación.
3. El usuario introduce el código.
4. El sistema valida el código.
5. El flujo continúa en el paso 6 del flujo principal.

#### FA-02. Usuario ya autenticado

Se inserta antes del paso 1 del flujo principal.

1. El sistema detecta una sesión válida existente.
2. El sistema redirige directamente al área privada.

### Flujos de excepción

#### FE-01. Contraseña incorrecta

Se produce en el paso 5 del flujo principal.

1. El sistema detecta que la contraseña no es válida.
2. El sistema muestra el mensaje `Credenciales incorrectas`.
3. El sistema no crea la sesión.

#### FE-02. Cuenta bloqueada

Se produce en el paso 5 del flujo principal.

1. El sistema detecta que la cuenta está bloqueada.
2. El sistema informa del bloqueo.
3. El sistema impide continuar.

#### FE-03. Código de segundo factor inválido

Se produce en el paso 4 del flujo FA-01.

1. El sistema detecta que el código no es válido.
2. El sistema muestra un error.
3. El sistema no permite completar el inicio de sesión.

### Reglas de negocio relacionadas

* RB-01: Solo las cuentas activas pueden iniciar sesión.
* RB-02: Tras cinco intentos fallidos consecutivos, la cuenta queda
  bloqueada.
* RB-03: Los usuarios con rol administrador requieren segundo factor.

### Criterios de validación asociados

* CV-01: Un usuario con credenciales válidas accede correctamente.
* CV-02: Un usuario con contraseña incorrecta no accede.
* CV-03: Un administrador debe completar segundo factor.
* CV-04: Una cuenta bloqueada no puede iniciar sesión.

---

## 12. Laboratorios desarrollados con solución

## Laboratorio 1. Redacción de casos de uso para una funcionalidad real

### Objetivo

Redactar casos de uso completos para una funcionalidad realista, con nivel
adecuado de precisión funcional.

### Enunciado

Se desea modelar la funcionalidad `Solicitud de devolución de pedido` para
una tienda en línea.

Condiciones del dominio:

* Solo se pueden solicitar devoluciones de pedidos entregados.
* El plazo máximo para solicitar la devolución es de 30 días desde la
  entrega.
* El cliente debe indicar un motivo de devolución.
* Algunos productos no admiten devolución por razones higiénicas.
* Si la solicitud es válida, el sistema genera un número de devolución.
* El cliente debe poder consultar posteriormente el estado de su solicitud.

Se pide redactar al menos un caso de uso principal.

### Solución propuesta

# CU-RET-01 Solicitar devolución de pedido

## Objetivo

Permitir que un cliente solicite la devolución de un producto de un pedido
entregado dentro del plazo permitido.

## Actor principal

Cliente autenticado

## Actores secundarios

* Sistema de pedidos
* Sistema de devoluciones
* Servicio de notificaciones

## Disparador

El cliente selecciona la opción `Solicitar devolución` desde el detalle del
pedido.

## Precondiciones

* El cliente tiene una sesión válida.
* El pedido existe y pertenece al cliente.
* El pedido figura como entregado.

## Postcondiciones

* Si la solicitud es válida, queda registrada con identificador único.
* Si la solicitud no es válida, no se genera devolución.

## Flujo principal

1. El cliente accede al detalle de un pedido entregado.
2. El sistema muestra los productos del pedido que pueden devolverse.
3. El cliente selecciona un producto y pulsa `Solicitar devolución`.
4. El sistema solicita el motivo de la devolución.
5. El cliente introduce el motivo y confirma la solicitud.
6. El sistema valida que el pedido está dentro del plazo permitido.
7. El sistema valida que el producto admite devolución.
8. El sistema registra la solicitud de devolución.
9. El sistema genera un número de devolución.
10. El sistema muestra la confirmación al cliente.
11. El sistema deja la solicitud en estado `Pendiente de revisión`.

## Flujos alternativos

### FA-01. Solicitud de devolución de varios productos

Se inserta después del paso 2 del flujo principal.

1. El cliente selecciona varios productos elegibles del mismo pedido.
2. El sistema permite introducir un motivo por cada producto o uno común.
3. El flujo continúa en el paso 5 del flujo principal.

### FA-02. Consulta posterior del estado de la devolución

Relacionado con la postcondición del flujo principal.

1. El cliente accede al apartado `Mis devoluciones`.
2. El sistema muestra la lista de solicitudes registradas.
3. El cliente consulta una solicitud concreta.
4. El sistema muestra su estado actual y su identificador.

## Flujos de excepción

### FE-01. Pedido fuera de plazo

Se produce en el paso 6 del flujo principal.

1. El sistema detecta que han transcurrido más de 30 días desde la entrega.
2. El sistema informa de que la devolución no puede solicitarse fuera de
   plazo.
3. El sistema no registra la solicitud.

### FE-02. Producto no devolvible

Se produce en el paso 7 del flujo principal.

1. El sistema detecta que el producto está excluido de devolución.
2. El sistema informa del motivo de exclusión.
3. El sistema no registra la solicitud.

### FE-03. Motivo no informado

Se produce en el paso 5 del flujo principal.

1. El sistema detecta que no se ha informado motivo de devolución.
2. El sistema muestra un mensaje de validación.
3. El sistema solicita completar el dato antes de continuar.

## Reglas de negocio relacionadas

* RB-01: Solo se permiten devoluciones de pedidos entregados.
* RB-02: El plazo máximo para solicitar la devolución es de 30 días desde
  la fecha de entrega.
* RB-03: Todo producto devuelto debe tener un motivo asociado.
* RB-04: Los productos marcados como no devolvibles no pueden generar una
  solicitud.

## Criterios de validación asociados

* CV-01: Un cliente puede registrar una devolución válida dentro de plazo.
* CV-02: Un producto no devolvible no puede generar solicitud.
* CV-03: Una devolución fuera de plazo es rechazada.
* CV-04: Una solicitud válida queda registrada con identificador único.

### Comentario didáctico

La solución es correcta porque:

* define el objetivo del actor;
* explicita precondiciones y postcondiciones;
* describe un flujo principal verificable;
* incorpora alternativas reales;
* incluye errores derivados de reglas de negocio.

---

## Laboratorio 2. Modelado de escenarios alternativos y excepcionales

### Objetivo

Practicar la identificación y redacción de variantes y errores en torno a
un flujo principal ya definido.

### Enunciado

Se parte del siguiente flujo principal simplificado para el caso de uso
`Reservar cita médica`:

1. El paciente accede al calendario de citas.
2. El sistema muestra horarios disponibles.
3. El paciente selecciona fecha y hora.
4. El sistema solicita confirmación.
5. El paciente confirma la reserva.
6. El sistema registra la cita.
7. El sistema muestra la confirmación.

Se pide:

* redactar dos flujos alternativos;
* redactar tres flujos de excepción;
* mantener coherencia con el objetivo del caso de uso.

### Solución propuesta

# CU-MED-01 Reservar cita médica

## Objetivo

Permitir que un paciente reserve una cita médica disponible.

## Flujo principal

1. El paciente accede al calendario de citas.
2. El sistema muestra horarios disponibles.
3. El paciente selecciona fecha y hora.
4. El sistema solicita confirmación.
5. El paciente confirma la reserva.
6. El sistema registra la cita.
7. El sistema muestra la confirmación.

## Flujos alternativos

### FA-01. Selección de especialista antes de la fecha

Se inserta antes del paso 2 del flujo principal.

1. El sistema solicita seleccionar especialidad o profesional.
2. El paciente selecciona una especialidad.
3. El sistema muestra horarios disponibles para esa selección.
4. El flujo continúa en el paso 3 del flujo principal.

### FA-02. Reserva con recordatorio habilitado

Se inserta después del paso 5 del flujo principal.

1. El paciente activa la opción de recordatorio.
2. El sistema registra la preferencia de aviso.
3. El flujo continúa en el paso 6 del flujo principal.

## Flujos de excepción

### FE-01. Horario ya no disponible

Se produce en el paso 6 del flujo principal.

1. El sistema detecta que otra reserva ha ocupado ese horario.
2. El sistema informa de que la franja ya no está disponible.
3. El sistema solicita seleccionar otra fecha u hora.
4. El flujo vuelve al paso 2 del flujo principal.

### FE-02. Paciente sin datos obligatorios actualizados

Se produce en el paso 5 del flujo principal.

1. El sistema detecta que faltan datos obligatorios del paciente.
2. El sistema informa de que debe actualizar su información personal antes
   de reservar.
3. El sistema no registra la cita.

### FE-03. Fallo al registrar la cita

Se produce en el paso 6 del flujo principal.

1. El sistema detecta un error interno al registrar la cita.
2. El sistema informa de que la reserva no ha podido completarse.
3. El sistema no muestra confirmación final.
4. El sistema registra la incidencia técnica para revisión.

### Comentario didáctico

La solución es adecuada porque distingue correctamente entre:

* alternativas válidas del flujo;
* excepciones que impiden continuar o fuerzan reintento.

También mantiene la relación con el mismo objetivo del actor:
`reservar una cita`.

---

## Laboratorio 3. Revisión cruzada de casos de uso entre equipos

### Objetivo

Aplicar una revisión estructurada sobre un caso de uso redactado por otro
equipo, identificando defectos y proponiendo mejoras.

### Enunciado

Se entrega el siguiente caso de uso redactado por otro equipo.

# CU-PAG-01 Pagar pedido

## Objetivo

Pagar un pedido.

## Actor principal

Cliente

## Flujo principal

1. El cliente entra en pago.
2. El sistema muestra los datos.
3. El cliente paga.
4. El sistema procesa la operación.
5. El sistema termina el proceso.

Se pide:

1. identificar problemas del caso de uso;
2. clasificarlos;
3. proponer una versión mejorada.

### Solución propuesta

## 1. Problemas detectados

### a) Falta de precisión

Expresiones como `entra en pago`, `muestra los datos`, `paga` y `termina
el proceso` son demasiado vagas.

### b) Falta de contexto

No se indican disparador, precondiciones, postcondiciones ni actores
secundarios relevantes.

### c) Incompletitud

No aparecen:

* validación de medios de pago;
* respuesta de la pasarela;
* tratamiento de rechazo;
* generación de confirmación;
* efectos sobre el pedido.

### d) Ausencia de flujos alternativos y excepciones

No se contemplan variantes como elegir medio de pago guardado ni errores
como tarjeta rechazada.

### e) Baja verificabilidad

Con la redacción actual no pueden derivarse pruebas objetivas con claridad.

## 2. Clasificación de defectos

| Defecto detectado         | Tipo                 |
| ------------------------- | -------------------- |
| Pasos vagos               | Ambigüedad           |
| Sin precondiciones        | Incompletitud        |
| Sin postcondiciones       | Incompletitud        |
| Sin actores secundarios   | Omisión              |
| Sin errores ni variantes  | Incompletitud        |
| No permite pruebas claras | Baja verificabilidad |

## 3. Versión mejorada

# CU-PAG-01 Pagar pedido

## Objetivo

Permitir que un cliente confirme el pago de un pedido pendiente.

## Actor principal

Cliente autenticado

## Actores secundarios

* Pasarela de pago
* Sistema de pedidos
* Servicio de notificaciones

## Disparador

El cliente selecciona la opción `Pagar pedido` desde el resumen del pedido.

## Precondiciones

* El cliente tiene una sesión válida.
* El pedido existe y está en estado `Pendiente de pago`.
* El importe total del pedido está calculado.

## Postcondiciones

* Si el pago se confirma, el pedido pasa a estado `Pagado`.
* Si el pago falla, el pedido permanece en estado `Pendiente de pago`.

## Flujo principal

1. El cliente accede al resumen del pedido pendiente.
2. El sistema muestra importe total y métodos de pago disponibles.
3. El cliente selecciona un método de pago.
4. El sistema solicita los datos necesarios para el método elegido.
5. El cliente introduce los datos y confirma la operación.
6. El sistema valida el formato de los datos.
7. El sistema solicita el cobro a la pasarela de pago.
8. La pasarela confirma la operación.
9. El sistema marca el pedido como `Pagado`.
10. El sistema muestra la confirmación al cliente.
11. El sistema envía una notificación de pago realizado.

## Flujos alternativos

### FA-01. Uso de tarjeta guardada

Se inserta después del paso 2 del flujo principal.

1. El cliente selecciona una tarjeta previamente guardada.
2. El sistema solicita únicamente la confirmación o el código adicional
   requerido.
3. El flujo continúa en el paso 5 del flujo principal.

### FA-02. Pago con cupón o saldo disponible

Se inserta antes del paso 7 del flujo principal.

1. El sistema detecta saldo o cupón aplicable.
2. El sistema recalcula el importe pendiente.
3. Si el importe pendiente sigue siendo mayor que cero, el flujo continúa en
   el paso 7.
4. Si el importe pendiente es cero, el sistema marca el pedido como pagado y
   continúa en el paso 10.

## Flujos de excepción

### FE-01. Datos de pago inválidos

Se produce en el paso 6 del flujo principal.

1. El sistema detecta datos incompletos o inválidos.
2. El sistema informa del error.
3. El sistema solicita corrección antes de continuar.

### FE-02. Pago rechazado por la pasarela

Se produce en el paso 8 del flujo principal.

1. La pasarela rechaza la operación.
2. El sistema informa de que el pago no ha sido aceptado.
3. El sistema no marca el pedido como pagado.

### FE-03. Pedido ya pagado

Se produce antes del paso 1 del flujo principal.

1. El sistema detecta que el pedido ya está en estado `Pagado`.
2. El sistema informa al cliente.
3. El sistema impide iniciar una nueva operación de cobro.

## Reglas de negocio relacionadas

* RB-01: Solo pueden pagarse pedidos en estado `Pendiente de pago`.
* RB-02: Todo pago confirmado debe quedar asociado a una transacción.
* RB-03: No puede confirmarse un pedido como pagado sin respuesta positiva de
  la pasarela, salvo casos expresamente definidos por negocio.

## Criterios de validación asociados

* CV-01: Un pedido pendiente puede pagarse correctamente.
* CV-02: Un rechazo de la pasarela no cambia el estado a `Pagado`.
* CV-03: Un pedido ya pagado no admite un nuevo cobro.
* CV-04: El cliente recibe confirmación tras un pago exitoso.

### Comentario didáctico

La revisión cruzada demuestra cómo mejorar un caso de uso a partir de una
lista de defectos observables. Esto entrena tanto la redacción como la
capacidad de revisión crítica.

---

## 13. Actividades de evaluación

## Evaluación formativa

Durante el tema se puede evaluar:

* identificación correcta de actores y objetivos;
* calidad de redacción de flujos;
* capacidad para distinguir alternativas y excepciones;
* coherencia entre caso de uso y reglas de negocio;
* calidad de la revisión entre pares.

## Evaluación sumativa sugerida

### Opción A. Cuestionario breve

1. ¿Qué diferencia existe entre un caso de uso y un escenario?
2. ¿Qué describe el flujo principal?
3. ¿Qué distingue a un flujo alternativo de uno de excepción?
4. ¿Por qué son importantes las precondiciones?
5. ¿Cómo se relaciona un caso de uso con las pruebas?

### Respuestas orientativas

1. El caso de uso describe la interacción completa orientada a un objetivo;
   el escenario es un recorrido concreto dentro de ese caso de uso.
2. Describe la secuencia esperada de éxito sin incidencias relevantes.
3. El alternativo sigue siendo una variante válida del comportamiento; el de
   excepción describe un error o bloqueo.
4. Porque definen desde qué situación parte el caso de uso y evitan
   interpretaciones incorrectas.
5. Permite derivar pruebas a partir del flujo principal, variantes,
   excepciones y reglas relacionadas.

### Opción B. Caso práctico corto

Se propone la funcionalidad `Cancelar reserva`.

Se pide al alumno:

* identificar actor principal;
* redactar objetivo;
* definir tres pasos del flujo principal;
* añadir un flujo alternativo;
* añadir un flujo de excepción.

### Solución orientativa

Actor principal: Cliente autenticado

Objetivo: Cancelar una reserva activa dentro de las condiciones permitidas.

Flujo principal:

1. El cliente accede al detalle de su reserva.
2. El sistema muestra la opción `Cancelar reserva` si la reserva es
   cancelable.
3. El cliente confirma la cancelación.
4. El sistema cambia el estado de la reserva a `Cancelada`.
5. El sistema muestra la confirmación.

Flujo alternativo:

* Si la reserva tiene gastos de cancelación, el sistema informa del importe
  antes de solicitar confirmación final.

Flujo de excepción:

* Si la reserva ya está vencida o consumida, el sistema impide la
  cancelación y muestra el motivo.

---

## 14. Criterios de evaluación

Se considerará superado el tema cuando el participante:

* modela correctamente el comportamiento funcional de una interacción;
* redacta casos de uso con estructura clara y suficiente;
* distingue entre flujo principal, alternativo y de excepción;
* contempla errores y variantes relevantes;
* relaciona el caso de uso con validación posterior;
* revisa críticamente casos de uso ajenos y propone mejoras justificadas.

---

## 15. Recursos didácticos recomendados

* plantilla de caso de uso del equipo;
* ejemplos de casos de uso buenos y defectuosos;
* checklist de revisión entre pares;
* catálogo de reglas de negocio del dominio;
* ejercicios de derivación de pruebas a partir de casos de uso.

---

## 16. Checklist práctico de revisión de casos de uso

```markdown
## Checklist de revisión

### Identificación
- [ ] El caso de uso tiene nombre orientado a objetivo
- [ ] Existe actor principal claramente identificado
- [ ] Se indica el objetivo del actor

### Contexto
- [ ] Se incluyen disparador y precondiciones
- [ ] Se incluyen postcondiciones

### Calidad del flujo
- [ ] El flujo principal es claro y secuencial
- [ ] Los pasos describen comportamiento observable
- [ ] No hay pasos vagos o ambiguos

### Cobertura
- [ ] Existen flujos alternativos relevantes
- [ ] Existen flujos de excepción relevantes
- [ ] Las reglas de negocio están reflejadas

### Validación
- [ ] Se pueden derivar pruebas del flujo principal
- [ ] Se pueden derivar pruebas de errores y variantes
```

---

## 17. Mensajes clave para cerrar el tema

1. Modelar comportamiento es describir objetivos, interacciones y
   respuestas del sistema.
2. Un caso de uso bien redactado ayuda a alinear análisis, desarrollo y
   validación.
3. El flujo principal no es suficiente: también hay que modelar variantes y
   errores.
4. Los casos de uso deben escribirse en lenguaje funcional y observable.
5. Un buen caso de uso permite derivar pruebas de forma natural.

---

## 18. Resumen ejecutivo del tema

El Tema 4 introduce el modelado del comportamiento del sistema mediante
casos de uso, escenarios y flujos. Se trabaja cómo describir interacciones
funcionales con claridad, desde el objetivo del actor hasta las variantes y
excepciones relevantes. El contenido pone énfasis en redactar casos de uso
comprensibles, estructurados y verificables, alineados con reglas de
negocio y útiles para validación posterior. Los laboratorios refuerzan la
práctica de redacción, ampliación y revisión crítica de casos de uso en
contextos realistas.
