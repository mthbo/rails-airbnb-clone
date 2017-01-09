class ObjectivesController < ApplicationController
  before_action :find_objective, only: [:update, :destroy]
  before_action :find_deal, only: [:create]

  def create
    @objective = @deal.objectives.new(objective_params)
    authorize @objective
    if @objective.save
      redirect_to proposition_deal_path(@deal)
    else
      render 'deals/proposition'
    end
  end

  def update
    if @objective.update(objective_params)
      redirect_to proposition_deal_path(@deal)
    else
      render 'deals/proposition'
    end
  end

  def destroy
    @objective.destroy
    redirect_to proposition_deal_path(@deal)
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
    params.require(:objective).permit(:description, :rating)
  end

end
