class DailyReportMailer < ApplicationMailer
  default from: 'noreply@shuoliangju.cn'
 
  def send_daily_report(time, subject)
    @users_count = User.where("DATE(created_at) = ?", time).count
    @apps_count = App.where("DATE(created_at) = ?", time).count
    @comments_count = Comment.where("DATE(created_at) = ?", time).count
    @posts_count = Post.where("DATE(created_at) = ?", time).count
    mail(to: "sanvibyfish@gmail.com", subject: subject)
  end


end
