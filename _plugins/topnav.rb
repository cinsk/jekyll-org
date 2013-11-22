require 'pathname'

module Jekyll
  @@_pagemap = {}
  @@_localemap = {}

  LANG_DEFAULT = "en"

  class Pager
    # def self.pagination_enabled?(config, file)
    #   puts "pagination_enabled?(config, #{file})"
    #   if !config['paginate'].nil?
    #     return (/index.*\.html$/.match file) != nil
    #   else
    #     return nil
    #   end
    # end
  end

  def self.tagmap
    @@_pagemap
  end

  def self.localemap
    @@_localemap
  end

  def self.update_localemap(context)
    if @@_localemap.empty?
      context['site']['linguas'].each { |ent|
        ::Jekyll.localemap[ent[:tag]] = ent[:label]
      }
    end
  end

  def self.dump_pageinfo(page)
    puts "page: #{page.name} basename(#{page.basename}) ext(#{page.ext})"
    puts "      dir(#{page.dir})"
    puts "      url: #{page.url}"
    page.data.each_pair { |k, v|
      puts "     [#{k}] = [#{v}]"
    }
  end

  def self.update_tagmap(context)
    result = "<!-- update_tagmap -->"

    if @@_pagemap.empty?
      context['site']['pages'].each { |pg|
        ::Jekyll.dump_pageinfo(pg)

        id = pg.data['pid']
        id = pg.data['id'] if id == nil

        if id
          if ::Jekyll.tagmap.has_key?(id)
            tag = ::Jekyll.tagmap[id]
          else
            tag = PageTag.new()
            puts "Inserting id(#{id}) in to TAGMAP"
            ::Jekyll.tagmap[id] = tag
          end

          locale = LANG_DEFAULT
          locale = pg.data['lang'] if pg.data['lang']

          # In some cases, there can be multiple pages that have same
          # PID.  (e.g. if pagination is enabled, the /index.html and
          # page*/index.htmlwill have same PID)

          if tag[locale]
            if tag[locale].name != pg.name
              raise RuntimeError,
              "duplicated id:lang pairs; previous(#{tag[locale].name}), current(#{pg.name})"
            end
            # Ignore this page since there is already PageTag with
            # same id.
          else
            tag[locale] = pg
          end
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

  def self.site_url_with_page(id, locale, context, exact = false)
    ::Jekyll.update_tagmap(context)
    # TODO: return the url of the page with LABEL in LOCALE if possible.

    # url of the current page: context['page']['url']
    # url of the Page object: page.destination(PREFIX)
    #context['site']

    #puts "SITE_URL(#{id}, #{locale}, context, #{exact})"
    STDERR.write("site_url: id not found\n") if id == nil

    base = Pathname.new(context['page']['url']).dirname

    ptag = ::Jekyll.tagmap[id]

    if ptag == nil
      #STDERR.write("#{context['page']['url']}: invalid id(#{id})\n")
      return nil
    end

    if ptag[locale]
      page = ptag[locale]
    else
      return nil if exact && (locale != nil)

      page = ptag[LANG_DEFAULT]
      if page == nil
        ptag.each_pair { |l, p|
          page = p
          break
        }
      end
    end

    if page
      [ page, 
        Pathname.new(page.destination("")).relative_path_from(base).to_s ]
    else
      nil
    end
  end

  def self.site_url(id, locale, context, exact = false)
    ret = site_url_with_page(id, locale, context, exact)
    #puts "site_url(#{id}, #{locale}, context, #{exact}) => #{ret}"
    if ret != nil && ret.size > 1
      ret[1]
    else
      nil
    end
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


      id = context['page']['pid']
      id = context['page']['id'] if id == nil

      txt += "<!-- fatal: current page does not have an id -->\n" if 
        id == nil

      context['site']['linguas'].each { |h|
        #txt += "<-- context[site][linguas]: #{context['site']['linguas']} -->"
        url = ::Jekyll.site_url(id, h[":tag"], context, true);
        #txt += "<-- url[#{h[":tag"]}]: #{url} -->"

        if url
          @linguas << { :id => id, :label => h[":label"],
            :url => url, :locale => h[":tag"] }
        end
      }

      lang = context['page']['lang']
      lang = LANG_DEFAULT if lang == nil

      @linguas.each { |v|
        context.stack {
          #txt += "<-- v_label: #{@v_label} -->"
          #txt += "<-- v[:label]: #{v[:label]} -->"
          #txt += "<-- context: #{context.to_s} -->"
          context[@v_label] = v[:label] if @v_label != nil
          context[@v_url] = v[:url] if @v_url != nil

          if @v_self
            if lang == v[:locale]
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
      super
    end
  end

  class TopNavLink < Liquid::Block
    def initialize(tag_name, params, tokens)
      super
      # @label = text.strip
      p = params.split(',').map(&:strip)

      @v_id = @v_label = @v_locale = @v_url = @v_self = nil

      @v_id = p[0] if p.size > 0
      @v_label = p[1] if p.size > 1
      @v_locale = p[2] if p.size > 2
      @v_url = p[3] if p.size > 3
      @v_self = p[4] if p.size > 4
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

      lang = context['page']['lang']
      lang = LANG_DEFAULT if lang == nil

      id = context['page']['pid']
      id = context['page']['id'] if id == nil

      if id == nil
        # raise RuntimeError, 
        # "page(#{context['page']['url']}) does not have id\n";
      end

      ptag = ::Jekyll.tagmap[id]

      txt = ""


        txt += "<!-- toplink: invalid parameter, label(#{context[@label]}) not found -->\n"
        pages = []

        context['site']['topnav-list'].each { |id_|
          pgtag = ::Jekyll.tagmap[id_]
          if pgtag == nil
            raise RuntimeError,
            "there is no page with id(#{id_})"
          end

          pg = pgtag[lang]
          pg = pgtag[LANG_DEFAULT] if pg == nil

          pid = pg.data['pid']
          pid = pg.data['id'] if id == nil

          linkinfo = { :id => pid,
            :label => pg.data['label'],
            :locale => pg.data['lang'],
            :url => ::Jekyll.site_url(pid, lang, context),
            :self => if id != nil && id == pid; true; else; false; end }

          pages << linkinfo

          if linkinfo[:label] == nil
            # if the page does not have "label", use "id" field instead.
            linkinfo[:label] = linkinfo[:id]
          end
        }

        pages.each { |linkinfo|
          context.stack {
            context[@v_id] = linkinfo[:id] if @v_id != nil
            context[@v_label] = linkinfo[:label] if @v_label != nil
            context[@v_locale] = linkinfo[:locale] if @v_locale != nil
            context[@v_url] = linkinfo[:url] if @v_url != nil
            context[@v_self] = linkinfo[:self] if @v_self != nil

            txt += render_all(@nodelist, context)
          }
        }
      txt
    end

    def render_old(context)
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

  class MultiLinguaLink < Liquid::Tag
    def initialize(tag_name, params, tokens)
      p = params.split(',').map(&:strip)
      #id, locale, exact
      
      @id = @locale = nil

      @id = p[0] if p.size > 0
      @locale = p[1] if p.size > 1

      @exact = if p.size > 2 && p[2].downcase == "true"; true; else; false; end
      super
    end

    def render(context)
      if @id == nil
        "<!-- mlink: missing argument -->"
      else
        if @locale == nil
          @locale = context['page']['lang']
        end

        ::Jekyll.site_url(@id, @locale, context, @exact)
      end
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
Liquid::Template.register_tag('linguas', Jekyll::LinguaLink)
Liquid::Template.register_tag('mlink', Jekyll::MultiLinguaLink)

#Liquid::Template.register_tag('topnav', Jekyll::TopNavBar)
#Liquid::Template.register_tag('navurl', Jekyll::TopNavUrl)


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
