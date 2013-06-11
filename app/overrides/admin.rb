Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                   :name => "config_suppliers",
                   :insert_after => 'code[erb-loud]:contains("t(:inventory_settings)")',
                   :text => '<%= configurations_sidebar_menu_item t(:suppliers), admin_suppliers_path %>')

Deface::Override.new(:virtual_path => "spree/admin/shared/_tabs",
                   :name => "config_suppliers",
                   :insert_before => 'code[erb-loud]:contains("tab :reports")',
                   :text => "<%= tab :purchase_orders, :icon => 'icon-book' %>")
                   
Deface::Override.new(:virtual_path => "spree/admin/products/_form",
                   :name => "product_supplier",
                   :insert_before => 'code[erb-loud]:contains("f.field_container :shipping_categories")',
                   :partial => 'spree/admin/products/supplier')
