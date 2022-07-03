class CommentsService
  def initialize(comment)
    @comment = comment
  end
  
  def translate_for(user)
    language = user.translation_language
    message_translation = @comment.translations.find_by(language: language, field_name: 'message')
    
    unless message_translation
      translated_message = TranslationService.translate_text(@comment.message, language.code)
      message_translation = Translation.create!(language: language, translatable: @comment, field_name: 'message', result: translated_message)
    end
    
    return { message: message_translation.result }
  end
  
  def detect_language
    detected_language_code = LanguageDetectionService.detect(@comment.message)
    @comment.update_columns(detected_language: detected_language_code) if detected_language_code
  end
end
