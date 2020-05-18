#!/usr/bin/env ruby

require 'json'
require 'open3'

stdout, stderr, status = Open3.capture3('floaty', 'list', '--active')

if status != 0
  result = {_error: {msg: "Failed to execute floaty: #{stderr}", kind: "execution-error", details: {exitcode: status.exitstatus}}}
  puts result.to_json
  exit 1
end

targets = stdout.split("\n").drop(1)
targets.map! { |t| t.split(' ')[1] }

result = { value: targets }
puts result.to_json
exit 0
