Oreidig::Application.routes.draw do

  resources :bookmarks do
    collection do
      get :hot
      get :most_recent
    end
    get 'click', on: :member
  end

  match 'bookmarklets' => 'pages#bookmarklets'

  # TODO
  match 'save_bookmark' => 'pages#dummy'

  root to: "pages#front_page"

end
