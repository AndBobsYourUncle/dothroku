class CreateServiceVariableSources < ActiveRecord::Migration[5.0]
  def change
    create_table :service_variable_sources do |t|
      t.references :service_variable

      t.string :name
      t.string :source_model
      t.string :source_attribute

    end
  end
end
