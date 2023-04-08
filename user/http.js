/** @format */

const BadRequest = (message) => ({ statusCode: 400, body: message })

const ServerException = () => ({
  statusCode: 500,
  body: 'Oops: Something went wrong',
})

const UnprocessableContent = (message) => ({
  statusCode: 422,
  body: message,
})

const OK = (body) => ({
  statusCode: 200,
  body,
})

const Created = () => ({
  statusCode: 201,
})

const Unauthorized = () => ({
  statusCode: 401,
})

export {
  BadRequest,
  Created,
  OK,
  ServerException,
  UnprocessableContent,
  Unauthorized,
}
