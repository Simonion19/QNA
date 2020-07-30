require 'rails_helper'
feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
  
      visit questions_path
      click_on 'Ask question'
    end
  
    scenario 'asks a question' do
      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Body'
      click_on 'Ask'
  
      expect(page).to have_content 'Your question successfully created.'
      within '.question__title' do
        expect(page).to have_content 'Title'
      end
      within '.question__body' do
        expect(page).to have_content 'Body'
      end
    end
  
    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end  
  end

  describe 'Unauthenticated user' do
    scenario 'tries to ask a question' do
      visit questions_path
      click_on 'Ask question'
  
      expect(page).to have_content 'You need to sign in or sign up before continuing.'
    end
  end
end