module NotificationHelper
  def notification_link_path(object)
    case object.source_type
    when 'BreakingNews'
      if object.source&.post&.present?
        link = post_post_comments_path(object.source.post)
      else
        link = root_path
      end
    when 'Event'
      link = events_path(date: object.source.start_date)
    when 'ChatMembership'
      link = chats_path()
    when 'ChatMessage'
      link = chats_path()
    when 'ChatAudioRoom'
      link = chats_path()
    when 'ChatVideoRoom'
      link = chats_path()
    when 'Comment'
      if object.source.source_type == 'NewsArticle'
        if object.source.comment_id.nil?
          link = comments_news_article_path(object.source.source)
        else
          link = news_article_comment_reply_comments_path(object.source.source, object.source.comment_id)
        end
      elsif object.source.source_type == 'Post'
        link = post_post_comments_path(object.source.source)
      else
        link = ''
      end
    when 'Post'
      link = post_post_comments_path(object.source)
    when 'SquadRequest'
      link = squad_requests_path
    when 'Stream'
      link = stream_path(access_token: object.source.access_token)
    when 'UserImage'
      link = images_user_image_path(username: object.sender.username)
    when 'UserVideo'
      link = videos_user_video_path(username: object.sender.username)
    else
      link = ''
    end
  end
  
  def notification_absolute_link_path(object)
    case object.source_type
    when 'BreakingNews'
      link = root_url
    when 'Event'
      link = events_url(date: object.source.start_date)
    when 'ChatMembership'
      link = chats_url()
    when 'ChatMessage'
      link = chats_url()
    when 'ChatAudioRoom'
      link = chats_url()
    when 'ChatVideoRoom'
      link = chats_url()
    when 'Comment'
      if object.source.source_type == 'NewsArticle'
        if object.source.comment_id.nil?
          link = comments_news_article_url(object.source.source)
        else
          link = news_article_comment_reply_comments_url(object.source.source, object.source.comment_id)
        end
      elsif object.source.source_type == 'Post'
        link = post_post_comments_url(object.source.source)
      else
        link = ''
      end
    when 'Post'
      link = post_post_comments_url(object.source)
    when 'SquadRequest'
      link = squad_requests_url
    when 'Stream'
      link = stream_url(access_token: object.source.access_token)
    when 'UserImage'
      link = images_user_image_url(username: object.sender.username)
    when 'UserVideo'
      link = videos_user_video_url(username: object.sender.username)
    else
      link = ''
    end
  end
end
