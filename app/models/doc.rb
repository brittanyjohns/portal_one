# == Schema Information
#
# Table name: docs
#
#  id                :integer          not null, primary key
#  body              :text
#  doc_type          :string
#  documentable_type :string           not null
#  name              :string
#  raw_body          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  documentable_id   :integer          not null
#
# Indexes
#
#  index_doc_on_documentable  (documentable_type,documentable_id)
#
class Doc < ApplicationRecord
  has_one_attached :main_image

  # def main_image_on_disk
  #   ActiveStorage::Blob.service.path_for(main_image.key)
  # end
end
