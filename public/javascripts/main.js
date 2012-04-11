
var Todo = {};

Todo.main = function () {
    $('.todo > div').filter(function () {
        return $.trim($(this).text()) === '';
    }).remove();
    $('.todo').first().addClass('selected');
    Todo.setupBindings();
};

Todo.moveSelection = function (dir) {
    if (dir !== 'next' && dir !== 'prev') {
        throw new Error("dir must either be 'next' or 'prev'");
    }
    var selected = $('.todo.selected');
    if ($(selected)[dir]().length === 1) {
        $(selected).removeClass('selected')[dir]().addClass('selected');
    }
};

Todo.setupBindings = function () {
    $(document).bind('keydown', 'c', function () {
        console.log('c pressed');
    });
    $(document).bind('keydown', 'j', function () {
        Todo.moveSelection('next');
    })
    $(document).bind('keydown', 'k', function () {
        Todo.moveSelection('prev');
    })
};

$(document).ready(function () {
    Todo.main();
});
