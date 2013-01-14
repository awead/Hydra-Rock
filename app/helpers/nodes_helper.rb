module NodesHelper

  def create_node_path type
    parts = [ "/nodes", params[:id], type, "create" ]
    return parts.join("/")
  end

  def new_node_path type
    parts = [ "/nodes", params[:id], type, "new" ]
    return parts.join("/")
  end
    
end
