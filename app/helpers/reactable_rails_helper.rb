module ReactableRailsHelper
  def bundle_tag
    if Rails.env.development?
      "<script src='http://localhost:8080/assets/#{current_bundle}.js'></script>".html_safe
    elsif !Rails.env.test?
      "<script src='/assets/#{script_for(current_bundle.split("-").first)}'></script>".html_safe
    end
  end

  def style_tag
    if Rails.env.development?
      "<link href='http://localhost:8080/assets/#{current_bundle}.css' rel='stylesheet' type='text/css'>".html_safe
    elsif !Rails.env.test?
      "<link href='/assets/#{script_for(current_bundle.split("-").first, '.css')}' rel='stylesheet' type='text/css'>".html_safe
    end
  end

  def script_for(bundle, ext = ".js")
    path = Rails.root.join('public', 'assets')
    file_name = `ls -lt #{path}/webpack-assets-* | awk '{if(NR==1) print $9}'`.gsub("\n", "")
    file = File.read(file_name)
    json = JSON.parse(file)
    bundle = json[bundle].split(".").first
    "#{bundle}#{ext}"
  end

  def react_component(bundle, component, props = {}, options = {})
    unless Rails.env.test?
      prerender = Rails.env.production? && options[:prerender]

      if prerender
        response = Faraday.post("http://localhost:3001",
          {
            bundle: script_for(current_bundle.split("-").first),
            component: component,
            data: props,
            section: current_bundle.split("-").first
          }.to_json,
          {'Content-Type' => "application/json"}
        )
      end

      data = {
        react_bundle: bundle,
        react_class: component,
        react_props: props.is_a?(String) ? props : props.to_json
      }

      content_tag(:div, '', {data: data}) do
        response.body.html_safe if prerender
      end
    end
  end
end
