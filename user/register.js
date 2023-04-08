/** @format */
import bcrypt from 'bcryptjs'
import { save } from './db.js'

const validateInput = (body) => {
  if (!body.hasOwnProperty('email') || !body.hasOwnProperty('password')) {
    const invalidInputError = new Error('Missing email or password')
    invalidInputError.name = 'InvalidInputError'
    throw invalidInputError
  }

  return body
}

const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10)
  return await bcrypt.hash(password, salt)
}

const register = async (event) => {
  try {
    const { email, password } = validateInput(JSON.parse(event.body))
    const hash = await hashPassword(password)
    await save({ email, password: hash })
    return { statusCode: 201 }
  } catch (error) {
    switch (error.name) {
      case 'InvalidInputError':
        return { statusCode: 400, body: error.message }
      case 'ConditionalCheckFailedException':
        return { statusCode: 422, body: 'User with email already exists' }
      default:
        return { statusCode: 500, body: 'Oops: Something went wrong' }
    }
  }
}

export default register
