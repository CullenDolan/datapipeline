#Data Pipeline for AWS

### Resources used:
- S3
- RDS
- Lambda
- Terraform

### Set up

Clone the repo
```
$ git clone https://github.com/CullenDolan/datapipeline.git
$ cd datapipeline
```
Add your password to the environment
```
$ export TF_VAR_db_password="hashicorp"
```
Initialize the terraform configuration
```
$ terraform init
```
Apply the changes
```
$ terraform apply
```
