class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates_presence_of :content
  # 将消息发送放入后台任务异步执行
  after_create_commit { MessageBroadcastJob.perform_later self }
end
