require 'firebase'
require 'json'
require 'firebase-admin'

firebase_config_path = Rails.root.join('/home/pedro/code/paisagens/paisagens-ebf68-firebase-adminsdk-fmbus-35f91bd4e8.json')

firebase_config = JSON.parse(File.read(firebase_config_path))

#base_uri = "https://#{firebase_config['project_id']}.firebaseio.com/"
base_uri = "https://paisagens-ebf68-default-rtdb.firebaseio.com/"
p base_uri
$firebase = Firebase::Client.new(base_uri, firebase_config['private_key'])

# # Initialize Firebase Admin SDK
# firebase_config = {
#   credential: Firebase::Admin::Credentials.from_file('/home/pedro/code/paisagens/paisagens-ebf68-firebase-adminsdk-fmbus-35f91bd4e8.json'),
#   database_url: "https://paisagens-ebf68-default-rtdb.firebaseio.com/"
# }

# Firebase::Admin.initializeApp(firebase_config)
