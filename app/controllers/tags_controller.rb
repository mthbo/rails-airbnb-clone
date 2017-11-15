class TagsController < ApplicationController
  skip_after_action :verify_policy_scoped
  def index
    @tags = ActsAsTaggableOn::Tag
            .where("name ILIKE ?", "%#{params[:name]}%")
            .where.not(name: params[:tags_chosen])
            .includes(:taggings)
            .where(taggings: {taggable_type: params[:taggable_type]})
    @tags = @tags.where(taggings: {context: params[:context] }) if params[:context]
    @tags.order!(taggings_count: :desc)
    render json: @tags
  end
end
