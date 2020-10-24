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
      website_configuration do
        redirect_all_requests_to do
          host_name ref!(:root_domain)
          protocol 'http'
        end
      end
    end
  end

  outputs.website_endpoint do
    description 'Url '
    value get_att!(:subdomain_bucket, 'WebsiteURL')
  end

  outputs.subdomain do
    description 'Subdomain'
    value ref!(:domain)
  end
end
