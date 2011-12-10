> Note that this project is very new and hardly usable for anything.
> The documentation is just started and will be completed before
> the end of 2011.

## What is it?

Booster is a RubyGem with support for writing rich client applications using
Backbone.js and Handlebars.js. It integrates with the Rails Asset Pipeline
in a somewhat peculiar way:

* Booster assets have the `.booster` extension and can contain both
  JavaScript and Handlebars markup __in the same file__. Handlebars templates
  are compiled to JavaScript functions inline during processing.
* String interpolations are supported.
* Each processed asset is wrapped in a CommonJS-like API inspired by
  [this Gist](https://gist.github.com/1153919) so that each asset
  essentially becomes a module closure that can be required by other modules.

In addition to the Asset Pipeline processor, Booster supplies a set of
assets of its own that can be used in your applications. This includes
support functionality on top of Backbone.js and Handlebars.js that you
can choose to extend from rather than the stock Backbone types. This
is explained in more detail below.

## Usage

Include the gem in your Gemfile:

**Gemfile:**

    group :assets do
      gem 'booster'
    end

Require Booster in your application asset manifest which, in turn, will
include Underscore.js, Backbone.js, and Handlebars.js (only the runtime part),
on which Booster depends. You also need to require jQuery (supplied by Rails) before
requiring Booster.

**app/assets/javascript/application.js:**

    //= require jquery
    //= require booster

This includes everything in Booster, including additional functionality for Backbone
and Handlebars which you may not need. If you only need the core Booster functionality
which includes module support and the Backbone and Handlebars dependencies, require
the core asset:

**app/assets/javascript/application.js:**

    //= require jquery
    //= require booster-core

## Example

The `app/assets/javascripts/views/user.js.booster` asset below exports
two Backbone views, `Show` and `Edit`, used for dealing with user models.
In this example, both views are defined in the same module and the templates used by the
views are defined in the same file, similar to what is
[possible in Sinatra](http://www.sinatrarb.com/intro#Inline%20Templates)

**app/assets/javascripts/views/user.js.booster:**

```javascript
exports.Show = Backbone.View.extend({
  /* ... */

  render: function() {
    $(this.el).html(show(this.model));
  }

  /* ... */
});

exports.Edit = Backbone.View.extend({
  /* ... */
  
  render: function() {
    $(this.el).html(edit(this.model));
  }

  /* ... */
})

@@ show
  <h2>{{firstName}} {{lastName}}</h2>
  <pre>{{address}}</pre>
  ...

@@ edit
  <input name="firstName" value="{{firstName}}"/>
  <textarea name="firstName">{{address}}</textarea>
```

If templates are included in an asset they are to be placed at the bottom of the
file. Each template is compiled to a JavaScript function with the same name
as the `@@ identifier` and can be invoked directly from anywhere in the module as
can be seen in the `render()` functions above.

To use this module, say from a router, you require it like a regular CommonJS module.

**app/assets/javascripts/routers/user.js.booster:**

```javascript
var views = require('../models/user');

exports = Backbone.Router.extend({
  routes: {
    '/users/:id':      'show',
    '/users/:id/edit': 'edit'
  }

  show: function(id) {
    var view = new views.Show({
      model: /* load model */
    });
    /* add view to layout */
  },

  edit: function(id) {
    var view = new views.Edit({
      model: /* load model */
    });
    /* add view to layout */
  }
});
```

## Support Functionality

Booster includes some support functionality that we often use in our own applications. This
includes JavaScript mixins for various things like models, collections, and views, as well
as basic support for I18N and nested models and collections.

This support is included by default in the `//= require booster` asset described in __Usage__ above
so if you required the full Booster you are set. If you have `//= require`'d `booster-core` which does
not include the extra support you can add the support on top of core:

**app/assets/javascript/application.js:**

    //= require jquery
    //= require booster-core
    //= require booster-support

We might introduce additional Booster assets in the future which can be required in the same way.

### Nested Models and Collections

> To be described

### I18N

> To be described

## Rails 3 Generators

> To be described

We are working on a set of Rails 3 generators that can be used to speed up development. Using these
generators you can create models, views, and routers, or complete scaffolds using the following
commands:

    > rails g booster:model Discussion
    > rails g booster:view Discussion [index [show [edit]]]
    > rails g booster:router Discussion
    > rails g booster:scaffold Discussion

This will generate Booster modules for each type of artefact with a skeleton implementation to get
you going quickly. It will also generate specs based on the Jasmine BDD library.