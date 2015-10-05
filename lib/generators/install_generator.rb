module ReactableRails
  class InstallGenerator < Rails::Generators::Base
    source_root Fil.expand_path("../../templates", __FILE__)

    desc "Creates all the files necessary to start using this gem"
    
    def copy_webpack_configs
      template "webpack.rb", "./webpack.config.js"
      template "webpack_hot.rb", "./webpack.hot.config.js"
    end

    def copy_package_json
      template "package_json.rb", "./package.json" 
    end

    def run_npm_install
      run "npm install" 
    end
  end
end
