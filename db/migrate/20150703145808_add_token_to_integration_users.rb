class AddTokenToIntegrationUsers < ActiveRecord::Migration
  def change
    add_column :integration_users, :token, :string
  end
end
