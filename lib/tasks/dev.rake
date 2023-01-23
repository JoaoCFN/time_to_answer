namespace :dev do
  DEFAULT_PASSWORD = 123456

  desc "Configure the development environment"
  task setup: :environment do
    if(Rails.env.development?)
      show_spinner("Deleting database...") do
        %x(rails db:drop)
      end

      show_spinner("Creating database...") do
        %x(rails db:create)
      end

      show_spinner("Making migrations...") do
        %x(rails db:migrate)
      end

      show_spinner("Creating default admin...") do
        %x(rails dev:add_default_admin)
      end

      show_spinner("Creating default user...") do
        %x(rails dev:add_default_user)
      end
    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Add the default admin"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com.br', 
      password: DEFAULT_PASSWORD, 
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Add the default user"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com.br', 
      password: DEFAULT_PASSWORD, 
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  private
    def show_spinner(start_message, end_message = "Successful")
      spinner = TTY::Spinner.new("[:spinner] #{start_message}")
      spinner.auto_spin
      yield
      spinner.success("(#{end_message})")
    end
end
