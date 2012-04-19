main = ->
  console.log 'ready!'
  $('.todo > div')
    .filter ->
      $.trim($(@).text()) is ''
    .remove()
  $('.todo').first().addClass 'selected'
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
    $('.create-todo').removeClass 'hidden'
    $('#title').focus()

setupEvents = ->
  $('.create-todo > form').submit ->
    formData = $(@).serializeArray()
    url = $(@).attr 'action'
    data = {}
    $.each formData, (i, item) ->
      data[item['name']] = item['value']
    $.post url, data, ->
      window.location = '/'
    $('.create-todo').addClass 'hidden'
    $('input.text-input').val('').blur()
    return false
  $('.cancel-btn').click ->
    $('.create-todo').addClass 'hidden'
    $('input.text-input').val('').blur()

$(document).ready -> main()
