const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({
  region: "eu-north-1",
  apiVersion: "2012-08-10"
});

exports.handler = (event, context, callback) => {
  const params = {
    TableName: "authors"
  };
  dynamodb.scan(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      var response = {
        "statusCode": 200,
        "body": JSON.stringify(data),
        "isBase64Encoded": false
      };
      callback(null, response);
    }
  });
};