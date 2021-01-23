class Photo
  attr_reader :image_id, :by, :date, :river, :url

  def initialize(data)
    @image_id = data["id"]
    @description = JSON.parse(data["description"]) if data["description"]
    @by = @description['autor'] if @description
    @date = @description['data'] if @description
    @river = @description['miejsce'] if @description
    @url = data["baseUrl"]
  end
end
