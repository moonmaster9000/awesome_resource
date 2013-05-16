RSpec::Matchers.define :include_interaction do |expected_interaction|
  interactions = nil

  expected_interaction[:response_body] = JSON.parse(expected_interaction[:response_body]) if expected_interaction[:response_body]
  expected_interaction[:request_body] = JSON.parse(expected_interaction[:request_body]) if expected_interaction[:request_body]

  def jsonify(content)
    begin
      JSON.parse(content) if !content.nil? && content != ""
    rescue JSON::ParserError => e
      e.to_s
    end
  end

  match do |http_interactions|
    interactions = http_interactions.map do |i|
      response_body = jsonify i[:response].body
      request_body = jsonify i[:request].body

      {
        response_status: i[:response].status.code.to_s,
        response_body: response_body,
        request_body: request_body,
        endpoint: i[:request].uri.to_s
      }
    end

    interactions.any? do |i|
      expected_interaction.keys.all? { |key| i[key] == expected_interaction[key] }
    end
  end

  failure_message_for_should do
    "interactions: #{interactions}\nexpected_interaction: #{expected_interaction}"
  end
end