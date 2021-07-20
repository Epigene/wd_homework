# frozen_string_literal: true

%w[Home Today Work].each do |title|
  Tag::Creator.call(params: {title: title})
end

{
  "Wash laundry" => %w[Home Today],
  "Prepare Q1 report" => %w[Today Work]
}.each_pair do |title, tags|
  Task::Creator.call(params: {title: title, tags: tags})
end

puts("Seeding done!") # rubocop:disable Rails/Output
