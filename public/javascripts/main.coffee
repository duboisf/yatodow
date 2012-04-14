main = ->
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
  $('create-todo > form').submit ->
    $('.create-todo').addClass 'hidden'
    $('input.text-input').val('').blur()
    window.location.reload()

$(document).ready -> main()
