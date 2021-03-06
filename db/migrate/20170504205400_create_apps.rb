class CreateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :apps do |t|
      t.string      :name
      t.string      :github_auth_token
      t.string      :github_repo
      t.string      :github_branch
      t.boolean     :deploying
      t.references  :buildpack
      t.string      :hostname
      t.string      :ssl_email

      t.timestamps
    end
  end
end
