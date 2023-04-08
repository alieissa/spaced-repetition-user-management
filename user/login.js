/** @format */
import bcrypt from 'bcryptjs'
import jwt from 'jsonwebtoken'
import * as User from './db.js'
import { BadRequest, OK, ServerException, Unauthorized } from './http.js'
import { validateInput } from './validation.js'

const getToken = (data) => {
  return jwt.sign({ data }, process.env.JWT_SECRET_KEY, { expiresIn: '72h' })
}

const login = async (event) => {
  try {
    const { email, password } = validateInput(JSON.parse(event.body))
    const { Item } = await User.get({ email })

    const isAuthorized = await bcrypt.compare(password, Item.password.S)
    const token = getToken({ email: Item.email.S })
    return isAuthorized ? OK(token) : Unauthorized()
  } catch (error) {
    switch (error.name) {
      case 'InvalidInputError':
        return BadRequest(error.message)
      default:
        return ServerException()
    }
  }
}

export default login
