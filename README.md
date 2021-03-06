# Quick Set up

This is for a consulting engagement I am working on where the client wants to test out a cloud service, automate some manual data processing, and build dashbaords for analysis.

[AWS Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html)

### System Requirements
- AWS Account
- Terraform
- IDE of Choice
- My OS is Ubuntu 20.04
- [PowerBI](https://docs.aws.amazon.com/en_us/whitepapers/latest/using-power-bi-with-aws-cloud/using-power-bi-with-aws-cloud.pdf?did=wp_card&trk=wp_card)
-  [Youtube Reference](https://www.youtube.com/watch?v=L5x_gnimz04)
- AWS VPN Client
- AWS Direct Connect

### AWS Resources used:
- S3
- Postgres RDS or MS SQl Server
- aws_s3 extension for psql ([Documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/PostgreSQL.Procedural.Importing.html#USER_PostgreSQL.S3Import))
- Lambda or possibly just the built in services

### High Level Steps
1. Set up AWS resources with Terraform
2. Configure Database
3. Give RDS access to S3
4. Import S3 data into RDS


### Set up

Clone the repo
```
$ git clone https://github.com/CullenDolan/datapipeline.git
$ cd datapipeline
```
Add your password to the environment. (Only once)
```
$ export TF_VAR_db_password="ADD PW HERE"
```
Initialize the terraform configuration
```
$ terraform init
```
Apply the changes (make sure to note endpoint, port, username, and db name)
```
$ terraform apply
```
PSQL code to run to connect to a database
```
psql \
   --host=<DB instance endpoint> \
   --port=<port> \
   --username=<master username> \
   --dbname=<database name> 
```
You will then be prompted for the dbinstance password

Add the extension for interfacing s3 to RDS
```
psql=> CREATE EXTENSION aws_s3 CASCADE;
```
Create a new table
```
psql=> CREATE TABLE tablename (col1 varchar(30), col2 varchar(30)...);
```
Follow these steps to manaually attach policy ([Helpful Link](https://www.sqlshack.com/integrating-aws-s3-buckets-with-aws-rds-sql-server/)):
- Create a Policy that can give access to read and get objects in the specific s3 bucket
- Create a role and assign the policy to the role
- add the role to RDS

Create the URI structure that will hold the s3 file referenced by table_import_from_s3
```
psql=> SELECT aws_commons.create_s3_uri('sample_s3_bucket','sample.csv','us-east-1') AS s3_uri 
psql-> \gset
```
Import the data into RDS:
```
psql=> SELECT aws_s3.table_import_from_s3('t1','','(format csv)',:'s3_uri');
```
Data is now accessible 
