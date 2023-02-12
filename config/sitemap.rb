# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'https://www.screade.com'

# The remote host where sitemaps are be hosted
SitemapGenerator::Sitemap.sitemaps_host = 'https://s3-screade-sitemaps-production.s3.us-east-1.amazonaws.com'

# Local folder to generate sitemaps (does not apply to S3)
SitemapGenerator::Sitemap.public_path = 'public/sitemaps/'

SitemapGenerator::Sitemap.create_index = true

SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsSdkAdapter.new('s3-screade-sitemaps-production',
  access_key_id: ENV['AWS_S3_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_S3_SECRET_ACCESS_KEY'],
  region: ENV['AWS_REGION']
)

SitemapGenerator::Sitemap.create do
  NewsArticle.find_each do |news_article|
    add comments_news_article_path(news_article), lastmod: news_article.updated_at
  end
  
  Post.find_each do |post|
    add post_post_comments_path(post), lastmod: post.updated_at
  end
end
