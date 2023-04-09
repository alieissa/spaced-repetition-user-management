/** @format */

import jwt from 'jsonwebtoken'
import redis from 'redis'
import { BadRequest, OK, ServerException } from './http.js'
import { validateAuthorizationHeader } from './validation.js'

const client = redis.createClient({
  url: process.env.REDIS_URL,
})

/**
 * Options for #client.set Removes token after removed after 72h,
 * i.e. length of its expiry.
 */
const options = {
  EX: 72 * 60 * 60,
}

const verifyToken = async (token) =>
  jwt.verify(token, process.env.JWT_SECRET_KEY)

const logout = async (event) => {
  try {
    const headers = validateAuthorizationHeader(event.headers)
    const token = await verifyToken(headers.authorization)
    await client.connect()
    await client.set(event.headers.authorization, token.data.email, options)
    client.quit()
    return OK()
  } catch (error) {
    switch (error.name) {
      case 'InvalidAuthorizationHeaderError':
      case 'JsonWebTokenError': // TODO Find a  better return for invalid/expired tokens
        return BadRequest()
      default:
        return ServerException()
    }
  }
}

export default logout
