Cached pages with updated partials.<br/>

Serve completely cached pages, but keep e.g. "Welcome <%= current_user %>" updated.<br/>
Does not influence not-cached actions.

Basics
======
**Up and running in 23 seconds or money back!**

### Install (5s)
[Rails 2 Version](http://github.com/grosser/easy_esi/tree/rails2)

    gem install easy_esi
Or

    rails plugin install git://github.com/grosser/easy_esi.git

### Action-cache the controller (5s)
    class UsersController < ApplicationController
      caches_action :show
      enable_esi
    end

### Refactor partials that should stay updated (3s)
Has no effect for non-esi controllers!
    <%= render 'profile' %>
    IS NOW
    <%= esi_render 'profile' %>

    <%= render 'profile', :local_variable => :foo %>
    IS NOW
    <%= esi_render :partial => 'profile', :locals => {:local_variable => :foo} %>

### Realize that its that simple (10s)

Behind the scenes
=================
`esi_render` inserts an esi-include (`<esi:include .... />`).<br/>
an `after_filter` or easy-esi-rails-cache-hack replaces these by rendering the partial.<br/>
==> if you want to share view caches between controllers,
call enable_esi in all of them (or in ApplicationController).

Comparison
===========
Normally ESI means having an extra server that parses `<esi>` tags and then calls your app to render these partials.
Which adds a whole lot of new problems(passing arguments, login, expiration, security...).
On top of that it will slow down your application unless you do everything so perfect that it gets
faster then a action-cached request (which is really hard...).

With 'hard' Esi, each `<esi>` tag causes a new, (yet small) request which needs to load all data (instance-variables) anew.<br/>
With easy-esi, each `<esi>` tag causes a partial to be rendered, inside the current context, re-using instance-variables.

Compared to normal [ESI](http://en.wikipedia.org/wiki/Edge_Side_Includes) this means:

 - Testable caching
 - Enabled per-controller
 - No global changes
 - Deactivatable at any moment
 - before-filters still work
 - No extra server
 - No new actions
 - No duplicate server requests
 - No new configuration language
 - No purge requests
 - No external dependencies
 - ...

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
