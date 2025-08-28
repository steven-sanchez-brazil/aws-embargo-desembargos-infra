# RDS Instance
module "rds" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = "${var.project}-${var.environment}"

  engine               = "postgres"
  engine_version       = "14"
  family              = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t3.medium"

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = "appdb"
  username = "dbadmin"
  port     = 5432

  multi_az               = false
  subnet_ids            = data.terraform_remote_state.vpc.outputs.private_subnets
  vpc_security_group_ids = [aws_security_group.rds.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 7
  skip_final_snapshot    = true

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# S3 Bucket
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${var.project}-${var.environment}-storage"
  acl    = "private"

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# SQS Queue
resource "aws_sqs_queue" "main" {
  name                      = "${var.project}-${var.environment}-queue"
  delay_seconds             = 0
  max_message_size         = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}

# Secrets Manager
resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.project}-${var.environment}-rds-credentials"

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
