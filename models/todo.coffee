Schema = require('mongoose').Schema
ObjectId = Schema.ObjectId

Todo = module.exports = new Schema
  title: 
    type: String
    required: true
  project: String
  notes: String
  done:
    type: Boolean
    default: false
  date_created:
    type: Date
    default: Date.now
  date_modified: 
    type: Date
  order:
    type: Number

Todo.pre 'save', (next) ->
  console.log 'Todo: saving...'
  next()

Todo.statics.getLatestTodos = (callback) ->
  @.find().sort('_id', 'descending').limit 15
