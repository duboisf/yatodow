
var Todo = {};

Todo.main = function () {
    $('.todo > div').filter(function () {
        return $.trim($(this).text()) === '';
    }).remove();
    $('.todo').first().addClass('selected');
    Todo.setupBindings();
    $('label').inFieldLabels();
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
    $(document).bind('keydown', 'j', function () {
        Todo.moveSelection('next');
    })
    $(document).bind('keydown', 'k', function () {
        Todo.moveSelection('prev');
    })
    $('.create-todo > form').submit(function () {
        $('.create-todo').addClass('hidden');
        $('input.text-input').val('').blur();
        return false;
    });
    $(document).bind('keydown', 'c', function (evt) {
        evt.preventDefault();
        $('.create-todo').removeClass('hidden');
        $('#title').focus();
    });
};

$(document).ready(function () {
    Todo.main();
});
