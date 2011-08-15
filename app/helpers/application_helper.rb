module ApplicationHelper
  def caption_for_action
    I18n.t "caption_for_action.#{params[:controller]}.#{params[:action]}"
  end
end
