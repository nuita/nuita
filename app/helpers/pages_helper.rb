module PagesHelper
  def navbar_type(landing)
    landing.present? ? 'landing-navbar' : 'guest-navbar'
  end

  def navbar_logo(landing)
    landing.present? ? 'logo_white.svg' : 'logo_color.svg'
  end
end
