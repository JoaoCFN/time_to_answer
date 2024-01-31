class Site::AnswerController < SiteController
  def question
    @redis_answer = Rails.cache.fetch(params[:answer_id])
    @redis_answer.present? ? set_redis_answer : set_database_answer

    UserStatistic.set_statistic(@answer_is_correct, current_user)
  end

  private
    def to_bool(string)
      ActiveModel::Type::Boolean.new.cast(string)
    end

    def set_redis_answer
      splited_redis_answer = @redis_answer.split("@@")

      @question_id = splited_redis_answer.first
      @answer_is_correct = to_bool(splited_redis_answer.last)
    end

    def set_database_answer
      answer = Answer.find(params[:answer_id])

      @question_id = answer.question_id
      @answer_is_correct = answer.correct
    end
end
