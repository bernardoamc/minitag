# frozen_string_literal: true

require 'minitag'

# Plugin extension to allow developers to run their tests while specifying
# the `--tag` or `-t` options.
module Minitest
  def self.plugin_minitag_options(opts, options)
    opts.on '-t', '--tag TAG' do |tag|
      options[:tags] ||= []
      options[:tags] << tag.to_s.strip.downcase
    end
  end

  def self.plugin_minitag_init(options)
    Array(options[:tags]).each do |tag|
      Minitag.add_filter(tag)
    end
  end
end
