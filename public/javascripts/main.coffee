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
  selected = $('.todo-row.selected')
  if $(selected)[dir]().length is 1
    $(selected)
      .removeClass('selected')[dir]()
      .addClass('selected')
  adjustSelectionHeight()
  selected = $('.todo-row.selected')[0]
  if not elementInViewport selected
    top = 
      if dir is 'next'
        selected.offsetTop - selected.offsetHeight * 2
      else
        prevPageTop = window.pageYOffset - window.innerHeight
        prevPageTop + selected.offsetHeight * 2
    $('body').stop().animate(scrollTop: top, 1500, 'easeOutQuint')

adjustSelectionHeight = ->
  rowHeight = $('.selected').height()
  $('.selected > .arrow').height(rowHeight - 4)

showCreateTodoForm = (evt) ->
  evt.preventDefault()
  formHeight = $('.create-todo').height()
  form = $('.create-todo > form').hide().detach()
  formContainer = $('.create-todo').detach()
  $(formContainer).height(formHeight)
  selected = $('.selected')
  if selected.length
     $(formContainer).insertBefore(selected)
  else
    $(form).appendTo('.todos')
  lastSelectionId = $('.selected > .todo').attr('id')
  $(formContainer)
    .slideDown 400, ->
      $(form)
        .data('lastSelectionId', lastSelectionId)
        .appendTo(formContainer)
        .fadeIn 400, ->
          $('#title').focus()

hideCreateTodoForm = (afterSlideUpCallback) ->
  createForm = $('.create-todo')
  lastSelectionId = $(createForm).data('lastSelectionId')
  $('#' + lastSelectionId)
    .parent()
    .addClass('selected')
  $(createForm).slideUp 'fast', ->
    $(@)
      .detach()
      .prependTo('body')
    if $.isFunction afterSlideUpCallback
      afterSlideUpCallback()
  $('input.text-input')
    .val('')
    .blur()

showCreatedTodo = (createdRecord) ->
  dateCreated = new Date(createdRecord.date_created).toDateString()
  createdRecord.date_created = dateCreated
  selected = $('.selected')
  newTodo = $('#todo-tmpl').tmpl(createdRecord)
  movePrev = false
  if selected.length
    $(newTodo).insertBefore('.selected')
    movePrev = true
  else
    $(newTodo).appendTo('.todos')
  $(newTodo).hide().slideDown 'fast', ->
    if movePrev
      moveSelection 'prev'
    else
      $(newTodo).addClass('selected')

createTodo = ->
  rawFormData = $(@).serializeArray()
  url = $(@).attr 'action'
  data = {}
  $.each rawFormData, (i, item) ->
    data[item['name']] = item['value']
  promise = $.post url, data
  promise.done (createdRecord) ->
    hideCreateTodoForm ->
      callback = -> showCreatedTodo(createdRecord)
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
    $('#' + todoIdToDelete)
      .parent()
      .fadeOut 'normal', ->
        $(@)
          .css('display', 'block')
          .css('visibility', 'hidden')
        $(@).slideUp 'normal', ->
          $(@).remove()
  promise.fail (jqXHR, textStatus, errorThrown) ->
    console.dir arg for arg in [jqXHR, textStatus, errorThrown]
    console.log 'error deleting todo with id ' + todoIdToDelete

elementInViewport = (el) ->
    rec = el.getBoundingClientRect()
    result = rec.top >= 0 and rec.left >= 0
    result &&= rec.bottom <= window.innerHeight
    result and rec.right <= window.innerWidth

setupBindings = ->
  $(document).bind 'keydown', 'j', -> moveSelection 'next'
  $(document).bind 'keydown', 'k', -> moveSelection 'prev'
  $(document).bind 'keydown', 't', -> toggleTodoCompletionState()
  $(document).bind 'keydown', 'c', (evt) -> showCreateTodoForm evt
  $(document).bind 'keydown', 'd', -> deleteTodo()

setupEvents = ->
  $('.create-todo > form').submit -> createTodo.call @
  $('.cancel-btn').click -> hideCreateTodoForm()
  $('.todo').click (evt) ->
    $('.selected').removeClass('selected')
    $(@).parent().addClass('selected')
    adjustSelectionHeight()

$(document).ready -> main()
