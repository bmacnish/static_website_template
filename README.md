# briennamacnish.com

## Website
This project is a static website built using HTML, CSS and the Bootstrap(3.3.6) framework.

## Deployment

To deploy changes to the content of the project you will need to run the following command.

```bash
ave powerbrie -- aws s3 sync . s3://briennamacnish.com
```


## Infrastructure

This project is a static website hosted on AWS infrastructure.

All the infrastructure for this project has been defined as code with the exception of the Hosted Zone and the SOA and NS domain records which were created as part of the process of purchasing a domain via Route 53.

The project is deployed in `ap-southeast-2`

## Prerequisits

- [AWS CLI tool](aws_cli)
- [AWS vault exec](aws_vault_exec)
    - A tool to securely store and access AWS credentials in a development environment
- [Stack Master](stack_master)
- [Sparkleformation](sparkleformation)
    - A Ruby DSL for writing Cloudformation templates

## Deployment

Update the relevant infrastructure templates and parameter files.

```bash
cd infrastructure
aws-vault exec powerbrie -- stack_master apply <stackname>
```

[aws_cli]: https://aws.amazon.com/cli/
[aws_valut_exec]: (https://github.com/99designs/aws-vault
[sparkleformation]: (https://www.sparkleformation.io/)
[stack_master]: https://github.com/envato/stack_master
