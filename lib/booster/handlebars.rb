# Based on https://github.com/josh/ruby-coffee-script
require 'execjs'
require 'pathname'

module Booster

  # Support class for compiling Handlebars templates to JavaScript
  # source code using the Handlebars.js library with ExecJS.
  class Handlebars
    class << self
      def precompile(*args)
        context.call('Handlebars.precompile', *args)
      end

    private

      def context
        @context ||= ExecJS.compile(source)
      end

      def source
        @source ||= path.read + patched_source
      end

      # Renames the built-in nameLookup method to make Handlebars.js support name lookups not
      # only directly on an object (object.title), but also via the `Backbone.Model#get()` which
      # is the way Backbone.Model exposes data attributes for a particular model.
      #
      # `Hello {{name}}` will then try `context.name` and then `context.get('name')`
      # if `context.name` returns `undefined`.
      def patched_source
        <<-PATCHED_SOURCE
          Handlebars.JavaScriptCompiler.prototype.nameLookupOriginal = Handlebars.JavaScriptCompiler.prototype.nameLookup;
          Handlebars.JavaScriptCompiler.prototype.nameLookup = function(parent, name) {
            return "((" + parent + ".get ? " + parent + ".get('" + name + "') : undefined) || " +
              this.nameLookupOriginal(parent, name) + ")";
          }
        PATCHED_SOURCE
      end

      def path
        @path ||= assets_path.join('javascripts', 'handlebars.js')
      end

      def assets_path
        @assets_path ||= Pathname(__FILE__).dirname.join('..','..','vendor','assets')
      end
    end
  end
end
