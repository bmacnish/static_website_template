# Static Website Template Project

## Website

This project is a template for a static website built on AWS infrastructure.

## Prerequisits

- [AWS CLI tool](aws_cli)
- [AWS vault exec](aws_vault_exec)
  - A tool to securely store and access AWS credentials in a development environment
- [Stack Master](stack_master)
- [Sparkleformation](sparkleformation)
  - A Ruby DSL for writing Cloudformation templates

You will also need an AWS account set up and and an IAM user which can assume a role that can create infrastructure in these AWS services:

- S3
- Amazon Certificate Manager
- Cloudfront
- Route 53

All the AWS commands referenced here must be run with a user and role with the required permissions.

## Using the template

1. Buy the domain you would host your website on in Route 53
1. Search for TODO in this code base and identify where you need to includes id's unique to your account
1. Bring up the infrastructure defined in the `stack_master.yml` file
1. Add your website to the `src/` folder ensuring that the main entry point to your site is called `index.html`

## Deployment

To deploy changes to the content of the project you will need to run the following command.

```bash
aws s3 sync . s3://examplewebsite.com
```

## Infrastructure

This project is a static website hosted on AWS infrastructure.

All the infrastructure for this project has been defined as code with the exception of the Hosted Zone and the SOA and NS domain records which were created as part of the process of purchasing a domain via Route 53.

The project is deployed in `ap-southeast-2`

## Deployment

Update the relevant infrastructure templates and parameter files.

```bash
cd infrastructure
stack_master apply <stackname>
```

[aws_cli]: https://aws.amazon.com/cli/
[aws_valut_exec]: (https://github.com/99designs/aws-vault
[sparkleformation]: (https://www.sparkleformation.io/)
[stack_master]: https://github.com/envato/stack_master
