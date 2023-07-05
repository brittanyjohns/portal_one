class ApplicationController < ActionController::Base
  def resubmit(item_to_save)
    puts "\n\n\nResubmitting --- \n\n\n"
    item_path = public_send("#{item_to_save.class.to_s.downcase}_url", item_to_save)
    puts "ITEM PATH: #{item_path}"
    if item_to_save.respond_to? :send_request_on_save
      item_to_save.send_request_on_save = true
    end
    respond_to do |format|
      if item_to_save.save
        format.html { redirect_to item_path }
        format.json { render :show, status: :created, location: item_to_save }
      else
        format.html { render item_path, status: :unprocessable_entity }
        format.json { render json: item_to_save.errors, status: :unprocessable_entity }
      end
    end
  end
end
