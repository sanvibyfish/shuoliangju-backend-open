class DailyReportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :schedule, backtrace: true, retry: false
  # 无需显示调用，sidekiq 运行后会自动执行
  # 传入参数和执行周期在 config/sidekiq_schedule.yml 中配置
  def perform(*args)
      Rails.logger.info 'every second execution...'
      DailyReportMailer.send_daily_report(Date.yesterday,"【#{Rails.env}】【说两句】昨日数据报表").deliver_later
  end
end
