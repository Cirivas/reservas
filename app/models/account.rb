class Account < ApplicationRecord
  mount_uploader :file, AccountUploader
end
