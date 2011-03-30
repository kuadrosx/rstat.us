class Rstatus
  get '/notifications' do
    require_login! :return => request.referrer
    @notifications = Notification.paginate( :page => params[:page],
                                            :per_page => params[:per_page] || 20,
                                            :order => :created_at.desc,
                                            :author_id => current_user.author_id)
    haml :notifications
  end

  post '/readall' do
    require_login! :return => request.referrer
    Notification.set({:author_id => current_user.author_id, :read => false}, {:read => true})
    redirect "/notifications"
  end
end
