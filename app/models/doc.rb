# == Schema Information
#
# Table name: docs
#
#  id                :integer          not null, primary key
#  body              :text
#  current           :boolean
#  doc_type          :string
#  documentable_type :string           not null
#  name              :string
#  prompt_used       :string
#  raw_body          :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  documentable_id   :integer          not null
#
# Indexes
#
#  index_doc_on_documentable  (documentable_type,documentable_id)
#
require "open-uri"

class Doc < ApplicationRecord
  has_one_attached :main_image

  def main_image_on_disk
    ActiveStorage::Blob.service.path_for(main_image.key)
  end

  def self.current
    where(current: true).last
  end

  def mark_current!
    related_docs.update_all(current: false)
    self.update!(current: true)
  end

  def related_docs
    Doc.where(documentable_id: documentable_id, documentable_type: documentable_type)
  end

  def grab_image(url)
    begin
      downloaded_image = URI.open(url,
                                  "User-Agent" => "Ruby/#{RUBY_VERSION}",
                                  "From" => "foo@bar.invalid",
                                  "Referer" => "http://www.ruby-lang.org/")
      puts "downloaded image: #{downloaded_image.inspect}"
      sleep 2
      self.main_image.attach(io: downloaded_image, filename: "#{name}_#{id}.png")
    rescue => e
      puts "ERROR: #{e.inspect}"
      raise e
    end

    return
  end
end
