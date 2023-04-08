class FixFontFamilyForExistingSettings < ActiveRecord::Migration[6.1]
  def change
    Setting.transaction do
      Setting.where.not(font_family: Setting::FONT_FAMILIES).update_all(font_family: 'roboto')
    end
  end
end
