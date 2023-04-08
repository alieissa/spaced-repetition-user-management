/**
 * Only importing entire DynamoDB as works in Lambda. Else we get an error
 * that says unable to import.
 *
 * Refer to https://github.com/aws/aws-sdk-js-v3/issues/3230
 *
 * @format
 */
import * as AWS from '@aws-sdk/client-dynamodb'

// https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB.html#constructor-property
const client = new AWS.DynamoDB({
  region: process.env.REGION,
})

const getInput = ({ email, password }) => ({
  Item: {
    email: {
      S: email,
    },
    password: {
      S: password,
    },
  },
  TableName: process.env.DYNAMODB_TABLENAME,
  ConditionExpression: 'attribute_not_exists(email)',
})

const save = async (data) => client.putItem(getInput(data))
export { save }
