# To run the tests: ./run_tests
#
# Available assertions:
# assert.true!
# assert.false!
# assert.equal!
# assert.exception!
# assert.includes!
# assert.not_includes!
# assert.int!
# + any that you define
#
# Powered by Dragon Test: https://github.com/DragonRidersUnite/dragon_test

# add your tests here

test :example do |args, assert|
  it "works" do
    assert.equal!(5 + 5, 10)
  end
end

run_tests
