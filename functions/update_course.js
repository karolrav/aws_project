const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({
    region: "eu-north-1",
    apiVersion: "2012-08-10"
});

exports.handler = (event, context, callback) => {
  const params = {
    Item: {
      id: {
        S: event.id
      },
      title: {
        S: event.title
      },
      watchHref: {
        S: event.watchHref
      },
      authorId: {
        S: event.authorId
      },
      length: {
        S: event.length
      },
      category: {
        S: event.category
      }
    },
    TableName: "courses"
  };
  dynamodb.putItem(params, (err, data) => {
    if (err) {
      console.log(err);
      callback(err);
    } else {
      const response = {
        statusCode: 200,
        body: JSON.stringify({
          id: data.Item.id.S,
          title: data.Item.title.S,
          watchHref: data.Item.watchHref.S,
          authorId: data.Item.authorId.S,
          length: data.Item.length.S,
          category: data.Item.category.S
        }),
        isBase64Encoded: false,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Headers": "Content-Type",
          "Access-Control-Allow-Methods": "OPTIONS,POST,GET,PUT"
        }
      };
      callback(null, response);
    }
  });
};