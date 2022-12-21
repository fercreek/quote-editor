class Quote < ApplicationRecord
  belongs_to :company
  has_many :line_item_dates, dependent: :destroy
  
  validates :name, presence: true

  scope :ordered, -> { order(id: :desc) }

  # Way 1
  # after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self }, target: "quotes" }
  # after_create_commit -> { broadcast_prepend_to "quotes", partial: "quotes/quote", locals: { quote: self } }

  # Way 2
  # after_create_commit -> { broadcast_prepend_to "quotes" }
  # after_update_commit -> { broadcast_replace_to "quotes" }

  # Way 3
  # after_create_commit -> { broadcast_prepend_later_to "quotes" }
  # after_update_commit -> { broadcast_replace_later_to "quotes" }
  # after_destroy_commit -> { broadcast_remove_to "quotes" }

  # Way 4
  # broadcasts_to ->(quote) { "quotes" }, inserts_by: :prepend

  # Way 5
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend
end
