/** @format */

import jwt from 'jsonwebtoken'
import redis from 'redis'
import { validateAuthorizationHeader } from './validation.js'

const client = redis.createClient({
  url: process.env.REDIS_URL,
})

const getIAMPolicy = ({ principalId, effect }) => {
  return {
    principalId,
    policyDocument: {
      Version: '2012-10-17',
      Statement: [
        {
          Action: 'execute-api:Invoke',
          Effect: effect,
          Resource:
            'arn:aws:execute-api:eu-central-1:079829475258:ccb5lhfr50/staging/*', // TODO update once prod environment is ready
        },
      ],
    },
  }
}

const verifyToken = async (token) =>
  jwt.verify(token, process.env.JWT_SECRET_KEY)

export const handler = async (event) => {
  try {
    const headers = validateAuthorizationHeader(event.headers)
    const token = await verifyToken(headers.authorization)
    await client.connect()
    const count = await client.exists(event.headers.authorization)
    const isBlacklisted = count > 0
    client.quit()

    /**
     * It is not necessary to return an IAM policy, we can configure the authorizer
     * to accept a simple response, but most of the documentation is for policy,
     * and it gives us much more granular control so will keep it.
     *
     * See https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-lambda-authorizer.html
     */
    return getIAMPolicy({
      principalId: token.data.email,
      effect: isBlacklisted ? 'Deny' : 'Allow',
    })
  } catch (error) {
    console.error(error)
    /**
     * This returns 401 HTTP response. It is equivalent to callback("Unauthorized")
     *
     * See https://docs.aws.amazon.com/lambda/latest/dg/nodejs-handler.html
     */
    throw new Error('Unauthorized')
  }
}
