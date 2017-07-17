# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://#{ENV['APP_DOMAIN']}"
# pick a place safe to write the files
SitemapGenerator::Sitemap.public_path = 'tmp/'
# store on S3 using Fog (pass in configuration values as shown above if needed)
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
# inform the map cross-linking where to find the other maps
SitemapGenerator::Sitemap.sitemaps_host = "http://s3-eu-west-1.amazonaws.com/#{ENV['FOG_DIRECTORY']}/"
# pick a namespace within your bucket to organize your maps
# SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

SitemapGenerator::Sitemap.create do
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host

  add '/advisor', priority: 1, changefreq: 'always'
  add '/signup', priority: 1, changefreq: 'daily'
  add '/about', priority: 0.9
  add '/contact', priority: 0.7
  add '/login'
  add '/welcome'
  add '/dashboard'
  add '/terms'
  add '/privacy'

  User.find_each do |user|
    add user_path(id: user.id), lastmod: user.updated_at
  end

  Offer.where.not(status: :archived).find_each do |offer|
    add offer_path(id: offer.id), lastmod: offer.updated_at
  end
end
