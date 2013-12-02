Werewolf::Application.routes.draw do



  root :to => "users#new"


  

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"
  get "get_possible_kills" => "players#get_possible_kills", :as => "get_possible_kills"
  get "kill_player/:nickname" => "players#kill_player", :as => "kill_player"
  post "vote_for_player" => "players#vote_for_player", :as => "vote_for_player"
  get "get_votables" => "players#get_votables", :as => "get_votables"
  get "restart_game" => "games#restart_game", :as => "restart_game"
  post "report_position/" => "players#report_position", :as => "report_position"
  get "leaderboard" => "users#leaderboard", :as => "leaderboard"
  get "start_game/:dayNightFreq/:kill_radius/:scent_radius" => "games#start_game", :as => "start_game"
  get "daily_report" => "kills#daily_report", :as => "daily_report"
  get "players_alive" => "players#players_alive", :as => "players_alive"
  get "types_left" => "players#types_left", :as => "types_left"
  get "playing_game" => "games#playing_game", :as => "playing_game"
  get "my_details" => "users#my_details", :as => "my_details"
  get "am_i_signed_in" => "sessions#am_i_signed_in", :as => "am_i_signed_in"
  get "night_or_day" => "games#night_or_day", :as => "night_or_day"
  get "current_game" => "games#current_game", :as => "current_game"
  
#  get "players_list_vote" => "players#players_list_vote", :as => "players_list_vote"
  

  resources :users, :sessions, :games, :players, :reports #TODO GET RID OF UNNEEDED CONTROLLER ACTIONS



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
