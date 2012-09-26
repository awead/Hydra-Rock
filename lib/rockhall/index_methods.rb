module Rockhall::IndexMethods

  def gather_terms(terms)
    results = Array.new
    terms.each { |r| results << r.text }
    return results.compact.uniq
  end

  def format_contributors_display(results = Array.new)
    (0..(self.find_by_terms(:contributor_name).count - 1)).each do |index|
      if self.find_by_terms(:contributor_role)[index].text.empty?
        results << self.find_by_terms(:contributor_name)[index]
      else
        results << self.find_by_terms(:contributor_name)[index].text + " (" + self.find_by_terms(:contributor_role)[index].text + ")"
      end
    end
    return results
  end

end