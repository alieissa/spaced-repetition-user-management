/** @format */

const validateInput = (body) => {
  if (!body.hasOwnProperty('email') || !body.hasOwnProperty('password')) {
    const invalidInputError = new Error('Missing email or password')
    invalidInputError.name = 'InvalidInputError'
    throw invalidInputError
  }
  return body
}

const validateAuthorizationHeader = (headers) => {
  if (!headers.hasOwnProperty('authorization')) {
    const invalidAuthorizationHeaderError = new Error(
      'Authorization token missing',
    )
    invalidAuthorizationHeaderError.name = 'InvalidAuthorizationHeaderError'
    throw invalidAuthorizationHeaderError
  }
  return headers
}
export { validateInput, validateAuthorizationHeader }
