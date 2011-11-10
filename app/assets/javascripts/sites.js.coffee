$(document).ready ->
  queue = $.manageAjax.create('queue', {queue: 'clear'});
  $("#site_hostname").keyup ->
    opts = 
      lines: 8
      length: 3
      width: 2
      radius: 2
      color: '#000'
      speed: 1.4
      trail: 100
    spinner=$("<span id=\"spinner\" style=\"padding-top:2px;padding-left:5px\"></span>")
    $("#domain_status").html(spinner)
    target = document.getElementById('spinner')
    spinner = new Spinner(opts).spin(target)
    
    queue.add
       url : "/domains/status?domain=#{$("#site_hostname").val()}&tld=#{$("#hostname_suffix").val()}"
       success : (data, textStatus, jqXHR)->
          switch data
            when "available"
              $("#domain_status").html("Available").removeClass("taken").addClass("available")
            else
              $("#domain_status").html("Taken").removeClass("available").addClass("taken")
