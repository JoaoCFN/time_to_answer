require 'net/http'
class ZipCode
  attr_reader :street, :neighborhood, :city, :state

  def initialize(zip_code)
    finded_zip_code = find_zip_code(zip_code)
    fill_data(finded_zip_code)
  end

  def address
    "#{@street} / #{@neighborhood} / #{@city} - #{@state}"
  end

  private
    def find_zip_code(zip_code)
      ActiveSupport::JSON.decode(
        Net::HTTP.get(
          URI("https://viacep.com.br/ws/#{zip_code}/json")
        )
      )
    end

    def fill_data(finded_zip_code)
      @street = finded_zip_code["logradouro"]
      @neighborhood = finded_zip_code["bairro"]
      @city = finded_zip_code["localidade"]
      @state = finded_zip_code["uf"]
    end
end

# ZipCode.new("44032582")