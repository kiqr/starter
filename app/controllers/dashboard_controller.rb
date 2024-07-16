class DashboardController < KiqrController
  def show
    add_breadcrumb "Dashboard", dashboard_path
  end
end
