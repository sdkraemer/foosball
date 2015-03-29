class PlayerDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def disabled?
  	#return not (player_signed_in? && (current_player.id == object.id || current_player.admin?))
  	if h.player_signed_in? && (h.current_player.admin? || h.current_player.id == object.id)
  		return false
  	end

  	return true
  end

  def editable?
  	return h.player_signed_in? && (h.current_player.admin? || h.current_player.id == object.id)
  end

  def current_player?
  	h.current_player.id == object.id
  end
end
