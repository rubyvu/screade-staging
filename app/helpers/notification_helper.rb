module NotificationHelper
  def notification_link_path(object)
      case object.source_type
      when 'Event'
        link = events_path(date: object.source.start_date)
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
      when 'UserImage'
        link = images_user_image_path(username: object.sender.username)
      when 'UserVideo'
        link = videos_user_video_path(username: object.sender.username)
      else
        link = ''
      end
  end
end
