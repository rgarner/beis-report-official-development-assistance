class S3Uploader
  def initialize(file)
    @client = Aws::S3::Client.new(
      region: JSON.parse(ENV["VCAP_SERVICES"])["aws-s3-bucket"][0]["credentials"]["aws_region"],
      credentials: Aws::Credentials.new(JSON.parse(ENV["VCAP_SERVICES"])["aws-s3-bucket"][0]["credentials"]["aws_access_key_id"], JSON.parse(ENV["VCAP_SERVICES"])["aws-s3-bucket"][0]["credentials"]["aws_secret_access_key"])
    )
    @file = file
    @filename = "export-file-#{Time.now.to_i}.csv"
  end
  attr_reader :client, :file, :filename

  def upload
    response = client.put_object(
      bucket: JSON.parse(ENV["VCAP_SERVICES"])["aws-s3-bucket"][0]["credentials"]["bucket_name"],
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
    resource.bucket(JSON.parse(ENV["VCAP_SERVICES"])["aws-s3-bucket"][0]["credentials"]["bucket_name"])
  end
end
