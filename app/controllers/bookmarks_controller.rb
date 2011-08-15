class BookmarksController < ApplicationController
  before_filter :load_bookmark, :only => [:edit, :update, :destroy, :show]
  before_filter :new_bookmark, :only => [:new, :create]

  def index
    @bookmarks = Bookmark.all
  end

  public

  def hot
    @bookmarks = Bookmark.hot
    render :index
  end

  def most_recent
    @bookmarks = Bookmark.most_recent
    render :index
  end

  def new
  end

  def edit
  end

  def create
    @bookmark.attributes = params[:bookmark]
    if @bookmark.save
      raise "saved"
      redirect_to @bookmark
    else
      raise "shit"
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

  def show
    @bookmark.click!
    redirect_to @bookmark.url
  end

  private

  def load_bookmark
    @bookmark = Bookmark.find params[:id]
  end

  def new_bookmark
    @bookmark = Bookmark.new
  end

end
