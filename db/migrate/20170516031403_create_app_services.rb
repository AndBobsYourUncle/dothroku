class CreateAppServices < ActiveRecord::Migration[5.0]
  def change
    create_table :app_services do |t|
      t.references :app
      t.references :service
    end
  end
end
