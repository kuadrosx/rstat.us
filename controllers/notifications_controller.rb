class Rstatus
  get '/notifications' do
    require_login! :return => request.referrer
    @notifications = Notification.paginate(:page => params[:page],
                                             :per_page => params[:per_page] || 20,
                                             :order => :created_at.desc,
                                             :user_id => current_user.id)
    haml :notifications
  end
end
