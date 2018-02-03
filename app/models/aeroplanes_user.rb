class AeroplanesUser < ApplicationRecord
  belongs_to :aeroplane
  belongs_to :user
end