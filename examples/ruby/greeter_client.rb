#!/usr/bin/env ruby

# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Sample app that connects to a Greeter service.
#
# Usage: $ path/to/greeter_client.rb

this_dir = __dir__
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'grpc'
require 'helloworld_services_pb'

# GRPC_ENABLE_FORK_SUPPORT=1 ruby greeter_client.rb

def test_fork(_user, hostname)
  p "GRPC VERSION: #{GRPC::VERSION}"
  stub = Helloworld::Greeter::Stub.new(hostname, :this_channel_is_insecure)
  message = stub.say_hello(Helloworld::HelloRequest.new(name: 'prefork parent')).message
  p "Greeting: #{message}"

  GRPC.prefork
  pid = fork do
    GRPC.postfork_child
    message = stub.say_hello(Helloworld::HelloRequest.new(name: 'postfork child')).message
    p "Greeting: #{message}"
    exit(0)
  end

  GRPC.postfork_parent
  message = stub.say_hello(Helloworld::HelloRequest.new(name: 'postfork parent')).message
  p "pid: #{pid}"
  p "Greeting: #{message}"

  Process.wait(pid)
end

def sanity_check(user, hostname)
  stub = Helloworld::Greeter::Stub.new(hostname, :this_channel_is_insecure)
  message = stub.say_hello(Helloworld::HelloRequest.new(name: user)).message
  p "Greeting: #{message}"
end

def main
  user = ARGV.size > 0 ? ARGV[0] : 'world'
  hostname = ARGV.size > 1 ? ARGV[1] : 'localhost:50051'
  # sanity_check(user, hostname)

  for i in 0..1000
    test_fork(user, hostname)
  end
end

main
