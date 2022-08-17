json.array! @notifications do |notification|
    json.id notification.id
    json.insight_text notification.params[:message]['insight_text']
    json.life_aspect  notification.params[:message]['life_aspect']
    json.created_at notification.created_at
    if notification.params[:message]['life_aspect'].downcase  == "sleep"
        json.url pages_sleep_path
    elsif notification.params[:message]['life_aspect'].downcase  == "exposome"
        json.url pages_exposome_path
    elsif notification.params[:message]['life_aspect'].downcase  == "mobility"
        json.url pages_mobility_path
    else
        json.url pages_dashboard_path
    end
end