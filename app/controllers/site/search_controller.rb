class Site::SearchController < SiteController
  def questions
    @questions = Question.search_by(params[:page], params[:term])
  end
end
