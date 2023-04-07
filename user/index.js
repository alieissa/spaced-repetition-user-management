/** @format */
import register from './register.js'

const getRoute = (event) => {
  return event.routeKey.split('/')[1]
}
export const handler = async (event) => {
  switch (getRoute(event)) {
    case 'register':
      return await register(event)
    default:
      console.log(event)
  }
}
