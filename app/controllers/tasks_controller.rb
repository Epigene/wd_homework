# frozen_string_literal: true

# CRUD actions for Task resource, also allows CRU for nested tags.
class TasksController < ApplicationController
  # GET /api/v1/tasks
  def index
    render(json: Task::IndexCollector.call(params: clean_params))
  end

  # POST /api/v1/tasks
  def create
    outcome = Task::Creator.call(params: clean_params)

    render_outcome(outcome)
  end

  # PUT /api/v1/tasks/:id
  def update
    outcome = Task::Updater.call(params: clean_params)

    render_outcome(outcome)
  end

  private

    def render_outcome(outcome)
      if outcome[:success]
        render(json: outcome[:task])
      elsif outcome[:task].blank?
        render(json: {}, status: :not_found)
      else
        render(json: {errors: invalid_record_errors(outcome[:task])}, status: :bad_request)
      end
    end
end
