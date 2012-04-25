main = ->
  $('.todo > div')
    .filter ->
      $.trim($(@).text()) is ''
    .remove()
  $('.todos > .todo')
    .first()
    .addClass('selected')
  setupBindings()
  setupEvents()
  $('label').inFieldLabels();

moveSelection = (dir) ->
  if dir isnt 'next' and dir isnt 'prev'
    throw new Error("dir must either be 'next' or 'prev'")
  selected = $ '.todo.selected'
  if $(selected)[dir]().length is 1
    $(selected)
      .removeClass('selected')[dir]()
      .addClass('selected')

setupBindings = ->
  $(document).bind 'keydown', 'j', ->
    moveSelection 'next'
  $(document).bind 'keydown', 'k', ->
    moveSelection 'prev'
  $(document).bind 'keydown', 't', ->
    currentId = $('.selected').attr('id')
    promise = $.post '/todo/toggle', id: currentId
    promise.success (updatedTodoDoc) ->
      $('.selected')
        .removeClass('done-true done-false')
        .addClass('done-' + updatedTodoDoc.done)
    promise.error (jqXHR, textStatus, errorThrown) ->
      console.dir errorThrown
      console.dir textStatus
      console.dir jqXHR
      console.log 'error toggling todo state'
  $(document).bind 'keydown', 'c', (evt) ->
    evt.preventDefault()
    createForm = $('.create-todo')
    selected = $('.selected')
    if selected.length
      $(createForm)
        .detach()
        .insertBefore(selected)
    $(createForm).removeClass('hidden')
    $('#title').focus()

resetForm = ->
  $('.create-todo')
    .addClass('hidden')
    .detach()
    .prependTo('body')
  $('input.text-input')
    .val('')
    .blur()

setupEvents = ->
  $('.create-todo > form').submit ->
    rawFormData = $(@).serializeArray()
    url = $(@).attr 'action'
    data = {}
    $.each rawFormData, (i, item) ->
      data[item['name']] = item['value']
    promise = $.post url, data
    promise.success (createdRecord) ->
      resetForm()
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

  $('.cancel-btn').click ->
    $('.create-todo').addClass('hidden')
    $('input.text-input')
      .val('')
      .blur()

$(document).ready -> main()
