class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :current_city
  before_filter :set_time
  before_filter :set_user_location
  before_filter :find_page
  before_filter :set_gon_current_user
  before_filter :set_user_path

  helper_method :current_city, :current_city_plural

  protected

    def current_city param=:slug
      current_user.try(:city).try(param) ||  session[:city] || 'kyiv'
    end

    def current_city_plural name = :plural_name
      City.find(current_city).send(name)
    end

    def set_locale
      if params[:locale] && Globalize.available_locales.include?(params[:locale].to_sym) #&& !request.xhr?
        I18n.locale = params[:locale].to_sym
      else
        I18n.locale = I18n.default_locale
      end
    end

  def set_user_location
    @user_location = cookies[:current_point].try(:split,',')
    if @user_location.present?
      @user_location.map(&:strip)
    else
      @user_location = ["50.451118","30.522301"]
    end
  end

  def set_time
    h,m = params[:reserve_time].try(:split,':')
    unless h and m
      h,m = (DateTime.now + (90 - DateTime.now.min % 15).minutes).strftime("%k:%M").split(':')
    end
    @time = {:h => h.to_s, :m => m.to_s }
  end

  def find_page
    structure = Structure.with_position(::PositionType.index).first
    setting_meta_tags structure
  end

  def setting_meta_tags struct
    if struct
      struct.headers.each do |header|
        tag_type = header.tag_type.code.to_sym
        case tag_type
          when :open_graph
            if header.og_tag
              set_meta_tags :open_graph => {
                  :title => header.og_tag.title,
                  :type  => header.og_tag.og_type.to_sym,
                  :url   => header.og_tag.url,
                  :image =>  header.og_tag.image,
                  :site_name =>  header.og_tag.site_name,
                  :description =>  header.og_tag.description
              }
            end
          when :keywords
            set_meta_tags  tag_type => header.content.split(',')
          else
            set_meta_tags tag_type => header.content
        end
      end
    end
  end

  def set_gon_current_user
    gon.current_user = current_user if current_user
  end

  def set_user_path
    if !current_user && !request.env['PATH_INFO'].to_s.include?("/users/")
      session[:return_path] = request.env['PATH_INFO']
    end
  end


  def signed_in_root_path(resource_or_scope)
    session[:return_path] || root_path
  end

end
