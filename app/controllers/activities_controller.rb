class ActivitiesController < ApplicationController

  def index
    @activities = PublicActivity::Activity.order(:created_at).reverse_order.limit(20)
  end

end
