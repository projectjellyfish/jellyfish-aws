module JellyfishAws
  class Engine < ::Rails::Engine
    isolate_namespace JellyfishAws

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end
    end

    # Initializer to combine this engines static assets with the static assets of the hosting site.
    initializer 'static assets' do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer 'jellyfish_aws.load_default_settings', :before => :load_config_initializers do
      begin
        if Setting.table_exists?
          Dir[File.expand_path '../../../app/models/setting/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        #ignored
        nil
      end
    end

    initializer 'jellyfish_aws.load_product_types', :before => :load_config_initializers do
      begin
        if ProductType.table_exists?
          Dir[File.expand_path '../../../app/models/product_type/*.rb', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        #ignored
        nil
      end
    end

    initializer 'jellyfish_aws.load_registered_providers', :before => :load_config_initializers do
      begin
        if RegisteredProvider.table_exists?
          Dir[File.expand_path '../../../app/models/registered_provider/*', __FILE__].each do |file|
            require_dependency file
          end
        end
      rescue
        #ignored
        nil
      end
    end

    initializer 'jellyfish_aws.register_extension', :after => :finisher_hook do |app|
      Jellyfish::Extension.register 'jellyfish-aws' do
        requires_jellyfish '>= 4.0.0'

        load_scripts 'extensions/aws/components/forms/fields.config.js',
          'extensions/aws/resources/aws-data.factory.js'

        mount_extension JellyfishAws::Engine, at: :aws
      end
    end

  end
end
