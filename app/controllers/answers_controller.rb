class AnswersController < ApplicationController
  def new; end

  def edit; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: 'Your answer successfully added.'
    else
      redirect_to @question, alert: "Body can't be blank"
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to answer.question
    else
      render :edit
    end
  end

  def destroy
    answer.destroy
    redirect_to answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
