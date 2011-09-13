class BookmarksController < ApplicationController
  before_filter :fetch_bookmark,
                only: [:new, :edit, :create, :update, :destroy, :show]

  def index
    @bookmarks = Bookmark.all
  end

  def hot
    @bookmarks = Bookmark.hot
    render :index
  end

  # TODO Sven: "recent"?
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
      # TODO Sven
      raise "saved"
      redirect_to @bookmark
    else
      # TODO Sven
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

  def fetch_bookmark
    @bookmark = params[:id] ? Bookmark.find(params[:id]) : Bookmark.new
  end

end
