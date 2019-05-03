class Goal < ApplicationRecord
    validates :goal, null: false

    belongs_to :user,
        primary_key: :id,
        foreign_key: :user_id,
        class_name: :User

    

end