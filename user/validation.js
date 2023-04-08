/** @format */

const validateInput = (body) => {
  if (!body.hasOwnProperty('email') || !body.hasOwnProperty('password')) {
    const invalidInputError = new Error('Missing email or password')
    invalidInputError.name = 'InvalidInputError'
    throw invalidInputError
  }
  return body
}

export { validateInput }
