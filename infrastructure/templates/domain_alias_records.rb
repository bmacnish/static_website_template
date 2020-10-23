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

  parameters.aliased_domain do
    description 'Location of s3 bucket that the alias points to'
    type 'String'
  end
  
  parameters.region do
    description 'region'
    type 'String'
  end

  resources.root_domain_alias do
    type 'AWS::Route53::RecordSet'
    properties do
      name ref!(:root_domain)
      type 'A'
      alias_target do
        d_n_s_name ref!(:aliased_domain)
        hosted_zone_id ref!(:hosted_zone_id)
      end
      region ref!(:region)
      hosted_zone_id ref!(:hosted_zone_id)
      set_identifier 'briennamacnish.com'
    end
  end

  resources.subdomain_alias do
    type 'AWS::Route53::RecordSet'
    properties do
      name ref!(:subdomain)
      type 'A'
      alias_target do
        d_n_s_name ref!(:aliased_domain)
        hosted_zone_id ref!(:hosted_zone_id)
      end
      region ref!(:region)
      hosted_zone_id ref!(:hosted_zone_id)
      set_identifier 'www.briennamacnish.com'
    end
  end
end

