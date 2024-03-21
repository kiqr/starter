module ViewComponentsHelper
  def navbar(*, &)
    render(Navbar::Component.new(*), &)
  end

  def fullscreen(*, &)
    render(Fullscreen::Component.new(*), &)
  end
end
