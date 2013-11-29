$ ->
  $("#site_domain_attributes_domain").keyup -> domainChange()
  domainChange = ->
    delay(500, ->
      domain = $("#site_domain_attributes_domain").val()
      tld = 'kissr.com'
      $.get "/domains/status?domain=#{domain}&tld=#{tld}", (response) ->
        if response == "taken"
          $('#new_site .help-block').text("Taken")
          $("#new_site .form-group").removeClass("has-success")
          $("#new_site .form-group").addClass("has-error")
        else
          $('#new_site .help-block').text("Available")
          $("#new_site .form-group").removeClass("has-error")
          $("#new_site .form-group").addClass("has-success")

    )
