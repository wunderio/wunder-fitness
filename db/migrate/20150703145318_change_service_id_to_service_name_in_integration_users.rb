class ChangeServiceIdToServiceNameInIntegrationUsers < ActiveRecord::Migration
  def change
    rename_column :integration_users, :service_id, :service_name
  end
end
