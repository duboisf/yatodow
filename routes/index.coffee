mongoose = require 'mongoose'
todo = require './todo'

module.exports = (app) ->
  app.get '/', (req, res) ->
    mongoose.model('Todo').find {}, (err, docs) ->
      unless err
        todos = docs.sort '_id', 'descending'
        res.render 'home',
          title: 'Yatodow'
          todos: todos
      else
        json =
          success: no
          message: 'Error retrieving todos'
        res.send json

  todo app
