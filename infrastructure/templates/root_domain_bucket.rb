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
      website_configuration do
        index_document ref!(:index_document)
      end
      logging_configuration do
        destination_bucket_name ref!(:logs_bucket)
        log_file_prefix 'logs/'
			end
    end
  end

  resources.bucket_policy do
    type 'AWS::S3::BucketPolicy'
    properties do
      bucket ref!(:domain)
      policy_document do
        version "2012-10-17"
        statement array!(
         -> {
           sid "PublicReadGetObject"
           effect "Allow"
           principal "*"
           action "s3:GetObject"
           resource ["arn:aws:s3:::briennamacnish.com/*"]
         },
       )
      end
    end
  end

  outputs.website_endpoint do
    description 'Url '
    value get_att!(:root_domain_bucket, 'WebsiteURL')
  end
  
  outputs.root_domain do
    description 'Root domain'
    value ref!(:domain)
  end
end
