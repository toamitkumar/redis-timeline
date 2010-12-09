#http://techblog.floorplanner.com/2010/01/29/two-practical-examples-of-rack-middleware-in-rails/
#module Rack
  class MaintenanceMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      # check if the maintenance page is in place
      if(File.exists?("#{Rails.root}/public/maintenance.html"))
        Rails.logger.debug env.inspect
        [301, {"Location" => "http://#{env['HTTP_HOST']}/maintenance.html"}, 'Redirecting to maintenance page..']
      else
        @app.call(env)
      end
    end
  end
#end