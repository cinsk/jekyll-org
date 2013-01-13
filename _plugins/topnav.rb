require 'pathname'

module Jekyll
  class TopNavLink < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @label = text.strip
    end

    def path_depth(s)
      depth = 0
      Pathname.new(s).each_filename() { |c|
        depth += 1
      }
      depth
    end

    def render(context)
      url = context['page']['url']
      #return "<!-- WARNING: page.url is missing -->" if url == nil

      # url should be something like "/index.html" or "/dir/somedoc.html"
      return "<!-- WARNING: cannot parse url(#{url}): not absolute path -->" if 
        Pathname.new(url).relative?

      label = context['page']['label']
      #return "<!-- WARNING: page.label is missing -->" if label == nil

      # depth of "/index.html" is 0, and depth of "dir/somedoc.html" is 1.
      depth = url.split("/").length - 2

      #txt = "scope: #{context.scopes}\n"
      txt = ""
      #txt += "depth: #{depth}\n"

      page = nil
      context['site']['pages'].each { |pg|
        next if pg.data['label'] == nil
        if context[@label] == pg.data['label']
          page = pg
          break
        end
      }
      if page == nil
        txt += "<! WARNING: page with label(#{@label}) is not found -->\n"
      else
        context.stack {
          # txt += "PAGE-URL: #{page.url}\n"
          # txt += "PAGE-DIR: #{page.dir}\n"
          # txt += "PAGE-base: #{page.basename}\n"
          # txt += "PAGE-DATA: #{page.data}\n"
          # txt += "PAGE-link: #{page.permalink}\n"
          # txt += "PAGE-dest: #{page.destination(".")}\n"

          # txt += "PAGE-label: #{page.data['label']}\n"
          context['label'] = context[@label]
          #url = "." + "/.." * depth + page.url
          context['url'] = page.destination("." + "/.." * depth)
          if label == context[@label]
            context['active'] = "active"
          else
            context['active'] = ""
          end
          #txt += "\nscope: #{context.scopes}\n"
          #txt += "PAGE DATA: #{context['site']['pages'][0].data}\n"
          #txt += "PAGE URL: #{context['site']['pages'][0].url}\n"
          txt += render_all(@nodelist, context)
        }
      end
      return txt

      txt += "\nscope: #{context.scopes}\n"

      txt = "TEXT: #{@text}\n"
      txt += "NODE: #{@nodelist}\n"
      txt += "PAGE CONTEXT:\n"
      context['page'].each_pair { |k, v|
        txt += "#{k} = |#{v}|\n"
      }

      txt += "SITE CONTEXT:\n"
      context['site'].each_pair { |k, v|
        txt += "#{k} = |#{v}|\n"
      }
     
      txt += "SCOPE: #{context.scopes}\n"
      
      txt += "context: #{context}\nfoo: |#{context['foo']}|\npage: |#{context['page']}|\n#{@text}\n#{@nodelist}"
      return txt
    end
  end

  class TopNavBar < Liquid::Tag
    @@navitems = nil

    def initialize(tag_name, text, tokens)
      puts "TopNavBar::initialize tag_name(#{tag_name})"
      #puts "TopNavBar::initialize tokens(#{tokens})"
      puts "TopNavBar::initialize text(#{text})"
      puts "source: #{Jekyll::DEFAULTS["source"]}"
      puts "nav-top: #{Jekyll::DEFAULTS["nav-top"]}"
      # DEFAULTS.each_pair { |k,v|
      #   puts "#{k} = |#{v}|"
      # }
      super
      @item = text.strip

      # if @@navitems == nil
      #   site = Site.new(Jekyll.configuration({}))
      #   @@navitems = site.config["nav-top"]
      #   puts "load navitems: #{@@navitems}"
      # end
    end

    def render(context)
      return super
      depth = context['page']['id'].split("/")

      context['site']['nav-top'].each { |h|
      }

      context.stack {
        context['label'] = 'new label'
        context['url'] = 'http://new url/'
      }

      puts "TopNavBar::render! text: #{@text}"
      #puts "TopNavBar::render! context: #{@context}"
      "#{@text} server: #{Jekyll::DEFAULTS["server"]}"

      #Pathname.new(
    end

  end
end

Liquid::Template.register_tag('toplink', Jekyll::TopNavLink)
Liquid::Template.register_tag('topnav', Jekyll::TopNavBar)
