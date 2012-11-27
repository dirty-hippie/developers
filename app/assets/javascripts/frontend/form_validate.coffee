class FormValidate

  constructor: ->
    @validate_email()
    @enter_phone()
    @validPass()
    @validNameLastname()


  validate_email: ->
    self = @
    $email  = $('#new_user #user_email')
    $email.keyup (event) ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "w"
      if value is ""
        $el.tipsy "hide"
      else
        if /[а-я]+/i.test(value)
          only_latin_words($el)
          $el.tipsy "show"
        else if value.length > 7
          input_correct_email($el)
          #original-title=Введите корректный e-mail
          pattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$/i
          if pattern.test(value)
            $el.tipsy "hide"
          else
            $el.tipsy "show"
        else
          $el.tipsy "hide"

    $email.blur ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "w"
      input_correct_email($el)
      if value is ""
        $el.tipsy "hide"
      else
        if /[а-я]+/i.test(value)
          only_latin_words($el)
          $el.tipsy "show"
        else if value.length > 0
          input_correct_email($el)
          #original-title=Введите корректный e-mail
          # /^[a-zA-Z0-9._-]+@[a-zA-Z0-9-]+\.[a-zA-Z.]{2,5}$/i
          pattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,5}$/i
          if pattern.test(value)
            $el.tipsy "hide"
          else
            $el.tipsy "show"
        else
          $el.tipsy "hide"

  enter_phone: ->
    #event enter phone (only numbers)
    $user_phone = $("#new_user #user_phone")
    $user_phone.keyup (event) ->
      $el = $(this)
      $el.tipsy
        trigger: "manual"
        gravity: "w"


      # Allow: backspace, delete, tab, escape, and enter

      # Allow: Ctrl+A

      # Allow: home, end, left, right
      if event.keyCode is 46 or event.keyCode is 8 or event.keyCode is 9 or event.keyCode is 27 or event.keyCode is 13 or (event.keyCode is 65 and event.ctrlKey is true) or (event.keyCode >= 35 and event.keyCode <= 39)
        # let it happen, don't do anything
        return
      else
        # Ensure that it is a number and stop the keypress
        if event.shiftKey or (event.keyCode < 48 or event.keyCode > 57) and (event.keyCode < 96 or event.keyCode > 105)
          hide = ->
            $el.tipsy "hide"
          $el.tipsy "show"
          setTimeout hide, 1500
          event.preventDefault()
        else
          $(this).tipsy "hide"

    $user_phone.blur ->
      $el = $(this)
      $el.tipsy
        trigger: "manual"
        gravity: "w"

      $el.tipsy "hide"

  validPass:  ->
    $user_pass = $("#new_user #user_password")
    $user_pass.keyup (event) ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "w"

      if value is ""
        $el.tipsy "hide"
      else
        if /[а-я]+/i.test(value)
          only_latin_words($el)
          $el.tipsy "show"
        else
          $el.tipsy "hide"

    $user_pass.blur ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "w"

      only_latin_words($el)
      if value is ""
        $el.tipsy "hide"
      else
        if /[а-я]+/i.test(value)
          only_latin_words($el)
          $el.tipsy "show"
        else
          $el.tipsy "hide"

  validNameLastname: ->
    $user_first_name = $("#new_user #user_first_name")
    $user_first_name.keyup (event) ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "s"

      if value is ""
        $el.tipsy "hide"
      else
        if /[^а-яa-z0-9_-]+/i.test(value)
          only_latin_cyril($el)
          $el.tipsy "show"
        else
          $el.tipsy "hide"

    $user_first_name.blur ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "s"

      if value is ""
        $el.tipsy "hide"
      else
        if /[^а-яa-z0-9_-]+/i.test(value)
          only_latin_cyril($el)
          $el.tipsy "show"
        else
          $el.tipsy "hide"

    $user_last_name = $("#new_user #user_last_name")
    $user_last_name.keyup (event) ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "s"

      if /[^а-яa-z0-9_-]+/i.test(value)
        only_latin_cyril($el)
        $el.tipsy "show"
      else
        $el.tipsy "hide"

    $user_last_name.blur ->
      $el = $(this)
      value = $el.val()
      $el.tipsy
        trigger: "manual"
        gravity: "s"

      if value is ""
        $el.tipsy "hide"
      else
        if /[^а-яa-z0-9_-]+/i.test(value)
          only_latin_cyril($el)
          $el.tipsy "show"
        else
          $el.tipsy "hide"


    #private methods
    # Todo use I18n.js for translations
  input_correct_email = ($el) ->
    $el.attr "original-title", "Введите корректный e-mail"

  only_latin_words = ($el) ->
    $el.attr "original-title", "Только латиница"

  only_latin_cyril= ($el) ->
    $el.attr "original-title", "Разрешается вводить латиницу, кириллицу, \"-\", \"_\""

$ ->
  new FormValidate() if $("#new_user").size() > 0