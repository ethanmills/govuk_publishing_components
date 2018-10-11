Rails.application.config.assets.precompile += %w(
  govuk_publishing_components/vendor/modernizr.js
  govuk_publishing_components/admin_scripts.js
  govuk_publishing_components/component_guide.css
  component_guide/all_components.css
  component_guide/all_components_print.css
  component_guide/no_slimmer.js
  govuk_publishing_components/search-button.png
  govuk_publishing_components/favicon-development.png
  govuk_publishing_components/favicon-integration.png
  govuk_publishing_components/favicon-example.png
  govuk_publishing_components/favicon-production.png
  govuk_publishing_components/favicon-staging.png
  govuk_publishing_components/favicon-test.png
  govuk_publishing_components/feed-icon-black.png
  govuk_publishing_components/mail-icon-x2.png
  govuk_publishing_components/mail-icon.png
  govuk_publishing_components/icon-pointer.png
  govuk_publishing_components/icon-pointer-2x.png
  govuk_publishing_components/govuk-logo.png
  govuk_publishing_components/govuk-schema-placeholder-1x1.png
  govuk_publishing_components/govuk-schema-placeholder-4x3.png
  govuk_publishing_components/govuk-schema-placeholder-16x9.png
)

# Add GOV.Frontend assets

Rails.application.config.assets.precompile += %w(
  govuk-logotype-crown.png
)

Rails.application.config.assets.paths += %W(
  #{__dir__}/../../node_modules/govuk-frontend/assets/images
  #{__dir__}/../../node_modules/govuk-frontend/assets/fonts
  #{__dir__}/../../node_modules/
)
