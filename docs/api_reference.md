## LevelUp API reference

### Navigation
[README](../README.md)

### API
- [Verifications that are called before all API endpoints](api/v1/api.md)

### Authentication
- [Sign In](api/v1/authentication/sign_in.md)
- [Sign Up](api/v1/authentication/sign_up.md)
- [Sign Out](api/v1/authentication/sign_out.md)

### Categories
- [List of all News Categories](api/v1/news_categories/index.md)
- [List of NewsArticles for each Category](api/v1/news_categories/news.md)

### Chat
- [List of all Chats](api/v1/chats/index.md)
- [View Chat](api/v1/chats/show.md)
- [Create new Chat](api/v1/chats/create.md)
- [Update Chat](api/v1/chats/update.md)
- [Add/Remove Chat Members](api/v1/chats/update_members.md)
- [List of all ChatMembers in the Chat](api/v1/chat_memberships/index.md)
- [List of all Users that can be added/removed from the Chat](api/v1/chat_memberships/chat_users.md)
- [Update ChatMember role](api/v1/chat_memberships/update.md)
- [Remove ChatMember from the Chat](api/v1/chat_memberships/destroy.md)
- [List of all ChatMessages in the Chat](api/v1/chat_messages/index.md)
- [Create new ChatMessage](api/v1/chat_messages/create.md)
- [Create new ChatAudioRoom](api/v1/chat_audio_rooms/create.md)
- [Create new ChatVideoRoom](api/v1/chat_video_rooms/create.md)

### Comments
- [Show Article Comment](api/v1/comments/show.md)
- [List of Article Comments](api/v1/news_articles/index_comment.md)
- [List of ReplyComments for Comment](api/v1/comments/reply_comments.md)
- [Add Comment to Article](api/v1/news_articles/create_comment.md)
- [Lit Comment](api/v1/comments/lit.md)
- [Unlit Comment](api/v1/comments/unlit.md)

### Contact Us Request
- [Create new request](api/v1/contact_us_requests/create.md)

### Countries
- [Get Countries list](api/v1/countries/index.md)

### Current User
- [Get current user Info](api/v1/current_user/info.md)
- [Update current user](api/v1/current_user/update.md)
- [Resend email confirmation to current user](api/v1/current_user/resend_email_confirmation.md)
- [Change password](api/v1/current_user/change_password.md)
- [Update Device push token](api/v1/current_user/device_push_token.md)

### Events
- [View all Events by Date](api/v1/events/index.md)
- [Create new Event](api/v1/events/create.md)
- [Update Event](api/v1/events/update.md)
- [Delete Event](api/v1/events/destroy.md)

### Forgot password
- [Get security question for User](api/v1/forgot_password/security_question.md)
- [Get new password instructions](api/v1/forgot_password/create.md)

### Groups
- [Show Tree of NewsCategories and Topics](api/v1/groups/index.md)
- [Add Comments list for Groups(Subscriptions)](api/v1/groups/comments.md)
- [Subscribe User to Group](api/v1/groups/subscribe.md)
- [Unsubscribe User from Group](api/v1/groups/unsubscribe.md)

### Home
- [Get News list](api/v1/home/news.md)
- [Get BreakingNews ](api/v1/home/breaking_news.md)
- [Get Trends list](api/v1/home/trends.md)

### Languages
- [Get Languages list](api/v1/languages/index.md)

### News Articles
- [Get News Article](api/v1/news_articles/show.md)
- [Lit Article](api/v1/news_articles/lit.md)
- [Unlit Article](api/v1/news_articles/unlit.md)
- [View Article](api/v1/news_articles/view.md)
- [Subscribe NewsArticle to Topic](api/v1/news_articles/topic_subscription.md)
- [Get NewsArticle Groups with Subscriptions](api/v1/news_articles/groups.md)

### Notifications
- [Get all user Notifications](api/v1/notifications/index.md)
- [Get Notification](api/v1/notifications/show.md)
- [Mark all User Notification as viewed](api/v1/notifications/view_all.md)
- [Mark Notification as viewed](api/v1/notifications/update.md)

### Squad Search
- [Global Search](api/v1/searches/index.md)

### Squad Requst
- [Accept request](api/v1/squad_requests/accept.md)
- [Create new request](api/v1/squad_requests/create.md)
- [Decline request](api/v1/squad_requests/decline.md)
- [Get requsts list](api/v1/squad_requests/index.md)
- [Get Squad Members by Username](api/v1/squad_members/index.md)

### Post
- [View all Posts](api/v1/posts/index.md)
- [View Post](api/v1/posts/show.md)
- [List of Groups for new Post](api/v1/post_groups/index.md)
- [Create new Post](api/v1/posts/create.md)
- [Update Post](api/v1/posts/update.md)
- [Delete Post](api/v1/posts/destroy.md)
- [Lit Post](api/v1/post_lits/create.md)
- [Unlit Post](api/v1/post_lits/destroy.md)
- [Post Comments List](api/v1/post_comments/index.md)
- [Create Post Comments](api/v1/post_comments/create.md)

### Stream
- [View all Streams](api/v1/streams/index.md)
- [View Stream](api/v1/streams/show.md)
- [Create new Stream](api/v1/streams/create.md)
- [Update Stream](api/v1/streams/update.md)
- [Delete Stream](api/v1/streams/destroy.md)
- [Complete Stream](api/v1/streams/complete.md)
- [Update in-progress status date in Stream](api/v1/streams/in_progress.md)
- [Lit Stream](api/v1/stream_lits/create.md)
- [Unlit Stream](api/v1/stream_lits/destroy.md)
- [Stream Comments List](api/v1/stream_comments/index.md)
- [Create Stream Comment](api/v1/stream_comments/create.md)

### Topic
- [Create new Topic](api/v1/topics/create.md)
- [Show Topic](api/v1/topics/show.md)

### User Assets
- [Get Images](api/v1/user_assets/images.md)
- [Get Videos](api/v1/user_assets/videos.md)
- [Update Image](api/v1/user_images/update.md)
- [Update Video](api/v1/user_videos/update.md)
- [Destroy Images](api/v1/user_assets/destroy_images.md)
- [Destroy Videos](api/v1/user_assets/destroy_videos.md)
- [Get URL for File upload](api/v1/user_assets/upload_url.md)
- [Confirm File upload to URL](api/v1/user_assets/confirmation.md)

### User Security Question
- [Get User Security Questions list](api/v1/user_security_questions/index.md)

### User Location
- [Get User and UserSquadMembers Locations](api/v1/user_locations/index.md)
- [Create or Update UserLocation](api/v1/user_locations/create.md)

### User Settings
- [Get user Settings](api/v1/settings/index.md)
- [Update user Settings](api/v1/settings/update.md)

### User
- [Get User Profile](api/v1/users/show.md)
