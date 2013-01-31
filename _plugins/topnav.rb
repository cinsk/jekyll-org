require 'pathname'

module Jekyll
  @@_pagemap = {}
  LANG_DEFAULT = "default"

  def self.tagmap
    @@_pagemap
  end

  def self.update_tagmap(context)
    result = "<!-- update_tagmap -->"

    if @@_pagemap.empty?
      context['site']['pages'].each { |pg|
        if pg.data['label']
          if ::Jekyll.tagmap.has_key?(pg.data['label'])
            tag = ::Jekyll.tagmap[pg.data['label']]
          else
            tag = PageTag.new()
            ::Jekyll.tagmap[pg.data['label']] = tag
          end

          lang = LANG_DEFAULT
          lang = pg.data['lang'] if pg.data['lang']

          if tag[lang]
            result += "<!-- WARNING: duplicated label:lang pairs\n"
            result += "     previous name: #{tag[lang].name}\n"
            result += "     current name: #{pg.name} -->\n"
          end

          tag[lang] = pg
        end
      }

      result += "<!--"
      ::Jekyll.tagmap.each_pair { |k, v|
        result += "#{k} = #{v}\n"
      }
      result += "-->\n"
    end
    result
  end

  def self.site_url(label, locale, context, exact = false)
    ::Jekyll.update_tagmap(context)
    # TODO: return the url of the page with LABEL in LOCALE if possible.

    # url of the current page: context['page']['url']
    # url of the Page object: page.destination(PREFIX)
    #context['site']

    base = Pathname.new(context['page']['url']).dirname

    ptag = ::Jekyll.tagmap[label]
    
    if ptag[locale]
      page = ptag[locale]
    else
      return nil if exact && (locale != nil)
      page = ptag[LANG_DEFAULT]
    end

    Pathname.new(page.destination("")).relative_path_from(base).to_s
  end

  class PageTag
    def initialize(inithash = {})
      @data = inithash.clone
    end

    def method_missing(name, *args, &block)
      @data.send(name, *args, &block)
    end
  end


  class LinguaLink < Liquid::Block
    def initialize(tag_name, params, tokens)
      @linguas = []
      @lang = {}

      p = params.split(',').map(&:strip)

      @v_label = @v_url = @v_self = nil

      @v_label = p[0] if p.size > 0
      @v_url = p[1] if p.size > 1
      @v_self = p[2] if p.size > 2

      super
    end

    def render(context)
      txt = ""
      ::Jekyll.update_tagmap(context)

      label = context['page']['label']
      
      txt += "<!-- fatal: label is not found in the current page -->\n" if 
        label == nil

      context['site']['linguas'].each { |h|
        url = ::Jekyll.site_url(label, h[:tag], context, true);

        if url
          @linguas << { :label => h[:label], :url => url, :tag => h[:tag] }
        end
      }

      @linguas.each { |v|
        context.stack {
          @lang = v
          context[@v_label] = v[:label] if @v_label != nil
          context[@v_url] = v[:url] if @v_url != nil

          if @v_self
            if context['page']['lang'] == v[:tag]
              context[@v_self] = true
            else
              context[@v_self] = false
            end
          end

          txt += render_all(@nodelist, context)
        }
      }
      txt
    end

    def unknown_tag(name, params, tokens)
      txt = ""
      txt += "unknown(#{name}, #{params}, #{tokens})\n"
      if name == "label"
        txt += "LABEL!\n"
        txt += @lang[:label] if @lang[:label]
      elsif name == "url"
        txt += "URL!\n"
        txt += @lang[:url] if @lang[:label]
      else
        super
      end
      return txt
    end

  end

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
      ::Jekyll.update_tagmap(context)

      txt = ""

      lang = context['page']['lang']
      lang = LANG_DEFAULT if lang == nil

      url = context['page']['url']
      txt += "<!-- page:url=#{url} -->\n"
      txt += "<!-- page[0].dest=#{context['site']['pages'][0].destination("")}-->\n"
      txt += "<!-- page[0].url=#{context['site']['pages'][0].url}-->\n"
      #return "<!-- WARNING: page.url is missing -->" if url == nil

      # url should be something like "/index.html" or "/dir/somedoc.html"
      return "<!-- WARNING: cannot parse url(#{url}): not absolute path -->" if 
        Pathname.new(url).relative?

      label = context['page']['label']
      #return "<!-- WARNING: page.label is missing -->" if label == nil

      # depth of "/index.html" is 0, and depth of "dir/somedoc.html" is 1.
      depth = url.split("/").length - 2

      #txt = "scope: #{context.scopes}\n"
      #txt = ""
      #txt += "depth: #{depth}\n"

      pagetag = ::Jekyll.tagmap[context[@label]]

      if pagetag == nil
        txt += "<!-- toplink: invalid parameter, label(#{context[@label]}) not found -->\n"
      else
        page = pagetag[lang]
        if page != nil && lang != LANG_DEFAULT
          pglang = "(#{lang})"
        else
          # if there is no localization page, fall back to the default page.
          page = pagetag[LANG_DEFAULT]
          pglang = ""
        end

        if page == nil
          txt += "<! WARNING: page with label(#{@label}) is not found -->\n"
        else
          context.stack {
            #txt += "PAGE-URL: #{page.url}\n"
            #txt += "PAGE-DIR: #{page.dir}\n"
            #txt += "PAGE-base: #{page.basename}\n"
            #txt += "PAGE-DATA: #{page.data}\n"
            #txt += "PAGE-link: #{page.permalink}\n"
            #txt += "PAGE-dest: #{page.destination(".")}\n"

            # txt += "PAGE-label: #{page.data['label']}\n"

            context['lang'] = pglang

            context['label'] = File.basename(context[@label])
            #url = "." + "/.." * depth + page.url
            #context['url'] = page.destination("." + "/.." * depth)

            if label == context[@label]
              context['active'] = "active"
              context['url'] = File.basename(page.destination("."))
            else
              context['active'] = ""
              context['url'] = page.destination("." + "/.." * depth)
            end
            #txt += "\nscope: #{context.scopes}\n"
            #txt += "PAGE DATA: #{context['site']['pages'][0].data}\n"
            #txt += "PAGE URL: #{context['site']['pages'][0].url}\n"
            txt += render_all(@nodelist, context)
          }
        end
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

  class TopNavUrl < Liquid::Tag
    def initialize(tag_name, text, tokens)
      @lang = text.strip
      super
    end

    def render(context)
          #txt += "PAGE DATA: #{context['site']['pages'][0].data}\n"
      txt = ""
      txt += "dir: #{context['site']['pages'][0].dir}\n"
      txt += "site: #{context['site']['pages'][0].site}\n"
      txt += "pager: #{context['site']['pages'][0].pager}\n"
      txt += "name: #{context['site']['pages'][0].name}\n"
      txt += "ext: #{context['site']['pages'][0].ext}\n"
      txt += "basename: #{context['site']['pages'][0].basename}\n"
      txt += "data: #{context['site']['pages'][0].data}\n"
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
Liquid::Template.register_tag('navurl', Jekyll::TopNavUrl)
Liquid::Template.register_tag('linguas', Jekyll::LinguaLink)


module MyFilter
  def exclude(input, regexp = '')
    if Array === input
      input.map { |v|
        if /#{regexp}/.match(v)
          nil
        else
          v
        end
      }.compact
    else
      if /#{regexp}/.match(input.to_s)
        ''
      else
        input
      end
    end
    "regexp: |#{regexp}|"
  end

  def subst(input, pattern = '', repl = '')
    input.to_s.gsub(/#{pattern}/, repl)
  end
    
  Liquid::Template.register_filter self
end
