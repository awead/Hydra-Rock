# Object-level methods for inserting and deleting terms from datastreams
#
# Each method here references an existing method in HydraPbcore that 
# performs the action on the datastream.  We have to duplicated the 
# methods here to link them to the appropriate datastream so that they're
# available at the object level.

module Rockhall::TemplateMethods

  include Rockhall::WorkflowMethods

  # Used in conjunction with NodesController to call new_[node] on
  # a given node within the web GUI.
  def create_node(args)
    self.respond_to?("new_"+args[:type]) ? self.send(("new_"+args[:type]), args) : self.errors["node"] = "#{args[:type]} is not defined"
  end

  # Special method to call the appropriate event field, such as event_series,
  # event_place or event_date.
  def new_event args
    self.respond_to?("event_"+args[:event_type]) ? self.send(("new_event_"+args[:event_type]), args) : self.errors["event"] = "Event type #{args[:event_type]} is not defined"
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

  def new_collection args
    if args[:name]
      self.datastreams["descMetadata"].insert_relation(args[:name], "Archival Collection")
    else
      self.errors.add(:additional_collection)
    end
  end

  def delete_collection index = 0
    self.datastreams["descMetadata"].remove_node(:collection, index, {:include_parent? => TRUE})
  end

  def new_event_series args
    if args[:event_value]
      self.datastreams["descMetadata"].insert_relation args[:event_value], "Event Series"
    else
      self.errors.add :event_series
    end
  end

  # Note: we're deleting the term "series" as defined in HydraPbcore, which is delegated to
  # event_series at the model level.
  def delete_event_series index = 0
    self.datastreams["descMetadata"].remove_node(:series, index, {:include_parent? => TRUE})
  end

  def new_event_place args
    if args[:event_value]
      self.datastreams["descMetadata"].insert_place args[:event_value]
    else
      self.errors.add :event_place
    end
  end

  def delete_event_place index = 0
    self.datastreams["descMetadata"].remove_node(:event_place, index, {:include_parent? => TRUE})
  end

  def new_event_date args
    if args[:event_value]
      parse_date(args[:event_value]).nil? ? self.errors.add(:event_date, "Date must be in YYYY-MM-DD format, or YYYY-MM, or just YYYY") : self.datastreams["descMetadata"].insert_date(args[:event_value])
    else
      self.errors.add :event_date 
    end
  end

  def delete_event_date index = 0
    self.datastreams["descMetadata"].remove_node(:event_date, index, {:include_parent? => TRUE})
  end

  def insert_next file
    self.datastreams["descMetadata"].insert_next file
  end

  def insert_previous file
    self.datastreams["descMetadata"].insert_previous file
  end

  def define_physical_instantiation
    self.datastreams["descMetadata"].define :physical
  end

  def define_digital_instantiation
    self.datastreams["descMetadata"].define :digital
  end

end