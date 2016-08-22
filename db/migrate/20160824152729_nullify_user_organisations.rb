class NullifyUserOrganisations < ActiveRecord::Migration
  def up
    User.where(organisation_content_id: "").update_all(organisation_content_id: nil)
  end
end
