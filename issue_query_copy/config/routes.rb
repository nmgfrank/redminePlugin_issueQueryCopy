# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match '/issue_query_copy/:project_id/get_ancestor_queries', :to => 'issue_query_copy#get_ancestor_queries', :via => [:get, :post]

match '/issue_query_copy/:project_id/copy_query', :to => 'issue_query_copy#copy_query', :via => [:get, :post]









