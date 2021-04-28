require 'rails_helper'

RSpec.describe SendSubscribeMessageJob, type: :job do
  describe "#perform_later" do
    it "send message" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        allow_any_instance_of(Wechat::MpApi).to receive(:wxa_get_wxacode_unlimit).and_return("http://xx.com")
        allow_any_instance_of(Wechat::MpApi).to receive(:subscribe_message_send).and_return({})
        SendSubscribeMessageJob.perform_later(['xx'],'xxx','pages/index/index',{},'developer')
      }.to have_enqueued_job
    end
  end
end
