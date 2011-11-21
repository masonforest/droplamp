module SiteHelper
  def hostname_link(site)
    link_to site.hostname,"http://#{site.hostname}", "target"=>"_blank"
  end
end
