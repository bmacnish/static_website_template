SparkleFormation.new(:cloudfront_distribution) do
  parameters.root_domain do
    description 'root domain'
    type 'String'
  end

  parameters.subdomain do
    description 'subdomain'
    type 'String'
  end

  parameters.s3_bucket_root_domain do
    description 'The AWS defined website endpoint for static websites in ap-southeast-2'
    type 'String'
  end

  parameters.header do
    description 'Secret header for restricting access'
    type 'String'
  end

  parameters.acm_certificate_arn do
    description 'ARN of ACM defined SSL certificate'
    type 'String'
  end

  resources.oai do
    type 'AWS::CloudFront::CloudFrontOriginAccessIdentity'
    properties do
      cloud_front_origin_access_identity_config do
        comment join!('OAI for accessing ', ref!(:root_domain))
      end
    end
  end

  resources.cloudfront_distribution_root_domain do
    type 'AWS::CloudFront::Distribution'
    properties do
      distribution_config do
        enabled true
        aliases [ref!(:root_domain)]
        default_root_object 'index.html'
        default_cache_behavior do
          compress true
          viewer_protocol_policy 'redirect-to-https'
          allowed_methods %w[GET HEAD]
          target_origin_id join!(ref!(:root_domain), 'cloudfront-distribution')
          forwarded_values do
            query_string false
            cookies do
              forward 'none'
            end
          end
        end
        origins array!(
          -> {
            id join!(ref!(:root_domain), 'cloudfront-distribution')
            domain_name ref!(:s3_bucket_root_domain)
            s3_origin_config do
              origin_access_identity join!('origin-access-identity/cloudfront/', ref!(:oai))
            end
          },
        )
        viewer_certificate do
          acm_certificate_arn ref!(:acm_certificate_arn)
          minimum_protocol_version 'TLSv1'
          ssl_support_method 'sni-only'
        end
      end
    end
  end

  resources.cloudfront_distribution_subdomain do
    type 'AWS::CloudFront::Distribution'
    properties do
      distribution_config do
        enabled true
        aliases [ref!(:subdomain)]
        default_root_object 'index.html'
        default_cache_behavior do
          compress true
          viewer_protocol_policy 'redirect-to-https'
          allowed_methods %w[GET HEAD]
          target_origin_id join!(ref!(:subdomain), 'cloudfront-distribution')
          forwarded_values do
            query_string false
            cookies do
              forward 'none'
            end
          end
        end
        origins array!(
          -> {
            id join!(ref!(:subdomain), 'cloudfront-distribution')
            domain_name ref!(:s3_bucket_root_domain)
            s3_origin_config do
              origin_access_identity join!('origin-access-identity/cloudfront/', ref!(:oai))
            end
          },
        )
        viewer_certificate do
          acm_certificate_arn ref!(:acm_certificate_arn)
          minimum_protocol_version 'TLSv1'
          ssl_support_method 'sni-only'
        end
      end
    end
  end

  outputs.root_domain_cloudfront_distribution_domain do
    description 'Domain name for the Cloudfront distribution for root domain'
    value get_att!(:cloudfront_distribution_root_domain, 'DomainName')
  end

  outputs.subdomain_cloudfront_distribution_domain do
    description 'Domain name for the Cloudfront distribution for root domain'
    value get_att!(:cloudfront_distribution_subdomain, 'DomainName')
  end

  outputs.oai_canonical_user_id do
    description 'The Amazon S3 canonical user ID for the origin access identity.'
    value attr!(:oai, 'S3CanonicalUserId')
  end
end
