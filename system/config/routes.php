<?php

//Less define our simple routes in this file to help us map to the exact methods in our project

$route['']                                                  =               "Home/index";

/*
 * Static url slags
 */
//$route['access_token']                                      =               "Fcm/access_token";
$route['about-us']                                          =               "Home/about_us";
$route['ajax-search']                                       =               "Products/ajax_search";
$route['auth']                                              =               "Auth/index";
$route['boo-cash']                                          =               "Home/affiliate";
$route['boo-cash/enroll']                                   =               "Boo_cash/boo_cash_enroll";
$route['call-back']                                         =               "Cron/_payment_call_back";
$route['cart']                                              =               "Checkout/cart";
$route['category/new']                                      =               "Admin/new_category";
$route['category/new_sub_category']                         =               "Admin/new_sub_category";
$route['checkout']                                          =               "Checkout/index";
$route['checkout/place-order']                              =               "Checkout/place_holder";
$route['checkout/process']                                  =               "Checkout/process_cart";
$route['choose']                                            =               "Home/choose_session";
$route['comfirm-account']                                   =               "Dashboard/confirm_account";
$route['contact-us']                                        =               "Home/contact_us";
$route['create_cart']                                       =               "Home/create_cart";
$route['create_watchlist']                                  =               "Home/create_watchlist";
$route['create-account']                                    =               "Dashboard/create_account";
$route['currency/new_currency']                             =               "Admin/new_currency";
$route['dashboard']                                         =               "Admin/index";
$route['dashboard/affiliates']                              =               "Admin/affiliates";
$route['dashboard/applications']                            =               "Suppliers/supplier_applications";
$route['dashboard/categories']                              =               "Admin/categories";
$route['dashboard/colors']                                  =               "Products/colors";
$route['dashboard/currency']                                =               "Admin/currency";
$route['dashboard/metrics']                                 =               "Admin/metrics";
$route['dashboard/orders']                                  =               "Admin/orders";
$route['dashboard/products']                                =               "Products/products";
$route['dashboard/sizes']                                   =               "Products/sizes";
$route['dashboard/sub_cats']                                =               "Admin/sub_categories";
$route['dashboard/suppliers']                               =               "Suppliers/index";
$route['dashboard/users']                                   =               "Admin/users";
$route['delete_pic']                                        =               "Products/delete_product_pic";
$route['firebase']                                          =               "Fcm/save_new_token";
$route['firebase/customised']                               =               "Fcm/send_customised_notifications";
$route['firebase/send_notifications']                       =               "Fcm/send_notifications";
$route['firebase/update']                                   =               "Fcm/update_token";
$route['forgot-password']                                   =               "Home/forgot_password";
$route['get-cart-content']                                  =               "Home/get_cart_content";
$route['get_addresses']                                     =               "Dashboard/get_addresses";
$route['get_cart']                                          =               "Home/get_cart";
$route['make-payment']                                      =               "Home/make_payment";
$route['more-feeds']                                        =               "Home/more_feeds";
$route['metrics/new_metric']                                =               "Admin/new_metric";
$route['login']                                             =               "Dashboard/login";
$route['logout']                                            =               "Dashboard/logout";
$route['password']                                          =               "Home/password";
$route['payment_progress']                                  =               "Checkout/payment_progress";
$route['privacy']                                           =               "Home/privacy";
$route['product/comment']                                   =               "Products/add_comment";
$route['product/new']                                       =               "Products/new_product";
$route['products/activate_deactivate']                      =               "Products/change_status";
$route['products/add_new_product']                          =               "Products/add_new_product";
$route['products/add_thumbnail']                            =               "Products/add_thumbnail";
$route['products/add_thumbnail_url']                        =               "Products/add_thumbnail_url";
$route['products/new_colors']                               =               "Products/new_colors";
$route['products/new_sizes']                                =               "Products/add_new_sizes";
$route['product/rate']                                      =               "Products/rate_product";
$route['products/special_categories']                       =               "Products/manage_special_categories";
$route['products/update_product']                           =               "Products/update_product";
$route['products/update_product_color']                     =               "Products/update_product_color";
$route['products/update_product_size']                      =               "Products/update_product_size";
$route['products/viewed']                                   =               "Products/products_viewed";
$route['profile']                                           =               "Dashboard/index";
$route['profile/address']                                   =               "Dashboard/index";
$route['profile/details']                                   =               "Dashboard/index";
$route['profile/order']                                     =               "Dashboard/index";
$route['profile/update']                                    =               "Dashboard/update";
$route['register']                                          =               "Dashboard/register";
$route['search/products']                                   =               "Home/search_products";
$route['sell-with-boo']                                     =               "Home/become_a_supplier";
$route["send-pwd-reset"]                                    =               "Home/send_password_reset";
$route['site_map']                                          =               "Site_map/index";
$route['shop']                                              =               "Products/shop";
$route['subscribe']                                         =               "Home/subscribe";
$route['supplier']                                          =               "Home/supplier_dashboard";
$route['supplier/add_thumbnail']                            =               "Suppliers/add_thumbnail";
$route['supplier/apply']                                    =               "Suppliers/apply";
$route['supplier/new_supplier']                             =               "Suppliers/new_supplier";
$route['supplier/edit_supplier']                            =               "Suppliers/edit_supplier";
$route['supplier/update']                                   =               "Suppliers/update_application";
$route['terms']                                             =               "Home/terms";
$route['transactions']                                      =               "Boo_cash/get_affiliate_transactions";
$route['watchlist']                                         =               "Dashboard/index";
$route['welcome']                                           =               "Home/welcome";

/*
 * Cron jobs
 */
$route['cron/successful_payments']                          =               "Cron/send_payment_mails";
$route['cron/welcome_mail']                                 =               "Cron/send_welcome_mail";

/*
 * Dynamic url slags
 */

$route['boo-cash/(:any)']                                   =               "Boo_cash/auth_affiliate/$1";
$route['cart/remove_item/(:any)']                           =               "Home/remove_from_cart/$1";
$route['confirm-account/(:any)']                            =               "Dashboard/confirm_account/$1";
$route['dashboard/(:any)']                                  =               "Products/view_product/$1";
$route['dashboard/application/(:any)']                      =               "Suppliers/view_application/$1";
$route['dashboard/order/(:any)']                            =               "Admin/orders/$1";
$route['dashboard/supplier/(:any)']                         =               "Suppliers/view_supplier/$1";
$route['dashboard/users/(:any)']                            =               "Admin/user_profile/$1";
$route['duplicate/(:any)']                                  =               "Products/duplicate_item/$1";
$route['product/(:any)']                                    =               "Products/product/$1";
$route['profile/order/(:any)']                              =               "Dashboard/index/$1";
$route['replace-order/(:any)']                              =               "Home/replace_order/$1";
$route['reset-password/(:any)']                             =               "Home/reset_password/$1";
$route['rony-cash/(:any)']                                  =               "Boo_cash/auth_affiliate/$1";
$route['sub-category/(:any)']                               =               "Products/sub_category/$1";
$route['sub_categories/add_to_home/(:any)']                 =               "Categories/add_to_home/$1";
$route['supplier/(:any)']                                   =               "Suppliers/get_supplier/$1";
$route['supplier/view/(:any)']                              =               "Home/view_supplier_business/$1";
$route['thumbnail/make_feature/(:any)/(:any)']              =               "Products/make_feature_photo/$1/$2";
$route['update_version']                                    =               "Dashboard/_update_app_version";
$route['watchlist/delete/(:any)']                           =               "Home/delete_watchlist_item/$1";

$route['profile/(:any)']                                    =               "Home/order/$1";
$route['(:any)']                                            =               "Products/index/$1";
