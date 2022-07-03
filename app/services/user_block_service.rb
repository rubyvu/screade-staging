class UserBlockService
  def initialize(user_block)
    @user_block = user_block
  end
  
  def remove_from_squad
    SquadRequest.where(receiver: @user_block.blocker, requestor: @user_block.blocked).update_all(accepted_at: nil, declined_at: DateTime.current)
    SquadRequest.where(receiver: @user_block.blocked, requestor: @user_block.blocker).update_all(accepted_at: nil, declined_at: DateTime.current)
  end
  
  def remove_one_on_one_chats
    dm_chat_ids = Chat.joins(:chat_memberships).group('chats.id').having('COUNT(chat_memberships.id) = 2').ids
    blocker_chats_ids = ChatMembership.where(user: @user_block.blocker, chat_id: dm_chat_ids).pluck(:chat_id)
    blocked_chats_ids = ChatMembership.where(user: @user_block.blocked, chat_id: dm_chat_ids).pluck(:chat_id)
    one_on_one_chats_ids = blocker_chats_ids.intersection(blocked_chats_ids)
    Chat.where(id: one_on_one_chats_ids).destroy_all
  end
end
