class FilterInput
  constructor: ->
    @checkIfNeeded()
    @bindChangeListener()

  checkIfNeeded: () ->
    querystring = window.location.search
    needToCheck = $.deparam querystring.slice(1)
    for filter, values of needToCheck
      for value in values
        $("#refine input[value='#{value}'][data-type='#{filter}']").click() unless $("#refine input[value='#{value}'][data-type='#{filter}']").is(':checked')

  bindChangeListener: () ->
    $('#refine input[type=checkbox]').change ->
      result = {}
      $('#refine input').each( ->
        type = $(this).data('type')
        result[type] = [] if result[type] is undefined
        result[type].push($(this).val()) if $(this).is(':checked')
      )
      baseURL = window.location.host + window.location.pathname
      newQuery = $.param result
      window.history.pushState('',null, baseURL + '/?' + newQuery)






$ ->
  if $('#refine').length isnt 0
    new FilterInput()
  ###
    ///
      (?<=filters=) # after word filters=
      [\w+%=&\d]*   # look for characters, %, =, &, and digits
    ///
  ###


