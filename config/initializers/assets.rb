# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.

# /app/assets
Rails.application.config.assets.precompile += %w( 
    admins_backoffice.css 
    admins_backoffice.js 
    users_backoffice.css 
    users_backoffice.js 
    admin_devise.css 
    admin_devise.js 
    user_devise.css 
    user_devise.js 
    site.css 
    site.js 
)

# /lib/assets
Rails.application.config.assets.precompile += %w( 
    sb-admin-2.css 
    sb-admin-2.js 
    custom.css
    custom.js
    img.jpg
    surface-fix.css 
    surface-fix.js 
    navbar.css
)

# /vendor/assets
Rails.application.config.assets.precompile += %w( 
    jquery-2.2.3/dist/jquery.js
)
