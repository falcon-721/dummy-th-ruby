Rails.application.routes.draw do
  devise_for :users

  concern :voteable do
    member do
      post 'vote_plus'
      post 'vote_minus'
      post 're_vote'
    end
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :questions,
            concerns: [:voteable, :commentable] do
    resources :answers,
              concerns: [:voteable, :commentable],
              except: [:index, :edit, :new] do
      member do
        post :best
      end
    end
  end

  root 'questions#index'
end
