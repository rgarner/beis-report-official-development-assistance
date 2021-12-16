module Export
  class S3Uploader
    def initialize(file)
      @client = Aws::S3::Client.new(
        region: S3UploaderConfig.region,
        credentials: Aws::Credentials.new(
          S3UploaderConfig.key_id,
          S3UploaderConfig.secret_key
        )
      )
      @file = file
      @filename = "export-file-#{Time.now.to_i}.csv"
    end
    attr_reader :client, :file, :filename

    def upload
      response = client.put_object(
        bucket: S3UploaderConfig.bucket,
        key: filename,
        body: file
      )
      if response.etag
        bucket.object(filename).public_url
      else
        # Raise something here to rollbar?
        return false
      end
    rescue StandardError => e
      # Raise something here and retry?
      puts "Error uploading object: #{e.message}"
      return false
    end

    private

    def bucket
      resource = Aws::S3::Resource.new(client: client)
      resource.bucket(S3UploaderConfig.bucket)
    end
  end
end
