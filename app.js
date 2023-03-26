/** @format */

// Import required AWS SDK clients and commands for Node.js
import dotenv from 'dotenv'
import dynamoose from 'dynamoose'
import express from 'express'
import indexRouter from './routes/index.js'
import usersRouter from './routes/users.js'
import { User } from './User.js'

dotenv.config()
const app = express()

app.use(express.json())
app.use(express.urlencoded({ extended: false }))

app.use('/', indexRouter)
app.use('/users', usersRouter)

const ddb = new dynamoose.aws.ddb.DynamoDB({
  accessKeyId: process.env.AWS_ACCESS_KEY_ID,
  secretAccessKey: process.env.AWS_SECRET_KEY,
  region: 'eu-central-1',
})

// Set DynamoDB instance to the Dynamoose DDB instance
dynamoose.aws.ddb.set(ddb)

User.create({ id: 6, email: 'user@example.com' }).then((args) =>
  console.log('done'),
)
export default app
