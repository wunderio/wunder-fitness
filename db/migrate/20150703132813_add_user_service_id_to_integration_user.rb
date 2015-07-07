class AddUserServiceIdToIntegrationUser < ActiveRecord::Migration
  def change
    add_column :integration_users, :user_service_id, :string
  end
end
