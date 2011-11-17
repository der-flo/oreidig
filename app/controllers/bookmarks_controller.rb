class BookmarksController < InheritedResources::Base
  respond_to :json

  protected

  def collection
    @bookmarks ||=
      end_of_association_chain.page(params[:page]).per(params[:limit])
  end

end
