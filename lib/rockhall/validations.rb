module Rockhall::Validations

  include Rockhall::WorkflowMethods

  def validate_creation_date
    date_format(:creation_date)
  end

  def validate_date
    date_format(:date)
  end

  def date_format(date)
    unless self.send(date).first.blank?
      if parse_date(self.send(date).first).nil?
        errors.add(date, "Date must be in YYYY-MM-DD format, or YYYY-MM, or just YYYY")
      else
        self.send((date.to_s+"=").to_sym, parse_date(self.send(date).first))
      end
    end
  end


end