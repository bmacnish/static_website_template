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

  parameters.oai_user do
    description 'OAI user with access to bucket'
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
      public_access_block_configuration do
        block_public_acls true
        block_public_policy true
        ignore_public_acls true
        restrict_public_buckets true
      end
    end
  end

  resources.oai_bucket_policy do
    type 'AWS::S3::BucketPolicy'
    properties do
      bucket ref!(:root_domain_bucket)
      policy_document do
        version '2012-10-17'
        statement _array(
          -> {
            effect 'Allow'
            principal do
              canonical_user ref!(:oai_user)
            end
            action _array(
              's3:GetObject'
            )
            resource join!('arn:aws:s3:::',ref!(:root_domain_bucket),'/*')
          }
        )
      end
    end
  end

  outputs.root_domain do
    description 'Root domain'
    value ref!(:domain)
  end
end
