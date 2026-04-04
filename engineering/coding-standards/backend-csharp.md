# C# / .NET Coding Standards

Conventions for all .NET backend projects at Improvs.

## Stack

- **ASP.NET Core** (latest LTS)
- **Entity Framework Core** for database access
- **MediatR** for CQRS command/query handlers
- **FluentValidation** for input validation
- **Serilog** for structured logging
- **xUnit** for testing

## Architecture

Clean Architecture with 4 layers:

```
src/
  Domain/                 # Entities, value objects, interfaces
  Application/            # Commands, queries, handlers (MediatR)
  Infrastructure/         # EF Core, external services, file I/O
  API/                    # Controllers, middleware, startup
```

Dependencies flow inward: API -> Application -> Domain. Infrastructure implements Domain interfaces.

## CQRS pattern

Every API action is a command (write) or query (read):

```csharp
// Command
public record CreateUserCommand(string Name, string Email) : IRequest<Guid>;

public class CreateUserHandler : IRequestHandler<CreateUserCommand, Guid>
{
    public async Task<Guid> Handle(CreateUserCommand request, CancellationToken ct)
    {
        // ...
    }
}
```

```csharp
// Controller
[HttpPost]
public async Task<IActionResult> Create(CreateUserCommand command)
    => Ok(await _mediator.Send(command));
```

## Validation

Use FluentValidation for every command/query:

```csharp
public class CreateUserValidator : AbstractValidator<CreateUserCommand>
{
    public CreateUserValidator()
    {
        RuleFor(x => x.Name).NotEmpty().MaximumLength(100);
        RuleFor(x => x.Email).NotEmpty().EmailAddress();
    }
}
```

Register validators in DI. MediatR pipeline behavior runs validation before handlers.

## Database

- Use EF Core migrations: `dotnet ef migrations add <Name>`
- Never write raw SQL unless EF Core can't express the query
- Use `async` for all database calls
- Configure entities in separate `IEntityTypeConfiguration<T>` classes

## Naming

- Files/classes: `PascalCase`
- Interfaces: `IPrefixed` (e.g., `IUserRepository`)
- Methods: `PascalCase` (C# convention)
- Private fields: `_camelCase`
- Constants: `PascalCase`

## Testing

- Unit tests for handlers (mock repository interfaces)
- Integration tests for API endpoints (WebApplicationFactory)
- Use `Bogus` for test data generation

## Don't

- Don't put business logic in controllers -- controllers only call MediatR
- Don't reference Infrastructure from Application layer
- Don't use `DateTime.Now` -- inject `IDateTimeProvider` for testability
- Don't catch generic `Exception` -- catch specific types
