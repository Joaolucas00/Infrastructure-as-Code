resource "aws_s3_bucket" "beanstalk_s3_deploy" {
    bucket = var.s3_bucket_name
}

resource "aws_s3_object" "docker" {
depends_on = [ aws_s3_bucket.beanstalk_s3_deploy ]
bucket = var.s3_bucket_name
key = "${var.s3_bucket_name}.zip"
source = "${var.s3_bucket_name}.zip"
etag = filemd5("${var.s3_bucket_name}.zip")
}