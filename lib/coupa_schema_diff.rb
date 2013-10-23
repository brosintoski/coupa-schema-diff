# require "coupa_schema_diff/version"

require "rubygems"
require "diffy"
require "trollop"
require "net/http"

module CoupaSchemaDiff

  def self.get_response(uri,api_key)
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    if uri.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    http.request(Net::HTTP::Get.new(uri.request_uri,initheader = {'X_COUPA_API_KEY' => api_key, 'Accept' => 'application/xml'}))
  end

  def self.diff(instance_from,api_key_from,instance_to,api_key_to,objects="",opts={})


  output = ""
  output << "<!DOCTYPE html><html><body>"
  output << "<style>"
  output << Diffy::CSS
  output << "</style>"
  output << "<header><h1>Instance From: #{instance_from} - To: #{instance_to}</h1><header>"
  objects.split(",").each do |obj|
    unless opts[:in_only] || opts[:csv_only]
      output << "<p>#{obj} API Out</p>\n"
      response_from = get_response("#{instance_from}/api/schemas?object=#{obj}",api_key_from)
      response_to = get_response("#{instance_to}/api/schemas?object=#{obj}",api_key_to)
      output << Diffy::Diff.new(response_from.body, response_to.body, :context => 0).to_s(:html)
    end

    unless opts[:out_only] || opts[:csv_only]
      output << "<p>#{obj} API In</p>\n"
      response_from = get_response("#{instance_from}/api/schemas?object=#{obj}&in=1",api_key_from)
      response_to = get_response("#{instance_to}/api/schemas?object=#{obj}&in=1",api_key_to)
      output << Diffy::Diff.new(response_from.body, response_to.body, :context => 0).to_s(:html)
    end

    unless opts[:in_only] || opts[:api_only]
      output << "<p>#{obj} CSV Out</p>\n"
      response_from = get_response("#{instance_from}/api/schemas/csv?object=#{obj}",api_key_from)
      response_to = get_response("#{instance_to}/api/schemas/csv?object=#{obj}",api_key_to)
      if response_from.code == '200' && response_to.code == '200'
        output << Diffy::Diff.new(response_from.body, response_to.body, :context => 0).to_s(:html)
      else
        output << "<div>CSV Out format does NOT exist</div>"
      end
    end

    unless opts[:out_only] || opts[:api_only]
      output << "<p>#{obj} CSV In</p>\n"
      response_from = get_response("#{instance_from}/api/schemas/csv?object=#{obj}&in=1",api_key_from)
      response_to = get_response("#{instance_to}/api/schemas/csv?object=#{obj}&in=1",api_key_to)
      output << Diffy::Diff.new(response_from.body, response_to.body, :context => 0).to_s(:html)
    end

  end

  output << "</body></html>"

  output

  end

end
