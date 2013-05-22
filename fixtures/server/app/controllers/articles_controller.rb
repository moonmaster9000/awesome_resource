class ArticlesController < ApplicationController
  respond_to :json

  def index
    respond_with Article.all
  end

  def show
    respond_with Article.find(params[:id])
  end

  def update
    respond_with(Article.find(params[:id]).tap do |article|
      article.update_attributes params[:article]
    end)
  end

  def destroy
    respond_with Article.find(params[:id]).tap(&:destroy)
  end

  def create
    respond_with Article.create(params[:article])
  end
end