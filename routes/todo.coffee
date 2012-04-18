mongoose = require('mongoose')
querystring = require('querystring')

exports.todo_get = (req, res) ->
  res.send(mongoose.model('Todo').getLatestTodos())

exports.todo_post = (req, res) ->
  Todo = mongoose.model('Todo')
  todo = new Todo(req.body)
  todo.save()
  res.send success: true
