module SudayiBack
  class Admin < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl

    ##
    # Application configuration options
    #
    # set :raise_errors, true         # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true          # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true      # Shows a stack trace in browser (default for development)
    # set :logging, true              # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, "foo/bar"   # Location for static assets (default root/public)
    # set :reload, false              # Reload application files (default in development)
    # set :default_builder, "foo"     # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, "bar"         # Set path for I18n translations (default your_app/locales)
    # disable :sessions               # Disabled sessions by default (enable if needed)
    # disable :flash                  # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout              # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    set :admin_model, 'Account'
    set :login_page,  '/sessions/new'

    enable  :sessions
    disable :store_location

    access_control.roles_for :any do |role|
      role.protect '/'
      role.allow   '/sessions'
    end

    access_control.roles_for :admin do |role|
      role.project_module :tags, '/tags'
      role.project_module :coupons, '/coupons'
      role.project_module :product_points, '/product_points'
      role.project_module :firm_addresses, '/firm_addresses'
      role.project_module :supplier_addresses, '/supplier_addresses'
      role.project_module :courier_addresses, '/courier_addresses'
      role.project_module :store_addresses, '/store_addresses'
      role.project_module :order_times, '/order_times'
      role.project_module :order_settings, '/order_settings'
      role.project_module :image_items, '/image_items'
      role.project_module :firm_types, '/firm_types'
      role.project_module :comments, '/comments'
      role.project_module :error_infos, '/error_infos'
      role.project_module :firm_infos, '/firm_infos'
      role.project_module :credit_infos, '/credit_infos'
      role.project_module :pay_types, '/pay_types'
      role.project_module :states, '/states'
      role.project_module :back_orders, '/back_orders'
      role.project_module :orders, '/orders'
      role.project_module :courier_orders, '/courier_orders'
      role.project_module :product_stores, '/product_stores'
      role.project_module :product_details, '/product_details'
      role.project_module :products, '/products'
      role.project_module :categories, '/categories'
      role.project_module :store_products, '/store_products'
      role.project_module :courier_stores, '/courier_stores'
      role.project_module :courier_employees, '/courier_employees'
      role.project_module :streets, '/streets'
      role.project_module :store_employees, '/store_employees'
      role.project_module :stores, '/stores'
      role.project_module :supplier_accounts, '/supplier_accounts'
      role.project_module :customer_accounts, '/customer_accounts'
      role.project_module :courier_accounts, '/courier_accounts'
      role.project_module :details, '/details'
      role.project_module :node_ways, '/node_ways'
      role.project_module :nodes, '/nodes'
      role.project_module :areas, '/areas'
      role.project_module :cities, '/cities'
      role.project_module :provinces, '/provinces'
      role.project_module :countries, '/countries'
      role.project_module :addresses, '/addresses'
      role.project_module :accounts, '/accounts'
    end

    # Custom error management 
    error(403) { @title = "Error 403"; render('errors/403', :layout => :error) }
    error(404) { @title = "Error 404"; render('errors/404', :layout => :error) }
    error(500) { @title = "Error 500"; render('errors/500', :layout => :error) }
  end
end
