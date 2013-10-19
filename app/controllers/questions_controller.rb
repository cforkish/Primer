class QuestionsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @quiz = Quiz.find(params[:quiz_id])
  end

  def new
    @quiz = Quiz.find(params[:quiz_id])
    @question = @quiz.questions.build
    @question.answers.build
    @question.answers.build
    @question.creator = current_user
  end

  def create
    @quiz = Quiz.find(params[:quiz_id])
    @question = @quiz.questions.build(params[:question])
    @question.creator = current_user

    if @question.save
      flash[:success] = "Question created!"
      redirect_to quiz_path(@quiz)
    else
      render 'new'
    end
  end

  def update
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    flash[:success] = "Question removed."
    redirect_to quiz_path(params[:quiz_id])
  end

  private

    def question_params
      params.require(:question).permit(:question, answers_attributes: [ :answer, :is_correct ])
    end
end