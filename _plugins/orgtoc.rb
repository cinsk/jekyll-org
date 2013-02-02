require 'pathname'
require 'set'

module Jekyll
  class Articles < Liquid::Block
    @@layouts = nil

    def initialize(tag_name, params, tokens)
      p = params.split(',').map(&:strip)

      @v_layout = @v_id = @v_url = @v_title = @v_lead = @v_lang = nil

      @v_layout = p[0] if p.size > 0
      @v_id = p[1] if p.size > 1
      @v_title = p[2] if p.size > 2
      @v_lead = p[3] if p.size > 3
      @v_url = p[4] if p.size > 4
      @v_lang = p[5] if p.size > 5

      # @articles holds the list of id of the pages that has the layout
      # specified in @layouts.
      @articles = []
      super
    end

    def init_layouts(context)
      if @@layouts == nil
        @layouts = Set.new(context['site'][@v_layout])
      end
    end

    def init_articles(context)
      # Collect all article IDs.
      articles = Set.new()
      context['site']['pages'].each { |pg|
        if @layouts.include? pg.data['layout']
          if pg.data['id'] == nil
            STDERR.write("warning: no 'id' in the page #{pg.url}\n");
            next
          end

          if pg.data['title'] == nil
            STDERR.write("warning: no 'title' in the page #{pg.url}\n");
            next
          end

          articles << pg.data['id']
        end
      }
      @articles = articles.to_a
    end

    def render(context)
      ::Jekyll.update_tagmap(context)
      ::Jekyll.update_localemap(context)

      init_layouts(context)
      init_articles(context)

      lang = context['page']['lang']
      lang = LANG_DEFAULT if lang == nil

      txt = "<!-- articles: #{@articles} -->\n"

      @articles.each { |id|
        pgtag = ::Jekyll.tagmap[id]

        txt += "<!-- id(#{id}) lang(#{lang}) -->\n"

        page, url = ::Jekyll.site_url_with_page(id, lang, context)

        #txt += "<!-- page(#{page}) url(#{url}) -->\n"

        if page != nil && url != nil
          context.stack {
            context[@v_id] = id if @v_id
            context[@v_url] = url if @v_url
            context[@v_title] = page.data['title'] if @v_title
            context[@v_lead] = page.data['lead'] if @v_lead

            l = page.data['lang']
            l = LANG_DEFAULT if l == nil

            if @v_lang
              if l == lang
                context[@v_lang] = ""
              else
                context[@v_lang] = ::Jekyll.localemap[l]
                context[@v_lang] = l if context[@v_lang] == nil
              end
            end

            txt += render_all(@nodelist, context)
          }
        end
      }

      txt
    end

  end

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
    def initialize(tag_name, params, tokens)
      p = params.split(',').map(&:strip)

      @v_id = @v_section = nil

      @v_id = p[0] if p.size > 0
      @v_section = p[1] if p.size > 1

      super
    end

    def render(context)
      contents = context['page']['content']

      thetoc = []

      contents.each_line { |line|
        m = /^ *<li> *<a +href *= *"#sec-([0-9]+)" *>(.*?)<\/a>/.match line
        if m
          thetoc << { :id => "#sec-#{m[1]}",
            :section => m[2] }
        end

        break if / *<div +id *= *"outline-container-[0-9]+\"/.match line
      }

      txt = ""

      thetoc.each { |c|
        context.stack {
          context[@v_id] = c[:id] if @v_id != nil
          context[@v_section] = c[:section] if @v_section != nil

          txt += render_all(@nodelist, context)
        }
      }
      
      #context['page']['orgtoc'] = thetoc
      #"ORGTOC: #{thetoc}"

      txt
    end
  end
end

Liquid::Template.register_tag('orgtoc', Jekyll::OrgToc)
Liquid::Template.register_tag('orgarticles', Jekyll::OrgArticles)
Liquid::Template.register_tag('articles', Jekyll::Articles)

