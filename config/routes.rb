Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :cancel_vote
    end
  end

  resources :questions,
            except: [:edit, :new],
            concerns: [:votable] do
    resources :answers,
              concerns: [:votable],
              except: [:index, :edit, :new] do
      member do
        post :best
      end

      resources :comments, only: [:create], defaults: { context: 'answer' }
    end

    resources :comments, only: [:create], defaults: { context: 'question' }
  end

  root 'questions#index'
end
