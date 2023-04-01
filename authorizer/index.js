/** @format */

// AWS is included by default in Lambdas
// https://aws.amazon.com/blogs/developer/why-and-how-you-should-use-aws-sdk-for-javascript-v3-on-node-js-18/#:~:text=The%20Node.,default%20in%20AWS%20Lambda%20Node
// Only importing these to make sure imports work and nothing else
import AWS from 'aws-sdk'
import { ExtractJwt } from 'passport-jwt'

// https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/DynamoDB.html#constructor-property
const client = new AWS.DynamoDB({
  region: process.env.REGION || 'eu-central-1',
  accessKeyId: process.env.API_AUTHORIZER_ACCESS_KEY_ID,
  secretAccessKey: process.env.API_AUTHORIZER_SECRET_ACCESS_KEY,
})
const opts = { jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken() }

export const handler = () => {
  console.log('Handler executed')
}
