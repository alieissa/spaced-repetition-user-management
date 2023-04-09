/** @format */
import login from './login.js'
import logout from './logout.js'
import register from './register.js'

const getRoute = (event) => event.routeKey.split('/')[1]

export const handler = async (event) => {
  switch (getRoute(event)) {
    case 'register':
      return register(event)
    case 'login':
      return login(event)
    case 'logout':
      return logout(event)
    default:
      console.log(event)
  }
}
