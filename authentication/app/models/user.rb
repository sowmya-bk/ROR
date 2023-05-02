class User
  extend Enumerize
  include Mongoid::Document
  include Mongoid::Timestamps 
  include CarrierWave::Mount
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  ## Database authenticatable
  field :phone_number, type: Integer
  validates :phone_number,uniqueness: true, presence: true,numericality: true,length: { minimum: 10,maximum: 15 } 

  field :email, type: String, default: ""
  validates :email,uniqueness: {case_sensitive: false},format: { with: /\w+@\w+\.{1}[a-zA-Z]{2,}/, on: :create , message: "Address is not valid"}

  field :encrypted_password, type: String, default: ""
  validates :password, 
  format: { with: /\A(?=.{8,})(?=.*\d)(?=.*[A-Z])(?=.*\W)\z/,
            message: 'should have more than 8 characters including 1 uppercase letter, 1 number, 1 special character'
          }
  
         
  field :role
  enumerize :role, in: [:user, :admin],default: :user

  mount_uploader :image, ImageUploader

  field :firstname, type: String
  validates :firstname, presence:true,uniqueness: {case_sensitive: false}

  field :lastname, type: String
  validates :lastname, presence:true

  field :username, type: String
  validates :username, presence:true,uniqueness: {case_sensitive: false}

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time
  ## Trackable
  # field :sign_in_count,      type: Integer, default: 0
  # field :current_sign_in_at, type: Time
  # field :last_sign_in_at,    type: Time
  # field :current_sign_in_ip, type: String
  # field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
 
end

