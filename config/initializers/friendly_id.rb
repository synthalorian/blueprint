FriendlyId.defaults do |config|
  config.base = :slug
  config.use :reserved
  config.reserved_words = %w[new edit index search share api v1 admin users blueprints about]
end
