module ApplicationHelper
  def uri_path(url)
    url.sub(TinyUrl::PROTOCOL_REGEXP, '')
  end
end
