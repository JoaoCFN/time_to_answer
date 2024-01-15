module UsersBackofficeHelper
  def user_sidebar_message
    current_user_full_name = current_user.full_name
    current_user_full_name.present? ? "Seja bem-vindo #{current_user_full_name}" : "Seja bem-vindo"
  end

  def avatar_url
    avatar = current_user.user_profile.avatar
    avatar.attached? ? avatar : 'img.jpg'
  end
end
