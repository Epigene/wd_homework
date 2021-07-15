# frozen_string_literal: true

%w[Home Today Work].each do |title|
  Tag::Creator.call(title: title)
end
