class CreateIntegrationUsers < ActiveRecord::Migration
  def change
    create_table :integration_users do |t|

      t.timestamps
    end
  end
end
