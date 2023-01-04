# To run the tests: ./run_tests
#
# Available assertions:
# assert.true!
# assert.false!
# assert.equal!
# + any that you define
#
# Powered by Dragon Test: https://github.com/DragonRidersUnite/dragon_test

def run_tests
  $gtk.tests&.passed.clear
  $gtk.tests&.inconclusive.clear
  $gtk.tests&.failed.clear
  puts "💨 running tests"
  $gtk.reset 100
  $gtk.log_level = :on
  $gtk.tests.start

  if $gtk.tests.failed.any?
    puts "🙀 tests failed!"
    failures = $gtk.tests.failed.uniq.map do |failure|
      "🔴 ##{failure[:m]} - #{failure[:e]}"
    end

    if $gtk.cli_arguments.keys.include?(:"exit-on-fail")
      $gtk.write_file("test-failures.txt", failures.join("\n"))
      exit(1)
    end
  else
    puts "🪩 tests passed!"
  end
end

# an optional BDD-like method to use to group and document tests
def it(message)
  yield
end

def test(method)
  test_name = "test_#{method}"
  define_method(test_name) do |args, assert|
    # define custom assertions here!
    # assert.define_singleton_method(:rect!) do |obj|
    #   assert.true!(obj.x && obj.y && obj.w && obj.h, "doesn't have needed properties")
    # end

    # usage: assert.int!(2 + 3)
    assert.define_singleton_method(:int!) do |obj|
      assert.true!(obj.is_a?(Integer), "that's no integer!")
    end

    yield(args, assert)
  end
end

test :math do |args, assert|
  it "works!" do
    assert.equal!(2 + 3, 5, "math works!")
  end

  it "returns an int" do
    assert.int!(2 + 3)
  end
end

run_tests
