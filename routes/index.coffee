mongoose = require 'mongoose'
todo = require './todo'

module.exports = (app) ->
  app.get '/', (req, res) ->
    todos = mongoose.model('Todo').getLatestTodos()
    res.render 'home',
      title: 'Todo'
      todos: todos

  todo app
