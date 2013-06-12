require 'curb'

module Rockhall::Headings

  def subjects query = String.new
    query.empty? ? [] : (suggested_facets_from_solr("subject_facet", query)+lcsh_suggestions(query)).uniq.sort
  end

  def genres query = String.new
    query.empty? ? [] : suggested_facets_from_solr("genre_facet", query).uniq.sort
  end

  def names query = String.new
    query.empty? ? [] : suggested_facets_from_solr("contributor_name_facet", query).uniq.sort
  end  

  def suggested_facets_from_solr facet, query
    args = { :qt => "standard", :facet => true, "facet.field" => facet, "facet.prefix" => query }
    result = ActiveFedora::SolrService.instance.conn.get("select", :params=>args)
    return result["facet_counts"]["facet_fields"][facet].flatten.delete_if { |t| t.is_a? Fixnum }
  end

  def lcsh_suggestions query
    http = Curl.get("http://id.loc.gov/authorities/suggest/?q="+query)
    array = eval(http.body_str.force_encoding("UTF-8"))
    return array[1]
  end

  # TODO: include FAST results
  # http://fast.oclc.org/fastSuggest/select?q=suggestall+%3AHun&fl=suggestall&wt=json
  def fast_suggestions query
    return []
  end

end