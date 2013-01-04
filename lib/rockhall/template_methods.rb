module Rockhall::TemplateMethods

# Object-level methods for inserting and deleting terms from datastreams
#
# Each method here references an existing method in HydraPbcore that 
# performs the action on the datastream.  We have to duplicated the 
# methods here to link them to the appropriate datastream so that they're
# available at the object level.

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

  def new_publisher(publisher=nil, role=nil)
    self.datastreams["descMetadata"].insert_publisher(publisher, role)
  end

  def delete_publisher(index)
    self.datastreams["descMetadata"].remove_node(:publisher, index)
  end

  def insert_next(file)
    self.datastreams["descMetadata"].insert_next(file)
  end

  def insert_previous(file)
    self.datastreams["descMetadata"].insert_previous(file)
  end

end