desc "发送每日数据报表"
task :send_daily_report => :environment do
  DailyReportMailer.send_daily_report(Date.yesterday,"【#{Rails.env}】【说两句】昨日数据报表").deliver_later
end

desc "发送今日数据报表"
task :send_today_report => :environment do
  DailyReportMailer.send_daily_report(Date.today,"【#{Rails.env}】【说两句】今日数据报表").deliver_later
end