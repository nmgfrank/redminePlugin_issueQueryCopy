module IssueQueryCopy
    class Hooks < Redmine::Hook::ViewListener
        def view_issues_index_bottom(context = {})
            context[:controller].send(:render_to_string, {:partial => "hooks/issue_query_copy/view_issues_index_bottom", :locals => context})
        end    
    end
end
