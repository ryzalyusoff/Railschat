class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def index
    @messages = Message.select('DISTINCT sender_id, recipient_id, pusher_channel').where('sender_id = ? OR recipient_id = ?', current_user.id, current_user.id)
    @contacts = []    
    @messages.each do |message|
      contact = nil
      sender_id = message.sender_id
      recipient_id = message.recipient_id

      if sender_id == current_user.id
        contact = recipient_id
      else
        contact = sender_id
      end 
      @contacts.push(contact)
    end  

    @contacts = @contacts.uniq

    if params[:init]
      identifier = params[:init]
      @init_user = User.find_by_identifier(identifier)  
      
      if @init_user && @init_user != current_user
        if !@contacts.include? @init_user.id
          @contacts.push(@init_user.id)
        end  
      end
    end  

  end

  def display_messages
    @pusher_channel = params[:pusher_channel]
  
    @messages = Message.where(pusher_channel: @pusher_channel)

    curent_user_unread_messages = Message.where(pusher_channel: @pusher_channel, recipient_id: current_user.id)    
    curent_user_unread_messages.each do |unread_message|
      unread_message.mark_as_read! :for => current_user
    end  

    @unread_messages = 0
    user_messages =  Message.where(recipient_id: current_user.id)   
    user_messages.each do |user_message|
      if user_message.unread?(current_user) == true
        @unread_messages += 1
      end
    end  

    @contact = User.find(params[:contact_id])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end  
  end  

  def append_message
    sender_id = params[:append_msg__user_id]
    @sender = User.find(sender_id)
    @sender_name = @sender.first_name
    @text = params[:append_msg__text]

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end  

  def show
  end

  def new
    @message = Message.new
  end

  def edit
  end

  def create
    sender_id = current_user.id
    recipient_id = params[:message][:recipient_id]

    pusher_channel = ""
    if recipient_id.to_i < sender_id  
      pusher_channel = "#{recipient_id}-#{sender_id}"
    else
      pusher_channel = "#{sender_id}-#{recipient_id}"
    end  

    @message = Message.new(message_params.merge(sender_id: sender_id, recipient_id: recipient_id, pusher_channel: pusher_channel))

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json do

          Pusher['private-'+recipient_id.to_s].trigger('new_message', {data_id: @message.id, text: @message.text, sender_id: sender_id, recipient_id: recipient_id, pusher_channel: pusher_channel})

          render :show, status: :created, location: @message 
        
        end
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  private
    def set_message
      @message = Message.find(params[:id])
    end

    def message_params
      params.require(:message).permit(:text, :recipient_id, :sender_id, :pusher_channel)
    end
end
