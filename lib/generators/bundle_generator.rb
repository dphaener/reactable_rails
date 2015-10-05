module ReactableRails
  class BundleGenerator < ::Rails::Generators::NamedBase
    source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

    desc "Generate a new webpack bundle and all of it's dependencies for your application"

    def create_bundle_file
      template "bundle.rb", File.join("app/assets/bundles", class_path, "#{file_name}.js")
    end

    def create_layout_file
      template "layout.rb", File.join("app/assets/javascripts/layouts", class_path, "#{file_name}.es6")    
    end

    def create_base_stylesheet
      template "base_stylesheet.rb", File.join("app/assets/stylesheets", class_path, "#{file_name}.scss")
    end

    def create_view_stylesheet
      create_file File.join("app/assets/stylesheets/views", class_path, "_#{file_name}.scss")
    end

    def update_webpack_configs
      gsub_file("webpack.config.js", /(#{Regexp.escape("entry: {")})/i) do |match|
        "#{match}\n      #{file_name}: './app/assets/bundles/#{file_name}.js',"
      end

      gsub_file("webpack.hot.config.js", /(#{Regexp.escape("entry: {")})/i) do |match|
        <<-JS.strip_heredoc.sub(/\n$/, '')
  #{match}
        #{file_name}: [
          'webpack-dev-server/client?http://localhost:8080/assets/',
          'webpack/hot/only-dev-server',
          './app/assets/bundles/#{file_name}.js'
        ],
        JS
      end
    end

    def update_rails_asset_config
      gsub_file(File.join("config/initializers", "assets.rb"), /(#{Regexp.escape("Rails.application.config.assets.bundled_assets = %w(")})/) do |match|
        "#{match}\n  #{file_name}"
      end
    end

  protected

    def destination_path(path)
      File.join(destination_root, path)
    end

    def gsub_file(relative_destination, regexp, *args, &block)
      path = destination_path(relative_destination)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end
  end
end
