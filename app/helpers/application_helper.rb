module ApplicationHelper
  def avatar_url(user)
    if user.avatar.attached?
      url_for(user.avatar)
    elsif user.image
      user.image
    else
      ActionController::Base.helpers.asset_path('icon_default_avatar.png')
    end
  end

  def gig_photo_url(gig)
    gig.photos.attached? ? url_for(gig.photos[0]): "icon_default_image.png"
  end
end
