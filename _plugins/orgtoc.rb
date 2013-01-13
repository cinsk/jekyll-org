require 'pathname'

module Jekyll
  class OrgArticles < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @layout = text.strip
      @layout = "org" if @layout == nil or @layout == ""
    end

    def render(context)
      txt = "<pre>\n"

      context['site'].each_pair { |k, v|
        txt += "site[#{k}] = |#{v}|\n"
      }
      context['page'].each_pair { |k, v|
        txt += "site[#{k}] = |#{v}|\n"
      }
      txt += "</pre>"

      txt += "CWD: #{Dir.pwd}\n"

      # Dir.chdir(File.join(context['site']['source'],
      #                context['site']['orgsource'])) {
      #   Dir.glob("*.html") { |fname|
      #     dst = File.join(context['site']['orgsource'], fname)
      #     txt += "ORG: #{dst}\n"
      #   }
      # }

      # In the Jekyll 0.12.0, I cannot find a way to locate Page
      # objects from context['site']['pages'] which are generated from
      # .org files.
      #
      # First, I thought that Page.dir has the relative pathname from
      # context['site']['destination'], but it is not.  It seems that
      # Page.dir is always "/" no matter where the .html is from.
      #
      # Thus, to find the exact Page object, I'll enumerate all Page objects
      # where Page.data['layout'] == "org".

      txt += "ORGPAGES: #{context['site']['orgpages']}\n"

      if context['site']['orgpages'] == nil
        context['site']['orgpages'] = []
        context['site']['pages'].each { |page|
          #txt += "Compare: #{page.data['layout']}\n"
          if page.data['layout'] == @layout
            #txt += "Found: #{page}\n"
            pg = page.data.clone
            pg['url'] = File.join(context['site']['orgsource'],
                             "#{page.basename}.html")
            context['site']['orgpages'].push pg
          end
        }
      end

      txt += "DIR: #{context['site']['pages'][4].dir}\n"
      #txt += "#{context['site']['pages'][0].site}\n"
      txt += "NAME: #{context['site']['pages'][4].name}\n"
      txt += "EXT: #{context['site']['pages'][4].ext}\n"
      txt += "BASENAME: #{context['site']['pages'][4].basename}\n"
      #txt += "DATA: #{context['site']['pages'][0].data}\n"
      #txt += "CONTENT: #{context['site']['pages'][0].content}\n"
      #txt += "OUTPUT: #{context['site']['pages'][0].output}\n"

      txt += "LAYOUT: #{@layout}\n"
      txt += "ORGPAGES: #{context['site']['orgpages']}\n"
      super context
      #txt
    end
  end

  class OrgToc < Liquid::Block
    def initialize(tag_name, text, tokens)
      super
      @label = text.strip
    end

    def render(context)
      contents = context['page']['content']

      thetoc = []

      contents.each_line { |line|
        m = /^ *<li> *<a +href *= *"#sec-([0-9]+)" *>(.*?)<\/a>/.match line
        if m
          thetoc.push( { "id" => "#sec-#{m[1]}",
                         "title" => m[2] })
        end

        break if / *<div +id *= *"outline-container-[0-9]+\"/.match line
      }

      context['page']['orgtoc'] = thetoc

      super
      #"ORGTOC: #{thetoc}"
    end
  end
end

Liquid::Template.register_tag('orgtoc', Jekyll::OrgToc)
Liquid::Template.register_tag('orgarticles', Jekyll::OrgArticles)
