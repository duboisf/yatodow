mongoose = require('mongoose')
querystring = require('querystring')

exports.get = (req, res) ->
  res.send(mongoose.model('Todo').getLatestTodos())

exports.post = (req, res) ->
  Todo = mongoose.model('Todo')
  console.log req.body
  todo = new Todo(req.body)
  todo.save()
  res.send success: true
