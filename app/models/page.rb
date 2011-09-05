class Page < ActiveRecord::Base
  belongs_to :site

  def render
    Liquid::Template.file_system = KISSrFileSystem.new(self.site)
    Liquid::Template.register_tag('markdown',MarkdownTag)
    content=dropbox.download("#{self.site.path}/#{self.path}.html")
    template = Liquid::Template.parse(content)
    content = template.render
    offload_assets(content)
  end
  def css_offload_assets(content)
    content.gsub(/url[ ]*\(['" ]*(.*?)['" ]*\)/) do
      asset=$1.gsub(/^\//,"")
      begin
        self.site.bucket.put(asset,dropbox.download("#{self.site.path}/#{asset}"))
      rescue Dropbox::UnsuccessfulResponseError
        puts $!
      end
      end

    
  end
  def offload_assets(content)
    doc = Nokogiri::HTML(content)
    # Upload to S3 and replace URLs
    doc.css('script,img').each do |asset|
      if not  asset['src'].nil? and not asset['src'].to_s =~ /^http:\/\//  then
      asset['src']= asset['src'].gsub(/^\//,"")
        asset['src']=self.site.bucket.put(asset["src"].to_s,dropbox.download("#{self.site.path}/#{asset["src"]}").to_s)
      end
    end

    doc.css('link').each do |asset|
       if  not asset['href'].nil? and not asset['href'].to_s =~ /^http:\/\//  then
        asset['href']= asset['href'].gsub(/^\//,"")
         source=dropbox.download("#{self.site.path}/#{asset["href"]}").to_s
         asset['href']=self.site.bucket.put(asset["href"].to_s,css_offload_assets(source))
       end
    end
    doc.to_s
  end
  def dropbox
   @dropbox ||= begin
    dropbox=Dropbox::Session.new('69vdq9pk8stjkb8', '6gc7j0bdw85uzoh')
    dropbox.set_access_token(self.site.user.dropbox_token,self.site.user.dropbox_token_secret)
    dropbox.mode = :dropbox
    dropbox 
   end
  end
end
class MarkdownTag < Liquid::Block                                             
  def render(context)
    render_all(@nodelist, context)
  end
  def render_all(list, context)
      list.collect do |token|
        begin
          token.respond_to?(:render) ? token.render(context) : RDiscount.new(token).to_html
        rescue ::StandardError => e
          context.handle_error(e)
        end
      end.join
  end
  
end

