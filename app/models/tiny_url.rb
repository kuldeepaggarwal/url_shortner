class TinyUrl < ActiveRecord::Base
  DEFAULT_PROTOCOL = 'http://'
  PROTOCOL_REGEXP = /\Ahttps?:\/\//i

  # Configurations
  cattr_accessor :slug_length
  self.slug_length = 5

  cattr_accessor :character_set
  self.character_set = ('a'..'z').to_a + (0..9).to_a

  cattr_accessor :max_retries
  self.max_retries = 10

  # Associations
  belongs_to :owner, polymorphic: true

  # Validations
  validates :url, presence: true
  validates :url, url: true, allow_blank: true
  validates :owner, presence: true, if: -> { owner_type.present? || owner_id.present? }

  # Callbacks
  before_save :normalize_url!
  before_create :set_slug

  # Scopes
  scope :ordered, -> { order(created_at: :desc) }

  private
    def set_slug
      self.class.max_retries.times do
        self.slug = generate_key
        if self.class.exists?(slug: slug)
          self.slug = nil
        else
          break
        end
      end

      slug.presence || raise('too many retries')
    end

    def generate_key
      (0...self.class.slug_length).map{ character_set[rand(character_set.size)] }.join
    end

    def character_set
      self.class.character_set
    end

    def normalize_url!
      return if url.blank?

      _url = url.prepend(DEFAULT_PROTOCOL) unless url =~ PROTOCOL_REGEXP
      normalized_url = URI.parse(_url || url).normalize.to_s
      self.url = normalized_url.ends_with?('/') ? normalized_url[0...-1] : normalized_url[0..-1]
    end
end
