class CreateBuildpackFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :buildpack_files do |t|
      t.references  :buildpack
      t.string      :source
      t.string      :destination
      t.boolean     :env_file
      t.string      :env_template
    end
  end
end
