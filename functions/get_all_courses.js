const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({
    region: "eu-north-1",
    apiVersion: "2012-08-10"
});

exports.handler = (event, context, callback) => {
  const params = {
    TableName: "courses"
  };
  dynamodb.scan(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      const courses = data.Items.map(item => {
        return {
          id: item.id.S,
          title: item.title.S,
          watchHref: item.watchHref.S,
          authorId: item.authorId.S,
          length: item.length.S,
          category: item.category.S
        };
      });
      var response = {
        "statusCode": 200,
        "body": JSON.stringify(courses),
        "isBase64Encoded": false,
        'headers' : {
          'Access-Control-Allow-Origin' : '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
      }
    }
      callback(null, response);
    }
  });
};