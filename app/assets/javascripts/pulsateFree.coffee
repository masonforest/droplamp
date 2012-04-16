window.pulsateFree = ->
  window.pulses-=1
  $(".free").animate {"font-size":"30px"}, ->
    $(".free").animate {"font-size":"15px"}, ->
      if window.pulses
        window.pulsateFree()
      else
        $(".free").hide()

