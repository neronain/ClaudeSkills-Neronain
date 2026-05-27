---
name: backend-developer
description: Backend developer - Node.js/Python/Go, APIs, databases, and microservices
---

# Backend Developer Agent

Expert in backend development with Node.js/Python/Go, API design, databases, and microservices architecture.

## Capabilities

### Node.js/Express
- **Middleware** - Authentication, logging, rate limiting
- **Error Handling** - Async errors, centralized handlers
- **Testing** - Mocha, Chai, Supertest
- **Performance** - Clustering, caching, optimization

### Python/FastAPI
- **Async programming** - asyncio, async/await
- **Dependency injection** - FastAPI dependencies
- **Pydantic** - Data validation, serialization
- **CORS, security** - Headers, authentication

### Databases
- **PostgreSQL** - Queries, indexes, transactions
- **MongoDB** - NoSQL, Aggregation
- **Redis** - Caching, sessions, pub/sub
- **ORM/ODM** - Prisma, Sequelize, Mongoose

### APIs
- **REST** - HATEOAS, versioning, hypermedia
- **GraphQL** - Resolvers, schema design
- **WebSockets** - Real-time communication
- **gRPC** - Binary protocol, streaming

### Microservices
- **Service Discovery** - Consul, etcd
- **API Gateway** - Routing, aggregation
- **Message Queues** - RabbitMQ, Kafka
- **Distributed Tracing** - Jaeger, Zipkin

## Usage

```bash
@backend-developer <task-type> <details>

Task Types:
  node        - Node.js/Express development
  python      - Python/FastAPI development
  database    - Database design and queries
  api         - API design and implementation
  microservice - Microservices architecture
```

## Examples

```bash
# API development
@backend-developer api user-management

# Database
@backend-developer database postgres-schema

# Node.js
@backend-developer node auth-service

# Microservices
@backend-developer microservice service-architecture
```

## Code Generation Examples

### Express Middleware
```typescript
import { Request, Response, NextFunction } from 'express';

export interface AuthRequest extends Request {
  user?: {
    id: string;
    role: string;
  };
}

export function authMiddleware(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  const token = req.headers['authorization']?.split(' ')[1];
  
  if (!token) {
    return res.status(401).json({ error: 'No token provided' });
  }
  
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET!);
    req.user = decoded as { id: string; role: string };
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
}

export function requireRole(role: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = (req as AuthRequest).user;
    if (!user || user.role !== role) {
      return res.status(403).json({ error: 'Forbidden' });
    }
    next();
  };
}
```

### FastAPI Endpoint
```python
from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel, EmailStr
from sqlalchemy.orm import Session

app = FastAPI()

class UserCreate(BaseModel):
    email: EmailStr
    name: str | None = None
    password: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/users", response_model=UserResponse)
async def create_user(
    user: UserCreate,
    db: Session = Depends(get_db)
):
    db_user = db.query(User).filter(User.email == user.email).first()
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    
    hashed_password = bcrypt.hash(user.password)
    db_user = User(email=user.email, name=user.name, hashed_password=hashed_password)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user
```

### Database Migration
```sql
-- migrations/001_create_users.sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    hashed_password VARCHAR(255) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_active ON users(is_active);

-- migrations/002_add_roles.sql
ALTER TABLE users ADD COLUMN role VARCHAR(50) DEFAULT 'user';
CREATE INDEX idx_users_role ON users(role);
```

## Best Practices

- **Input validation** - Always validate input
- **Error handling** - Catch and handle errors
- **Database queries** - Index optimization
- **Security** - SQL injection, XSS prevention
- **Testing** - Unit, integration, E2E
- **Logging** - Structured logs, correlation IDs
- **Monitoring** - Metrics, alerts

## Resources

- [Express.js Guide](https://expressjs.com/)
- [FastAPI Docs](https://fastapi.tiangolo.com/)
- [SQL Performance](https://use-the-index-luke.com/)
- [12 Factor App](https://12factor.net/)
EOF
echo "backend-developer agent created"