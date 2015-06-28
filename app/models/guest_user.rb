class GuestUser
  def build_tiny_url(attributes = {})
    TinyUrl.new(attributes)
  end
end
