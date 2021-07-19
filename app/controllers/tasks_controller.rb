# frozen_string_literal: true

# CRUD actions for Task resource, also allows CRU for nested tags.
class TasksController < ApplicationController
  # GET /api/v1/tasks
  def index
    render(json: Task::IndexCollector.call(params: params.permit!.to_h))
  end

  # POST /api/v1/tasks
  def create
    outcome = Task::Creator.call(params: params.permit!.to_hash)

    if outcome[:success]
      head(201)
    else
      render(json: {errors: invalid_record_errors(outcome[:task]), status: :bad_request})
    end
  end

  # PUT /api/v1/tasks/:id
  def update
    outcome = Task::Updater.call(params: params.permit!.to_hash)

    if outcome[:success]
      head(201)
    else
      render(json: {errors: invalid_record_errors(outcome[:task]), status: :bad_request})
    end
  end
end
