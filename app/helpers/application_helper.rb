module ApplicationHelper
    def notice_message
        flash_messages = []
        close_html = %(<a class="close" data-dismiss="alert" aria-label="close">&times;</a>)
        flash.each do |type, message|
          type = :success if type.to_sym == :notice
          type = :danger  if type.to_sym == :alert
          text = content_tag(:div, raw(message) + raw(close_html), class: "alert alert-#{type} alert-dismissible", role: "alert")
          flash_messages << text if message
        end
        flash_messages.join("\n").html_safe
    end

    def admins
      User.where(state: :admin)
    end

  # Check if a particular controller is the current one
  #
  # args - One or more controller names to check (using path notation when inside namespaces)
  #
  # Examples
  #
  #   # On TreeController
  #   current_controller?(:tree)           # => true
  #   current_controller?(:commits)        # => false
  #   current_controller?(:commits, :tree) # => true
  #
  #   # On Admin::ApplicationController
  #   current_controller?(:application)         # => true
  #   current_controller?('admin/application')  # => true
  #   current_controller?('gitlab/application') # => false
  def current_controller?(*args)
    args.any? do |v|
      v.to_s.downcase == controller.controller_name || v.to_s.downcase == controller.controller_path
    end
  end

  # Check if a particular action is the current one
  #
  # args - One or more action names to check
  #
  # Examples
  #
  #   # On Projects#new
  #   current_action?(:new)           # => true
  #   current_action?(:create)        # => false
  #   current_action?(:new, :create)  # => true
  def current_action?(*args)
    args.any? { |v| v.to_s.downcase == action_name }
  end

  def is_admin?
    current_account.try(:admin?)
  end

  def is_apps_page?(path)
    path == '/apps' || path == '/apps/new'
  end

  def image_thumb_url(url)
    "#{url}?x-oss-process=image/resize,h_100,w_100"
  end
end
