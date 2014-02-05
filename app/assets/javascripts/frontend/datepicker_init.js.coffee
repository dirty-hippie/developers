

$ ->

  $datepicker = $('input[name="reserve_date"]')
  if $datepicker.length > 0
    offset = [-180, 0]
    window.language = $('#lang a:first').data('id')
    $datepicker.Zebra_DatePicker(
      "offset": offset
      "format": 'd/m/Y'
      'direction': true
      'zIndex': 8
      'always_show_clear': false
      'days': I18n.translations[window.language].admin_js.day_names
      'days_abbr': I18n.translations[window.language].admin_js.abbr_day_names
      'months': I18n.translations[window.language].admin_js.month
      onSelect: (formattedDate, dateISO, dateJS, element ) ->
        if gon?.day_discounts
          reserveOffset = ->
            return moment().hour(23).minute(30) if moment().hours() >= 23 && moment().minutes() >= 30
            offset = if moment().minutes() > 30
              60 - moment().minutes()
            else if moment().minutes < 30            
              30 - moment().minutes()
            else if  moment().minutes is 30            
              30
            time = moment().add('minutes', 60 + offset)
            #time.add('days', 1) if time.isAfter(moment().hours(23).minutes(30))
            time        
          discountRate = ->                      
            discount = gon.day_discounts[dateJS.getDay()]
            hole_start = moment(discount.end_at, 'H.m')
            hole_end = moment(discount.start_at, 'H.m')
            #discount_end.add('day', 1) if discount_end.hours() < 10 #следующий день
            if  (time.isAfter(hole_start, 'minutes') and  time.isBefore(hole_end, 'minutes'))  # time.isSame(hole_start, 'minutes') or 
            #or
            #time.isSame(hole_end, 'minutes') 
              ""              
            else
              " | -#{discount.discount}%"
          
          time_format = ('HH:mm')
          time = moment().startOf("day")  
          cachedOffset = reserveOffset()                   
          dst = $('#reserve_time').empty()
          #создание списка опций для поля выбора
          while time < moment().endOf("day")            
            option = $("<option value=#{time.format(time_format)}>#{time.format(time_format) + "" + discountRate()}</option>")
            option.attr('selected', 'selected') if time.isSame(cachedOffset, 'minute')
            dst.append(option)
            time.add("m", 30)

    )

    magic_number = $datepicker.offset().top + $datepicker.height() + 20
    $('.Zebra_DatePicker').css('top', magic_number)