
require 'active_support/test_case'

class ActiveSupport::TestCase

  def assert_not(assertion)
    assert !assertion
  end

  def assert_same_content(result, expected)
    assert expected.size == result.size, "the arrays doesn't have the same size"
    expected.each do |element|
      assert result.include?(element), "The array doesn't include '#{element}'."
    end
  end

end

