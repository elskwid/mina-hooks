require 'helper'
require 'mina/hooks'

class TestMina::Hooks < Minitest::Test

  def test_version
    version = Mina::Hooks.const_get('VERSION')

    assert(!version.empty?, 'should have a VERSION constant')
  end

end
