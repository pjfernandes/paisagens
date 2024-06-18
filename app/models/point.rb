class Point
  attr_accessor :id, :latitude, :longitude, :name, :description, :user_id, :user_email

  include ActiveModel::Model  # Include ActiveModel modules
  include ActiveModel::Attributes

  def initialize(attributes = {})
    @id = attributes['id']
    @latitude = attributes['latitude']
    @longitude = attributes['longitude']
    @name = attributes['name']
    @description = attributes['description']
    @user_id = attributes['user_id']
    @user_email = attributes['user_email']
  end

  def self.all
    response = $firebase.get('points')
    if response.success?
      points = []
      response.body.each do |id, data|
        point = Point.new(data.merge('id' => id))
        points << point
      end
      points
    else
      []
    end
  end

  def self.find(id)
    response = $firebase.get("points/#{id}")
    if response.success?
      Point.new(response.body.merge('id' => id))
    else
      nil
    end
  end

  def save
    response = if id.present?
                $firebase.update("points/#{id}", to_hash)
              else
                $firebase.push('points', to_hash)
              end

    Rails.logger.info "Firebase Response: #{response.body}"

    if response.success?
      @id ||= response.body['name']
      true
    else
      Rails.logger.error "Firebase Error: #{response.body}"
      false
    end
  end

  def destroy
    $firebase.delete("points/#{id}") if id.present?
  end

  def to_hash
    {
      'id' => id,
      'latitude' => latitude,
      'longitude' => longitude,
      'name' => name,
      'description' => description,
      'user_id' => user_id,
      'user_email' => user_email
    }
  end

  def persisted?
    id.present?
  end

  def to_key
    persisted? ? [id] : nil
  end

  def to_param
    id.to_s
  end
end
