SparkleFormation.new(:root_domain_bucket) do
  description 'Root domain bucket for briennamacnish.com'

  parameters.domain do
    description 'Root domain'
    type 'String'
  end

  parameters.index_document do
    description 'Index document'
    type 'String'
  end

  parameters.logs_bucket do
    description 'Destination for access logs'
    type 'String'
  end

  resources.root_domain_bucket do
    type 'AWS::S3::Bucket'
    deletion_policy 'Retain'
    properties do
      bucket_name ref!(:domain)
      logging_configuration do
        destination_bucket_name ref!(:logs_bucket)
        log_file_prefix 'logs/'
      end
    end
  end

  outputs.root_domain do
    description 'Root domain'
    value ref!(:domain)
  end
end
