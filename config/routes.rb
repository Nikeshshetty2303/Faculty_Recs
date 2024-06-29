Rails.application.routes.draw do
  resources :tabs
  resources :departments
  resources :upload_questions
  resources :upload_sections
  resources :file_uploads
  resources :credit_questions
  resources :credit_sections
  devise_for :users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :answers
  resources :responses do
    post 'add_remark', on: :member
    post 'update_eligibility', on: :member
  end
  resources :options
  resources :question_types
  resources :questions
  resources :homes


  resources :forms do
  get 'submit_form', on: :member
  post 'create_response', on: :member
  post 'update_response', on: :member
  post 'update_app_profile_response', on: :member
  post 'submit_form', on: :member
  get 'checkout', on: :member
  patch 'payment', on: :member
  get 'view_pdf',on: :member
  end

  resources :credit_answers do
    post 'update_response', on: :member
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
   get 'home/app_profile'
   get 'admin_dashboard/all_responses'
   post 'responses/printshow.pdf', to: 'responses#print', format: 'pdf'
   get 'home/edit_app_profile'
   post 'home/app_profile'

   resources :credit_questions do
    collection do
      post :import
    end
  end

end
