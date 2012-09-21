NhsPatientlist::Application.routes.draw do
  resources :grades

  devise_for :users

  resources :users, only: [] do
    resources :patient_lists
  end

  resources :patients, :only=>[:show, :edit, :update] do
    collection do
      get 'current'
      get 'select_ward'
    end
    member do
      get 'history'
      post 'update_risk_level'
    end
    resources :to_do_items, :controller => "patients/to_do_items" do
      member do
        put 'update'
      end
    end
  end

  resources :lists
  resources :handover_lists
  resources :memberships, :only => [:create, :destroy]

  
  resources :to_do_items do
    resources :handovers, :only => [:new, :create], :controller => "to_do_items/handovers"
  end

  resources :teams, :only => [:index]
  resources :team_members, :only => [:create]
  resources :handovers

  match 'memberships' => 'memberships#create', via: :post
  match 'memberships/:patient_id/:patient_list_id' => 'memberships#destroy', via: :delete

  root :to => "lists#index"
end


