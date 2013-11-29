window.delay = (ms, callback) ->
        clearTimeout timer
        timer = setTimeout(callback, ms)
