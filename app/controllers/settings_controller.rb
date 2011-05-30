class SettingsController < ApplicationController
  def email
    @setting = Setting.find_or_create_by_key("notification_email")
  end
  
  def update
    setting = Setting.find_by_key(params[:setting][:key])
    setting.update_attributes(params[:setting])
    flash[:notice] = "Settings saved!"
    redirect_to :back
  end
  
  def campfire
    @campfire_settings = Campfire.settings
  end
  
  def update_campfire
    Campfire::KEYS.each do |key|
      setting = Setting.find_or_create_by_key(key)
      setting.update_attribute(:value, params[key])
    end
    flash[:notice] = "Settings saved!"
    redirect_to campfire_settings_path
  end
end
