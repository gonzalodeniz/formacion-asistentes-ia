# Tema 5. Contratos, interfaces y reglas de dominio

## Descripción ampliada

En Spec Driven Development (SDD), el comportamiento del sistema no queda
completamente definido solo con casos de uso y escenarios. También es
necesario especificar con precisión cómo se relacionan los distintos
componentes, qué esperan unos de otros, qué garantizan al responder y qué
reglas del dominio deben preservarse en todo momento.

Este tema profundiza en tres piezas esenciales para lograr esa precisión:
los contratos, las interfaces y las reglas de dominio.

Un contrato define el acuerdo explícito entre un consumidor y un proveedor.
Puede existir entre módulos internos, entre servicios, entre una API y sus
clientes, o entre capas de una aplicación. Ese acuerdo debe aclarar qué
entradas se aceptan, qué salidas se devuelven, qué condiciones deben
cumplirse antes de invocar una operación y qué garantías deben mantenerse
después de ejecutarla.

Una interfaz expresa la forma de interacción. En sistemas software suele
materializarse como una API REST, una firma de método, un mensaje, un
evento, un comando o un esquema de datos. No obstante, en SDD una interfaz
no debe verse solo como una forma técnica de acceso, sino como una frontera
de comportamiento especificado.

Las reglas de dominio representan las restricciones, decisiones y
condiciones del negocio que el sistema debe respetar. Algunas se aplican
solo en ciertos procesos, mientras que otras deben mantenerse siempre. Estas
últimas suelen expresarse como invariantes.

El objetivo de este tema es enseñar a especificar interfaces y contratos de
forma clara y verificable, y a modelar reglas de dominio con suficiente
precisión para mantener coherencia entre intención de negocio e
implementación técnica.

---

## Objetivos de aprendizaje

Al finalizar este tema, el alumnado será capaz de:

* Especificar contratos claros entre módulos o servicios.
* Definir precondiciones, postcondiciones e invariantes.
* Modelar reglas de negocio de manera explícita.
* Mejorar la consistencia entre dominio e implementación.
* Distinguir entre interfaz técnica y contrato funcional.
* Detectar defectos de especificación en entradas, salidas y errores.
* Relacionar contratos y reglas de dominio con validación posterior.

---

## Resultados de aprendizaje esperados

Al terminar el tema, el participante podrá:

* Redactar contratos claros para operaciones de servicios o APIs.
* Definir precondiciones y postcondiciones de una funcionalidad.
* Identificar invariantes del dominio y expresar sus implicaciones.
* Diferenciar reglas de proceso de reglas estructurales del dominio.
* Detectar incoherencias entre contrato publicado e implementación esperada.
* Revisar contratos desde la perspectiva de consumidor y proveedor.

---

## Contenidos

## 1. Qué es un contrato en desarrollo software

Un contrato es una especificación explícita de lo que una parte espera y de
lo que otra parte garantiza en una interacción. Su función es reducir
ambigüedad y hacer predecible la colaboración entre componentes.

Un contrato suele responder a preguntas como estas:

* ¿Qué operación puede invocarse?
* ¿Qué datos deben enviarse?
* ¿Qué formato y restricciones tienen esos datos?
* ¿Qué condiciones deben cumplirse antes de la invocación?
* ¿Qué resultado se devuelve si todo va bien?
* ¿Qué errores pueden ocurrir?
* ¿Qué estado del sistema debe mantenerse o cambiar?

En SDD, el contrato no es solo un detalle técnico. Es una forma de hacer
explícito el acuerdo entre intención funcional y comportamiento observable.

### Ejemplo simple

Operación: `crearPedido(cliente, lineas, direccion)`

Contrato básico:

* si el cliente existe y las líneas son válidas, el sistema crea un pedido;
* si falta la dirección, la operación se rechaza;
* si una línea no tiene stock, no se genera el pedido parcial.

Este contrato ya expresa entradas, precondiciones y comportamiento esperado.

---

## 2. Diferencia entre interfaz y contrato

Aunque suelen aparecer juntos, no son lo mismo.

## 2.1. Interfaz

La interfaz describe la forma de acceso o comunicación.

Ejemplos:

* endpoint REST;
* firma de método;
* estructura de un mensaje;
* esquema de un evento;
* parámetros de una función.

## 2.2. Contrato

El contrato define el significado de esa interacción y sus garantías.

Incluye aspectos como:

* restricciones de entrada;
* semántica de la operación;
* condiciones previas;
* resultados esperados;
* errores;
* efectos sobre el estado;
* compatibilidad.

### Ejemplo comparativo

Interfaz REST:

* `POST /orders`

Contrato asociado:

* acepta un pedido con al menos una línea;
* requiere cliente existente;
* si el pago no está autorizado, no crea el pedido;
* devuelve `201 Created` con identificador del pedido cuando tiene éxito;
* devuelve `400 Bad Request` si faltan datos obligatorios;
* devuelve `409 Conflict` si el pedido viola una regla de negocio de
  exclusividad.

La interfaz dice cómo entrar. El contrato dice qué significa hacerlo.

---

## 3. Elementos de un contrato bien especificado

## 3.1. Identificación de la operación

Debe quedar claro qué operación se está definiendo.

Ejemplos:

* `POST /returns`
* `ReservaService.confirmarReserva`
* `Evento PedidoPagado`

## 3.2. Propósito

Describe qué objetivo funcional cumple la operación.

Ejemplo:

* registrar una solicitud de devolución;
* confirmar una reserva;
* informar de que un pedido ha sido pagado.

## 3.3. Entradas

Son los datos que recibe la operación. Deben describirse con claridad.

Deben precisarse, cuando aplique:

* nombre del campo;
* tipo;
* obligatoriedad;
* formato;
* restricciones;
* significado funcional.

### Ejemplo

Campo `customerId`:

* tipo: cadena;
* obligatorio: sí;
* restricción: debe corresponder a un cliente existente y activo.

## 3.4. Salidas

Son los datos o resultados devueltos al consumidor.

Deben indicar:

* formato;
* significado;
* campos obligatorios;
* posibles variantes;
* códigos de respuesta si aplica.

## 3.5. Precondiciones

Son condiciones que deben cumplirse antes de ejecutar la operación.

Ejemplos:

* el usuario debe estar autenticado;
* el pedido debe existir;
* el recurso debe estar en estado cancelable;
* el producto debe seguir activo en catálogo.

## 3.6. Postcondiciones

Son condiciones que deben cumplirse tras la ejecución.

Ejemplos:

* se crea un nuevo pedido en estado `Pendiente`;
* se registra una devolución con identificador único;
* el saldo del cliente se actualiza;
* no se modifica ningún dato si la operación falla por validación.

## 3.7. Errores y excepciones contractuales

El contrato debe indicar qué errores son esperables y cómo se representan.

Ejemplos:

* validación incorrecta;
* recurso inexistente;
* conflicto de estado;
* operación no permitida;
* dependencia externa no disponible.

## 3.8. Reglas de compatibilidad

Cuando la interfaz evoluciona, el contrato debe indicar cómo se preserva o
rompe la compatibilidad.

Ejemplos:

* se permite añadir campos opcionales;
* no se elimina un campo obligatorio sin versionado;
* no se cambia la semántica de un código sin transición.

---

## 4. Precondiciones, postcondiciones e invariantes

Estos conceptos son fundamentales para expresar rigor en las operaciones del
sistema.

## 4.1. Precondiciones

Una precondición debe cumplirse antes de ejecutar una operación. Si no se
cumple, la operación no debería ejecutarse con normalidad.

### Ejemplos

* una cuenta debe estar activa antes de permitir transferencias;
* una reserva debe estar en estado `Pendiente` antes de poder confirmarse;
* un pedido debe estar entregado antes de poder devolverse.

### Clave práctica

La precondición protege la operación frente a un contexto inválido.

## 4.2. Postcondiciones

Una postcondición describe lo que debe ser verdad tras la operación si esta
ha sido aceptada.

### Ejemplos

* tras confirmar un pago, el pedido queda en estado `Pagado`;
* tras registrar una devolución válida, existe una solicitud asociada al
  pedido;
* tras asignar un cupón, el cupón queda marcado como consumido.

### Clave práctica

La postcondición garantiza el efecto observable de la operación.

## 4.3. Invariantes

Un invariante es una condición del dominio que debe mantenerse siempre
verdadera mientras el sistema esté en un estado válido.

### Ejemplos

* el saldo de una cuenta no puede ser inferior a cero;
* un pedido pagado no puede carecer de transacción asociada;
* una reserva confirmada no puede tener fecha pasada en el momento de su
  creación;
* una línea de pedido debe tener cantidad mayor que cero.

### Clave práctica

El invariante no depende de una operación concreta, sino de la validez del
modelo del dominio.

---

## 5. Qué son las reglas de dominio

Las reglas de dominio son condiciones, restricciones o decisiones del
negocio que el sistema debe respetar.

No todas las reglas tienen el mismo alcance. Conviene distinguir entre:

* reglas de validación de entrada;
* reglas operativas de proceso;
* reglas estructurales del dominio;
* invariantes permanentes.

### Ejemplos

* un cliente premium puede usar envío prioritario;
* una devolución solo se acepta dentro de 30 días;
* un contrato no puede estar simultáneamente `Cancelado` y `Activo`;
* una factura emitida no puede modificarse sin rectificación formal.

Estas reglas deben especificarse de forma explícita, porque si permanecen
implícitas suelen aparecer errores de interpretación entre negocio,
desarrollo y QA.

---

## 6. Cómo redactar reglas de dominio con calidad

## 6.1. Expresar condición y consecuencia

Una buena regla suele responder a esta estructura:

* bajo qué condición aplica;
* qué comportamiento o restricción produce.

### Ejemplo

Si un pedido contiene productos refrigerados, solo podrá asignarse a
transportistas con capacidad de cadena de frío.

## 6.2. Evitar términos vagos

Expresiones como `adecuado`, `normal`, `suficiente` o `si procede` no sirven
para reglas de dominio de calidad.

## 6.3. Identificar alcance

Conviene indicar si la regla aplica:

* siempre;
* solo en cierto estado;
* solo para ciertos roles;
* solo durante un proceso concreto.

## 6.4. Relacionarla con el modelo del dominio

Una regla debe vincularse con entidades, estados y conceptos del negocio.

## 6.5. Hacerla verificable

Debe ser posible comprobar si la regla se cumple o no.

---

## 7. Contratos en APIs REST

Las APIs REST son un contexto muy habitual para formalizar contratos. Un
buen contrato REST no se limita a enumerar endpoints.

Debe aclarar, como mínimo:

* método y ruta;
* propósito de la operación;
* autenticación y autorización;
* esquema de entrada;
* restricciones y validaciones;
* respuestas de éxito;
* respuestas de error;
* efectos sobre el estado;
* idempotencia, si aplica;
* compatibilidad y versionado, si aplica.

### Ejemplo resumido

Operación: `POST /api/v1/returns`

Propósito: crear una solicitud de devolución.

Entradas mínimas:

* `orderId`: obligatorio;
* `items`: obligatorio, lista no vacía;
* `reason`: obligatorio.

Precondiciones:

* el pedido existe;
* pertenece al cliente autenticado;
* está entregado;
* no ha superado el plazo de devolución.

Postcondición:

* si es válida, se crea la solicitud y se devuelve su identificador.

Errores:

* `400` si faltan datos;
* `403` si el pedido no pertenece al cliente;
* `404` si el pedido no existe;
* `409` si el pedido no es devolvible.

---

## 8. Coherencia entre dominio e implementación

Uno de los riesgos más comunes es que la implementación cumpla la interfaz
técnica, pero viole reglas del dominio.

### Ejemplo

Una API acepta cancelar una suscripción en cualquier estado. Sin embargo, la
regla de dominio establece que una suscripción ya vencida no puede
cancelarse, solo cerrarse por expiración.

Técnicamente la operación existe. Funcionalmente el comportamiento es
incorrecto.

Por eso, el contrato no debe definirse solo desde la perspectiva técnica.
Debe incorporar las restricciones reales del dominio.

### Señales de incoherencia habituales

* se aceptan estados imposibles;
* se devuelven respuestas técnicamente válidas, pero semánticamente
  incorrectas;
* faltan validaciones de reglas clave;
* el contrato no contempla invariantes;
* el consumidor interpreta una semántica distinta a la del proveedor.

---

## 9. Errores frecuentes al especificar contratos

## 9.1. Confundir esquema con contrato

Publicar solo un JSON de ejemplo no basta para definir un contrato.

## 9.2. Omitir precondiciones

Esto genera comportamientos inesperados y dependencia de interpretación.

## 9.3. No definir errores de negocio

Muchos contratos solo documentan errores técnicos y omiten conflictos
funcionales.

## 9.4. No explicar efectos sobre el estado

Si el consumidor no sabe qué cambia tras una operación, el contrato queda
incompleto.

## 9.5. Ignorar invariantes del dominio

Esto lleva a interfaces correctas desde el punto de vista técnico, pero
inseguras desde el punto de vista funcional.

## 9.6. No distinguir entre validación y conflicto

No es lo mismo un campo mal formado que un recurso válido pero en estado no
permitido.

## 9.7. Romper compatibilidad sin indicarlo

Cambiar significado, obligatoriedad o estructura de datos sin transición
rompe consumidores y destruye confianza en el contrato.

---

## 10. Plantilla base para especificar contratos

```markdown
# [ID] Nombre del contrato

## Propósito
...

## Consumidor
...

## Proveedor
...

## Operación o interfaz
- Tipo:
- Identificador:
- Método o acción:

## Entradas
| Campo | Tipo | Obligatorio | Restricciones | Descripción |
| --- | --- | --- | --- | --- |
| ... | ... | ... | ... | ... |

## Precondiciones
- ...

## Salidas de éxito
| Campo | Tipo | Descripción |
| --- | --- | --- |
| ... | ... | ... |

## Postcondiciones
- ...

## Errores y respuestas
| Código | Condición | Comportamiento esperado |
| --- | --- | --- |
| ... | ... | ... |

## Invariantes relacionados
- ...

## Reglas de dominio asociadas
- RD-01:
- RD-02:

## Observaciones de compatibilidad
- ...
```

Esta plantilla ayuda a separar forma, semántica y restricciones.

---

## 11. Ejemplo didáctico completo

## Contrato `CTR-ACC-01 - Bloquear cuenta por intentos fallidos`

### Propósito

Bloquear una cuenta cuando supera el número máximo de intentos fallidos de
autenticación.

### Consumidor

Servicio de autenticación

### Proveedor

Servicio de cuentas

### Operación o interfaz

* Tipo: operación de servicio interno
* Identificador: `AccountService.registerFailedLogin`
* Método o acción: registrar intento fallido

### Entradas

| Campo       | Tipo       | Obligatorio | Restricciones     | Descripción             |
| ----------- | ---------- | ----------- | ----------------- | ----------------------- |
| `accountId` | cadena     | Sí          | Debe existir      | Identificador de cuenta |
| `timestamp` | fecha-hora | Sí          | No futura         | Momento del intento     |
| `sourceIp`  | cadena     | No          | Formato IP válido | Origen del intento      |

### Precondiciones

* La cuenta existe.
* La cuenta no está eliminada.
* El evento corresponde a un intento real de autenticación fallida.

### Salidas de éxito

| Campo            | Tipo     | Descripción                              |
| ---------------- | -------- | ---------------------------------------- |
| `accountId`      | cadena   | Cuenta afectada                          |
| `failedAttempts` | entero   | Número acumulado de intentos             |
| `status`         | cadena   | Estado actual de la cuenta               |
| `blocked`        | booleano | Indica si la cuenta ha quedado bloqueada |

### Postcondiciones

* El contador de intentos fallidos se incrementa en una unidad.
* Si el contador alcanza el umbral definido, la cuenta queda bloqueada.
* Si la cuenta queda bloqueada, se registra el momento del bloqueo.

### Errores y respuestas

| Código              | Condición                   | Comportamiento esperado    |
| ------------------- | --------------------------- | -------------------------- |
| `ACCOUNT_NOT_FOUND` | La cuenta no existe         | No se registra intento     |
| `ACCOUNT_DELETED`   | La cuenta está eliminada    | No se procesa la operación |
| `INVALID_TIMESTAMP` | La marca temporal es futura | La operación se rechaza    |

### Invariantes relacionados

* Una cuenta bloqueada no puede autenticarse con éxito hasta su desbloqueo.
* El número de intentos fallidos acumulados no puede ser negativo.

### Reglas de dominio asociadas

* RD-01: Tras cinco intentos fallidos consecutivos, la cuenta queda
  bloqueada.
* RD-02: Un inicio de sesión exitoso reinicia el contador de intentos
  fallidos.

### Observaciones de compatibilidad

* Puede añadirse información adicional de auditoría sin romper el contrato.
* No debe cambiarse el umbral de bloqueo sin revisar reglas dependientes.

---

## 12. Laboratorios desarrollados con solución

## Laboratorio 1. Definición de contratos para una API REST

### Objetivo

Especificar un contrato completo y claro para una operación REST con
restricciones funcionales y respuestas definidas.

### Enunciado

Se desea definir el contrato de la operación `POST /api/v1/bookings` para
crear una reserva.

Condiciones del dominio:

* la reserva requiere `customerId`, `resourceId`, `startDate` y `endDate`;
* la fecha de inicio debe ser anterior a la de fin;
* el recurso debe estar disponible en el intervalo solicitado;
* un cliente no puede tener dos reservas activas solapadas para el mismo
  recurso;
* si la reserva se crea correctamente, debe quedar en estado `Pending`;
* el sistema debe devolver un identificador único.

Se pide redactar el contrato de la operación.

### Solución propuesta

# CTR-RES-01 Crear reserva

## Propósito

Crear una nueva reserva sobre un recurso disponible para un cliente.

## Consumidor

Aplicación cliente de reservas

## Proveedor

API de reservas

## Operación o interfaz

* Tipo: API REST
* Identificador: `POST /api/v1/bookings`
* Método o acción: crear reserva

## Entradas

| Campo        | Tipo       | Obligatorio | Restricciones                    | Descripción              |
| ------------ | ---------- | ----------- | -------------------------------- | ------------------------ |
| `customerId` | cadena     | Sí          | Debe existir y estar activo      | Cliente solicitante      |
| `resourceId` | cadena     | Sí          | Debe existir                     | Recurso a reservar       |
| `startDate`  | fecha-hora | Sí          | Debe ser anterior a `endDate`    | Inicio de la reserva     |
| `endDate`    | fecha-hora | Sí          | Debe ser posterior a `startDate` | Fin de la reserva        |
| `notes`      | cadena     | No          | Longitud máxima 500              | Observaciones opcionales |

## Precondiciones

* El cliente existe y está activo.
* El recurso existe.
* El intervalo solicitado es válido.
* El recurso está disponible en el intervalo solicitado.
* El cliente no tiene otra reserva activa solapada para el mismo recurso.

## Salidas de éxito

| Campo        | Tipo       | Descripción                       |
| ------------ | ---------- | --------------------------------- |
| `bookingId`  | cadena     | Identificador único de la reserva |
| `status`     | cadena     | Estado inicial de la reserva      |
| `customerId` | cadena     | Cliente asociado                  |
| `resourceId` | cadena     | Recurso reservado                 |
| `startDate`  | fecha-hora | Inicio confirmado                 |
| `endDate`    | fecha-hora | Fin confirmado                    |

## Postcondiciones

* Se crea una nueva reserva persistida.
* La reserva queda en estado `Pending`.
* El identificador de la reserva es único en el sistema.

## Errores y respuestas

| Código HTTP | Código funcional         | Condición                                           | Comportamiento esperado |
| ----------- | ------------------------ | --------------------------------------------------- | ----------------------- |
| `400`       | `BOOKING_INVALID_DATES`  | Fechas inválidas                                    | No se crea la reserva   |
| `404`       | `CUSTOMER_NOT_FOUND`     | Cliente inexistente                                 | No se crea la reserva   |
| `404`       | `RESOURCE_NOT_FOUND`     | Recurso inexistente                                 | No se crea la reserva   |
| `409`       | `RESOURCE_NOT_AVAILABLE` | Recurso no disponible en el intervalo               | No se crea la reserva   |
| `409`       | `BOOKING_OVERLAP`        | Reserva activa solapada del mismo cliente y recurso | No se crea la reserva   |

## Invariantes relacionados

* Toda reserva debe tener `startDate` anterior a `endDate`.
* No pueden coexistir dos reservas activas solapadas para el mismo cliente y
  recurso.
* Toda reserva válida debe estar asociada a un cliente y a un recurso
  existentes.

## Reglas de dominio asociadas

* RD-01: Una reserva nueva se crea siempre en estado `Pending`.
* RD-02: El recurso debe estar disponible en el intervalo solicitado.
* RD-03: Un cliente no puede duplicar reservas activas solapadas sobre el
  mismo recurso.

## Observaciones de compatibilidad

* Es posible añadir campos opcionales en la respuesta sin romper el
  contrato.
* No debe cambiarse el significado del estado inicial sin versionado o
  acuerdo previo.

### Comentario didáctico

La solución es correcta porque:

* distingue claramente forma y semántica;
* documenta entradas, restricciones y errores;
* incorpora reglas del dominio como parte del contrato;
* hace verificable el comportamiento esperado.

---

## Laboratorio 2. Especificación de reglas de negocio con invariantes

### Objetivo

Identificar reglas del dominio, clasificarlas y expresar invariantes de
forma precisa.

### Enunciado

Se trabaja sobre un dominio de gestión de préstamos bibliotecarios.

Información del dominio:

* un usuario no puede tener más de cinco préstamos activos;
* un libro no puede estar prestado a dos usuarios al mismo tiempo;
* un préstamo vencido genera una penalización;
* un usuario penalizado no puede solicitar nuevos préstamos;
* todo préstamo debe tener fecha de inicio y fecha prevista de devolución;
* la fecha prevista de devolución debe ser posterior a la fecha de inicio.

Se pide:

1. redactar las reglas de dominio;
2. identificar cuáles pueden considerarse invariantes;
3. justificar la clasificación.

### Solución propuesta

## Reglas de dominio redactadas

* RD-01: Un usuario no puede tener más de cinco préstamos activos de forma
  simultánea.
* RD-02: Un libro no puede estar asignado en préstamo activo a más de un
  usuario al mismo tiempo.
* RD-03: Cuando un préstamo supera su fecha prevista de devolución sin haber
  sido cerrado, el sistema genera una penalización asociada al usuario.
* RD-04: Un usuario con penalización activa no puede registrar nuevos
  préstamos.
* RD-05: Todo préstamo debe registrar una fecha de inicio y una fecha
  prevista de devolución.
* RD-06: La fecha prevista de devolución debe ser posterior a la fecha de
  inicio.

## Invariantes identificados

* INV-01: Ningún usuario puede tener más de cinco préstamos activos
  simultáneos.
* INV-02: Ningún libro puede tener más de un préstamo activo al mismo
  tiempo.
* INV-03: Todo préstamo válido debe tener fecha de inicio informada.
* INV-04: Todo préstamo válido debe tener fecha prevista de devolución
  informada.
* INV-05: La fecha prevista de devolución debe ser posterior a la fecha de
  inicio.

## Reglas que no se clasifican como invariantes permanentes

* RD-03 no es un invariante en sí mismo, sino una regla de proceso o de
  consecuencia temporal. Se activa cuando se cumple una condición.
* RD-04 puede verse como una precondición operativa para la acción
  `registrar préstamo`, pero no como una propiedad universal de toda entidad
  `préstamo`.

## Justificación de la clasificación

Un invariante describe una condición que debe mantenerse siempre verdadera
en cualquier estado válido del modelo.

Por eso:

* el límite de préstamos activos es una restricción estructural del dominio;
* la exclusividad de préstamo por libro también lo es;
* la presencia y coherencia de fechas forma parte de la validez de la
  entidad préstamo.

En cambio:

* la penalización por vencimiento es una consecuencia de una situación;
* la prohibición de nuevos préstamos para usuarios penalizados es una regla
  operativa previa a una acción concreta.

### Comentario didáctico

La clasificación ayuda a decidir dónde y cómo validar cada regla:

* los invariantes deben proteger el modelo del dominio;
* las reglas operativas deben controlarse en los procesos o servicios que
  ejecutan acciones.

---

## Laboratorio 3. Validación de contratos entre consumidor y proveedor

### Objetivo

Detectar inconsistencias entre la visión del consumidor y la del proveedor
sobre un mismo contrato.

### Enunciado

Se analiza una operación `GET /api/v1/invoices/{invoiceId}`.

### Expectativa del consumidor

* la operación devuelve siempre una factura si el identificador existe;
* si la factura está anulada, la respuesta incluye `status = cancelled`;
* el campo `totalAmount` siempre está presente;
* si la factura no existe, devuelve `404`.

### Especificación actual del proveedor

* si la factura está anulada, el sistema puede devolver `404` para ocultar
  recursos no activos;
* el campo `totalAmount` no se devuelve cuando la factura está anulada;
* en algunos entornos heredados, una factura anulada puede devolverse con
  `status = archived`.

Se pide:

1. identificar conflictos contractuales;
2. proponer una versión alineada del contrato;
3. indicar qué impacto tendría mantener la divergencia.

### Solución propuesta

## 1. Conflictos detectados

### Conflicto 1. Semántica de existencia del recurso

El consumidor espera `404` solo cuando la factura no existe. El proveedor
puede devolver `404` también cuando existe, pero está anulada.

Esto rompe la semántica del recurso.

### Conflicto 2. Presencia del campo `totalAmount`

El consumidor espera que `totalAmount` esté siempre presente. El proveedor
lo omite en facturas anuladas.

Esto rompe predictibilidad de la respuesta.

### Conflicto 3. Valor del estado

El consumidor espera el valor `cancelled`. El proveedor puede devolver
`archived` en algunos entornos.

Esto genera inconsistencia semántica entre entornos.

## 2. Propuesta de contrato alineado

# CTR-INV-01 Consultar factura por identificador

## Propósito

Recuperar una factura existente por su identificador único.

## Consumidor

Aplicaciones de consulta y reporting

## Proveedor

API de facturación

## Operación o interfaz

* Tipo: API REST
* Identificador: `GET /api/v1/invoices/{invoiceId}`
* Método o acción: consultar factura

## Entradas

| Campo       | Tipo   | Obligatorio | Restricciones             | Descripción              |
| ----------- | ------ | ----------- | ------------------------- | ------------------------ |
| `invoiceId` | cadena | Sí          | Debe tener formato válido | Identificador de factura |

## Precondiciones

* El consumidor debe estar autenticado y autorizado para consultar la
  factura.

## Salidas de éxito

| Campo         | Tipo       | Descripción                    |
| ------------- | ---------- | ------------------------------ |
| `invoiceId`   | cadena     | Identificador de factura       |
| `status`      | cadena     | Estado funcional de la factura |
| `totalAmount` | número     | Importe total de la factura    |
| `currency`    | cadena     | Divisa de la factura           |
| `issuedAt`    | fecha-hora | Fecha de emisión               |

## Postcondiciones

* La operación no modifica el estado de la factura.

## Errores y respuestas

| Código HTTP | Código funcional    | Condición                     | Comportamiento esperado |
| ----------- | ------------------- | ----------------------------- | ----------------------- |
| `404`       | `INVOICE_NOT_FOUND` | La factura no existe          | No se devuelve recurso  |
| `403`       | `INVOICE_FORBIDDEN` | El consumidor no tiene acceso | No se devuelve recurso  |

## Invariantes relacionados

* Toda factura accesible debe tener identificador único.
* Toda factura devuelta debe incluir `status` y `totalAmount`.

## Reglas de dominio asociadas

* RD-01: Una factura anulada sigue existiendo como recurso consultable.
* RD-02: El estado canónico de factura anulada es `cancelled`.
* RD-03: El campo `totalAmount` forma parte de la representación funcional
  de la factura, incluso si está anulada.

## Observaciones de compatibilidad

* El valor `archived` queda deprecado y debe mapearse a `cancelled`.
* La omisión de `totalAmount` en facturas anuladas no es compatible con el
  contrato y debe corregirse.

## 3. Impacto de mantener la divergencia

Si la divergencia se mantiene, pueden producirse estos problemas:

* el consumidor interpretará como inexistentes facturas que realmente
  existen;
* se romperán integraciones por ausencia inesperada de `totalAmount`;
* aparecerán errores de tratamiento por estados no previstos;
* se perderá confianza en la estabilidad del contrato;
* QA y desarrollo validarán comportamientos distintos según entorno.

### Comentario didáctico

Este laboratorio muestra que validar contratos no consiste solo en revisar
formatos. También exige alinear la semántica funcional entre quien consume y
quien provee.

---

## 13. Actividades de evaluación

## Evaluación formativa

Durante el tema se puede observar:

* capacidad para distinguir interfaz y contrato;
* calidad en la definición de precondiciones y postcondiciones;
* precisión al redactar reglas de dominio;
* identificación correcta de invariantes;
* revisión crítica de divergencias contractuales.

## Evaluación sumativa sugerida

### Opción A. Cuestionario breve

1. ¿Qué diferencia existe entre una interfaz y un contrato?
2. ¿Qué función tiene una precondición?
3. ¿Qué distingue una postcondición de un invariante?
4. ¿Por qué una regla de dominio debe ser explícita?
5. ¿Qué riesgo existe si consumidor y proveedor interpretan de forma
   distinta un mismo contrato?

### Respuestas orientativas

1. La interfaz describe la forma de interacción; el contrato define el
   significado, restricciones y garantías de esa interacción.
2. Define qué debe cumplirse antes de ejecutar una operación con normalidad.
3. La postcondición describe el estado esperado tras una operación; el
   invariante describe una condición que debe mantenerse siempre en estados
   válidos del dominio.
4. Porque si queda implícita genera ambigüedad, errores de implementación y
   validaciones inconsistentes.
5. Aparecen fallos de integración, semánticas incompatibles y pérdida de
   confianza en el comportamiento del sistema.

### Opción B. Caso práctico corto

Se propone la operación `Cancelar suscripción`.

Se pide:

* definir dos precondiciones;
* definir dos postcondiciones;
* identificar un invariante relacionado;
* redactar una regla de dominio.

### Solución orientativa

Precondiciones:

* la suscripción existe;
* la suscripción está en estado `Activa` o `Pendiente de renovación`.

Postcondiciones:

* la suscripción queda en estado `Cancelada`;
* se registra la fecha de cancelación.

Invariante relacionado:

* una suscripción no puede estar simultáneamente en estado `Activa` y
  `Cancelada`.

Regla de dominio:

* una suscripción ya vencida no puede cancelarse manualmente; debe cerrarse
  por expiración.

---

## 14. Criterios de evaluación

Se considerará superado el tema cuando el participante:

* especifica contratos con entradas, salidas y errores bien definidos;
* distingue correctamente interfaz, contrato y regla de dominio;
* redacta precondiciones, postcondiciones e invariantes con precisión;
* identifica reglas estructurales y reglas operativas del negocio;
* detecta incoherencias entre consumidor y proveedor;
* relaciona contratos con consistencia del dominio e implementación.

---

## 15. Recursos didácticos recomendados

* plantillas de contrato para APIs y servicios;
* ejemplos de contratos bien y mal definidos;
* catálogos de reglas de dominio del negocio;
* ejercicios de clasificación entre precondición, postcondición e
  invariante;
* escenarios de integración entre consumidor y proveedor.

---

## 16. Checklist práctico de revisión

```markdown
## Checklist de contratos y reglas de dominio

### Interfaz y propósito
- [ ] La operación está claramente identificada
- [ ] El propósito funcional está descrito
- [ ] Se distinguen consumidor y proveedor

### Entradas y salidas
- [ ] Las entradas están definidas con restricciones
- [ ] Las salidas de éxito están descritas
- [ ] Los errores y conflictos están especificados

### Condiciones
- [ ] Existen precondiciones claras
- [ ] Existen postcondiciones observables
- [ ] Se identifican invariantes relevantes

### Dominio
- [ ] Las reglas de negocio están redactadas de forma explícita
- [ ] El contrato respeta el modelo del dominio
- [ ] No hay estados o transiciones imposibles

### Coherencia
- [ ] Consumidor y proveedor comparten la misma semántica
- [ ] La compatibilidad está considerada
- [ ] El contrato permite validación objetiva
```

---

## 17. Mensajes clave para cerrar el tema

1. Una interfaz define la forma; un contrato define el significado y las
   garantías.
2. Las precondiciones protegen la operación; las postcondiciones garantizan
   su efecto.
3. Los invariantes preservan la validez del dominio en cualquier estado
   correcto.
4. Las reglas de negocio deben expresarse de forma explícita y verificable.
5. Un contrato técnicamente correcto puede ser funcionalmente incorrecto si
   viola el dominio.
6. La alineación entre consumidor y proveedor es imprescindible para
   integraciones fiables.

---

## 18. Resumen ejecutivo del tema

El Tema 5 desarrolla la especificación de contratos, interfaces y reglas de
dominio como base para una implementación robusta y coherente. Se estudia
cómo definir entradas, salidas, precondiciones, postcondiciones e
invariantes, y cómo distinguir entre la forma técnica de una interacción y
su significado funcional. También se trabaja la redacción explícita de
reglas de negocio y la validación de contratos entre consumidor y
proveedor. Los laboratorios permiten practicar la definición de contratos
REST, la identificación de invariantes de dominio y la detección de
divergencias semánticas en integraciones reales.
