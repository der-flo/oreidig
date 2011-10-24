class BookmarksController < ApplicationController

  # TODO Sven: CrudController daraus bauen
  respond_to :json

  before_filter :fetch_bookmark, only: [:update, :destroy]
  before_filter :new_bookmark, only: [:create]

  def index
    respond_with Bookmark.all
  end

  def hot
    respond_with Bookmark.hot
  end

  def recent
    respond_with Bookmark.recent
  end

  def create
    bookmark = Bookmark.new params[:bookmark]
    if bookmark.save
      respond_with bookmark, status: :created, location: bookmark
    else
      respond_with bookmark.errors, status: :unprocessable_entity
    end
  end

  def update
    if @bookmark.update_attributes params[:bookmark]
      respond_with @bookmark
    else
      respond_with bookmark.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @bookmark.destroy
      respond_with @bookmark, status: :accepted
    else
      respond_with @bookmark, status: :not_found
    end
  end

  private

  def fetch_bookmark
    @bookmark = Bookmark.find params[:id]
  end

  def new_bookmark
    @bookmark = Bookmark.new
  end

end
