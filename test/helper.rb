require "rubygems"

begin
  require "bundler"
rescue LoadError => e
  STDERR.puts e.message
  STDERR.puts "Run `gem install bundler` to install Bundler."
  exit e.status_code
end

begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  STDERR.puts e.message
  STDERR.puts "Run `bundle install` to install missing gems."
  exit e.status_code
end

require "mina"

# create a regular class scope to test methods
class MinaClass
  require "mina/hooks"
  extend Mina::Hooks::Plugin
end

# create a test mina app scope
def mina_app
  Rake.application.instance_eval do
    init "mina"
    require "mina/rake"
    load "test/deploy.rb"

    # list of tasks that were "invoked"
    @invoked_tasks = []

    # helper for invoked tasks
    def invoked_tasks
      @invoked_tasks
    end

    # fake invoke command for testing
    def invoke(task)
      invoked_tasks << task
    end

    # flag if cleanup method called
    @cleanup_called = false

    # helper for cleanup method
    def cleanup_called
      @cleanup_called
    end

    # fake mina_cleanup! command for testing
    def mina_cleanup!
      cleanup_called = true
    end

    return self
  end
end

# create a task in the scope of the mina app
def task(name = "test_task", &block)
  mina_app.instance_eval do
    define_task Rake::Task, name, &block
  end
end

require "minitest/autorun"
