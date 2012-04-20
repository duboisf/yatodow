mongoose = require 'mongoose'
querystring = require 'querystring'

module.exports = (app) ->
  console.log 'in todo routes'
  app.get '/todo', (req, res) ->
    res.send(mongoose.model('Todo').getLatestTodos())

  app.post '/todo', (req, res) ->
    Todo = mongoose.model 'Todo'
    console.log req.body
    if !req.body.title
      msg = 
        success: false
        message: "Title required"
      res.send msg, 400
      return
    todo = new Todo req.body
    todo.save()
    res.send todo
