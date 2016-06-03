class UnpublishRedundantPolicy < ActiveRecord::Migration
  def up
    Services.publishing_api.unpublish(
      "f656d065-43aa-4ab0-91f7-a6809ce5b68b",
      type: "gone",
      discard_drafts: true,
    )
  end

  def down
  end
end
