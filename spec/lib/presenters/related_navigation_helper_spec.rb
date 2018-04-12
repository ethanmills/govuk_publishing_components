require "spec_helper"

RSpec.describe GovukPublishingComponents::Presenters::RelatedNavigationHelper do
  def payload_for(schema, content_item)
    example = GovukSchemas::RandomExample.for_schema(frontend_schema: schema) do |payload|
      payload.merge(content_item)
    end

    described_class.new(example).related_navigation
  end

  describe "#related-navigation-sidebar" do
    it "can handle randomly generated content" do
      expect { payload_for("placeholder", {}) }.to_not raise_error
    end

    it "returns empty arrays if there are no related navigation sidebar links" do
      nothing = payload_for("placeholder",
        "details" => {
          "external_related_links" => []
        },
        "links" => {
        })

      expected = {
        "related_items" => [],
        "related_guides" => [],
        "collections" => [],
        "topics" => [],
        "policies" => [],
        "topical_events" => [],
        "world_locations" => [],
        "statistical_data_sets" => [],
        "related_contacts" => [],
        "related_external_links" => [],
      }

      expect(nothing).to eq(expected)
    end

    it "extracts and returns the appropriate related links" do
      payload = payload_for("speech",
        "details" => {
          "body" => "body",
          "government" => {
            "title" => "government",
            "slug" => "government",
            "current" => true
            },
          "political" => true,
          "delivered_on" => "2017-09-22T14:30:00+01:00"
        },
        "links" => {
          "ordered_related_items" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-item",
              "title" => "related item",
            }
          ],
          "document_collections" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-collection",
              "title" => "related collection",
              "document_type" => "document_collection"
            }
          ],
          "topics" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-topic",
              "title" => "related topic",
              "document_type" => "topic"
            }
          ],
          "topical_events" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-topical-event",
              "title" => "related topical event",
              "document_type" => "topical_event"
            }
          ],
          "organisations" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-organisation",
              "title" => "related organisation",
              "document_type" => "organisation"
            }
          ],
          "mainstream_browse_pages" => [
            {
              "content_id" => "06ddefca-c44b-4b7b-b0de-226d15129a29",
              "locale" => "en",
              "base_path" => "/browse/something",
              "title" => "A mainstream browse page",
              "document_type" => "mainstream_browse_page"
            }
          ],
          "related_policies" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "locale" => "en",
              "base_path" => "/related-policy",
              "title" => "related policy",
              "document_type" => "policy"
            }
          ],
          "world_locations" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "title" => "World, ~ (@Location)",
              "locale" => "en"
            }
          ],
        })

      expected = {
        "related_items" => [{ path: "/related-item", text: "related item" }],
        "related_guides" => [],
        "collections" => [{ path: "/related-collection", text: "related collection" }],
        "topics" => [{ path: "/browse/something", text: "A mainstream browse page" }, { path: "/related-topic", text: "related topic" }],
        "policies" => [{ path: "/related-policy", text: "related policy" }],
        "related_contacts" => [],
        "related_external_links" => [],
        "topical_events" => [{ path: "/related-topical-event", text: "related topical event" }],
        "world_locations" => [{ path: "/world/world-location/news", text: "World, ~ (@Location)" }],
        "statistical_data_sets" => [],
      }

      expect(payload).to eql(expected)
    end

    it "returns statistical data sets" do
      payload = payload_for("publication",
        "details" => {
          "body" => "body",
          "government" => {
            "title" => "government",
            "slug" => "government",
            "current" => true
          },
          "political" => false,
          "documents" => [],
          "first_public_at" => "2016-01-01T19:00:00Z",
        },
        "links" => {
          "related_statistical_data_sets" => [
            {
              "content_id" => "32c1b93d-2553-47c9-bc3c-fc5b513ecc32",
              "title" => "related statistical data set",
              "base_path" => "/related-statistical-data-set",
              "document_type" => "statistical_data_set",
              "locale" => "en"
            }
          ],
        })

      expect(payload["statistical_data_sets"]).to eql(
        [{ path: "/related-statistical-data-set", text: "related statistical data set" }]
      )
    end

    it "deduplicates topics for mainstream content" do
      payload = payload_for("answer",
        "details" => {
          "external_related_links" => []
        },
        "links" => {
          "mainstream_browse_pages" => [
            {
              "content_id" => "fecdc8c8-4006-4f8e-95d5-fe40ca49c7a8",
              "locale" => "en",
              "title" => "Self Assessment",
              "base_path" => "/browse/tax/self-assessment",
              "document_type" => "mainstream_browse_page",
            }
          ],
          "ordered_related_items" => [
            {
              "content_id" => "f29ca4a8-8ed9-4b0f-bb6a-11e373095dee",
              "locale" => "en",
              "title" => "Self Assessment tax returns",
              "base_path" => "/self-assessment-tax-returns",
              "document_type" => "guide",
            }
          ],
          "topics" => [
            {
              "content_id" => "7beb97b6-75c9-4aa7-86be-a733ab3a21aa",
              "locale" => "en",
              "base_path" => "/topic/personal-tax/self-assessment",
              "title" => "Self Assessment",
              "document_type" => "topic",
            }
          ],
        })

      expect(payload["topics"]).to eql(
        [{ text: "Self Assessment", path: "/browse/tax/self-assessment" }]
      )
    end

    it "handles ordered related items that aren't tagged to a mainstream browse page" do
      example = GovukSchemas::Example.find("guide", example_name: "single-page-guide")
      payload = described_class.new(example).related_navigation
      expected = [
        { text: "Travel abroad", path: "/browse/abroad/travel-abroad" },
        { text: "Arriving in the UK", path: "/browse/visas-immigration/arriving-in-the-uk" },
        { text: "Pets", path: "/topic/animal-welfare/pets" },
      ]
      expect(payload["topics"]).to eql(expected)
    end

    it "returns an Elsewhere on the web section for external related links" do
      payload = payload_for("placeholder",
        "details" => {
          "external_related_links" => [
            {
              "title" => "external-link",
              "url" => "https://external"
            }
          ]
        },)

      expect(payload["related_external_links"]).to eql([
        {
          path: "https://external",
          text: "external-link",
          rel: "external",
        }
      ])
    end

    it "returns an 'Other contacts' section" do
      payload = payload_for("contact",
        "links" => {
          "related" => [
            {
              "content_id" => "d636b991-a239-497b-be51-1617b0299cf5",
              "locale" => "en",
              "base_path" => "/foo",
              "document_type" => "contact",
              "title" => "Foo"
            }
          ]
        },)

      expect(payload["related_contacts"]).to eql(
        [{ path: "/foo", text: "Foo" }]
      )
    end
  end
end
