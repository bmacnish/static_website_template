SparkleFormation.new(:domain_alias_records) do
  parameters.root_domain do
    description 'root domain'
    type 'String'
  end

  parameters.subdomain do
    description 'subdomain'
    type 'String'
  end

  parameters.hosted_zone_id do
    description 'hosted zone id'
    type 'String'
  end

  parameters.cloudfront_hosted_zone_id do
    description 'hosted zone id AWS defines for static website s3 endpoints'
    type 'String'
  end

  parameters.root_domain_cloudfront_distribution_domain do
    description 'Cloudfront distribution for the root domain'
    type 'String'
  end

  parameters.subdomain_cloudfront_distribution_domain do
    description 'Cloudfront distribution for the subdomain'
    type 'String'
  end

  resources.root_domain_alias do
    type 'AWS::Route53::RecordSet'
    properties do
      name ref!(:root_domain)
      type 'A'
      alias_target do
        d_n_s_name ref!(:root_domain_cloudfront_distribution_domain)
        hosted_zone_id ref!(:cloudfront_hosted_zone_id)
      end
      hosted_zone_id ref!(:hosted_zone_id)
    end
  end

  resources.subdomain_alias do
    type 'AWS::Route53::RecordSet'
    properties do
      name ref!(:subdomain)
      type 'A'
      alias_target do
        d_n_s_name ref!(:subdomain_cloudfront_distribution_domain)
        hosted_zone_id ref!(:cloudfront_hosted_zone_id)
      end
      hosted_zone_id ref!(:hosted_zone_id)
    end
  end
end
