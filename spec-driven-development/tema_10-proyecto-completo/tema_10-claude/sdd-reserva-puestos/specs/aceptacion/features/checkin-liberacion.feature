# language: es
Feature: Check-in y liberación automática

  Como empleado con reserva
  quiero confirmar mi llegada al puesto
  para que el sistema sepa que lo estoy usando.

  @FUNC-004 @AC-004-01
  Scenario: Check-in exitoso dentro del plazo
    Given "Ana García" tiene reserva "confirmada"
      para hoy franja "AM" (inicio 08:00)
    And la hora actual es "08:15"
    When Ana hace check-in
    Then la reserva pasa a estado "checked_in"
    And se muestra "Check-in completado"

  @FUNC-004 @AC-004-02
  Scenario: Liberación automática por no-show
    Given "Ana García" tiene reserva "confirmada"
      para hoy franja "AM" (inicio 08:00)
    And no ha hecho check-in
    And la hora actual es "08:31"
    When el sistema ejecuta el job de liberación
    Then la reserva pasa a estado "liberada_auto"
    And el puesto vuelve a estado "libre"
    And Ana recibe notificación de liberación

  @FUNC-004 @AC-004-03
  Scenario: Check-in de día completo cubre ambas franjas
    Given "Luis Pérez" tiene reserva "confirmada"
      para hoy franja "FD" (inicio 08:00)
    When Luis hace check-in a las "08:10"
    Then la reserva pasa a estado "checked_in"
    And no se requiere un segundo check-in
      a las 14:00

  @FUNC-004 @AC-004-04
  Scenario: Intento de check-in tras liberación
    Given "Ana García" tenía reserva para hoy "AM"
    And la reserva fue liberada automáticamente
      a las "08:31"
    When Ana intenta hacer check-in a las "08:45"
    Then se muestra "Tu reserva fue liberada
      automáticamente"
    And la reserva permanece en estado "liberada_auto"
