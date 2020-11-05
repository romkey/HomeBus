require 'securerandom'
require 'base64'
require 'bcrypt'

class MosquittoAccount < MosquittoRecord
  belongs_to :provision_request

#  has_many :mosquitto_acl, foreign_key: 'username', dependent: :destroy
#  has_many :mosquitto_acl

  def generate_password!
    unencoded_password = SecureRandom.base64(40)
    cost = 12

    BCrypt::Engine.cost = 12

    hashed_password = BCrypt::Password.create unencoded_password

    puts "unencoded password for device is #{unencoded_password}"
    puts "encoded password for device is #{hashed_password}"
    self.password = hashed_password
    self.save

    return unencoded_password
  end

  def generate_pbkdf2_password!
    unencoded_password = SecureRandom.base64(40)
    salt = SecureRandom.base64(16)
    iterations = 100000
    key_length = 64

    encoded = Base64.encode64(OpenSSL::PKCS5::pbkdf2_hmac(unencoded_password, salt, iterations, key_length, OpenSSL::Digest::SHA512.new)).chomp

    hashed_password = "PBKDF2$sha512$#{iterations}$#{salt}$#{encoded}"

    puts "unencoded password for device is #{unencoded_password}"
    puts "encoded password for device is #{hashed_password}"
    self.password = hashed_password
    self.save

    return unencoded_password
  end

end
