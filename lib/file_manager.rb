require './lib/constant'

class FileManager
  # rubocop:disable Layout/LineLength
  def image_filepaths(filename_without_ext, sliced_directory_name)
    extracted_images_saved_base_path = Constant.extracted_images_saved_base_path
    image_dir_path = "#{extracted_images_saved_base_path}/#{filename_without_ext}/#{Constant.images_base_directory_name}/#{sliced_directory_name}"

    Dir.glob("#{image_dir_path}/*.png")
  end
  # rubocop:enable Layout/LineLength

  def mabikied_image_filepaths(image_filepaths, number_of_mabiki_frame)
    mabikied_image_filepaths = []

    image_filepaths.each_with_index do |image_filepath, index|
      mabikied_image_filepaths << image_filepath if (index.to_f % number_of_mabiki_frame).zero?
    end

    mabikied_image_filepaths
  end

  def normalized_filename(image_filepath, extension, fps)
    sliced_directory_name = image_filepath.split('/')[-2]
    filename_with_ext = image_filepath.split('/')[-1]
    second_number_on_filename = filename_with_ext.split('.')[0]

    start_second_number = sliced_directory_name.split('_')[0].to_i * fps
    normalized_filename_number = start_second_number + second_number_on_filename.to_i

    "#{format('%07d', normalized_filename_number)}.#{extension}"
  end

  def normalized_second_number(image_filepath, extension, fps)
    normalized_filename(image_filepath, extension, fps).split('.')[0].to_i
  end

  # "/path/to/quotz/s2_15/images/01200_01500/0000001.png" #=> "s2_15"
  def convert_image_filepath_to_video_filename_without_ext(image_filepath)
    image_filepath.split('/')[-4]
  end

  # "/path/to/quotz/s2_15/images/01200_01500/0000001.png" #=> "01200_01500"
  def convert_image_filepath_to_sliced_directory_name(image_filepath)
    image_filepath.split('/')[-2]
  end

  # "/path/to/quotz/s2_15/images/01200_01500/0000001.png" #=> "0000001.png"
  def convert_image_filepath_to_image_filename_with_ext(image_filepath)
    image_filepath.split('/')[-1]
  end

  # "/path/to/quotz/s2_15/images/01200_01500/0000001.png" #=> "0000001"
  def convert_image_filepath_to_image_filename_without_ext(image_filepath)
    image_filepath.split('/')[-1].split('.')[0]
  end

  def convert_image_filepath_to_saved_responses_directory_path(image_filepath)
    extracted_images_saved_base_path = Constant.extracted_images_saved_base_path
    filename_without_ext = convert_image_filepath_to_video_filename_without_ext(image_filepath)
    responses_base_directory_name = Constant.responses_base_directory_name
    sliced_directory_name = convert_image_filepath_to_sliced_directory_name(image_filepath)

    # rubocop:disable Layout/LineLength
    "#{extracted_images_saved_base_path}/#{filename_without_ext}/#{responses_base_directory_name}/#{sliced_directory_name}"
    # rubocop:enable Layout/LineLength
  end

  def saved_json_filepath(image_filepath)
    saved_responses_directory_path = convert_image_filepath_to_saved_responses_directory_path(image_filepath)

    saved_json_filename_without_ext = convert_image_filepath_to_image_filename_without_ext(image_filepath)
    saved_json_filename = "#{saved_json_filename_without_ext}.json"

    "#{saved_responses_directory_path}/#{saved_json_filename}"
  end
end
