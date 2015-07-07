class AddUserToIntegrationUsers < ActiveRecord::Migration
  def change
    add_reference :integration_users, :user
  end
end
