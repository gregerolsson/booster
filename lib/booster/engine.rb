module Booster
  class Engine < Rails::Engine
    initializer 'sprockets.booster', :after => 'sprockets.environment' do |app|
      next unless app.assets
      app.assets.register_engine('.booster', Tilt)
    end
  end
end