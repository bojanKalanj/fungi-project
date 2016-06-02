function FungiorbisSearchUsability() {
  var searchUsability = this;
  var form;

  searchUsability.initialize = function (f) {
    try {
      form = f;

      searchUsability.bindToggleUsability();
      if ($('input[name="edible"]').val().length > 0) {
        $('[data-usability="edible"]').addClass('active');
      }
      if ($('input[name="cultivated"]').val().length > 0) {
        $('[data-usability="cultivated"]').addClass('active');
      }
      if ($('input[name="medicinal"]').val().length > 0) {
        $('[data-usability="medicinal"]').addClass('active');
      }
      if ($('input[name="poisonous"]').val().length > 0) {
        $('[data-usability="poisonous"]').addClass('active');
      }

    }
    catch (error) {
//      Notification.send({type: 'Map.initializeMap()', error: error, jsData: {mapData: mapData, hotelMarkerData: hotelMarkerData, selector: mapContainerSelector}});
    }
  };

  searchUsability.bindToggleUsability = function () {
    $(document).on('click', '#usability .usability', function (e) {
      $(this).toggleClass('active');
      var $input = $(this).parent().find('input[name="' + $(this).data('usability') + '"]');
      if ($input.val().length > 0) {
        $input.val('');
      }
      else {
        $input.val('true');
      }
      form.submit();
    });
  };


}