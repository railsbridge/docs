RSpec::Matchers.define :loosely_equal do |expected|
  match do |actual|
    actual.gsub(/\n\s*/, '') == expected.gsub(/\n\s*/, '')
  end

  diffable
end
