class Og
  constructor: ->
    @bind_click()

  bind_click: ->
    $(".header .tag_type_header").on 'change', (e) ->
      $el = $(this)
      $parent = $el.parents('.header:first')
      if $el.val() == '7'
        $($parent.find(".locale_tabs:first")).hide()
        $($parent.find(".add_nested_fields")).click()
      else
        $($parent.find(".nested_fields .fields")).remove()
        $($parent.find(".locale_tabs:first")).show()




$ ->
  new Og()