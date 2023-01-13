# DragonTest

A simple DSL and test runner DragonRuby Game Toolkit (DRGTK).

🚧 **DragonTest is a work in progress! It works, but the API and methods will change.** 🚧

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
  it "returns proper text for boolean vals" do
    assert.equal!(text_for_setting_val(true), "ON")
    assert.equal!(text_for_setting_val(false), "OFF")
  end

  it "passes the value through when not a boolean" do
    assert.equal!(text_for_setting_val("other"), "other")
  end
end
```

## Get Started

1. Replace `mygame/app/tests.rb` in your DRGTK with `app/tests.rb`.
2. Place the `run_tests` script into the `mygame` folder of your project
3. Write your tests
4. Run tests with `./run_tests` or just boot up your `dragonruby` engine and tests will run on file change

## Bugs/Features

- documentation
- simple DSL
- easily define custom assertions
- bash script for running on CI with proper exit code and output on failure
- watch your tests run when you start your game with the `dragonruby` executable and save the tests file

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
- `assert.exception!` - expect the code in the block to raise an error with optional message, ex: `assert.exception!(KeyError, "Key not found: :not_present") { text(args, :not_present) }`
- `assert.int!` - the passed in value is an Integer
- `assert.includes!` - whether or not the second param is included in the first arrary parameter, ex: `assert.includes!([1, 2, 3], 2])`
- `assert.not_includes!` – the second param is not included in the first array param

You can also pass an optional failure message too as the last parameter of many of the assertions: `assert.equal(5, 2 + 2, "the math didn't work")`

### Custom assertions

Define custom assertions within the `GTK::Assert` class (see the comment and example in the code):

``` ruby
class GTK::Assert
  def rect!(obj)
    true!(obj.x && obj.y && obj.w && obj.h, "doesn't have needed properties to be a rectangle")
  end
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

- the `./run_tests` script handles running the test suite and outputing any test failures with proper exit code; relies upon the `--exit-on-fail` flag
- the `#run_tests` method encapsulates all the test running logic that exists on top of DRGTK
- the `#test` method is the main entrypoint into the DSL and is where you can define custom assertions
- the `#it` method is just a nice little way to organize your tests in a block, kinda like RSpec:

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

## Thanks

- 68K (James) for the help/guidance/support!
- Levi for API feedback
