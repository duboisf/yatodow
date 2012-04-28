main = ->
  $('.todo > div')
    .filter ->
      $.trim($(@).text()) is ''
    .remove()
  $('.todo-row')
    .first()
    .addClass('selected')
  $('.create-todo').hide()
  adjustSelectionHeight()
  setupBindings()
  setupEvents()
  $('label').inFieldLabels();

moveSelection = (dir) ->
  if dir isnt 'next' and dir isnt 'prev'
    throw new Error("dir must either be 'next' or 'prev'")
  selected = $ '.todo-row.selected'
  if $(selected)[dir]().length is 1
    $(selected)
      .removeClass('selected')[dir]()
      .addClass('selected')
  adjustSelectionHeight()

adjustSelectionHeight = ->
  rowHeight = $('.selected').height()
  $('.selected > .arrow').height(rowHeight - 4)

showCreateTodoForm = (evt) ->
  evt.preventDefault()
  createForm = $('.create-todo')
  selected = $('.selected')
  if selected.length
    $(createForm)
      .detach()
      .insertBefore(selected)
  lastSelectionId = $('.selected > .todo').attr('id')
  $(createForm).data('lastSelectionId', lastSelectionId)
  $(selected).removeClass('selected')
  $(createForm).slideDown('fast')
  $('#title').focus()

hideCreateTodoForm = (afterSlideUpCallback) ->
  createForm = $('.create-todo')
  lastSelectionId = $(createForm).data('lastSelectionId')
  $('#' + lastSelectionId)
    .parent()
    .addClass('selected')
  $(createForm).slideUp 'fast', ->
    console.log 'hidden'
    $(@)
      .detach()
      .prependTo('body')
    if $.isFunction afterSlideUpCallback
      afterSlideUpCallback()
  $('input.text-input')
    .val('')
    .blur()

displayCreatedTodo = (createdRecord) ->
  dateCreated = new Date(createdRecord.date_created).toDateString()
  createdRecord.date_created = dateCreated
  selected = $('.selected')
  newTodo = $('#todo-tmpl').tmpl(createdRecord)
  if selected.length
    $(newTodo).insertBefore('.selected')
    moveSelection 'prev'
  else
    $(newTodo)
      .addClass('selected')
      .appendTo('.todos')
  $(newTodo).hide().slideDown('fast')

createTodo = ->
  rawFormData = $(@).serializeArray()
  url = $(@).attr 'action'
  data = {}
  $.each rawFormData, (i, item) ->
    data[item['name']] = item['value']
  promise = $.post url, data
  promise.done (createdRecord) ->
    hideCreateTodoForm ->
      callback = -> displayCreatedTodo(createdRecord)
      setTimeout callback, 100
  promise.fail (jqXHR, textStatus, errorThrown) ->
    console.dir arg for arg in [errorThrown, textStatus, errorThrown]
    console.log 'error creating todo'
  return false

toggleTodoCompletionState = ->
  currentId = $('.selected > .todo').attr('id')
  promise = $.post '/todo/toggle', id: currentId
  promise.done (updatedTodoDoc) ->
    $('.selected > .todo')
      .removeClass('done-true done-false')
      .addClass('done-' + updatedTodoDoc.done)
  promise.fail (jqXHR, textStatus, errorThrown) ->
    console.dir arg for arg in [errorThrown, textStatus, errorThrown]
    console.log 'error toggling todo state'

deleteTodo = ->
  todoIdToDelete = $('.selected > .todo').attr('id')
  promise = $.ajax
    url: '/todo'
    type: 'DELETE'
    data:
      id: todoIdToDelete
  promise.done ->
    moveSelection if $('.selected').next().length then 'next' else 'prev'
    $('#' + todoIdToDelete).parent().remove()
  promise.fail (jqXHR, textStatus, errorThrown) ->
    console.dir arg for arg in [jqXHR, textStatus, errorThrown]
    console.log 'error deleting todo with id ' + todoIdToDelete

setupBindings = ->
  $(document).bind 'keydown', 'j', -> moveSelection 'next'
  $(document).bind 'keydown', 'k', -> moveSelection 'prev'
  $(document).bind 'keydown', 't', -> toggleTodoCompletionState()
  $(document).bind 'keydown', 'c', (evt) -> showCreateTodoForm evt
  $(document).bind 'keydown', 'd', -> deleteTodo()

setupEvents = ->
  $('.create-todo').submit -> createTodo.call @
  $('.cancel-btn').click -> hideCreateTodoForm()

$(document).ready -> main()
