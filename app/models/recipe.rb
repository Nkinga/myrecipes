class Recipe < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true, length: {minimum: 5, maximum: 500}
  validates :chef_id, presence: true
  validates :avatar, attachment_presence: true
  
    
  belongs_to :chef
  acts_as_votable
  has_many :recipe_ingredients
  has_many :ingredients, through: :recipe_ingredients
  has_many :comments, dependent: :destroy
  default_scope -> { order(updated_at: :desc) }
  
  has_attached_file :avatar, styles: { small: ["64x64", :jpg], med: ["100x100", :jpg], large: ["200x200", :jpg] }, 
                      :default_url => ActionController::Base.helpers.asset_path('chow-mein.jpg')
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  # Validate filename
  validates_attachment_file_name :avatar, matches: [/png\Z/, /jpeg\Z/, /tiff\Z/, /bmp\Z/, /jpg\Z/]
end 