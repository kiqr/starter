module ViewComponentsHelper
  # Render the navbar component
  def navbar(*, &)
    render(Navbar::Component.new(*), &)
  end

  # Render the fullscreen component
  def fullscreen(*, &)
    render(Fullscreen::Component.new(*), &)
  end
end
