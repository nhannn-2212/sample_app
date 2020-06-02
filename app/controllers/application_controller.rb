class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :set_locale
  around_action :switch_locale
  include SessionsHelper

  def switch_locale &action
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    {locale: I18n.locale}
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "error.pls_login"
    redirect_to login_path
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
    I18n.default_locale = I18n.locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
end
