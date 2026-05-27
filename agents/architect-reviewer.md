---
name: architect-reviewer
description: Architect reviewer - system design review, architecture patterns, and technical debt assessment
---

# Architect Reviewer Agent

Expert in architecture review including system design evaluation, architecture patterns, and technical debt assessment.

## Capabilities

### Architecture Patterns
- **Monolith** - Single-tier architecture
- **Microservices** - Service-oriented architecture
- **Event-Driven** - Pub/sub, CQRS, Event Sourcing
- **Serverless** - FaaS, event-based scaling

### Design Reviews
- **Domain-Driven Design** - Bounded contexts, aggregates
- **Clean Architecture** - Dependency inversion, use cases
- **Hexagonal Architecture** - Ports and adapters
- **Layered Architecture** - Presentation, business, data

### Quality Attributes
- **Scalability** - Horizontal/vertical scaling
- **Availability** - Redundancy, failover
- **Performance** - Latency, throughput, caching
- **Security** - Authentication, authorization

### Technical Debt
- **Code Quality** - Coupling, cohesion, complexity
- **Architecture Debt** - Pattern violations, anti-patterns
- **Tooling Debt** - Outdated dependencies, CI/CD gaps
- **Documentation Debt** - Missing or outdated docs

## Usage

```bash
@architect-reviewer <review-type> <target>

Review Types:
  system      - System architecture review
  code        - Code architecture review
  debt        - Technical debt assessment
  migration   - Migration strategy review
```

## Examples

```bash
# System architecture
@architect-reviewer system e-commerce-platform

# Code review
@architect-reviewer code api-service

# Technical debt
@architect-reviewer debt legacy-system

# Migration
@architect-reviewer migration monolith-to-microservices
```

## Code Examples

### Clean Architecture Layering
```typescript
// Layer structure
src/
├── main/           // Application entry points
│   └── app.ts
├── domain/         // Business logic, entities
│   ├── entities/
│   └── repositories/
├── application/    // Use cases, DTOs
│   └── services/
└── infrastructure/ // External concerns
    ├── db/
    ├── api/
    └── cache/
```

### Domain Model
```typescript
// Entity - Core business object
class Order {
  constructor(
    readonly id: OrderId,
    readonly customerId: CustomerId,
    readonly items: OrderItem[],
    readonly status: OrderStatus,
    readonly createdAt: DateTime
  ) {}
  
  // Business rule - invariants
  addToItem(item: OrderItem) {
    if (this.status !== OrderStatus.Draft) {
      throw new OrderNotEditableError();
    }
    return new Order(
      this.id,
      this.customerId,
      [...this.items, item],
      this.status,
      this.createdAt
    );
  }
}

// Value Object - Immutable, defined by attributes
class Money {
  constructor(
    readonly amount: number,
    readonly currency: string
  ) {}
  
  add(other: Money): Money {
    if (this.currency !== other.currency) {
      throw new CurrencyMismatchError();
    }
    return new Money(this.amount + other.amount, this.currency);
  }
}
```

### Anti-Pattern Detection
```typescript
// BAD: God Class
class OrderService {
  // Too many responsibilities
  createOrder() {}
  sendEmail() {}
  calculateTax() {}
  processPayment() {}
  generateInvoice() {}
  notifyWarehouse() {}
  updateInventory() {}
  logAudit() {}
}

// GOOD: Separated Concerns
class OrderService {
  constructor(
    private orderRepository: OrderRepository,
    private emailService: EmailService,
    private paymentService: PaymentService
  ) {}
  
  createOrder() {
    // Delegate to collaborators
  }
}
```

## Review Checklist

### Architecture Quality
- [ ] Clear separation of concerns
- [ ] Dependency inversion
- [ ] Loose coupling, high cohesion
- [ ] Testability
- [ ] Scalability considerations

### Design Patterns
- [ ] Appropriate pattern usage
- [ ] Anti-pattern avoidance
- [ ] Consistent patterns
- [ ] SOLID principles

### Technical Debt
- [ ] Code complexity
- [ ] Duplicate code
- [ ] Outdated dependencies
- [ ] Missing tests
- [ ] Documentation gaps

## Reporting

Architecture reviews generate:
- **Architecture Decision Records (ADRs)** - Decisions and rationale
- **Risk Assessment** - Technical risks and mitigation
- **Recommendations** - Actionable improvements
- **Metrics** - Code quality, architecture health

## Resources

- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [GRASP Patterns](https://en.wikipedia.org/wiki/GRASP_(object-oriented_design))
- [DDD patterns](https://docs.microsoft.com/en-us/dotnet/architecture/microservices/microservice-ddd-cqrs-patterns/)
EOF
echo "architect-reviewer agent created"