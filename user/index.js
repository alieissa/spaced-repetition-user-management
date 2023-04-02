/** @format */

/**
 * Only importing entire DynamoDB as works in Lambda. Else we get an error
 * that says unable to import.
 *
 * Refer to https://github.com/aws/aws-sdk-js-v3/issues/3230
 */
import * as AWS from '@aws-sdk/client-dynamodb'

// https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB.html#constructor-property
// TODO Remove credentials and add permissions in IAM to allow lambda access
// to DynamoDB
const client = new AWS.DynamoDB({
  region: process.env.REGION,
  accessKeyId: process.env.DYNAMODB_ACCESS_KEY_ID,
  secretAccessKey: process.env.DYNAMODB_SECRET_ACCESS_KEY,
})

const register = () => {
  console.log('Register route handled')
}

const login = () => {
  console.log('Login route handled')
}
export const handler = (event) => {
  console.log('Handler executed')
  console.log(event)
}
