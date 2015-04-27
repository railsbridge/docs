module StepExtensions
  module Docs
    def site_desc site_name, description
      div class: 'site-desc' do
        h2 do
          a href: "/#{site_name}" do
            text Titleizer.title_for_page(site_name)
          end
        end
        div raw(md2html description)
      end
    end
  end
end