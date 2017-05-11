# == Schema Information
#
# Table name: buildpack_files
#
#  buildpack_id :integer
#  destination  :string
#  id           :integer          not null, primary key
#  source       :string
#

class Buildpack::File < ApplicationRecord
  belongs_to :buildpack, optional: true

  def full_source
    "buildpacks/#{buildpack.url_name}#{source}"
  end
end
