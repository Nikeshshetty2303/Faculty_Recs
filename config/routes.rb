Rails.application.routes.draw do
  resources :announcements
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

post '/update_credit_answers', to: 'credit_answers#update_batch'

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
    get 'print_profile'
    get 'displaypdf'
    get 'myresponse'
    get 'my_credit'
    get 'my_credit_freezed'
    get 'view_pdf'
    get 'view_sum_pdf'
    get 'view_combined_pdf'
    get 'validate'
    patch 'validate'
    get 'update_status'
    patch 'update_status'
    get 'view_app_pdf'
    get 'combine_pdf'
    patch 'combine_pdf'
  end
end

  # devise_scope :user do
  # root to: "devise/sessions#new"
  # end

  devise_scope :user do
     get '/users/sign_out' => 'devise/sessions#destroy'
  end

   get 'home/index'
   get 'home/validate'
   get 'home/app_profile'
   get 'admin_dashboard/all_responses'
   get 'admin_dashboard/all_users'
   get 'admin_dashboard/statistics'
   get 'admin_dashboard/view_summary_report'
   get 'admin_dashboard/summary_report'
   patch 'admin_dashboard/view_summary_report'
   get 'admin_dashboard/extract_print'
   get 'admin_dashboard/extractpdf'
   get 'admin_dashboard/extract_portal'
  get 'admin_dashboard/view_summary_report_csv'

   post 'responses/printshow.pdf', to: 'responses#print', format: 'pdf'
   get 'home/edit_app_profile'
   post 'home/app_profile'
   get 'home/instruction'
   get 'home/export_to_excel'
   get 'home/deadline'

   root to: "home#deadline"

   get 'restriction/frozen_application'
    get 'restriction/view_frozen_app_pdf'
    get 'restriction/view_frozen_combined_pdf'
  #  root to: "restriction#frozen_application"
  get 'developer/multiple_app_user'
  get 'developer/csv_generator'
  get 'developer/extract_print'
  get 'developer/extractpdf'
  get 'developer/credit_questions_check'
   resources :credit_questions do
    collection do
      post :import
    end
  end

  get '*path', to: 'home#index', via: :all

end
