# Quick Set up

This is a consulting engagement I am working on where the client wants to test out a cloud service, automate some manual data cleaning, and create dashbaords for analysis.

If you want to see the full detail [CLICK HERE](https://gist.github.com/CullenDolan/89120be904b531d5787d4785257fd8a1) to access the Gist for this project.

### System Requirements
- AWS Account
- Terraform
- IDE of Choice
- My OS is Ubuntu 20.04
- PowerBI Desktop

### AWS Resources used:
- S3
- RDS (Postgres or MS SQL Server - This is TBD)
- Lambda or possibly just the built in services

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
PSQL code to run to connect to a db
```
psql \
   --host=<DB instance endpoint> \
   --port=<port> \
   --username=<master username> \
   --dbname=<database name> 
```
Add the extension for interfacing s3 to RDS
```
psql=> CREATE EXTENSION aws_s3 CASCADE;
```
