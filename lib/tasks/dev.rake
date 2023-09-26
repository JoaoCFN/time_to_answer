namespace :dev do
  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

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

      show_spinner("Creating extra admins...") do
        %x(rails dev:add_extra_admins)
      end

      show_spinner("Creating default subjects...") do
        %x(rails dev:add_subjects)
      end

      show_spinner("Creating default questions and answers...") do
        %x(rails dev:add_questions_and_answers)
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

  desc "Adiciona outros administradores extras"
  task add_extra_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas padrões"
  task add_questions_and_answers: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        params = create_question_params(subject)
        answers_array = params[:question][:answers_attributes]

        add_answers(answers_array)
        elect_true_answer(answers_array)

        Question.create!(params[:question])
      end
    end
  end

  desc "Reseta o contador dos assuntos"
  task reset_subject_counter: :environment do
    show_spinner("Reset subjects counter...") do
      Subject.all.each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  private
    def create_question_params(subject = Subject.all.sample)
      {
        question: {
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject,
          answers_attributes: []
        }
      }
    end

    def create_answer_params(correct = false)
      {
        description: Faker::Lorem.sentence,
        correct: correct
      }
    end

    def add_answers(answers_array = [])
      rand(2..5).times do |j|
        answers_array.push(
          create_answer_params
        )
      end
    end

    def elect_true_answer(answers_array = [])
      selected_index = rand(answers_array.size)
      answers_array[selected_index] = create_answer_params(true)
    end

    def show_spinner(start_message, end_message = "Successful")
      spinner = TTY::Spinner.new("[:spinner] #{start_message}")
      spinner.auto_spin
      yield
      spinner.success("(#{end_message})")
    end
end
