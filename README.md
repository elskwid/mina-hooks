# mina-hooks

* [Homepage](https://github.com/elskwid/mina-hooks#readme)
* [Issues](https://github.com/elskwid/mina-hooks/issues)
* [Documentation](http://rubydoc.info/gems/mina-hooks/frames)
* [Email](mailto:don at elskwid.net)

## Description

Mina plugin to provide local task hooks that run before and after the mina
commands.

Mina uses a queueing system to create a deploy script that executes on the
remote system but that leaves no way to know when the deploy has started or
ended.

`mina-hooks` gets around this limitation by defining a new `mina_cleanup!`
method that does the following:

* invoke each of the `before_mina_tasks`
* delegate to the pre-existing `mina_cleanup!`
* invoke each of the `after_mina_tasks`

### Warning

This is extremenly dependant on Mina internals so buyer beware. However,
it's not a lot of code so we should be fine. It will all be just fine.

## Features

### Easily add tasks

Helper methods to add tasks to the lists: (see Usage)

  * `before_mina`
  * `after_mina`

### Access the task lists

Lists of tasks to be run before and after the mina commands:

  * `before_mina_tasks`
  * `after_mina_tasks`

### Output
Prints confirmation that the hook is running

* `<----- Invoke before mina tasks`
* `<----- Invoke after mina tasks`

Prints task list using Mina-style output if set to verbose

* `>> tasks: some:task, some:other:task`

### Still Just Rake

Task invocation is still handled by Rake and operates under the same
rules you've come to expect.

## Usage

```ruby
require "mina/hooks"
```

### before_mina

```ruby
# Inside your deploy tasks ...

before_mina :"some:task", :"some:other:task"
before_mina :"task:added:later"

puts before_mina_tasks.inspect
# => [:"some:task", :"some:other:task", :"task:added:later"]

# ...
```

### after_mina

```ruby
# Still inside your deploy tasks ...

after_mina :"some:task", :"some:other:task"
after_mina :"task:added:later", :"some:task"

puts after_mina_tasks.inspect
# => [:"some:task", :"some:other:task", :"task:added:later", :"some:task"]

# ...
```

Because this is Rake, the above task `some:task` will only be invoked once.

## Requirements

  * [mina](https://github.com/nadarei/mina)

## Install

    $ gem install mina-hooks

## Copyright

Copyright (c) 2013 Don Morrison

See {file:LICENSE.txt} for details.
