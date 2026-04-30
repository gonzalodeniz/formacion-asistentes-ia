# Tema 7. Trazabilidad entre especificación, diseño, código y pruebas

> La trazabilidad es el hilo invisible que conecta el "por qué" del negocio con el "qué" de la especificación, el "cómo" del código y el "está verificado" de las pruebas automatizadas.

## 1. El concepto de Trazabilidad en SDD

En el desarrollo tradicional, es común que una vez finalizado el proyecto nadie sepa exactamente qué módulo de código corresponde a qué documento funcional. En el Spec Driven Development (SDD), la trazabilidad no es un trabajo administrativo posterior, sino una propiedad fundamental y continua del ciclo de vida del software.

La trazabilidad bidireccional nos permite asegurar dos direcciones vitales:

* **Hacia adelante (Completitud):** Asegurar que cada regla especificada ha sido diseñada, programada y probada. Impide que las funcionalidades queden a medias.
* **Hacia atrás (Justificación):** Asegurar que cada línea de código, endpoint o prueba existe *únicamente* para satisfacer una especificación documentada. Esto previene el código inútil, el "gold-plating" (añadir características no solicitadas) y la deuda técnica no justificada.

### 2. Estrategias para mantener la alineación

Para no depender de la memoria del equipo, la trazabilidad debe sistematizarse utilizando metadatos, herramientas integradas y convenciones estrictas:

* **Identificadores Únicos (IDs):** Toda regla de negocio, caso de uso o invariante debe estar indexada con un código único (ej. `REQ-AUTH-01`).
* **Etiquetado en repositorios:** Los commits de código fuente y las ramas de desarrollo deben referenciar el ID de la especificación (ej. `git commit -m "feat: implementar validación de contraseña (REQ-AUTH-01)"`).
* **Pruebas vinculadas:** Los tests automatizados (unitarios, de integración o Gherkin) deben incluir etiquetas o comentarios que los aten al contrato funcional original.

### 3. Beneficios de la Trazabilidad

* **Análisis de impacto rápido:** Si cambia una regla de negocio (por ejemplo, una ley fiscal o de privacidad), el equipo sabe instantáneamente qué bases de datos, componentes visuales y tests automatizados deben modificarse.
* **Auditoría continua:** Permite generar reportes automáticos que demuestran la calidad y cobertura del producto ante clientes, certificadoras o entidades reguladoras.
* **Mantenimiento seguro:** Un desarrollador nuevo puede leer una línea de código complejo y, siguiendo el hilo hacia atrás, entender exactamente qué regla de negocio exigió esa complejidad técnica.

---

## Soluciones a los Laboratorios (Tema 7)

### Laboratorio 1: Matriz de trazabilidad requisito-diseño-prueba

**Reto:** Construir una matriz de trazabilidad bidireccional para la funcionalidad de seguridad "Bloqueo de cuenta tras 3 intentos fallidos".

**Solución:**
El equipo documenta una tabla (o utiliza herramientas de gestión de ciclo de vida como Jira con Xray/Zephyr) que mapea el flujo completo a través de todos los artefactos.

| ID Especificación | Descripción (Regla de Negocio) | Artefacto de Diseño / Interfaz | Artefacto de Código (Backend) | ID Caso de Prueba (QA) | Estado de Cobertura |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `SEC-001` | Bloquear cuenta tras 3 intentos. | UI: Modal `LockoutAlert` | `AuthService.checkAttempts()` | `TEST-SEC-001-A` | Cubierto |
| `SEC-002` | Enviar email de aviso al bloquear. | Template: `lock_alert.html` | `NotificationSender.notifyLock()` | `TEST-SEC-002-A` | Cubierto |
| `SEC-003` | Desbloqueo automático en 15 min. | N/A (Proceso en background) | `CronJob.unlockAccounts()` | `TEST-SEC-003-A` | Pendiente |

*Lección del laboratorio:* La matriz revela visualmente un hueco crítico: la regla `SEC-003` está pendiente de prueba o desarrollo, bloqueando funcionalmente el despliegue a producción de esta característica.

### Laboratorio 2: Detección de huecos entre especificación y código

**Reto:** Auditar un repositorio simulado donde un desarrollador proactivo decidió añadir un botón y un endpoint para "Exportar a Excel", aunque la especificación original solo indicaba explícitamente "Exportar a PDF".

**Solución (Resolución bajo SDD):**

1. **Identificación del hueco (Código huérfano):** Durante la revisión de código (Pull Request) o mediante herramientas de análisis estático, se detecta el nuevo endpoint `/api/export/excel`. Al buscar su trazabilidad hacia atrás, no se encuentra ningún ID de especificación asociado.
2. **Evaluación de impacto:** Aunque la función parezca útil a primera vista, representa un riesgo grave. No hay invariantes definidas sobre cómo se debe formatear el Excel, no hay pruebas de aceptación redactadas por QA que garanticen que no filtra datos sensibles de otros usuarios, y no existe validación por parte de Negocio.
3. **Acción correctiva:** Se rechaza la subida del código a la rama principal. El negocio debe decidir si la exportación a Excel aporta valor real. Si es afirmativo, primero se redacta y aprueba la especificación, se definen sus pruebas y, solo entonces, se valida e integra el código del desarrollador.

### Laboratorio 3: Auditoría rápida de cobertura de requisitos

**Reto:** Extraer métricas de cobertura de forma automatizada utilizando un framework de pruebas basado en especificaciones ejecutables (como Cucumber/Gherkin).

**Solución:**
Para realizar auditorías continuas sin esfuerzo manual, el equipo asocia sistemáticamente las etiquetas de los casos de prueba automatizados con el catálogo de especificaciones.

*Ejemplo de archivo de especificación ejecutable (Gherkin):*

```gherkin
@REQ-CART-05
Feature: Aplicación de cupones de descuento en carrito

  Scenario: El importe del cupón no puede exceder el valor total de la compra
    Given que el usuario tiene un carrito con un total de "10.00€"
    When aplica un cupón promocional por valor de "15.00€"
    Then el total a pagar se actualiza a "0.00€"
    And el sistema informa de que el cupón excede el importe y el resto se pierde
```

*Ejecución de la Auditoría:*
Al ejecutar la suite de integración continua (CI/CD), el sistema genera un informe automático cruzando la lista total de requisitos del proyecto con las etiquetas ejecutadas exitosamente. 
*Resultado de la auditoría:* "Existen 10 especificaciones aprobadas en el catálogo (`REQ-CART-01` a `REQ-CART-10`). Se ejecutaron pruebas con éxito para 8 de ellas. Faltan pruebas automatizadas para `REQ-CART-08` y `REQ-CART-09`. La cobertura actual del contrato es del 80%."
