class CreateServiceVariables < ActiveRecord::Migration[5.0]
  def change
    create_table :service_variables do |t|
      t.references  :service
      t.string      :name
      t.string      :build_type
      t.string      :value
    end
  end
end
