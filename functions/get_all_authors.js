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
      const authors = data.Items.map(item => {
        return { id: item.id.S, firstName: item.firstName.S, lastName: item.lastName.S };
      });
      var response = {
        "statusCode": 200,
        "body": JSON.stringify(authors),
        "isBase64Encoded": false,
        'headers' : {
          'Access-Control-Allow-Origin' : '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
      }
      };
      callback(null, response);
    }
  });
};