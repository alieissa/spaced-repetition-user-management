/** @format */
import dynamoose from 'dynamoose'

const UserSchema = new dynamoose.Schema(
  {
    id: Number,
    email: String, // Need to be validated when actual implementation is done
  },
  {
    timestamps: true,
  },
)
const UserCollection = 'spaced-repetition-users'
const User = dynamoose.model(UserCollection, UserSchema)

export { User }
