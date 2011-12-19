module Rockhall::ModelMethods

  # Call insert_subject on the descMetadata datastream
  def insert_subject(type, opts={})
    ds = self.datastreams["descMetadata"]
    node, index = ds.insert_subject(type,opts)
    return node, index
  end

  # Call remove_contributor on the descMetadata datastream
  # We only need the numbered index node since type is irrelevant
  def remove_subject(index)
    ds = self.datastreams["descMetadata"]
    result = ds.remove_subject(index)
    return result
  end

  # Call the insert_node method for PBcore xml
  def insert_node(type, opts={})
    ds = self.datastreams["descMetadata"]
    node, index = ds.insert_node(type,opts)
    return node, index
  end

  # Call the remove_node method for PBcore xml
  def remove_node(type, index)
    ds = self.datastreams["descMetadata"]
    result = ds.remove_node(type,index)
    return result
  end

end
