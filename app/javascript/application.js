// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbolinks:load", function () {
  FontAwesome.dom.i2svg();
});
