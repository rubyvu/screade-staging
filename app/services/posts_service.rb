class PostsService
  def initialize(post)
    @post = post
  end
  
  def translate_for(user)
    language = user.translation_language
    
    title_translation = @post.translations.find_by(language: language, field_name: 'title')
    unless title_translation
      translated_title = TranslationService.translate_text(@post.title, language.code)
      title_translation = Translation.create!(language: language, translatable: @post, field_name: 'title', result: translated_title)
    end
    
    description_translation = @post.translations.find_by(language: language, field_name: 'description')
    unless description_translation
      translated_description = TranslationService.translate_text(@post.description, language.code)
      description_translation = Translation.create!(language: language, translatable: @post, field_name: 'description', result: translated_description)
    end
    
    return {
      title: title_translation.result,
      description: description_translation.result
    }
  end
  
  def detect_language
    detected_language_code = LanguageDetectionService.detect("#{@post.title} #{@post.description}")
    @post.update_columns(detected_language: detected_language_code) if detected_language_code
  end
end
