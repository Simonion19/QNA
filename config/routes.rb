Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions, shallow: true, except: %i[ edit ] do
    resources :answers, except: %i[index show new edit] do
      member do
        patch :best
      end
    end
  end

  resources :attachments, only: %i[ destroy ]
end
