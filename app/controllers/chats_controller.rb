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
    squad_receivers_sql = User.joins(:squad_requests_as_receiver).where(squad_requests_as_receiver: { requestor: current_user }).where.not(squad_requests_as_receiver: { accepted_at: nil }).to_sql
    squad_requestors_sql = User.joins(:squad_requests_as_requestor).where(squad_requests_as_requestor: { receiver: current_user }).where.not(squad_requests_as_requestor: { accepted_at: nil }).to_sql
    @squad_members = User.from("(#{squad_receivers_sql} UNION #{squad_requestors_sql}) AS users")
    
    respond_to do |format|
      format.js { render 'new', layout: false }
    end
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
