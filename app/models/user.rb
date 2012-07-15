class User
  include CouchPotato::Persistence
  include ActiveModel::SecurePassword
  has_secure_password
  
  before_save :set_user_id
  
  property :name
  property :display_name
  property :email
  property :password_digest
  property :url
  
  view :all, :key => :name, :language => :erlang
  
  def set_user_id
    self.id = self.name
  end
  
end