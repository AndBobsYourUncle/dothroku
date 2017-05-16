class CreateEnvironmentVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :environment_variables do |t|
      t.references  :app
      t.string      :name
      t.string      :value
    end
  end
end
