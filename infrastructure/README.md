## Infrastructure

This project is a static website hosted on AWS infrastructure.

All the infrastructure for this project has been defined as code with the exception of the Hosted Zone which was created as part of the process of purchasing a domain via Route 53.

The project is deployed in `ap-southeast-2`

## Prerequisits

- AWS CLI tool
- [AWS vault exec](https://github.com/99designs/aws-vault) 
    - A tool to securely store and access AWS credentials in a development environment
- [Stack Master](stack_master)
- Sparkleformation 
    - A Ruby DSL for writing Cloudformation templates

## Deployment

Update the relevant infrastructure templates and parameter files.

```bash
cd infrastructure
aws-vault exec powerbrie -- stack_master apply <stackname>
```


[stack_master]: https://github.com/envato/stack_master