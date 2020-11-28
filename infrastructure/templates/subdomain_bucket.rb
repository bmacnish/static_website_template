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
    end
  end

  outputs.subdomain do
    description 'Subdomain'
    value ref!(:domain)
  end
end
