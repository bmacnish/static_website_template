SparkleFormation.new(:subdomain_bucket) do
  description 'Root domain bucket for briennamacnish.com'

  parameters.domain do
    description 'Subdomain'
    type 'String'
  end

  parameters.root_domain do
    description 'Root domain to redirect request to'
    type 'String'
  end

  resources.subdomain_bucket do
    type 'AWS::S3::Bucket'
    deletion_policy 'Retain'
    properties do
      bucket_name ref!(:domain)
      public_access_block_configuration do
        block_public_acls true
        block_public_policy true
        ignore_public_acls true
        restrict_public_buckets true
      end
    end
  end

  outputs.subdomain do
    description 'Subdomain'
    value ref!(:domain)
  end
end
