#!/usr/bin/env ruby

require 'json'
require 'yaml'
require 'open3'

# Try to predict which service output we'll get by reading the VMFloaty config
# file and seeing if multiple services are defined. If none are, fall back to
# vmpooler
config_file = File.expand_path(File.join("~", ".vmfloaty.yml"))
config = if File.exist?(config_file)
           File.open(config_file, "r:UTF-8") do |f|
             YAML.safe_load(f.read)
           end
         end
service = ENV['PT_service'] || config&.dig('services')&.keys&.first || 'vmpooler'

# List active VMs, specifying a service if provided
cmd = %w[floaty list --active --json]
cmd += %W[--service #{ENV['PT_service']}] if ENV['PT_service']
stdout, stderr, status = Open3.capture3(*cmd)

# Handle failures
if status != 0
  result = { _error: {
    msg: "Failed to execute floaty: #{stderr}",
    kind: "execution-error",
    details: {
      exitcode: status.exitstatus
    }
  } }
  puts result.to_json
  exit 1
end

output = JSON.parse(stdout)
targets = if service == 'abs'
            output.values.dig(0, 'allocated_resources').map do |host|
              host['hostname']
            end
          elsif service == 'vmpooler'
            output.keys
          else
            result = { _error: {
              msg: "VMFloaty service must be either 'abs' or 'vmpooler', got #{service}",
              kind: "service-error",
              details: {
                exitcode: status.exitstatus
              }
            } }
            puts result.to_json
            exit 1
          end

result = { value: targets }
puts result.to_json
exit 0
