require 'google/cloud/vision'
require './lib/file_manager'
require './lib/constant'

class VisionApi
  attr_reader :response

  def initialize(image_filepath)
    @image_filepath = image_filepath
    @image_annotator = Google::Cloud::Vision.image_annotator
  end

  def send_api_request_and_set_response
    # rubocop:disable Naming/MemoizedInstanceVariableName
    @response ||= @image_annotator.text_detection(image: @image_filepath)
    # rubocop:enable Naming/MemoizedInstanceVariableName
  end

  def response_hash
    @response.to_h
  end

  def response_pretty_json
    JSON.pretty_generate(@response.to_h)
  end

  def save_response_as_json
    fm = FileManager.new

    saved_json_filepath = fm.saved_json_filepath(@image_filepath)
    saved_json_file_directory = File.dirname(saved_json_filepath)
    FileUtils.mkdir_p(saved_json_file_directory)

    File.write(saved_json_filepath, response_pretty_json)
  end
end
