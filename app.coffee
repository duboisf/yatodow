express = require 'express'
routes = require './routes'
mongoose = require 'mongoose'
stylus = require 'stylus'

require 'express-mongoose'

mongoose.connect 'mongodb://localhost/yatodow'

mongoose.model 'Todo', require('./models/todo')

app = module.exports = express.createServer()

# Configuration

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use stylus.middleware
    src: __dirname + '/public'
    compress: true
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session secret: 'your secret here'
  app.use app.router
  app.use express.static(__dirname + '/public')

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

# Init routes
routes app

app.listen 3000, ->
  console.log "Express server listening on port %d in %s mode",
    app.address().port,
    app.settings.env
