module Rockhall::SolrMethods

  def get_year_from_date(term)
    result = String.new
    if term.match(/^[0-9]{4}$/)
      result = term
    else
      begin
        result = DateTime.parse(term).strftime("%Y")
      rescue
        result = nil
      end
    end
    return result
  end

end