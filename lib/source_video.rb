require 'json'
require './lib/constant'

class SourceVideo
  def initialize(filepath, youtube_id = nil)
    raise "#{filepath} が存在しません。" unless File.exist?(filepath)

    @filepath = filepath
    @youtube_id = youtube_id

    @sliced_unit_number_of_seconds = Constant.sliced_unit_number_of_seconds
    @extracted_images_saved_base_path = Constant.extracted_images_saved_base_path
    @images_base_directory_name = Constant.images_base_directory_name
    @responses_base_directory_name = Constant.responses_base_directory_name
  end

  def stream_info
    hour, minute, second = hour_and_minute_and_second

    {
      filepath:,
      filename:,
      filename_without_ext:,
      fps:,
      hour:,
      minute:,
      second:,
      sum_seconds:,
      youtube_id: @youtube_id,
      youtube_url:,
      sliced_directory_names:,
      images_path:,
      json_files_path:
    }
  end

  def raw_stream_info
    raw_stream_info_json = `ffprobe -v quiet -print_format json -show_format -show_streams #{@filepath}`

    JSON.parse(raw_stream_info_json, symbolize_names: true)
  end

  private

  def json_files_path
    "#{@extracted_images_saved_base_path}/#{File.basename(@filepath, '.*')}/#{@responses_base_directory_name}"
  end

  def images_path
    "#{@extracted_images_saved_base_path}/#{File.basename(@filepath, '.*')}/#{@images_base_directory_name}"
  end

  def duration_seconds
    raw_stream_info[:format][:duration].to_f
  end

  def hour
    hour_and_minute_and_second[0]
  end

  def minute
    hour_and_minute_and_second[1]
  end

  def second
    hour_and_minute_and_second[2]
  end

  def sum_seconds
    duration_seconds.ceil
  end

  def hour_and_minute_and_second
    [
      (duration_seconds / 60 / 60).floor,
      ((duration_seconds / 60) % 60).floor,
      (duration_seconds % 60).ceil,
    ]
  end

  def youtube_url
    @youtube_id.nil? ? nil : "https://youtu.be/#{@youtube_id}"
  end

  def fps
    video_stream = raw_stream_info[:streams][0]

    raise 'ビデオストリームが存在しません。' unless video_stream[:codec_type] == 'video'

    video_stream[:r_frame_rate].split('/').first.to_i
  end

  def filepath
    raw_stream_info[:format][:filename]
  end

  def filename
    File.basename(filepath)
  end

  def filename_without_ext
    File.basename(filepath).split('.').first
  end

  def sliced_directory_names
    sliced_directory_names = []

    (0..sum_seconds).each_slice(@sliced_unit_number_of_seconds).with_index do |_seconds, index|
      start_second = index * @sliced_unit_number_of_seconds
      end_second = start_second + @sliced_unit_number_of_seconds

      start_second_str = start_second.to_s.rjust(5, '0')
      end_second_str = end_second.to_s.rjust(5, '0')
      sliced_directory_name = "#{start_second_str}_#{end_second_str}"

      sliced_directory_names << sliced_directory_name
    end

    sliced_directory_names
  end
end
