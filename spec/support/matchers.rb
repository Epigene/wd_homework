# frozen_string_literal: true

#                              new alias, existing
RSpec::Matchers.alias_matcher(:contain, :include)

RSpec::Matchers.define_negated_matcher(:exclude, :include)
RSpec::Matchers.define_negated_matcher(:not_contain, :contain)
RSpec::Matchers.define_negated_matcher(:not_change, :change)
RSpec::Matchers.define_negated_matcher(:not_receive, :receive)
