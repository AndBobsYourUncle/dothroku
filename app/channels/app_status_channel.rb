class AppStatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from "app_status_channel-#{params['image_name']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
