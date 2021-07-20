# frozen_string_literal: true

# CRUD actions for Tag resource
class TagsController < ApplicationController
  # GET /api/v1/tags
  def index
    render(json: Tag::IndexCollector.call(params: clean_params))
  end

  # POST /api/v1/tags
  def create
    outcome = Tag::Creator.call(params: clean_params)

    render_outcome(outcome)
  end

  # PUT api/v1/tags/:id
  def update
    outcome = Tag::Updater.call(params: clean_params)

    render_outcome(outcome)
  end

  private

    def render_outcome(outcome)
      if outcome[:success]
        render(json: outcome[:tag])
      elsif outcome[:tag].blank?
        render(json: {}, status: :not_found)
      else
        render(json: {errors: invalid_record_errors(outcome[:tag])}, status: :bad_request)
      end
    end
end
