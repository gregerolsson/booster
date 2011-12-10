require 'tilt'

module Booster

  # Tilt integration which pre-processes `.booster` files by wrapping them in a
  # CommonJS-like closure and converts inline templates to JavaScript functions
  # using the Handlebars compiler. While it is at it, it also does string interpolation
  # on regular JavaScript strings.
  class Tilt < Tilt::Template

    # Regex for capturing sections of template code to be compiled to JavaScript
    TEMPLATE_SECTION = /@@\s*([A-Za-z0-9]*)\n(((?!@@).)*)/m

    # Regex for capturing string interpolations
    STRING_INTERPOLATION = /('|")(.*)#\{([\s\S]+?)\}/

    # Processing Booster files result in plain JavaScript.
    def self.default_mime_type
      'application/javascript'
    end

    def evaluate(scope, locals, &block)
      # Replace template code with compiled JavaScript
      data.gsub! TEMPLATE_SECTION do
        "var #{$1} = #{Handlebars.precompile($2)}\n\n"
      end

      # Convert string interpolation to string concatenation with rudimentary
      # guessing of quote type ($1). Since the template functions compiled in the
      # previous step are just functions it is possible to use interpolations there
      # as well, even if Handlebars does not support them by default. This is not
      # recommended though although it works.
      data.gsub! STRING_INTERPOLATION, '\1\2\1 + (\3) + \1'

      # Wrap the whole thing in a closure and register it as a module (https://gist.github.com/1153919)
      @output ||= "\nrequire.define({'#{ module_name(scope) }': function(exports, require, module) {\n#{data}\n}});\n"
    end

  protected

    def module_name(scope)
      scope.logical_path #.split('/')[1..-1].join('/')
    end

    def basename(path)
      path.gsub(%r{.*/}, '')
    end

    def prepare
    end
  end
end
