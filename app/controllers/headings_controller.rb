class HeadingsController < ApplicationController

  include Rockhall::Headings

  def index
    case
    when params[:term] == "subject"
      then @headings = subjects(params[:q])
    when params[:term] == "genre"
      then @headings = genres(params[:q])
    when params[:term] == "name"
      then @headings = names(params[:q])
    else
      @headings = subjects(params[:q])
    end      

    respond_to do |format|
      format.html { render :layout => false, :text => @headings.to_json }
      format.json { render :layout => false, :text => @headings.to_json }
      format.js   { render :layout => false, :text => @headings.to_json }
    end
  end

end
