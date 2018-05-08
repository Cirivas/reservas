# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Change behaviour of forms' errors
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|

  label_index = html_tag.index 'label'

  if label_index == 1
    html_tag.insert html_tag.index('>'), 'class="error"'
  end  
  html_tag.html_safe
end

require 'carrierwave/orm/activerecord'

ActionMailer::Base.smtp_settings = {
  :user_name => ENV['SENDGRID_USERNAME'],
  :password => ENV['SENDGRID_PASSWORD'],
  :domain => 'cua-reservas.herokuapp.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
