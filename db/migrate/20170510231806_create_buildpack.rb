class CreateBuildpack < ActiveRecord::Migration[5.0]
  def change
    create_table :buildpacks do |t|
      t.string    :name
    end
  end
end
