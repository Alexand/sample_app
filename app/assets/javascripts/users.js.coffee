# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Countdown 140 Characters for TextAreas
$ ->
  $("textarea[data-text-area]").keyup (e) ->
  	if this.textLength > 140
  		this.value = this.value.substring(0,140)
  	else
    	$ '#characters-left' 
    		.html((140 - this.textLength) + " characters left.")    