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
        assert_equal klass.before_mina_tasks, []
      end

      it "after tasks" do
        assert_equal klass.after_mina_tasks, []
      end
    end # default task lists
  end # class scope

  describe "rake/mina scope" do
    describe "before mina" do
      let(:task_list) { ["some:task", "some:other:task"] }

      it "defines before_mina" do
        task do
          assert_respond_to self, :before_mina
        end
      end

      it "adds tasks to the task list" do
        task do
          before_mina *task_list
          assert_equal before_mina_tasks, task_list
        end
      end

      it "adds more tasks to the list" do
        task do
          before_mina *task_list
          before_mina "another:task"
          assert_equal before_mina_tasks, (task_list + ["another:task"])
        end
      end
    end # before mina

    describe "after mina" do
      let(:task_list) { ["after:task"] }

      it "defines after_mina" do
        task do
          assert_respond_to self, :after_mina
        end
      end

      it "adds tasks to the task list" do
        task do
          after_mina *task_list
          assert_equal after_mina_tasks, task_list
        end
      end
    end # after mina

    describe "invoke tasks" do
      let(:task_list) { ["first:task", "second:task", "third:task"]}

      it "invokes before mina in order" do
        task do
          before_mina *task_list
          invoke_before_mina_tasks
          assert_equal invoked_tasks, task_list
        end
      end

      it "invokes after mina in order" do
        task do
          after_mina *task_list
          invoke_after_mina_tasks
          assert_equal invoked_tasks, task_list
        end
      end
    end # invoke tasks

    describe "mina cleanup" do
      let(:before_task_list) { ["before:task:one", "before:task:two"] }
      let(:after_task_list)  { ["after:task:one", "after:task:two"]   }

      it "invokes all tasks" do
        task do
          before_mina *before_task_list
          after_mina *after_task_list
          mina_cleanup!
          assert cleanup_called
          assert_equal invoked_tasks, (before_task_list + after_task_list)
        end
      end
    end # mina cleanup

  end # rake/mina scope
end
