require "helper"

describe Mina::Hooks::Plugin do
  describe "class scope" do
    let(:klass) { MinaClass }

    it "defines before_mina_tasks" do
      assert_respond_to klass, :before_mina_tasks
    end

    it "defines after_mina_tasks" do
      assert_respond_to klass, :after_mina_tasks
    end

    it "defines before_mina" do
      assert_respond_to klass, :before_mina
    end

    it "defines after_mina" do
      assert_respond_to klass, :after_mina
    end

    it "defines invoke_before_mina_tasks" do
      assert_respond_to klass, :invoke_before_mina_tasks
    end

    it "defines invoke_after_mina_tasks" do
      assert_respond_to klass, :invoke_after_mina_tasks
    end

    it "defines mina_cleanup!" do
      assert_respond_to klass, :mina_cleanup!
    end

    it "defines print_task_list" do
      assert_respond_to klass, :print_task_list
    end

    it "defines print_local_status" do
      assert_respond_to klass, :print_local_status
    end

    describe "default task lists" do
      it "before tasks" do
        assert_equal [], klass.before_mina_tasks
      end

      it "after tasks" do
        assert_equal [], klass.after_mina_tasks
      end
    end # default task lists
  end # class scope

  describe "rake/mina scope" do
    before do
      mina_app.reset!
    end

    describe "before mina" do
      let(:task_list) { ["some:task", "some:other:task"] }

      it "adds tasks to the task list" do
        task do |t|
          t.before_mina *task_list
        end
        assert_equal task_list, mina_app.before_mina_tasks
      end

      it "adds more tasks to the list" do
        task do |t|
          t.before_mina *task_list
          t.before_mina "another:task"
        end
        assert_equal (task_list + ["another:task"]), mina_app.before_mina_tasks
      end
    end # before mina

    describe "after mina" do
      let(:task_list) { ["after:task"] }

      it "adds tasks to the task list" do
        task do |t|
          t.after_mina *task_list
        end
        assert_equal task_list, mina_app.after_mina_tasks
      end
    end # after mina

    describe "invoke tasks" do
      let(:mina) { mina_app }
      let(:task_list) { ["first:task", "second:task", "third:task"]}

      describe "when deploying" do
        it "invokes before mina in order" do
          mina.test_task do |t|
            t.before_mina *task_list
            t.invoke_before_mina_tasks
          end
          assert_equal task_list, mina.invoked_tasks
        end
      end

      it "invokes after mina in order" do
        mina.test_task do |t|
          t.after_mina *task_list
          t.invoke_after_mina_tasks
        end
        assert_equal task_list, mina.invoked_tasks
      end

      describe "when not deploying" do
        it "invokes before mina in order" do
          mina.test_task do |t|
            t.not_deploying!
            t.before_mina *task_list
            t.invoke_before_mina_tasks
          end
          refute_equal task_list, mina.invoked_tasks
        end

        it "invokes after mina in order" do
          mina.test_task do |t|
            t.not_deploying!
            t.after_mina *task_list
            t.invoke_after_mina_tasks
          end
          refute_equal task_list, mina.invoked_tasks
        end
      end
    end # invoke tasks

    describe "mina cleanup" do
      let(:mina) { mina_app }
      let(:before_task_list) { ["before:task:one", "before:task:two"] }
      let(:after_task_list)  { ["after:task:one", "after:task:two"]   }

      it "invokes all tasks" do
        mina.test_task do |t|
          t.before_mina *before_task_list
          t.after_mina *after_task_list
          t.mina_cleanup!
        end
        assert mina.cleanup_called, "cleanup_called must be true."
        assert_equal (before_task_list + after_task_list), mina.invoked_tasks
      end
    end # mina cleanup

  end # rake/mina scope
end
