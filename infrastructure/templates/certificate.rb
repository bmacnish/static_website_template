SparkleFormation.new(:certificate_dns_validation) do
  description "Creates the CNAME record to validate an ACM SSL certificate via DNS validation, given the name/value DNS validation in params generated by a script"

  parameters.domain_name do
    description "Target domain name"
    type "String"
  end

  parameters.hosted_zone_id do
    description "Hosted Zone ID"
    type "String"
  end

  resources.certificate do
    type "AWS::CertificateManager::Certificate"
    properties do
        domain_name ref!(:domain_name)
        domain_validation_options array!(
          -> {
            domain_name ref!(:domain_name)
            hosted_zone_id ref!(:hosted_zone_id)
          }
        )
        validation_method "DNS"
    end
  end

  outputs do
    domain_name do
      description "Domain name for the certificate"
      value ref!(:domain_name)
    end

    certificate_arn do
      description "ARN of the SSL certificate issued by ACM for HTTPS"
      value ref!(:certificate)
    end
  end
end
