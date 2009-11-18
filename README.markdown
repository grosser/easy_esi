Simple yet powerful ESI.  

 - Simple
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

Basics
======
**Up and running in 23 seconds or money back!**

### Install (5s)
    script/plugins install git://github.com/grosser/easy_esi.git

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
Partials rendered using `esi_render` will render as esi-includes (`<esi:include .... />`) when you are inside an esi-controller,
do not cache their result in a view-cache, which non-esi controllers use.

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...