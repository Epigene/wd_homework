# frozen_string_literal: true

%w[Home Today Work].each do |title|
  Tag::Creator.call(title: title)
end

{
  "Wash laundry" => %w[Home Today],
  "Prepare Q1 report" => %w[Today Work]
}.each_pair do |title, tags|
  Task::Creator.call(title: title, tags: tags)
end
