SparkleFormation.new(:logs_bucket) do
  description 'Logs bucket for briennamacnish.com'

  parameters.domain do
    description 'domain'
    type 'String'
  end

  resources.logs_bucket do
    type 'AWS::S3::Bucket'
    deletion_policy 'Retain'
    properties do
      bucket_name ref!(:domain)
      access_control 'LogDeliveryWrite'
    end
  end

  outputs.logs_bucket_name do
    description 'logs_bucket_name '
    value ref!(:logs_bucket)
  end
end
