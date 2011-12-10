require 'test_helper'

module Booster
  class TiltTest < Test::Unit::TestCase
    def test_render
      scope = Object.new
      class << scope
        def logical_path
          'models/user'
        end
      end

      template = Booster::Tilt.new('/myapp/app/assets/javascripts/models/user.js.booster') {
        <<-FILE
  exports.Index = booster.View.extend({
    greeting: 'This is Booster \#{this.version}!'
  });

  @@ layout
  <h1 data-yield="title"></h1>
  <div data-yield="content"></div>

  @@ index
  <ul>
    {{#each models}}
      <li>{{name}}</li>
    {{/each}}
  </ul>
        FILE
      }

      puts template.render(scope, {})
    end
  end
end
