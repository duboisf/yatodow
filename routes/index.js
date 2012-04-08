var mongoose = require('mongoose'),
    todo = require('./todo');

module.exports = function (app) {

    app.get('/', function (req, res) {
        var todos = mongoose.model('Todo').getLatestTodos();
        res.render('home', {
            title: 'I did it',
            todos: todos
        });
    });

    app.get('/todo', todo.todo_get);
    app.post('/todo', todo.todo_post);
};
