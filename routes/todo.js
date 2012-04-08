
var mongoose = require('mongoose'),
    querystring = require('querystring');

exports.todo_get = function (req, res) {
    res.send(mongoose.model('Todo').getLatestTodos());
};

exports.todo_post = function (req, res) {
    var Todo = mongoose.model('Todo'),
        todo = new Todo(req.body);
    todo.save();
    res.send({success: true});
};
