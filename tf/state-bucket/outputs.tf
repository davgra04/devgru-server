output "arn" {
  value = "${aws_s3_bucket.state-bucket.arn}"
}

output "bucket_domain_name " {
  value = "${aws_s3_bucket.state-bucket.bucket_domain_name}"
}
