/** @format */
import bcrypt from 'bcryptjs'
import { getItem } from './db.js'
import { BadRequest, ServerException } from './http.js'
import { validateInput } from './validation.js'

const login = async (event) => {
  try {
    const { email, password } = validateInput(JSON.parse(event.body))
    const { Item } = await getItem({ email })

    const isAuthorized = await bcrypt.compare(password, Item.password.S)
    // TODO return JWT or Unauthorized error
    return isAuthorized ? { statusCode: 200 } : { statusCode: 401 }
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
