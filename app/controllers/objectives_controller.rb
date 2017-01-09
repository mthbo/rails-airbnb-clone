class ObjectivesController < ApplicationController
  before_action :find_objective, only: [:update, :destroy]
  before_action :find_deal, only: [:create]
  layout 'devise', only: [:create, :update, :destroy]

  def create
    @objective = Objective.new(objective_params)
    @objective.deal = @deal
    authorize @objective
    if @objective.save
      respond_to do |format|
        format.html { redirect_to proposition_deal_path(@deal) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render 'deals/proposition' }
        format.js
      end
    end
  end

  # Update to do for rating
  def update
    @deal = @objective.deal
    if @objective.update(objective_params)
      redirect_to proposition_deal_path(@deal)
    else
      render 'deals/proposition'
    end
  end

  def destroy
    @objective.destroy
    @deal = @objective.deal
    respond_to do |format|
      format.html { redirect_to proposition_deal_path(@deal) }
      format.js
    end
  end

  private

  def find_deal
    @deal = Deal.find(params[:deal_id])
  end

  def find_objective
    @objective = Objective.find(params[:id])
    authorize @objective
  end

  def objective_params
    params.require(:objective).permit(:description, :rating, :deal)
  end

end
