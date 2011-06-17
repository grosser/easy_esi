[Rails 2 Version](http://github.com/grosser/easy_esi/tree/rails2)

Cached pages with dynamic partials == Easy ESI.

Compared to 'standard/complicated/hard' ESI:

 - Testable
 - Per-controller
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

Basics
======
**Up and running in 23 seconds or money back!**

### Install (5s)
    rails plugin install git://github.com/grosser/easy_esi.git -r rails3

### Action-cache the controller (5s)
    class UserController < ApplicationController
      caches_action :show
      enable_esi
    end

### Make dynamic partials into esi includes (3s)
Has no effect for non-esi controllers!
    <%= render 'profile' %>
    IS NOW
    <%= esi_render 'profile' %>

### Realize that its that simple (10s)

Advanced
========
Partials rendered inside an esi-controller, using `esi_render`, will render as esi-includes (`<esi:include .... />`).<br/>
Do not cache these results in a view-cache, which non-esi controllers use too.

Normally ESI means having an extra server that parses `<esi>` tags and then calls your app to render these partials.
Which adds a whole lot of new problems(passing arguments, login, expiration, security...).
On top of that it will slow down your application unless you do everything so perfect that it gets
faster then a action-cached request (which is really hard...).

With 'hard' Esi, each `<esi>` tag causes a new, (yet small) request which needs to load all data anew.<br/>
With easy-esi, each `<esi>` tag causes a partial to be rendered, inside the current context, without loading any new data.

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
Hereby placed under public domain, do what you want, just do not hold me accountable...
