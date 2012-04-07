const Schema = require('mongoose').Schema
    , ObjectId = Schema.ObjectId;

var Todo = module.exports = new Schema({
    title: { type: String, required: true },
    body: { type: String, required: false },
    done: { type: Boolean, default: false },
    date_created: { type: Date, default: Date.now },
    date_modified: { type: Date }
})

Todo.pre('save', function (next) {
    console.log('Todo: saving...');
    next();
});

Todo.statics.getLatestTodos = function (callback) {
    return this.find().sort('_id','descending').limit(15);
};
