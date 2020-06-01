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
end
