require 'google/cloud/translate/v2'

class TranslationService
  
  def self.client
    Google::Cloud::Translate::V2.new(
      key: ENV['GOOGLE_TRANSLATE_API_KEY']
    )
  end
  
  def self.translate_text(original, language_code)
    self.client.translate(original, to: language_code).text
  end
end
