$ -> 
  #window.leakFree()
  #setInterval("window.moveFree()",50)

window.moveFree = ->
  console.log($(".free").offset().top+1)
  $(".free").each ->
    if $(this).offset().top < 550
      $(this).css('top',$(this).offset().top+5)
    else 
      $(this).css('top',"487px")

window.leakFree = ->
  $('#new_site').after($("<div class=\"free\">Free</div>"))
  $('#new_site').after($("<div class=\"free\">Free</div>"))
  $('#new_site').after($("<div class=\"free\">Free</div>"))
  $(".free").each ->
    $(this).css('top',$(this).offset().top+Math.floor(Math.random()*80))
    $(this).css('left',$(this).offset().left+Math.floor(Math.random()*20))

