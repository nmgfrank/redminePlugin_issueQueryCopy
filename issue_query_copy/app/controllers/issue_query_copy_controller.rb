class IssueQueryCopyController < ApplicationController
  unloadable

  def get_ancestor_queries
    project_id = params['project_id']
    
    ancestor_ids = []
    
    project = Project.find_by_id(project_id)
    parent_project = nil
    if (!project.blank?) && (!project.parent_id.blank?)
        parent_project = Project.find_by_id(project.parent_id)
    end
    
    str = ""
    
    parent_proj_id_str = ""
    
    project_hash = {}
    # get all the visible ancestor projects
    while !parent_project.blank? do
        if parent_project.visible?
            parent_proj_id_str += parent_project.id.to_s + ","
            if !project_hash.has_key? parent_project.id
                project_hash[parent_project.id] = parent_project
            end
        end
        parent_project = Project.find_by_id(parent_project.parent_id)
    end
    
    queries_hash = {}
    
    if (parent_proj_id_str.length > 0) && (!User.current.blank?)
        parent_proj_id_str = parent_proj_id_str[0,parent_proj_id_str.length - 1]
        parent_proj_id_str = "(" + parent_proj_id_str + ")"
        queires_infos = IssueQuery.where(["project_id in #{parent_proj_id_str} and (user_id = '#{User.current.id.to_s}' or is_public = '1') "])
        
        queires_infos.each do |info|
            query_info = {}
            query_info['id'] = info.id
            query_info['project_id'] = info.project_id
            query_info['user_id'] = info.user_id
            query_info['query_name'] = info.name
            query_info['project_name'] = project_hash[info.project_id].name
            if !queries_hash.has_key? info.project_id
                queries_hash[info.project_id] = []
            end        
            queries_hash[info.project_id].push(query_info)
        end
    end
    
    render :text => queries_hash.to_json
  end
  
  
  def copy_query
    
    project_id = params['project_id']
    query_id = params['query_id']
    user_id = params['user_id']
    
    if (user_id.blank?) || (user_id.to_s != User.current.id.to_s)
        render :text => "{msg:'No User'}"
        return
    end
    
    query = IssueQuery.find(query_id)
    
    if query.blank?
        render :text => "{msg:'No Query'}"
        return
    end   
    
    query_new = IssueQuery.new
    query_new.project_id = project_id
    query_new.name = query.name
    query_new.filters = query.filters
    query_new.user_id = user_id
    query_new.is_public = query.is_public
    query_new.column_names = query.column_names
    query_new.sort_criteria = query.sort_criteria
    query_new.group_by = query.group_by
    query_new.type = query.type
    
    query_new.save
     
    
    render :text => 1
  
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end
