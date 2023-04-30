class Constant
  class << self
    def sliced_unit_number_of_seconds
      # 60fps だとしても、一つのユニットにて 18,000ファイル程度に収まる
      300
    end

    def sliced_unit_number_of_frames
      9000
    end

    # Quotz のすべての保存ファイルのルート
    # この配下に "動画ファイル毎/画像" や "動画ファイル毎/JSON" のディレクトリが作成される
    def extracted_images_saved_base_path
      ENV.fetch('EXTRACTED_IMAGES_SAVED_BASE_PATH', nil)
    end

    def images_base_directory_name
      'images'
    end

    def responses_base_directory_name
      'responses'
    end
  end
end
