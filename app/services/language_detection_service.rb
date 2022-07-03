class LanguageDetectionService
  
  # Pass text, get language code back
  def self.detect(text)
    return nil if text.blank?
    
    detected_language = CLD.detect_language(text)
    detected_language_code = detected_language[:code]&.upcase
    
    return 'ZH' if detected_language_code == 'ZH-TW'
    
    detected_language_code
  end
end
