resource "aws_security_group" "tf_db_sg" {
  name        = "tf_db_sg"
  description = "Allow inbound traffic for db created w/ tf"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["24.1.57.53/32"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db access"
  }
}


resource "aws_db_instance" "tf-test-instance" {
  identifier             = "tf-test-instance"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.1"
  username               = "cullen"
  name                   = "testdb"
  password               = var.db_password
  vpc_security_group_ids = [aws_security_group.tf_db_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}