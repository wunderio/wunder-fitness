class AddServiceIdToIntegrationUsers < ActiveRecord::Migration
  def change
    add_column :integration_users, :service_id, :string
  end
end
