class AuthenticateUser 
  prepend SimpleCommand 

  def initialize(email, password) 
    @email = email 
    @password = password 
  end 

  def call 
    JsonWebToken.encode(user_id: user.id) if user 
  end 

  private 

  attr_accessor :email, :password 

  def user 
    # Using devise inbuilt menthod for finding User
    user = User.find_for_authentication(email: email) 

    # NOTE: Currently we are not using `has_secure_password` of password Digest
    # and using devise which authenticates user using method valid_password?
    # Hence commenting below code

    # return user if user && user.authenticate(password) 

    return user if user && user.valid_password?(password)

    errors.add :user_authentication, 'invalid credentials' 
    
    nil 
  end 
end
