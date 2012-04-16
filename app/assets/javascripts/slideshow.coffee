soundManager.url = '/swf/'
soundManager.flashVersion = 9
soundManager.useFlashBlock = false
mute= true
playing= true
timeout = null

$ ->
  $(".stop").click ->
    soundManager.getSoundById("kissr").stop()
    clearTimeout(timeout)
    $(".scene").hide()
    $(".welcome").show()
    $(".stop,.mute").hide()

  $(".mute").click ->
    $(this).children().toggle()
    if mute
      soundManager.getSoundById("kissr").setVolume(0)
    else
      soundManager.getSoundById("kissr").setVolume(100)

    mute = !mute


  $(".play").click ->
    $(".mute .icon-volume-up").hide()
    $(".stop,.mute").fadeIn()
    soundManager.createSound(
      id: 'kissr',
      url: '/welcome.mp3',
      autoLoad: true,
      ).play()
    
    $(".welcome").fadeOut ->
      $(".scene:first").fadeIn ->
        timeout = setTimeout("window.nextScene()",3100)
window.nextScene = ->
  $thisScene = $(".scene:visible")
  if $thisScene.next().hasClass("scene")
    $thisScene.fadeOut ->
      $thisScene.next().fadeIn()
      timeout = setTimeout("window.nextScene()",3100)
  else
    $('#new_site').after($("<div class=\"free\">Free</div>"))
    window.pulses = 5
    window.pulsateFree()




