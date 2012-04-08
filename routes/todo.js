
var mongoose = require('mongoose'),
    querystring = require('querystring');

module.exports = function (app) {
    app.get('/todo', function (req, res) {
        res.send(mongoose.model('Todo').getLatestTodos());
    });

    app.post('/todo', function (req, res) {
        var Todo = mongoose.model('Todo'),
            todo = new Todo(req.body);
        todo.save();
        res.send({success: true});
    });
};
