# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

@updateImagesList = (images) ->
  @image_count = Array.from(images.files).length
  document
    .getElementById 'image_list'
    .innerHTML = "Ilość dodanych zdjęć: #{image_count}"
