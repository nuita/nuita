module PagesHelper
  def navbar_type(landing)
    landing.present? ? 'landing-navbar' : 'guest-navbar'
  end
end
