$(document).ready ->
  queue = $.manageAjax.create('queue', {queue: 'clear'});
  $("#site_domain_attributes_domain").keyup ->
    opts = 
      lines: 8
      length: 3
      width: 4
      radius: 5
      color: '#000'
      speed: 1.4
      trail: 100
    spinner=$("<div id=\"spinner\" style=\"margin-top:20px;margin-left:20px\"></div>")
    $("#domain_status").html(spinner)
    target = document.getElementById('spinner')
    spinner = new Spinner(opts).spin(target)
    
    queue.add
       url : "/domains/status?domain=#{$("#site_domain_attributes_domain").val()}&tld=#{$("#site_domain_attributes_tld").val()}"
       success : (data, textStatus, jqXHR)->
          switch data
            when "available"
              $("#domain_status").html("Available").removeClass("taken").addClass("available")
            else
              $("#domain_status").html("Taken").removeClass("available").addClass("taken")
