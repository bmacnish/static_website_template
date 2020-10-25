SparkleFormation.new(:cloudfront_distribution) do
  parameters.root_domain do
    description 'root domain'
    type 'String'
  end

  parameters.subdomain do
    description 'subdomain'
    type 'String'
  end

  parameters.aws_website_endpoint do
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
  
  resources.cloudfront_distribution_root_domain do
    type "AWS::CloudFront::Distribution"
    properties do
      distribution_config do 
        enabled true
        aliases [ref!(:root_domain)]
        default_root_object 'index.html'
        default_cache_behavior do
          compress true
          viewer_protocol_policy 'redirect-to-https'
          allowed_methods ['GET', 'HEAD']
          target_origin_id join!(ref!(:root_domain), "cloudfront-distribution")
          forwarded_values do
          query_string false
            cookies do
              forward "none"
            end
          end
        end
        origins array!( 
          -> {
          id join!(ref!(:root_domain), "cloudfront-distribution")
          domain_name ref!(:aws_website_endpoint)
          origin_custom_headers array!(
            -> {
              header_name 'Referer'
              header_value ref!(:header)
            }
          )
          custom_origin_config do
            origin_protocol_policy 'https-only'
          end
          }
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
    type "AWS::CloudFront::Distribution"
    properties do
      distribution_config do 
        enabled true
        aliases [ref!(:subdomain)]
        default_root_object 'index.html'
        default_cache_behavior do
          compress true
          viewer_protocol_policy 'redirect-to-https'
          allowed_methods ['GET', 'HEAD']
          target_origin_id join!(ref!(:subdomain), "cloudfront-distribution")
          forwarded_values do
            query_string false
            cookies do
              forward "none"
            end
          end
        end
        origins array!( 
          -> {
          id join!(ref!(:subdomain), "cloudfront-distribution")
          domain_name ref!(:aws_website_endpoint)
          origin_custom_headers array!(
            -> {
              header_name 'Referer'
              header_value ref!(:header)
            }
          )
          custom_origin_config do
            origin_protocol_policy 'https-only'
          end
          }
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
end
