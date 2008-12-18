module Stratus::Generator
  
  def self.config
    ::Stratus.settings[:generator]
  end
  
end

require 'stratus/generator/builder'
require 'stratus/generator/context'
require 'stratus/generator/renderer'
require 'stratus/generator/scanner'
