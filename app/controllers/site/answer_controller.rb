class Site::AnswerController < SiteController
  def question
    redis_answer = Rails.cache.fetch(params[:answer_id])

    if redis_answer.present?
      splited_redis_answer = redis_answer.split("@@")

      @question_id = splited_redis_answer.first
      @answer_is_correct = ActiveModel::Type::Boolean.new.cast(splited_redis_answer.last)
    else
      answer = Answer.find(params[:answer_id])

      @question_id = answer.question_id
      @answer_is_correct = answer.correct
    end

    UserStatistic.set_statistic(@answer_is_correct, current_user)
  end
end
