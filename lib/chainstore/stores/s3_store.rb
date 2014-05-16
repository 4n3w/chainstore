require 'aws/s3'

class S3Store
  include Chainstore::Store
  include Chainstore::LinkableStore

  def initialize(key_id, secret_key, server_name, bucket_name)
    AWS::S3::DEFAULT_HOST.replace server_name
    AWS::S3::Base.establish_connection!(
        :access_key_id => key_id,
        :secret_access_key => secret_key
    )
    @bucket = bucket_name
  end

  def get(key)
    begin
      tuple = AWS::S3::S3Object.find key, @bucket
    rescue AWS::S3::NoSuchKey
      return nil
    end
    tuple.value
  end

  def put(key, value)
    AWS::S3::S3Object.store key, value, @bucket
  end

  def del(key)
    AWS::S3::S3Object.delete key, @bucket
  end

  chain_method :get
  chain_method :put
  chain_method :del
end