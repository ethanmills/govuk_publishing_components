# Component Conventions

## Namespacing

All components must use the `.app-` namespace with the `c` prefix. The `c` is for component. For example, `.app-c-banner`.

Do not use the `.govuk-` namespace.

The namespace indicates where a component lives. A single page on GOV.UK could render components from multiple places.

| Prefix | Place |
| -- | -- |
| `.app-c-` | Component lives within the frontend application |
| `.gem-c-` | Component originates from the govuk_publishing_components gem |
| `.govuk-` | Component originates from [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend) |

## Structure

| Type | Location | Example | Description |
| -- | -- | -- | -- |
| Template | `app/views/components` | `_my-comp.html.erb` | [Template logic and markup](#template) |
| Documentation | `app/views/components/docs` | `my-comp.yml` | [Describes the component](#write-documentation) |
| Styles | `app/assets/stylesheets/components` | `_my-comp.scss` | [Component styles](#styles) |
| Print styles | `app/assets/stylesheets/components/print` | `_my-comp.scss` | [Component styles](#styles) |
| Images | `app/assets/images/govuk_publishing_components` | `my-comp.png` | [Images](#images) |
| Scripts | `app/assets/javascripts/components` | `my-comp.js` | [Javascript enhancements](#javascript) |
| Tests | `test/components` | `my_comp_test.rb` | [Unit tests](#tests) |
| Javascript tests | `spec/components` | `my_comp_spec.rb` | [Unit tests](#tests) |
| Helpers | `lib/govuk_publishing_components/presenters` | `my_comp_helper.rb` | [Helpers](#helpers) |

## Template

The template logic and markup. The template defines the component’s API. Filename must begin with an underscore.

If complex logic is required this should be handled using a [helper](#helpers).

Example:

```ruby
<%
  options ||= []
  id ||= false
  helper = GovukPublishingComponents::Presenters::MyComponentHelper.new(options)
%>

<% if options.any? %>
  <div class="govuk-something" id="<%= id %>">
    <h2>An example component</h2>
    <%= helper.someContent %>
  </div>
<% endif %>
```

If a component includes a heading, consider including an option to control the heading level (see the [heading component](https://components.publishing.service.gov.uk/component-guide/heading/specific_heading_level) for example).

Components can use other components within their template, if required (see the [input component](https://github.com/alphagov/govuk_publishing_components/blob/master/app/views/govuk_publishing_components/components/_input.html.erb#L37) for example).

Complex components can be split into smaller partials to make them easier to understand and maintain (see the [feedback component](https://github.com/alphagov/govuk_publishing_components/blob/master/app/views/govuk_publishing_components/components/_feedback.html.erb) for example).

Components should not have an option to include arbitrary classes as this could violate the principle of isolation. If there is a requirement for a styling variation on a component this should be included as an option e.g. `small: true`.

## Write documentation

Each component is represented with a single `.yml` file. eg `lead-paragraph.yml`

The `.yml` file must have:

| Property | Required | Description |
| -- | -- | -- |
| filename | Required | Filename of `.yml` file must match component partial name |
| name | Required | Friendly name for component |
| description | Required | One or two sentences summarising the component
| body | Optional | A govspeak markdown block giving guidance for the component |
| accessibility_criteria | Required | A govspeak markdown block listing the [accessibility acceptance criteria](accessibility_acceptance_criteria.md) this component must meet to be accessible |
| examples | Required | Each block represents an example and each example is listed in the component guide. Examples must cover all expected use cases. |

### Example yaml file

```yaml
name: Name of component
description: Short description of component
body: |
  Optional markdown providing further detail about the component
accessibility_criteria: |
  Markdown listing what this component must do to be accessible. For example:

  The banner must:

  - be visually distinct from other content on the page
  - have an accessible name that describes the banner as a notice
shared_accessibility_criteria:
  - link
examples:
  default:
    data:
      some_parameter: 'The parameter value'
    description: |
      This component is used in the following contexts:

      - [the GOV.UK homepage](https://www.gov.uk)
  another_example:
    data:
      some_parameter: 'A different parameter value'
```

#### Yaml configuration for a component which accepts a block

Some components can accept a block as an argument.
eg.

```ruby
<%= render "my-accepts-block-component", { param: value }, do %>
  <span>Some text</span>
<% end %>
```

To configure the block in the component yaml file you should specify
a `block` key in the example data:

```yaml
examples:
  default:
    data:
      some_parameter: 'The parameter value'
      block: |
        <span>Some text</span>
```

#### Yaml configuration for components that need contextual HTML

If a component is only visible, or behaves differently, in a certain context
the examples for it can be embedded within HTML using the embed option.
eg.

```ruby
<button class="trigger-for-component">Click me</button>
<%= render "my-hidden-by-default-component", { param: value } %>
```

To configure a HTML embed in the component yaml file you can specify `embed` at
the root or individual examples:

```yaml
embed: |
  <button class="trigger-for-component">Click me<button>
  <%= component %>
examples:
  default:
  different_embed_example:
    embed: |
      <button class="different-trigger-for-component">Click me<button>
      <%= component %>
```

#### [Accessibility Acceptance Criteria](accessibility_acceptance_criteria.md)

Markdown listing what this component must do to be accessible.

[Shared accessibility criteria](https://github.com/alphagov/govuk_publishing_components/blob/master/app/models/govuk_publishing_components/shared_accessibility_criteria.rb) can be included in a list as shown. They are pre-written accessibility criteria that can apply to more than one component, created to avoid duplication. For example, links within components should all accept focus, be focusable with a keyboard, etc.

A component can have accessibility criteria, shared accessibility criteria, or both.

#### Description

An example can have an optional description. This is a govspeak markdown block.

#### Providing context to examples

A context block can be passed to examples. The guide currently supports `right_to_left` and `dark_background` contexts. For example:

```yaml
examples:
  right_to_left_example:
    data:
      some_parameter: 'عربى'
    context:
      right_to_left: true
```

The component guide will wrap the example with a `direction-rtl` class. It is expected that the host application will set the text direction using the class in a parent element using the following CSS:

```css
.direction-rtl {
  direction: rtl;
  text-align: start;
}
```

The component guide will wrap a `dark_background` context example with a `dark-background` class that sets the parent element background color to govuk-blue. The component should either already work on a dark background or contain a param that, when set to `true`, allows it to work against darker colours.

## Styles

With the exception of namespaces, follow the [GOV.UK Frontend CSS conventions](https://github.com/alphagov/govuk-frontend/blob/master/docs/contributing/coding-standards/css.md), which describes in more detail our approach to namespaces, linting and BEM (block, element, modifier) CSS naming methodology.

### BEM
`.block {}`

`.block__element {}`

`.block--modifier {}`

`.block__element--modifier {}`

All CSS selectors should follow the BEM naming convention shown above, explained in [more detail here](https://github.com/alphagov/govuk-frontend/blob/master/docs/contributing/coding-standards/css.md#block-element-modifier-bem).

Note: to avoid long and complicated class names, we follow the [BEM guidance](http://getbem.com/faq/#css-nested-elements) that classes do not have to reflect the nested nature of the DOM. We also try to avoid nesting classes too deeply, so that styles can be overridden more easily if needed.

```scss
  // Avoid this:
  .block__elem1__elem2__elem3

  // Instead use:
  .block__elem1
  .block__elem2
  .block__elem3
```

Using BEM means we have confidence in our styles only being applied within the component context, and never interfering with other global styles. It also makes it clearer how HTML elements relate to each other.

Visit the links below for more information:

* [Official BEM Documentation](https://en.bem.info/methodology/naming-convention/#css-selector-naming-convention)
* [Guide on BEM naming conventions](https://webdesign.tutsplus.com/articles/an-introduction-to-the-bem-methodology--cms-19403)

### Layout

New components should be built with a bottom margin and no top margin.

A standard for options to control this spacing has [not been decided upon yet](https://github.com/alphagov/govuk_publishing_components/pull/292), although it is likely we will adopt something using the [Design System spacing](https://design-system.service.gov.uk/styles/spacing/).

### Linting
All stylesheets must be linted according to [the style rules](https://github.com/alphagov/govuk-lint/blob/master/configs/scss_lint/gds-sass-styleguide.yml) in [govuk-lint](https://github.com/alphagov/govuk-lint).

```
# Lint Sass in your application components using govuk-lint
bundle exec govuk-lint-sass app/assets/stylesheets/components
```

## Images

Images must be listed in `config/initializers/assets.rb` and can be referred to in Sass as follows.

```
background-image: image-url("govuk_publishing_components/search-button.png");
```

SVGs can also be used for images, ideally inline in templates and compressed.

## Javascript

Follow the [GOV.UK Frontend JS conventions](https://github.com/alphagov/govuk-frontend/blob/master/docs/contributing/coding-standards/js.md).

Scripts should use the [module pattern](https://github.com/alphagov/govuk_publishing_components/blob/master/docs/javascript-modules.md) and be linted using [StandardJS](https://standardjs.com/).

Most components should have an option to include arbitrary data attributes (see the [checkboxes component](https://components.publishing.service.gov.uk/component-guide/checkboxes/checkboxes_with_data_attributes) for example). These can be used for many purposes including tracking (see the [select component](https://components.publishing.service.gov.uk/component-guide/select/with_tracking) for [example code](https://github.com/alphagov/govuk_publishing_components/blob/master/app/assets/javascripts/govuk_publishing_components/components/select.js)) but specific tracking should only be added to a component where there is a real need for it.

Some [common Javascript modules](https://github.com/alphagov/govuk_publishing_components/tree/master/app/assets/javascripts/govuk_publishing_components/lib) are available. If new functionality is required, consider adding it as a common module.

## Tests

Component tests should include a check that the component doesn't fail if no data is passed.

Javascript tests should be included if the component has any Javascript that is unique to it. Use of existing Javascript modules should be covered by existing tests.

## Helpers

Any code needed by a component that is more complex than basic parameter initialisation should be included in a separate file rather than in the template. Any new presenter files must be included in `lib/govuk_publishing_components.rb` to work.

Code can be called and referred to in the template as follows:

```
<%
  card_helper = GovukPublishingComponents::Presenters::ImageCardHelper.new(local_assigns)
%>

<%= card_helper.heading_tag %>
```

### Shared helper

There is also a [shared helper](https://github.com/alphagov/govuk_publishing_components/blob/master/lib/govuk_publishing_components/presenters/shared_helper.rb) that can provide common functionality to all components. This includes a margin bottom option and a heading level option. See components that use the shared helper for [examples of usage](https://github.com/alphagov/govuk_publishing_components/blob/master/app/views/govuk_publishing_components/components/_heading.html.erb).

```
shared_helper = GovukPublishingComponents::Presenters::SharedHelper.new(local_assigns)
```

## Passing HTML to a component
Avoid marking HTML as safe within components, this means avoiding use of `raw` or `html_safe` within a component's view.

By doing this we can avoid the risk of a Cross Site Scripting (XSS) attack.

Only sanitise HTML when the component is used in the application.

There are a few methods to achieve this:

### Yielding blocks with single slots for nested children

Similar to HTML, there may be a clear slot where nested children should appear in a component.

For a panel component, you may expect anything nested within it to appear
at the bottom of the component.

Do not:

```erb
<%= render 'panel', content: "Your reference number<br><strong>HDJ2123F</strong>" %>
```

Do:

```erb
<%= render 'panel' do %>
  Your reference number
  <br>
  <strong>HDJ2123F</strong>
<% end %>
```

### Parameters with HTML for multiple slots

If you have multiple slots where HTML may go, you could consider passing them as parameters.

Note: If you can avoid a requirement for HTML this may be better. In the following example you may consider
`title: { level: 1, text: 'Application complete' }`.

Do not:

```erb
<%= render 'panel', { title: '<h1>Application complete</h1>' } do %>
  Your reference number
  <br>
  <strong>HDJ2123F</strong>
<% end %>
```

Do:

```erb
<% panel_title = capture do %>
  <h1>Application complete</h1>
<% end %>
<%= render 'panel', { title: panel_title } do %>
  Your reference number
  <br>
  <strong>HDJ2123F</strong>
<% end %>
```

or (if the data is passed from a presenter / controller)

```erb
<%= render 'panel', { title: presented_panel_title.html_safe } do %>
  Your reference number
  <br>
  <strong>HDJ2123F</strong>
<% end %>
```
