require "mina/hooks/version"
require "mina/hooks/plugin"

if defined?(Mina) && self.respond_to?(:mina_cleanup!)
  extend Mina::Hooks::Plugin
end
