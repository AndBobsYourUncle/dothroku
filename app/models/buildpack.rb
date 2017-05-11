# == Schema Information
#
# Table name: buildpacks
#
#  id   :integer          not null, primary key
#  name :string
#

class Buildpack < ApplicationRecord
  validates :name, presence: true
  has_many :files, class_name: 'Buildpack::File'

  accepts_nested_attributes_for :files

  def url_name
    name.parameterize
  end

  def compose_filename
    "buildpacks/#{url_name}/docker-compose.yml"
  end
end
