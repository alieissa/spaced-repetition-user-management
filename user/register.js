/** @format */
import bcrypt from 'bcryptjs'
import * as User from './db.js'
import { BadRequest, Created, ServerException } from './http.js'
import { validateInput } from './validation.js'

const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10)
  return await bcrypt.hash(password, salt)
}

const register = async (event) => {
  try {
    const { email, password } = validateInput(JSON.parse(event.body))
    const hash = await hashPassword(password)
    await User.save({ email, password: hash })
    return Created()
  } catch (error) {
    switch (error.name) {
      case 'InvalidInputError':
        return BadRequest(error.message)
      case 'ConditionalCheckFailedException':
        return UnprocessableContentError('User with email already exists')
      default:
        return ServerException()
    }
  }
}

export default register
