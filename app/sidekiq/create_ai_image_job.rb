class CreateAiImageJob
  include Sidekiq::Job

  def perform(word)
    word.save! if word.no_saved_images
    puts "Saved word!"
    sleep 1
  end
end
