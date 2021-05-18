output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.lscdevdbinstance.address
  sensitive   = true
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.lscdevdbinstance.port
  sensitive   = true
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.lscdevdbinstance.username
  sensitive   = true
}

// # add this once keybase is figured out
// output "password" {
//   value = aws_iam_user_login_profile.DataLoadUserLogin.encrypted_password
// }