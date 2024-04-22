module Spree
  module StoreHelper
    include LocaleHelper

    def spree_frontend_path_to_checkout
      if Spree::Frontend::Engine.checkout_available?
        spree.checkout_root_path
      else
        spree.checkout_path
      end
    end

    def store_country_iso(store = nil)
      store ||= current_store if defined?(current_store)

      store&.default_country&.iso&.downcase
    end

    def stores
      @stores ||= Spree::Store.includes(:default_country).order(:id)
    end

    def store_currency_symbol(store = nil)
      store ||= current_store  if defined?(current_store)
      return unless store&.default_currency

      ::Money::Currency.find(store.default_currency).symbol
    end

    def store_locale_name(store = nil)
      store ||= current_store if defined?(current_store)
      return unless store
      return store.name if store.default_locale.blank?

      locale_full_name(store.default_locale)
    end

    def should_render_store_chooser?
      Spree::Frontend::Config[:show_store_selector] && stores.size > 1
    end

    def store_link(store = nil, html_opts = {})
      store ||= current_store if defined?(current_store)
      return unless store

      link_to "#{store_locale_name(store)} (#{store_currency_symbol(store)})", store.formatted_url, **html_opts
    end
  end
end
