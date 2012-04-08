var mongoose = require('mongoose'),
    todo = require('./todo');

module.exports = function (app) {

    app.get('/', function (req, res) {
        var todos = mongoose.model('Todo').find();
        res.render('home', {
            title: 'I did it',
            todos: todos
        });
    });

    todo(app);
};
