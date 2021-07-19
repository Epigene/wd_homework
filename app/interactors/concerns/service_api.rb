# frozen_string_literal: true

# Allows operation to be called with the class-level .call method
# instead of instance level #call. Eases testing.
module ServiceApi
  extend ActiveSupport::Concern

  module ClassMethods
    def call(**options, &block)
      new(**options).call(&block)
    end
  end
end
