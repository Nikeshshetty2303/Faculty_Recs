Rails.application.routes.draw do
  resources :upload_questions
  resources :upload_sections
  resources :file_uploads
  resources :credit_answers
  resources :credit_questions
  resources :credit_sections
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :answers
  resources :responses
  resources :options
  resources :question_types
  resources :questions
  resources :homes


  resources :forms do
  get 'submit_form', on: :member
  post 'create_response', on: :member
  post 'submit_form', on: :member
  end

   # resources :questions, only: %i[edit update]
   # patch 'questions/moveup' ,on: :member
   resources :questions do
     post 'moveup', on: :member
       patch 'moveup' ,on: :member
       patch 'movedown' ,on: :member
   end




  resources :responses do
  member do
    get 'display'
    get 'print'
    get 'displaypdf'
    get 'myresponse'
    get 'my_credit'
    get 'view_pdf'
    get 'validate'
    patch 'validate'
  end
end

  devise_scope :user do
  root to: "devise/sessions#new"
  end

  devise_scope :user do
     get '/users/sign_out' => 'devise/sessions#destroy'
  end

   get 'home/index'
   get 'home/validate'
   post 'responses/printshow.pdf', to: 'responses#print', format: 'pdf'

   resources :credit_questions do
    collection do
      post :import
    end
  end

end
