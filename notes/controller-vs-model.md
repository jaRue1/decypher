Bang (!) Convention:
  - Part of the method name, not an operator
  - Signals: "modifies data" or "raises exception on failure"
  - update returns false on failure, update! raises an exception

  Conditional Method Calls:
  if @mission.commence!
  - Executes the method AND uses its return value
  - Equivalent to: result = @mission.commence!; if result
  - Methods in Ruby always return something (last expression or explicit return)

  Controller vs Model - Quick Reference:
  ┌─────────────────────────────┬─────────────────────────────┐
  │           Pattern           │            Layer            │
  ├─────────────────────────────┼─────────────────────────────┤
  │ @instance.method            │ Model method                │
  ├─────────────────────────────┼─────────────────────────────┤
  │ redirect_to, render, params │ Controller (Rails-provided) │
  ├─────────────────────────────┼─────────────────────────────┤
  │ update!, save!, find, where │ Active Record (Model)       │
  ├─────────────────────────────┼─────────────────────────────┤
  │ Business logic, validations │ Model                       │
  ├─────────────────────────────┼─────────────────────────────┤
  │ Request/response handling   │ Controller                  │
  └─────────────────────────────┴─────────────────────────────┘
  "Thin Controller, Fat Model":
  - Controller: coordinates, handles HTTP request/response
  - Model: business logic, database operations, validations