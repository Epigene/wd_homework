# frozen_string_literal: true

class TagsController < ApplicationController
  include CursorPagination

  # GET
  def index
    render json: page_records
  end

  # POST
  def create; end

  # PUT
  def update; end

  private

    def page_records
      page_records_by_single_cursor(collection: Tag.all)
    end
end
