
## Modules = TypeScript Shared Packages

**The key insight:** Modules in Rails serve the same purpose as shared packages in a TypeScript monorepo.

| TypeScript Monorepo | Rails |
|---------------------|-------|
| `packages/shared/` | Modules (`app/helpers/`, `app/services/`) |
| `import { formatDate } from '@shared/utils'` | `include DateHelper` |
| Shared types/interfaces | Modules with shared methods |
| Used by both `apps/web` and `apps/api` | Used by views, controllers, and models |

### Structure Comparison

```
TypeScript Monorepo:
├── apps/
│   ├── web/           (frontend)
│   └── api/           (backend)
└── packages/
    └── shared/        ← shared code between both

Rails:
├── app/
│   ├── views/         (frontend templates)
│   ├── controllers/   (coordination layer)
│   ├── models/        (data layer)
│   ├── helpers/       ← shared code for views (auto-included)
│   └── services/      ← shared business logic (convention)
```

## Modules vs Classes

| | Class | Module |
|---|-------|--------|
| **Instantiate?** | Yes - `User.new` | No |
| **Inheritance?** | Yes - `class Mission < ApplicationRecord` | No |
| **State?** | Yes - instance variables | No |
| **Purpose** | Create objects with state | Share behavior (mixins) |

### Classes - Blueprints for Objects

```ruby
class Mission < ApplicationRecord
  # Can create instances with state
  def commence!
    update!(status: "active")
  end
end

mission = Mission.new(title: "Learn Ruby")  # instantiation
mission.commence!                            # method on instance
```

### Modules - Shared Behavior (Mixins)

```ruby
module MissionsHelper
  def status_color(status)
    case status
    when "active" then "bg-blue-400"
    end
  end
end

# Include in any class that needs it:
class MissionsController < ApplicationController
  include MissionsHelper
end
```