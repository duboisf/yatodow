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
  $(document).bind 'keydown', 'c', (evt) ->
    evt.preventDefault()
    $('.create-todo')
      .detach()
      .insertBefore('.selected')
    $('.create-todo').removeClass('hidden')
    $('#title').focus()

setupEvents = ->
  $('.create-todo > form').submit ->
    rawFormData = $(@).serializeArray()
    url = $(@).attr 'action'
    data = {}
    $.each rawFormData, (i, item) ->
      data[item['name']] = item['value']
    promise = $.post url, data
    promise.success (createdRecord) ->
      $('.create-todo')
        .addClass('hidden')
        .detach()
        .prependTo('body')
      $('input.text-input')
        .val('')
        .blur()
      dateCreated = new Date(createdRecord.date_created).toDateString()
      createdRecord.date_created = dateCreated
      $('#todo-tmpl')
        .tmpl(createdRecord)
        .insertBefore('.selected')
      moveSelection 'prev'
    promise.error (jqXHR, textStatus, errorThrown) ->
      console.log 'error'
    return false

  $('.cancel-btn').click ->
    $('.create-todo').addClass('hidden')
    $('input.text-input')
      .val('')
      .blur()

$(document).ready -> main()
