require "rubygems"
require "securerandom"

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
  require "mina/hooks/plugin"
  extend Mina::Hooks::Plugin
end

# create a test mina app scope
def mina_app
  Rake.application.instance_eval do
    init "mina"
    require "mina/rake"

    @rakefiles = ["test/deploy.rb"]
    load_rakefile

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
      super
      @cleanup_called = true
    end

    @deploying = true

    # set not deploying!
    def not_deploying!
      @deploying = false
    end

    def test_task(task_name = random_task_name, &block)
      task = define_task(Rake::Task, task_name) do |t|
        extend Mina::Helpers
        extend Mina::Hooks::Plugin # simulates a rakefile env
        block.call(self)
      end
      task.invoke
      task
    end

    # to avoid rake task enhancing and correct invocation
    def random_task_name
      "test_task_#{SecureRandom.hex}"
    end

    def reset!
      @before_mina_tasks = []
      @after_mina_tasks = []
      @invoked_tasks = []
      @cleanup_called = false
      @deploying = true
    end

    return self
  end
end

# create a task in the scope of the mina app
def task(&block)
  mina_app.test_task(&block)
end

require "minitest/autorun"
