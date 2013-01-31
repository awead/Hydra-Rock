module NodesHelper

  def create_node_path type
    parts = [ "nodes", params[:id], type, "create" ]
    url = parts.join("/")
    return (root_path + url)
  end

  def new_node_path type
    parts = [ "nodes", params[:id], type, "new" ]
    url = parts.join("/")
    return (root_path + url)
  end

  def delete_node_path type, index
    parts = [ "nodes", params[:id], type, "destroy", index ]
    url = parts.join("/")
    return (root_path + url)
  end
    
end
