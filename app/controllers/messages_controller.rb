class MessagesController < ApplicationController
  def index
  	@message = Message.new
  	render layout: false
  end

  def new
		@message = Message.new
	end

  def create
  	@message = Message.create(message_params)
  	if @message.save
  		ActionCable.server.broadcast 'room_channel',
  		                             content: @message.content,
  		                             sname: params[:message][:sname]
  	end
  end

  def message_params
  	params.require(:message).permit(
  		:content, 
  		:sender_id, 
  		:receiver_id)
  end
end
