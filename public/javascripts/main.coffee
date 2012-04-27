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

hideCreateTodoForm = ->
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
  $('input.text-input')
    .val('')
    .blur()

createTodo = ->
  rawFormData = $(@).serializeArray()
  url = $(@).attr 'action'
  data = {}
  $.each rawFormData, (i, item) ->
    data[item['name']] = item['value']
  promise = $.post url, data
  promise.success (createdRecord) ->
    hideCreateTodoForm()
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
  promise.error (jqXHR, textStatus, errorThrown) ->
    console.log 'error'
  return false

toggleTodoCompletionState = ->
  currentId = $('.selected > .todo').attr('id')
  promise = $.post '/todo/toggle', id: currentId
  promise.success (updatedTodoDoc) ->
    $('.selected > .todo')
      .removeClass('done-true done-false')
      .addClass('done-' + updatedTodoDoc.done)
  promise.error (jqXHR, textStatus, errorThrown) ->
    console.dir errorThrown
    console.dir textStatus
    console.dir jqXHR
    console.log 'error toggling todo state'

setupBindings = ->
  $(document).bind 'keydown', 'j', ->
    moveSelection 'next'
  $(document).bind 'keydown', 'k', ->
    moveSelection 'prev'
  $(document).bind 'keydown', 't', -> toggleTodoCompletionState()
  $(document).bind 'keydown', 'c', (evt) -> showCreateTodoForm evt

setupEvents = ->
  $('.create-todo > form').submit -> createTodo.call @
  $('.cancel-btn').click -> hideCreateTodoForm()

$(document).ready -> main()
