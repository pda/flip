Flip &mdash; flip your features
================

**Flip** provides a declarative, layered way of enabling and disabling application functionality at run-time.

This gem optimizes for:

* developer ease-of-use,
* visibility and control for other stakeholders (like marketing); and
* run-time performance

There are three layers of strategies per feature:

* default
* database, to flip features site-wide for all users
* cookie, to flip features just for you (or someone else)

There is also a configurable system-wide default - !Rails.env.production?` works nicely.

Flip has a dashboard UI that's easy to understand and use.

![Feature Flipper Dashboard](https://dl.dropbox.com/u/13833591/flip-gem-dashboard.png "Feature Flipper Dashboard")

Install
-------

**Rails 3.0 and 3.1+**

    # Gemfile
    gem "flip"
    
    # Generate the model and migration
    > rails g flip:install
    
    # Run the migration
    > rake db:migrate


Declaring Features
------------------

    # This is the model class generated by rails g flip:install
    class Feature < ActiveRecord::Base
      include Flip::Declarable

      # The recommended Flip strategy stack.
      strategy Flip::CookieStrategy
      strategy Flip::DatabaseStrategy
      strategy Flip::DefaultStrategy
      default false
    
      # A basic feature declaration.
      feature :shiny_things

      # Override the system-wide default.
      feature :world_domination, default: true

      # Enabled half the time..? Sure, we can do that.
      feature :flakey,
        default: proc { rand(2).zero? }

      # Provide a description, normally derived from the feature name.
      feature :something,
        default: true,
        description: "Ability to purchase enrollments in courses",
    
    end


Checking Features
-----------------

`Flip.on?` or the dynamic predicate methods are used to check feature state:

    Flip.on? :world_domination   # true
    Flip.world_domination?       # true
    
    Flip.on? :shiny_things       # false
    Flip.shiny_things?           # false

Views and controllers use the `feature?(key)` method:

    <div>
      <% if feature? :world_domination %>
        <%= link_to "Dominate World", world_dominations_path %>
      <% end %>
    </div>


Feature Flipping Controllers
----------------------------

The `Flip::ControllerFilters` module is mixed into the base `ApplicationController` class.  The following controller will respond with 404 Page Not Found to all but the `index` action unless the :new_stuff feature is enabled:

    class SampleController < ApplicationController
    
      require_feature :something, :except => :index
    
      def show
      end
    
      def index
      end
    
    end

Dashboard
---------

The dashboard provides visibility and control over the features.

The gem includes some basic styles:

    = content_for :stylesheets_head do
      = stylesheet_link_tag "flip"

You probably don't want the dashboard to be public.  Here's one way of implementing access control.

app/controllers/admin/features_controller.rb:

    class Admin::FeaturesController < Flip::FeaturesController
      before_filter :assert_authenticated_as_admin
    end

app/controllers/admin/feature_strategies_controller.rb:

    class Admin::FeatureStrategiesController < Flip::FeaturesController
      before_filter :assert_authenticated_as_admin
    end

routes.rb:

    namespace :admin do
      resources :features, only: [ :index ] do
        resources :feature_strategies, only: [ :update, :destroy ]
      end
    end

    mount Flip::Engine => "/admin/features"

----
Created by Paul Annesley
Copyright © 2011-2013 Learnable Pty Ltd, [MIT Licence](http://www.opensource.org/licenses/mit-license.php).
