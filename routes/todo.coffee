mongoose = require 'mongoose'
querystring = require 'querystring'

sendError = (res, msg) ->
  json =
    success: false
    message: msg
  res.send json, 400

module.exports = (app) ->
  app.get '/todo', (req, res) ->
    res.send(mongoose.model('Todo').getLatestTodos())

  app.post '/todo', (req, res) ->
    Todo = mongoose.model 'Todo'
    if !req.body.title
      msg = 
        success: false
        message: "Title required"
      res.send msg, 400
      return
    todo = new Todo req.body
    todo.save ->
      res.send todo

  app.delete '/todo', (req, res) ->
    Todo = mongoose.model 'Todo'
    idToDelete = req.body.id
    console.log 'Removing todo with id: ' + idToDelete
    Todo.findById idToDelete, (err, todoDocument) ->
      unless err
        todoDocument.remove()
        res.send success: true
      else
        sendError res, "Error deleting: can't find todo with id " + idToDelete

  app.post '/todo/toggle', (req, res) ->
    Todo = mongoose.model 'Todo'
    Todo.findById req.body.id, (err, todoDocument) ->
      console.log "querry result: err: " + err
      unless err
        todoDocument.done = !todoDocument.done
        todoDocument.save (err) ->
          console.log 'save done, err: ' + err
          unless err
            res.send todoDocument
          else
            sendError res, "Error saving new todo"
      else
        sendError res, "Couldn't find document id: " + req.body.id
