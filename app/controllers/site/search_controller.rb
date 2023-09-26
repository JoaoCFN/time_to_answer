class Site::SearchController < SiteController
  def questions
    @questions = Question.search_by(params[:page], params[:term])
  end

  def subject
    @questions = Question.search_by_subject(params[:page], params[:subject_id])
  end
end
