class BookmarksController < ApplicationController
  before_filter :load_bookmark, :except => :index

  def index
    @bookmarks = Bookmark.all
  end
  def show
    @bookmark = Bookmark.find(params[:id])
  end
  def new
  end
  def edit
  end
  def create
    @bookmark.attributes = params[:bookmark]
    if @bookmark.save
      redirect_to @bookmark
    else
      render 'new'
    end
  end
  def update
    if @bookmark.update_attributes params[:bookmark]
      redirect_to @bookmark
    else
      render 'edit'
    end
  end
  def destroy
    @bookmark.destroy
    redirect_to Bookmark
  end
  
  def click
    @bookmark.click!
    redirect_to @bookmark.url
  end

  private
  
  def load_bookmark
    @bookmark = params[:id] ? Bookmark.find(params[:id]) : Bookmark.new
  end
end
