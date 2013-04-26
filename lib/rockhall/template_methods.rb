module Rockhall::TemplateMethods

# Object-level methods for inserting and deleting terms from datastreams
#
# Each method here references an existing method in HydraPbcore that 
# performs the action on the datastream.  We have to duplicated the 
# methods here to link them to the appropriate datastream so that they're
# available at the object level.

  # Used in conjunction with NodesController to call new_[node] on
  # a given node within the web GUI.
  def create_node(args)
    if self.respond_to?("new_"+args[:type])
      self.send(("new_"+args[:type]), args)
    else
      self.errors["node"] = "#{args[:type]} is not defined"
    end
  end

  def new_contributor(args)
    if args[:name]
      self.datastreams["descMetadata"].insert_contributor(args[:name], args[:role])
    else
      self.errors.add(:contributor_name)
    end
  end

  def delete_contributor(index)
    self.datastreams["descMetadata"].remove_node(:contributor, index)
  end

  def new_publisher(args)
    if args[:name]
      self.datastreams["descMetadata"].insert_publisher(args[:name], args[:role])
    else
      self.errors.add(:publisher_name)
    end
  end

  def delete_publisher(index)
    self.datastreams["descMetadata"].remove_node(:publisher, index)
  end

  def new_collection(args)
    if args[:name]
      self.datastreams["descMetadata"].insert_relation(args[:name], "Archival Collection")
    else
      self.errors.add(:additional_collection)
    end
  end

  def delete_collection(index = 0)
    self.datastreams["descMetadata"].remove_node(:collection, index, {:include_parent? => TRUE})
  end

  def insert_next(file)
    self.datastreams["descMetadata"].insert_next(file)
  end

  def insert_previous(file)
    self.datastreams["descMetadata"].insert_previous(file)
  end

  def define_physical_instantiation
    self.datastreams["descMetadata"].define :physical
  end

  def define_digital_instantiation
    self.datastreams["descMetadata"].define :digital
  end

end