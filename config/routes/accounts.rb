scope "/team/:account_id", account_id: %r{[^/]+} do
  namespace :account, path: nil, module: :accounts do
    namespace :settings do
      resource "profile", only: [ :show, :update ]
      resources "members", only: [ :index, :new, :create ]
    end
  end
end