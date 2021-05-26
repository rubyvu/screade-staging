class ChatsController < ApplicationController
  before_action :get_chat, only: [:show, :update, :destroy]
  # GET /chats
  def index
    @chats = Chat.order(updated_at: :desc)
  end
  
  # GET /chats/:id
  def show
    
  end
  
  # GET /chats/new
  def new
    
  end
  
  # POST /chats
  def create
    
  end
  
  # PUT/PATCH /chats/:id
  def update
    
  end
  
  # DELETE /chats/:id
  def destroy
    
  end
  
  private
    def get_chat
      @chat = Chat.find(params[:id])
    end
end
