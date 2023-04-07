/** @format */
import bcrypt from 'bcryptjs'
import { save } from './db.js'

const validateInput = (body) => {
  if (!body.hasOwnProperty('email') || !body.hasOwnProperty('password')) {
    const invalidInputError = new Error('Missing email or password field')
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
    await save({ email, password: hashPassword(password) })
    return { statusCode: 201 }
  } catch (error) {
    switch (error.name) {
      case 'SyntaxError':
      case 'InvalidInputError':
        return error.message
      default:
        return 'Oops: Something went wrong'
    }
  }
}

export default register
