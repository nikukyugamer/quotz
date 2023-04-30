# rubocop:disable Metrics/AbcSize
class Valid
  class << self
    def stream_info?(stream_info)
      return false if stream_info[:filepath].nil?
      return false if stream_info[:filename].nil?
      return false if stream_info[:filename_without_ext].nil?
      return false if stream_info[:fps].nil?
      return false if stream_info[:hour].nil?
      return false if stream_info[:minute].nil?
      return false if stream_info[:second].nil?
      return false if stream_info[:sum_seconds].nil?
      return false if stream_info[:youtube_id].nil?
      return false if stream_info[:youtube_url].nil?
      return false if stream_info[:sliced_directory_names].nil?
      return false if stream_info[:images_path].nil?
      return false if stream_info[:json_files_path].nil?

      true
    end
  end
end
# rubocop:enable Metrics/AbcSize
