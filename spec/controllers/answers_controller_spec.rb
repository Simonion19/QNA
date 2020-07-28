require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }
  let(:user2) { create(:user) }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #edit' do
    describe 'Authenticated user' do
      before { login(user) }
    
      it 'renders edit view' do
        get :edit, params: { id: answer, question_id: question }
        expect(response).to render_template :edit
      end
    end

    describe 'Unauthenticated user' do
      before { get :edit, params: { id: answer } }
      
      it 'tries to render edit view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #create' do
    describe 'Authenticated user' do
      before { login(user) }
      
      context 'with valid attributes' do
        it 'saves a new answer in the database' do        
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user } }.to change(question.answers, :count).by(1)
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, user_id: user } }.to change(user.answers, :count).by(1) 
        end
  
        it 'redirects to question view' do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
          expect(response).to redirect_to question_path(question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count) 
        end
        
        it 're-render question template' do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
          expect(response).to render_template 'questions/show'
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries create answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authenticated user' do
      before { login(user) }
      
      let!(:answer) { create(:answer, question: question) }
  
      context 'with valid attributes' do
        it 'assigns the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          expect(assigns(:answer)).to eq answer  
        end
  
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }
          answer.reload
          expect(answer.body).to eq 'new body'
        end
  
        it 'redirects to question' do
          patch :update, params: { id: answer, answer: attributes_for(:answer) }
          expect(response).to redirect_to question
        end
      end
  
      context 'with invalid attributes' do
        before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }
  
        it 'does not change answer' do
          answer.reload
          expect(answer.body).to eq 'Answer body'
        end
  
        it 're-renders edit view' do
          expect(response).to render_template :edit
        end
      end
    end

    describe 'Unauthenticated user' do
      it 'tries to change answer' do
        patch :update, params: { id: answer,  answer: attributes_for(:answer) }
        expect(assigns(:answer)).not_to eq answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'Authenticated user' do
      let!(:answer) { create(:answer, question: question, user: user) }
  
      context 'author' do
        before { login(user) }
    
        it 'tries to delete the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to change(Answer, :count).by(-1)
        end
    
        it 'redirects to question' do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question
        end
      end
  
      context 'not author' do
        before { login(user2) }
  
        it 'tries to delete the answer' do
          expect { delete :destroy, params: { id: answer, question_id: question } }.to_not change(Answer, :count)
        end
      end
    end

    describe 'Unauthenticated user' do
      let!(:answer) { create(:answer) }

      it 'tries to delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
