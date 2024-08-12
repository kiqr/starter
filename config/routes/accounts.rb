namespace :account, path: nil, module: :accounts do
  namespace :settings do
    resource "profile", only: [ :show, :update ]
    resources "members", only: [ :index ]
  end
end
