# Dragon Test

A simple DSL and test runner DragonRuby Game Toolkit (DRGTK).

Given a method in your game called `#text_for_setting_val`,

``` ruby
def text_for_setting_val(val)
  case val
  when true
    "ON"
  when false
    "OFF"
  else
    val
  end
end
```

You'd test it like this:

``` ruby
test :text_for_setting_val do |args, assert|
  assert.equal!(text_for_setting_val(true), "ON")
  assert.equal!(text_for_setting_val(false), "OFF")
  assert.equal!(text_for_setting_val("other"), "other")
end
```

## Get Started

1. Replace `mygame/app/tests.rb` in your DRGTK with `app/tests.rb`.
2. Place the `run_tests` script into the `mygame` folder of your project
3. Run tests with `./run_tests` or just boot up your `dragonruby` engine and tests will run on file change

## Bugs/Features

- documentation
- simple DSL
- easily define custom assertions
- bash script for running on CI with proper exit code and output on failure
- watch your tests run when you start your game with the `dragonruby` executable

## Docs (a.k.a. How It Works)

When running DRGTK tests, the exit status doesn't fail when non-zero. So we want to easily have a way to break the build on CI. Plus we want to properly reset the tests that ran with each run.

Define tests with:

``` ruby
test :method_under_test do |args, assert|
end
```

You then have access to `args` that you normally do in `#tick` for a DRGTK game.

### Included assertions

`assert` is an object you use to make assertions. Three are included by default:

- `assert.true!` - whether or not what's passed in is truthy, ex: `assert.true!(5 + 5 == 10)`
- `assert.false!` - whether or not what's passed in is falsey, ex: `assert.false!(5 + 5 != 10)`
- `assert.equal!` - whether or not what's passed into param 1 is equal to param 2, ex: `assert.equal!(5, 2 + 3)`

You can also pass an optional failure message too as the last parameter: `assert.equal(5, 2 + 2, "the math didn't work")`


### Custom assertions

Define custom assertions like this within `#test` (see the comment and example in the code)

``` ruby
assert.define_singleton_method(:rect!) do |obj|
  assert.true!(obj.x && obj.y && obj.w && obj.h, "doesn't have needed properties to be a rectangle")
end
```

usage:

``` ruby
test :create_player do |args, assert|
  it "is a rectangle" do
    assert.rect!(create_player(args))
  end
end
```

### Overview of files and methods:

- the `./run_tests` script handles running the test suite and outputing any test failures with proper exit code
- the `#run_tests` method encapsulates all the test running logic that exists on top of DRGTK
- the `#it` method is just a nice little way to organize your tests in a block, kinda like RSpec:
- the `#test` method is the main entrypoint into the DSL and is where you can define custom assertions

``` ruby
test :vel_from_angle do |args, assert|
  it "rounds values four places" do
    assert.equal!(vel_from_angle(90, 10), [10.2323, 12.1231])
  end
end
```

### Run on CI

You'll need to be using DRGTK in a private repo with the Linux engine source checked into the codebase.

In the CI script for your provider, just have it run `run_tests`.

Then on PR, commit, whatever event, tests will run. If tests fail, the build will break.

## TODO

- Windows script support
- `assert.exception!`
