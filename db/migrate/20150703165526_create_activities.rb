class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :service_activity_id
      t.datetime :date
      t.decimal :distance
      t.references :integration_user, index: true

      t.timestamps
    end
  end
end
