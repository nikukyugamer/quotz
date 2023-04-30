require 'semantic_logger'
require './lib/valid'
require './lib/constant'

class Extract
  def initialize(stream_info)
    raise 'stream_info が不正です。' unless Valid.stream_info?(stream_info)

    @stream_info = stream_info

    SemanticLogger.default_level = :trace
    SemanticLogger.add_appender(file_name: 'log/development.log')
    @logger = SemanticLogger['Extract']
  end

  def execute
    @stream_info[:sliced_directory_names].each do |directory_name|
      execute_per_directory(directory_name)
    end
  end

  private

  def execute_per_directory(directory_name)
    FileUtils.mkdir_p(saved_directory_path(directory_name))
    command = extract_command(directory_name)

    start_log = " (#{Time.now}) [LOG] #{saved_directory_path(directory_name)} への出力を開始します。"
    puts start_log
    @logger.info(start_log)

    @logger.info(command)
    `#{command}`

    end_log = " (#{Time.now}) [LOG] #{saved_directory_path(directory_name)} への出力が完了しました。"
    puts end_log
    @logger.info(end_log)
  end

  # NOTE: WSL内のディレクトリに保存するとストレージアクセスが常時フルになりフリーズする
  def saved_directory_path(directory_name)
    "#{@stream_info[:images_path]}/#{directory_name}"
  end

  def extract_command(directory_name)
    # rubocop:disable Layout/LineLength
    "ffmpeg -loglevel quiet #{range_options(directory_name)} #{input_file_option} #{codec_option} #{saved_directory_path(directory_name)}/%07d.png"
    # rubocop:enable Layout/LineLength
  end

  def range_options(directory_name)
    start_second, end_second = directory_name.split('_').map(&:to_i)

    "-ss #{start_second} -to #{end_second}"
  end

  def codec_option
    '-vcodec png'
  end

  def input_file_option
    "-i #{@stream_info[:filepath]}"
  end
end
