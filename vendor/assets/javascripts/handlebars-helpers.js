// Replaces the built-in each helper to support Backbone collections and JavaScript Objects
Handlebars.registerHelper('each', function(ctx, options) { 
  var context = typeof ctx == "function" ? ctx.call(this) : ctx; 
  var block = options.fn, inverse = options.inverse; 
  var ret = ""; 

  // Navigate into models arrays if context is a Backbone.Collection. 
  if (context && context.models != undefined) { 
    context = context.models; 
  } 

  // Allow context to be an array or a regular JavaScript object, in which 
  // case we iterate over each attribute in the object and supply a name/value 
  // pair context to the block. 
  if (context) { 
    if (_.isArray(context)) { 
      for ( var i = 0, j = context.length; i < j; ++i) { 
        ret = ret + block(context[i]); 
      } 
    } else { 
      _.each(context, function(value, key) { 
        ret = ret + block({ 
          key : key, 
          value : value 
        }); 
      }) 
    } 
  } else { 
    ret = inverse(this); 
  } 
  return ret; 
});

Handlebars.registerHelper('if', function(cond, options) { 
  cond = (typeof cond == 'function' ? cond.call(this) : cond);
  if (cond) {
    return options.fn(this);
  } else {
    if (options.inverse) {
      return options.inverse(this);
    }
  }
});

Handlebars.registerHelper('unless', function(cond, options) {
  cond = (typeof cond === 'function' ? cond.call(this) : cond);
  return Handlebars.helpers['if'].call(this, !cond, options);
});

// Replaces the built-in Handlebars.js #with helper to support function values.
Handlebars.registerHelper('with', function(context, options) {
  if (typeof context === 'function') {
    context = context.call(this);
  }
  return options.fn(context);
});
