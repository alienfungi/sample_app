# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('#micropost_content').keyup ->
    quantity = $(this).val().length
    remaining = 140 - quantity
    remaining_div = $('#remaining')

    if remaining >= 0
      remaining_div.html "#{140 - quantity} characters remaining."
    else
      remaining_div.html "too many characters"
      remaining_div.addClass "alert-error"