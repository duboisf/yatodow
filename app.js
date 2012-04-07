
/**
 * Module dependencies.
 */

var express = require('express')
  , todocli = require('./routes/todocli')
  , mongoose = require('mongoose');

require('express-mongoose');

mongoose.connect('mongodb://localhost/todocli');

mongoose.model('Todo', require('./models/todo'));

var app = module.exports = express.createServer();

// Configuration

app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: 'your secret here' }));
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// Routes

app.get('/', todocli.home);

app.get('/todo', function (req, res) {
    var Todo = mongoose.model('Todo');
    res.send(Todo.getLatestTodos());
});

app.post('/todo', function (req, res) {
    var Todo = mongoose.model('Todo');
    console.log(req.param('post'));
    var todo = new Todo(req.param('post'));
    todo.save();
    res.send({success: true});
});

app.get('/test/json', todocli.test_json);

app.listen(3000, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
