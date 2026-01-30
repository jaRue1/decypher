# Rails Views & ERB

*Notes for TypeScript/React developers learning Rails views*

---

## ERB - Embedded Ruby

ERB is the templating language. HTML with Ruby embedded:

```ruby
<%= expression %>   ← Outputs the result (prints to HTML)
<% code %>          ← Executes code but doesn't output
```

**Example:**
```ruby
<%= @mission.title %>                    ← Outputs: "Learn Ruby"
<% if @mission.status == "active" %>     ← Logic only, no output
  <span>Active</span>
<% end %>
```

**React equivalent:**
```tsx
{mission.title}                          // Output
{mission.status === "active" && (        // Logic
  <span>Active</span>
)}
```

---

## Partials - Reusable Components

Files starting with `_` are partials (like React components):

```
app/views/missions/
├── index.html.erb
├── show.html.erb
├── _mission_card.html.erb    ← Partial (underscore prefix)
└── _form.html.erb            ← Partial
```

**Rendering a partial:**
```ruby
<%= render "mission_card", mission: @mission %>
           ↑ filename       ↑ local variable
           (without _)
```

**React equivalent:**
```tsx
<MissionCard mission={mission} />
```

---

## Passing Data to Partials (Locals)

```ruby
<!-- In index.html.erb -->
<%= render "mission_card", mission: mission, show_actions: true %>

<!-- In _mission_card.html.erb -->
<h2><%= mission.title %></h2>
<% if show_actions %>
  <%= link_to "Edit", edit_mission_path(mission) %>
<% end %>
```

**React equivalent:**
```tsx
// Parent
<MissionCard mission={mission} showActions={true} />

// Component
const MissionCard = ({ mission, showActions }) => (
  <h2>{mission.title}</h2>
  {showActions && <Link to={`/missions/${mission.id}/edit`}>Edit</Link>}
)
```

---

## Instance Variables from Controller

Controllers pass data to views via `@instance_variables`:

```ruby
# Controller
def show
  @mission = Mission.find(params[:id])
  @objectives = @mission.objectives.order(:position)
end
```

```ruby
<!-- View automatically has access -->
<h1><%= @mission.title %></h1>
<% @objectives.each do |objective| %>
  <%= objective.description %>
<% end %>
```

**React equivalent:** Like props passed from a parent route/page component.

---

## Form Helpers

Rails generates forms with CSRF protection built-in:

```ruby
<%= form_with model: @mission do |f| %>
  <%= f.label :title %>
  <%= f.text_field :title, class: "input-class" %>
  <%= f.text_area :description, rows: 4 %>
  <%= f.select :grade, [["Grade A", "A"], ["Grade B", "B"]] %>
  <%= f.submit "Save" %>
<% end %>
```

**Generates:**
```html
<form action="/missions" method="post">
  <input type="hidden" name="authenticity_token" value="...">
  <label for="mission_title">Title</label>
  <input type="text" name="mission[title]" id="mission_title">
  <!-- etc -->
</form>
```

**Nested resource forms:**
```ruby
<%= form_with model: [@mission, Objective.new] do |f| %>
  <!-- Creates form for /missions/:mission_id/objectives -->
<% end %>
```

---

## Link & Button Helpers

```ruby
<!-- Links (GET requests) -->
<%= link_to "View", mission_path(@mission) %>
<%= link_to "View", @mission %>                    ← Shorthand

<!-- Link with block for complex content -->
<%= link_to mission_path(@mission), class: "btn" do %>
  <span>View</span>
  <svg>...</svg>
<% end %>

<!-- Buttons (POST/DELETE/PATCH requests) -->
<%= button_to "Delete", @mission, method: :delete %>

<%= button_to commence_mission_path(@mission), method: :post do %>
  Commence Mission
<% end %>
```

**React equivalent:**
```tsx
<Link to={`/missions/${mission.id}`}>View</Link>
<button onClick={() => deleteMission(mission.id)}>Delete</button>
```

---

## Path Helpers

Rails auto-generates URL helpers from routes:

```ruby
# routes.rb
resources :missions do
  member do
    post :commence
  end
end
```

**Generated helpers:**
| Helper | URL |
|--------|-----|
| `missions_path` | `/missions` |
| `mission_path(@mission)` | `/missions/4` |
| `new_mission_path` | `/missions/new` |
| `edit_mission_path(@mission)` | `/missions/4/edit` |
| `commence_mission_path(@mission)` | `/missions/4/commence` |

**React equivalent:** Manually building URLs or using a route config.

---

## Helpers in Views

Helper module methods are automatically available in views:

```ruby
# app/helpers/missions_helper.rb
module MissionsHelper
  def status_color(status)
    case status
    when "active" then "bg-blue-400"
    when "completed" then "bg-emerald-400"
    end
  end
end
```

```ruby
<!-- Use directly in any view -->
<span class="<%= status_color(@mission.status) %>">
  <%= @mission.status %>
</span>
```

---

## Loops and Conditionals

```ruby
<!-- Loop -->
<% @missions.each do |mission| %>
  <div><%= mission.title %></div>
<% end %>

<!-- Conditional -->
<% if @mission.completed? %>
  <span>Done!</span>
<% elsif @mission.active? %>
  <span>In Progress</span>
<% else %>
  <span>Not Started</span>
<% end %>

<!-- Inline conditional -->
<span class="<%= @mission.completed? ? 'text-green' : 'text-gray' %>">
```

**React equivalent:**
```tsx
{missions.map(mission => (
  <div>{mission.title}</div>
))}

{mission.completed ? <span>Done!</span> : <span>Not Started</span>}
```

---

## Quick Reference

| Concept | Rails ERB | React/TSX |
|---------|-----------|-----------|
| Template file | `.html.erb` | `.tsx` |
| Output value | `<%= %>` | `{ }` |
| Logic (no output) | `<% %>` | `{ }` with no return |
| Partial/Component | `_card.html.erb` | `Card.tsx` |
| Render partial | `render "card", x: y` | `<Card x={y} />` |
| Pass data | Locals: `render "x", foo: bar` | Props: `<X foo={bar} />` |
| Loop | `<% items.each do \|i\| %>` | `{items.map(i => ...)}` |
| Conditional | `<% if x %>...<% end %>` | `{x && ...}` |
| CSS class logic | `class="<%= condition ? 'a' : 'b' %>"` | `className={condition ? 'a' : 'b'}` |
| Link | `link_to "Text", path` | `<Link to={path}>Text</Link>` |
| Form | `form_with model: @x` | `<form>` + state management |
| URL generation | `mission_path(@m)` | Manual or route config |
