# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "spec/"
  add_filter "config/"

  add_group "Collectors", "app/collectors"
  add_group "Controllers", "app/controllers"
  add_group "Interactors", "app/interactors"
  add_group "Models", "app/models"
  add_group "Serializers", "app/serializers"
end
