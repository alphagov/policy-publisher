class UnpublishStalePlaceholders < ActiveRecord::Migration
  def change
    stale_placeholders_hash = {
      "12a4eb7a-6037-4cc0-aa58-0a4f2fbc5e7f" => "/government/policies/carers-health",
      "e0deb0ec-e9fc-4308-b8c0-eba4dc92aa83" => "/government/policies/museums-and-galleries",
      "f656d065-43aa-4ab0-91f7-a6809ce5b68b" => "/government/policies/special-educational-needs-and-disability-send",
    }

    stale_placeholders_hash.each do |placeholder_content_id, base_path_for_redirect|
      Services.publishing_api.unpublish(
        placeholder_content_id,
        type: "redirect",
        alternative_path: base_path_for_redirect,
        discard_drafts: true,
      )
    end
  end
end
