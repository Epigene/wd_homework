# frozen_string_literal: true

Rails.application.routes.draw do
  scope "/api/v1" do
    resources :tags, only: %i[index create update]
    resources :tasks, only: %i[index create update]
  end
end
