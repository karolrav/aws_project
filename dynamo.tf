resource "aws_dynamodb_table" "tf_course_table" {
 name = "courses"
 billing_mode = "PROVISIONED"
 read_capacity= "10"
 write_capacity= "10"

 attribute {
  name = "id"
  type = "S"
 }
 hash_key = "id"
}

resource "aws_dynamodb_table" "tf_authors_table" {
 name = "authors"
 billing_mode = "PROVISIONED"
 read_capacity= "10"
 write_capacity= "10"

 attribute {
  name = "id"
  type = "S"
 }
 hash_key = "id"

}