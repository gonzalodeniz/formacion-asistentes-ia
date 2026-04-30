# Tema 7. Trazabilidad entre especificación, diseño, código y pruebas

## Descripción

La trazabilidad permite conectar cada necesidad del sistema con sus
artefactos derivados: requisitos, decisiones de diseño, componentes de
código, pruebas, evidencias y entregables.

En Spec Driven Development, la especificación no es un documento aislado.
Es la fuente de verdad que guía el diseño, la implementación y la
validación. Por ello, cada cambio debe poder seguirse desde su origen hasta
su resultado final.

Este tema se centra en cómo mantener esa cadena de relación, cómo detectar
desviaciones y cómo usar la trazabilidad para mejorar mantenimiento,
auditoría, evolución y calidad.

## Objetivos

Al finalizar el tema, el estudiante será capaz de:

* Diseñar una estrategia de trazabilidad entre artefactos.
* Relacionar requisitos con componentes, pruebas y entregables.
* Detectar desviaciones entre especificación e implementación.
* Facilitar mantenimiento, auditoría y evolución del sistema.
* Construir matrices de trazabilidad útiles y mantenibles.
* Evaluar la cobertura real de requisitos mediante evidencias.
* Identificar huecos entre lo especificado y lo implementado.

## 1. Concepto de trazabilidad

La trazabilidad es la capacidad de seguir la vida de un requisito desde su
origen hasta su validación final.

Incluye responder preguntas como:

* ¿Qué necesidad originó este requisito?
* ¿Qué diseño satisface este requisito?
* ¿Qué componente lo implementa?
* ¿Qué prueba demuestra que funciona?
* ¿Qué entrega contiene su implementación?
* ¿Qué impacto tiene cambiarlo?

Una trazabilidad efectiva evita que el proyecto pierda alineación entre lo
que se pidió, lo que se diseñó, lo que se programó y lo que se probó.

## 2. Trazabilidad en Spec Driven Development

En Spec Driven Development, la especificación es el punto de partida del
desarrollo. Esto implica que cada artefacto posterior debe tener una
relación explícita con ella.

La cadena habitual es:

```text
Necesidad -> Requisito -> Diseño -> Código -> Prueba -> Evidencia
```

También puede extenderse con artefactos de negocio:

```text
Objetivo -> Caso de uso -> Requisito -> Historia -> Tarea -> Commit
```

El propósito no es generar burocracia, sino mantener una línea clara entre
decisión, implementación y validación.

## 3. Tipos de trazabilidad

### 3.1 Trazabilidad hacia delante

Permite partir de un requisito y comprobar qué artefactos lo desarrollan.

Ejemplo:

```text
REQ-001 -> CMP-AUTH -> auth.service.ts -> TEST-AUTH-001
```

Sirve para verificar que todos los requisitos han sido diseñados,
implementados y probados.

### 3.2 Trazabilidad hacia atrás

Permite partir de una prueba, componente o decisión y justificar su
existencia mediante un requisito.

Ejemplo:

```text
TEST-AUTH-001 -> REQ-001
```

Sirve para detectar código, pruebas o funcionalidades sin respaldo en la
especificación.

### 3.3 Trazabilidad bidireccional

Combina las dos anteriores. Es la más útil para auditoría y mantenimiento.

Debe permitir responder:

* Desde un requisito, qué código y pruebas lo cubren.
* Desde una prueba, qué requisito valida.
* Desde un componente, qué decisión de diseño lo justifica.
* Desde un cambio, qué artefactos quedan afectados.

## 4. Artefactos trazables

Los artefactos más habituales son:

* Necesidades de usuario.
* Objetivos de negocio.
* Requisitos funcionales.
* Requisitos no funcionales.
* Casos de uso.
* Historias de usuario.
* Decisiones de arquitectura.
* Diagramas de diseño.
* Componentes de software.
* Interfaces y contratos.
* Casos de prueba.
* Pruebas automatizadas.
* Resultados de ejecución.
* Incidencias.
* Commits.
* Versiones y entregables.

No todos los proyectos necesitan trazar todo. La estrategia debe ajustarse
al riesgo, tamaño y criticidad del sistema.

## 5. Identificadores de trazabilidad

Una buena trazabilidad empieza con identificadores estables.

Ejemplos recomendados:

```text
OBJ-001  Objetivo de negocio
NEC-001  Necesidad de usuario
REQ-001  Requisito funcional
RNF-001  Requisito no funcional
CU-001   Caso de uso
ADR-001  Decisión de arquitectura
CMP-001  Componente
API-001  Contrato de interfaz
TC-001   Caso de prueba
BUG-001  Defecto
REL-001  Entregable
```

Reglas básicas:

* Cada identificador debe ser único.
* No se debe reutilizar un identificador eliminado.
* El identificador debe ser estable aunque cambie el texto.
* Los artefactos derivados deben referenciar el identificador original.
* Los commits y pruebas deben incluir referencias cuando sea útil.

Ejemplo de mensaje de commit:

```text
REQ-004 TC-008 valida cancelación de reserva sin penalización
```

## 6. Matriz de trazabilidad

La matriz de trazabilidad es una representación estructurada de las
relaciones entre artefactos.

Una matriz mínima puede incluir:

* Requisito.
* Descripción resumida.
* Diseño asociado.
* Componente asociado.
* Prueba asociada.
* Estado.
* Evidencia.

Ejemplo:

```csv
requisito,diseno,componente,prueba,estado
REQ-001,DSN-001,CMP-AUTH,TC-001,cubierto
REQ-002,DSN-002,CMP-BOOKING,TC-002,cubierto
REQ-003,DSN-003,CMP-NOTIF,,sin prueba
REQ-004,,CMP-PAYMENT,TC-004,sin diseno
```

La matriz no tiene por qué ser una hoja de cálculo. Puede vivir en un
repositorio como YAML, JSON, CSV o Markdown.

Ejemplo en YAML:

```yaml
traceability:
  - requirement: REQ-001
    design: DSN-001
    component: CMP-AUTH
    tests:
      - TC-001
    status: covered

  - requirement: REQ-002
    design: DSN-002
    component: CMP-BOOKING
    tests:
      - TC-002
    status: covered
```

## 7. Estados de cobertura

Para que la matriz sea útil, conviene definir estados claros.

Estados recomendados:

* `draft`: el requisito está definido, pero no aprobado.
* `approved`: el requisito está aprobado.
* `designed`: existe diseño asociado.
* `implemented`: existe código asociado.
* `tested`: existe prueba asociada.
* `validated`: la prueba ha pasado.
* `blocked`: no puede avanzarse por dependencia externa.
* `obsolete`: el requisito ya no aplica.
* `gap`: existe un hueco de trazabilidad.

Una regla práctica es distinguir entre cobertura declarada y cobertura
demostrada.

Cobertura declarada:

```text
El requisito tiene una prueba asociada.
```

Cobertura demostrada:

```text
La prueba asociada se ha ejecutado y ha pasado.
```

## 8. Trazabilidad y diseño

El diseño debe explicar cómo se satisface cada requisito relevante.

Ejemplo:

```text
REQ-010:
  El sistema debe permitir cancelar una reserva hasta 24 horas antes.

DSN-010:
  La cancelación se resuelve en BookingService mediante una regla de
  dominio que compara la fecha actual con la fecha de inicio de la reserva.
```

Relación esperada:

```text
REQ-010 -> DSN-010 -> CMP-BOOKING -> TC-010
```

Un requisito sin diseño puede indicar:

* Falta de análisis.
* Implementación directa sin justificación.
* Riesgo de solución inconsistente.
* Dificultad para mantener el sistema.

## 9. Trazabilidad y código

El código puede vincularse a requisitos de varias formas.

Opciones habituales:

* Nombre de rama.
* Mensaje de commit.
* Pull request.
* Comentario estructurado.
* Anotación en prueba.
* Archivo de trazabilidad externo.

Ejemplo de rama:

```text
feature/REQ-010-cancel-booking
```

Ejemplo de pull request:

```text
Implementa REQ-010 y añade TC-010, TC-011.
```

Ejemplo de anotación en prueba:

```python
def test_cancel_booking_before_deadline():
    """
    Covers: REQ-010
    """
    assert can_cancel(hours_before_start=25) is True
```

No es recomendable llenar el código de comentarios de trazabilidad si eso
reduce su legibilidad. En muchos casos, es mejor mantener la relación en
commits, pruebas y archivos de trazabilidad.

## 10. Trazabilidad y pruebas

Cada prueba debe tener una intención clara.

Una prueba puede cubrir:

* Un requisito completo.
* Una regla de negocio.
* Una condición de borde.
* Un requisito no funcional.
* Un defecto corregido.

Ejemplo:

```text
REQ-010:
  El usuario puede cancelar reservas hasta 24 horas antes.

TC-010:
  Cancelación aceptada cuando faltan 25 horas.

TC-011:
  Cancelación rechazada cuando faltan 23 horas.
```

Esto demuestra que no basta con tener una prueba por requisito. A veces se
necesitan varias pruebas para cubrir casos positivos, negativos y límite.

## 11. Detección de desviaciones

Una desviación aparece cuando los artefactos dejan de estar alineados.

Tipos frecuentes:

* Requisito sin diseño.
* Requisito sin código.
* Requisito sin prueba.
* Código sin requisito.
* Prueba sin requisito.
* Diseño no implementado.
* Prueba que valida una regla obsoleta.
* Requisito modificado sin actualizar pruebas.
* Código que implementa más de lo especificado.

Ejemplo de desviación:

```text
REQ-015 exige exportar informes en CSV.
El código permite exportar CSV y PDF.
No existe requisito que justifique PDF.
```

La funcionalidad PDF puede ser útil, pero desde trazabilidad es una
desviación. Debe documentarse, aprobarse o eliminarse.

## 12. Auditoría de trazabilidad

Una auditoría de trazabilidad revisa si los artefactos están completos y
alineados.

Preguntas de auditoría:

* ¿Todos los requisitos aprobados tienen diseño?
* ¿Todos los requisitos aprobados tienen implementación?
* ¿Todos los requisitos aprobados tienen pruebas?
* ¿Todas las pruebas apuntan a requisitos válidos?
* ¿Hay componentes sin justificación funcional?
* ¿Hay requisitos obsoletos aún implementados?
* ¿La evidencia de pruebas corresponde a la versión entregada?

La auditoría puede hacerse manualmente, con scripts o con integración
continua.

## 13. Métricas útiles

Algunas métricas prácticas son:

* Porcentaje de requisitos con diseño.
* Porcentaje de requisitos con implementación.
* Porcentaje de requisitos con pruebas.
* Porcentaje de requisitos validados.
* Número de requisitos sin cobertura.
* Número de pruebas huérfanas.
* Número de componentes sin requisito.
* Número de desviaciones abiertas.
* Tiempo medio de cierre de desviaciones.

Ejemplo:

```text
Requisitos aprobados: 20
Requisitos con diseño: 18
Requisitos con prueba: 17
Requisitos validados: 15

Cobertura de diseño: 90 %
Cobertura de prueba: 85 %
Cobertura validada: 75 %
```

## 14. Estrategia de trazabilidad recomendada

Una estrategia equilibrada puede seguir estos pasos:

1. Definir los tipos de artefactos a trazar.
2. Crear identificadores únicos.
3. Definir relaciones obligatorias.
4. Elegir formato de almacenamiento.
5. Establecer estados de cobertura.
6. Automatizar comprobaciones básicas.
7. Revisar trazabilidad en cada pull request.
8. Auditar antes de cada entrega.
9. Actualizar la matriz tras cada cambio relevante.

Relaciones mínimas recomendadas:

```text
REQ -> DSN
REQ -> CMP
REQ -> TC
TC  -> REQ
REL -> REQ
```

Para proyectos críticos, añadir:

```text
OBJ -> REQ
REQ -> ADR
REQ -> RISK
BUG -> TC
TC  -> EVIDENCE
```

## 15. Errores habituales

Errores comunes:

* Crear una matriz enorme que nadie mantiene.
* Usar identificadores inestables.
* No diferenciar cobertura y validación.
* Mantener trazabilidad solo al final del proyecto.
* No actualizar pruebas cuando cambia la especificación.
* No registrar decisiones de diseño.
* Trazar componentes demasiado pequeños.
* No automatizar ninguna comprobación.
* Confundir documentación con evidencia.

La mejor matriz no es la más grande, sino la que se mantiene actualizada y
ayuda a tomar decisiones.

## 16. Buenas prácticas

Buenas prácticas recomendadas:

* Mantener la trazabilidad cerca del repositorio.
* Revisar la matriz en cada cambio de requisitos.
* Incluir identificadores en historias, ramas y pruebas.
* Automatizar validaciones simples.
* Revisar requisitos sin pruebas antes de cada entrega.
* Eliminar o justificar código sin requisito.
* Usar estados claros y consistentes.
* Mantener evidencias de ejecución de pruebas.
* Priorizar trazabilidad profunda en requisitos críticos.

## 17. Ejemplo integrador

Sistema de ejemplo: plataforma de reservas de salas.

Requisitos:

```text
REQ-001:
  El usuario debe poder autenticarse con correo y contraseña.

REQ-002:
  El usuario debe poder reservar una sala disponible.

REQ-003:
  El sistema debe enviar una notificación tras crear una reserva.

REQ-004:
  El usuario debe poder cancelar una reserva hasta 24 horas antes.
```

Diseño:

```text
DSN-001:
  Autenticación mediante AuthService.

DSN-002:
  Reserva gestionada por BookingService.

DSN-003:
  Notificación gestionada por NotificationService.

DSN-004:
  Cancelación validada mediante regla de dominio en BookingService.
```

Componentes:

```text
CMP-AUTH:
  src/auth/auth.service.ts

CMP-BOOKING:
  src/booking/booking.service.ts

CMP-NOTIF:
  src/notification/notification.service.ts
```

Pruebas:

```text
TC-001:
  Login correcto con credenciales válidas.

TC-002:
  Reserva aceptada si la sala está disponible.

TC-003:
  Notificación enviada tras crear reserva.

TC-004:
  Cancelación aceptada si faltan más de 24 horas.

TC-005:
  Cancelación rechazada si faltan menos de 24 horas.
```

Matriz resultante:

```csv
requisito,diseno,componente,pruebas,estado
REQ-001,DSN-001,CMP-AUTH,TC-001,validado
REQ-002,DSN-002,CMP-BOOKING,TC-002,validado
REQ-003,DSN-003,CMP-NOTIF,TC-003,validado
REQ-004,DSN-004,CMP-BOOKING,"TC-004 TC-005",validado
```

## 18. Laboratorio de matriz de trazabilidad

### 18.1 Enunciado del laboratorio

Construir una matriz que relacione requisitos, diseño, componentes y
pruebas para un sistema de reservas de salas.

El sistema debe cubrir:

* Autenticación.
* Consulta de disponibilidad.
* Creación de reserva.
* Cancelación de reserva.
* Notificación al usuario.

### 18.2 Objetivo del laboratorio

El objetivo es obtener una matriz que permita comprobar si cada requisito
tiene diseño, implementación prevista y prueba asociada.

### 18.3 Artefactos de entrada

Requisitos:

```text
REQ-001:
  El usuario debe iniciar sesión con correo y contraseña.

REQ-002:
  El usuario debe consultar salas disponibles por fecha y hora.

REQ-003:
  El usuario debe crear una reserva sobre una sala disponible.

REQ-004:
  El usuario debe cancelar una reserva hasta 24 horas antes.

REQ-005:
  El sistema debe enviar una notificación tras crear o cancelar
  una reserva.
```

Diseño:

```text
DSN-001:
  AuthService validará credenciales.

DSN-002:
  AvailabilityService consultará franjas disponibles.

DSN-003:
  BookingService creará reservas y evitará solapamientos.

DSN-004:
  BookingService aplicará la regla de cancelación.

DSN-005:
  NotificationService enviará mensajes transaccionales.
```

Componentes:

```text
CMP-AUTH:
  src/auth/auth.service.ts

CMP-AVAIL:
  src/availability/availability.service.ts

CMP-BOOKING:
  src/booking/booking.service.ts

CMP-NOTIF:
  src/notification/notification.service.ts
```

Pruebas:

```text
TC-001:
  Login correcto con credenciales válidas.

TC-002:
  Login rechazado con contraseña incorrecta.

TC-003:
  Consulta de disponibilidad devuelve salas libres.

TC-004:
  Reserva aceptada si no hay solapamiento.

TC-005:
  Reserva rechazada si existe solapamiento.

TC-006:
  Cancelación aceptada si faltan más de 24 horas.

TC-007:
  Cancelación rechazada si faltan menos de 24 horas.

TC-008:
  Notificación enviada al crear reserva.

TC-009:
  Notificación enviada al cancelar reserva.
```

### 18.4 Solución del laboratorio

Matriz de trazabilidad:

```csv
requisito,diseno,componente,pruebas,estado
REQ-001,DSN-001,CMP-AUTH,"TC-001 TC-002",validado
REQ-002,DSN-002,CMP-AVAIL,TC-003,validado
REQ-003,DSN-003,CMP-BOOKING,"TC-004 TC-005",validado
REQ-004,DSN-004,CMP-BOOKING,"TC-006 TC-007",validado
REQ-005,DSN-005,CMP-NOTIF,"TC-008 TC-009",validado
```

Lectura de la matriz:

* Todos los requisitos tienen diseño asociado.
* Todos los requisitos tienen componente asignado.
* Todos los requisitos tienen al menos una prueba.
* Los requisitos con reglas de borde tienen más de una prueba.
* No se observan huecos de cobertura.

### 18.5 Resultado esperado

El laboratorio se considera superado si:

* Cada requisito aparece una vez en la matriz.
* Cada requisito tiene diseño relacionado.
* Cada requisito tiene componente responsable.
* Cada requisito tiene pruebas asociadas.
* Los casos positivos y negativos están representados.

## 19. Laboratorio de detección de huecos

### 19.1 Enunciado del laboratorio

Dada una especificación y un conjunto de archivos de código y pruebas,
detectar huecos entre lo especificado y lo implementado.

### 19.2 Objetivo del laboratorio

El objetivo es identificar requisitos sin implementación, pruebas sin
requisito y código no justificado por la especificación.

### 19.3 Datos de entrada

Especificación:

```text
REQ-001:
  Inicio de sesión con correo y contraseña.

REQ-002:
  Consulta de disponibilidad de salas.

REQ-003:
  Creación de reserva sin solapamiento.

REQ-004:
  Cancelación hasta 24 horas antes.

REQ-005:
  Notificación al crear o cancelar reserva.
```

Archivos encontrados:

```text
src/auth/auth.service.ts
src/availability/availability.service.ts
src/booking/booking.service.ts
src/payment/payment.service.ts
test/auth.test.ts
test/availability.test.ts
test/booking.test.ts
test/payment.test.ts
```

Referencias declaradas:

```text
src/auth/auth.service.ts:
  REQ-001

src/availability/availability.service.ts:
  REQ-002

src/booking/booking.service.ts:
  REQ-003
  REQ-004

src/payment/payment.service.ts:
  REQ-009

test/auth.test.ts:
  REQ-001

test/availability.test.ts:
  REQ-002

test/booking.test.ts:
  REQ-003
  REQ-004

test/payment.test.ts:
  REQ-009
```

### 19.4 Análisis manual

Requisitos válidos en especificación:

```text
REQ-001
REQ-002
REQ-003
REQ-004
REQ-005
```

Requisitos encontrados en código y pruebas:

```text
REQ-001
REQ-002
REQ-003
REQ-004
REQ-009
```

Huecos detectados:

```text
REQ-005 no tiene implementación.
REQ-005 no tiene prueba.
REQ-009 aparece en código, pero no existe en la especificación.
REQ-009 aparece en pruebas, pero no existe en la especificación.
```

Componentes problemáticos:

```text
src/payment/payment.service.ts
test/payment.test.ts
```

### 19.5 Solución del laboratorio

Informe de desviaciones:

```text
GAP-001:
  Tipo: requisito sin implementación
  Requisito: REQ-005
  Descripción: no existe componente asociado a notificaciones.
  Acción: implementar CMP-NOTIF o aplazar REQ-005 formalmente.

GAP-002:
  Tipo: requisito sin prueba
  Requisito: REQ-005
  Descripción: no hay prueba para notificación tras reserva.
  Acción: crear TC-008 y TC-009.

GAP-003:
  Tipo: código sin requisito válido
  Artefacto: src/payment/payment.service.ts
  Referencia: REQ-009
  Descripción: REQ-009 no existe en la especificación.
  Acción: crear requisito aprobado o eliminar el componente.

GAP-004:
  Tipo: prueba sin requisito válido
  Artefacto: test/payment.test.ts
  Referencia: REQ-009
  Descripción: la prueba valida funcionalidad no especificada.
  Acción: alinear con especificación o retirar la prueba.
```

Matriz corregida propuesta:

```csv
requisito,componente,prueba,estado
REQ-001,CMP-AUTH,TC-001,validado
REQ-002,CMP-AVAIL,TC-002,validado
REQ-003,CMP-BOOKING,TC-003,validado
REQ-004,CMP-BOOKING,TC-004,validado
REQ-005,CMP-NOTIF,"TC-008 TC-009",pendiente
```

Decisión sobre `REQ-009`:

```text
REQ-009 no debe permanecer como referencia activa hasta que sea aprobado.
```

Opciones válidas:

1. Crear `REQ-009` en la especificación si el pago forma parte del alcance.
2. Eliminar el código de pago si está fuera de alcance.
3. Marcarlo como experimento no entregable si todavía no debe validarse.

### 19.6 Automatización opcional

Un script simple puede comparar requisitos especificados y referenciados.

```python
specified = {
    "REQ-001",
    "REQ-002",
    "REQ-003",
    "REQ-004",
    "REQ-005",
}

referenced = {
    "REQ-001",
    "REQ-002",
    "REQ-003",
    "REQ-004",
    "REQ-009",
}

missing_in_code = specified - referenced
unknown_references = referenced - specified

print("Requisitos sin referencia:", sorted(missing_in_code))
print("Referencias desconocidas:", sorted(unknown_references))
```

Salida esperada:

```text
Requisitos sin referencia: ['REQ-005']
Referencias desconocidas: ['REQ-009']
```

### 19.7 Resultado esperado

El laboratorio se considera superado si se identifican:

* Requisitos especificados sin implementación.
* Requisitos especificados sin pruebas.
* Código asociado a requisitos inexistentes.
* Pruebas asociadas a requisitos inexistentes.
* Acciones correctivas para cada desviación.

## 20. Laboratorio de auditoría rápida

### 20.1 Enunciado del laboratorio

Realizar una auditoría rápida de cobertura de requisitos antes de una
entrega.

### 20.2 Objetivo del laboratorio

El objetivo es decidir si la entrega puede considerarse trazable y qué
riesgos deben resolverse antes de publicarla.

### 20.3 Datos de entrada

Matriz de trazabilidad:

```csv
requisito,diseno,codigo,prueba,evidencia,estado
REQ-001,si,si,si,si,validado
REQ-002,si,si,si,si,validado
REQ-003,si,si,si,no,probado_sin_evidencia
REQ-004,si,si,no,no,sin_prueba
REQ-005,no,si,si,no,sin_diseno
REQ-006,si,no,no,no,sin_codigo
```

Criterios de aceptación de entrega:

```text
C1:
  Todo requisito aprobado debe tener diseño.

C2:
  Todo requisito aprobado debe tener código asociado.

C3:
  Todo requisito aprobado debe tener prueba.

C4:
  Toda prueba debe tener evidencia de ejecución.

C5:
  No puede haber requisitos críticos sin validación.
```

Criticidad:

```text
REQ-001: alta
REQ-002: alta
REQ-003: media
REQ-004: alta
REQ-005: baja
REQ-006: media
```

### 20.4 Cálculo de cobertura

Total de requisitos:

```text
6
```

Requisitos con diseño:

```text
5 de 6 = 83,33 %
```

Requisitos con código:

```text
5 de 6 = 83,33 %
```

Requisitos con prueba:

```text
4 de 6 = 66,67 %
```

Requisitos con evidencia:

```text
2 de 6 = 33,33 %
```

Requisitos validados:

```text
2 de 6 = 33,33 %
```

### 20.5 Hallazgos de auditoría

Hallazgos:

```text
AUD-001:
  Requisito: REQ-003
  Criticidad: media
  Problema: tiene prueba, pero no evidencia.
  Riesgo: no se puede demostrar ejecución satisfactoria.

AUD-002:
  Requisito: REQ-004
  Criticidad: alta
  Problema: no tiene prueba ni evidencia.
  Riesgo: requisito crítico no validado.

AUD-003:
  Requisito: REQ-005
  Criticidad: baja
  Problema: tiene código y prueba, pero no diseño.
  Riesgo: implementación sin justificación técnica.

AUD-004:
  Requisito: REQ-006
  Criticidad: media
  Problema: tiene diseño, pero no código ni prueba.
  Riesgo: requisito aprobado no entregado.
```

### 20.6 Solución del laboratorio

Dictamen de auditoría:

```text
La entrega no debe aprobarse como versión final.
```

Motivos:

* Existe un requisito crítico sin prueba: `REQ-004`.
* La cobertura con evidencia es insuficiente.
* Hay código sin diseño asociado en `REQ-005`.
* Existe un requisito aprobado sin implementación: `REQ-006`.

Acciones obligatorias antes de entregar:

```text
ACT-001:
  Crear y ejecutar pruebas para REQ-004.

ACT-002:
  Adjuntar evidencia de ejecución para REQ-003 y REQ-004.

ACT-003:
  Documentar diseño de REQ-005 o retirar la implementación.

ACT-004:
  Implementar REQ-006 o excluirlo formalmente del alcance.

ACT-005:
  Recalcular cobertura tras aplicar correcciones.
```

Nueva matriz esperada tras corrección:

```csv
requisito,diseno,codigo,prueba,evidencia,estado
REQ-001,si,si,si,si,validado
REQ-002,si,si,si,si,validado
REQ-003,si,si,si,si,validado
REQ-004,si,si,si,si,validado
REQ-005,si,si,si,si,validado
REQ-006,si,si,si,si,validado
```

Cobertura esperada:

```text
Diseño: 100 %
Código: 100 %
Prueba: 100 %
Evidencia: 100 %
Validación: 100 %
```

### 20.7 Resultado esperado

El laboratorio se considera superado si el estudiante:

* Calcula correctamente los porcentajes de cobertura.
* Identifica requisitos críticos sin validación.
* Emite un dictamen justificado.
* Propone acciones correctivas.
* Distingue entre prueba existente y evidencia disponible.

## 21. Plantilla de matriz de trazabilidad

La siguiente plantilla puede usarse en proyectos reales.

```csv
id,tipo,descripcion,diseno,componente,pruebas,evidencia,estado
REQ-001,funcional,"",DSN-001,CMP-001,TC-001,EVD-001,validado
REQ-002,funcional,"",DSN-002,CMP-002,TC-002,EVD-002,validado
RNF-001,rendimiento,"",DSN-003,CMP-003,TC-003,EVD-003,validado
```

Campos recomendados:

* `id`: identificador del requisito.
* `tipo`: funcional, no funcional, seguridad, legal u otro.
* `descripcion`: resumen breve.
* `diseno`: diseño o decisión asociada.
* `componente`: componente responsable.
* `pruebas`: casos de prueba asociados.
* `evidencia`: resultado de ejecución o informe.
* `estado`: situación actual de cobertura.

## 22. Lista de comprobación

Antes de cerrar una entrega, revisar:

* Todos los requisitos aprobados tienen identificador.
* Todos los requisitos aprobados tienen estado.
* Todos los requisitos críticos tienen prueba.
* Todas las pruebas referencian requisitos válidos.
* Todo código entregado tiene justificación.
* Los requisitos obsoletos no siguen activos.
* Las evidencias corresponden a la versión entregada.
* Las desviaciones están cerradas o aceptadas formalmente.
* La matriz está actualizada en el repositorio.
* El informe de cobertura se ha revisado antes de publicar.

## 23. Resumen

La trazabilidad conecta especificación, diseño, código y pruebas. Su valor
principal es mantener el proyecto alineado con lo que realmente se pidió y
se aprobó.

Una estrategia eficaz debe ser clara, ligera y mantenible. Debe permitir
detectar huecos, justificar decisiones, medir cobertura y facilitar cambios
futuros.

En Spec Driven Development, la trazabilidad convierte la especificación en
un elemento vivo. No solo describe el sistema: guía su construcción,
verifica su cumplimiento y facilita su evolución.
