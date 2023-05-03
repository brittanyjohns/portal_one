class Doc < ApplicationRecord
  has_one_attached :main_image

  def main_image_on_disk
    ActiveStorage::Blob.service.path_for(main_image.key)
  end
end
