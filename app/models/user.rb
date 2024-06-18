class User < ApplicationRecord
  after_create :save_user_to_firebase
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # POST /resource
  # def create
  #   super do |user|
  #     # After Devise creates the user, save additional data to Firebase
  #     save_user_to_firebase(user)
  #   end
  # end

  private

  def save_user_to_firebase
    firebase_config_path = Rails.root.join('/home/pedro/code/paisagens/paisagens-ebf68-firebase-adminsdk-fmbus-35f91bd4e8.json')
    firebase_config = JSON.parse(File.read(firebase_config_path))
    base_uri = 'https://paisagens-ebf68-default-rtdb.firebaseio.com/'
    fb = Firebase::Client.new(base_uri, firebase_config['private_key'])
    # Assuming you have access to user data like email and uid after sign up
    user_data = {
      email: self.email,
      uid: self.id,
      created_at: Time.now.to_i # Example timestamp
      # Add any other user data you want to store
    }

    response = if id.present?
                 fb.update("users/#{id}", user_data)
               else
                 fb.push('users', user_data)
               end
    #raise

    Rails.logger.info "Firebase Response: #{response.body}"

    if response.success?
      @id ||= response.body['name']
      true
    else
      Rails.logger.error "Firebase Error: #{response.body}"
      false
    end
  end

end
