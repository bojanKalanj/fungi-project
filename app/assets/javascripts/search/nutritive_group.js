function FungiorbisSearchNutritiveGroup() {
  var searchNutritiveGroup = this;
  var form;

  searchNutritiveGroup.initialize = function (f) {
    try {
      form = f;

      searchNutritiveGroup.bindAddNutritiveGroup();
      searchNutritiveGroup.bindClearNutritiveGroup();
      searchNutritiveGroup.bindNutritiveGroupChange();

      var $nutritiveGroupSelect = $('select', '#nutritive-group-select');
      if ($nutritiveGroupSelect.val().length > 0) {
        $('.add-nutritive-group', '#nutritive-group-input').addClass('hidden');
        $('#nutritive-group-select').removeClass('hidden');
      }

    }
    catch (error) {
//      Notification.send({type: 'Map.initializeMap()', error: error, jsData: {mapData: mapData, hotelMarkerData: hotelMarkerData, selector: mapContainerSelector}});
    }
  };

  searchNutritiveGroup.bindAddNutritiveGroup = function () {
    $(document).on('click', '#nutritive-group-input .add-nutritive-group', function (e) {
      $(this).addClass('hidden');
      $('#nutritive-group-select').removeClass('hidden');
    });
  };

  searchNutritiveGroup.bindClearNutritiveGroup = function () {
    $(document).on('click', '#nutritive-group-input .clear-nutritive-group', function (e) {
      searchNutritiveGroup.resetNutritiveGroup(true);
    });
  };

  searchNutritiveGroup.resetNutritiveGroup = function (shouldSubmit){
    $('.add-nutritive-group', '#nutritive-group-input').removeClass('hidden');
    $('#nutritive-group-select').addClass('hidden');
    var $select = $('select', '#nutritive-group-select');
    if ($select.val().length > 0) {
      $select.val('');
      if (shouldSubmit){
        form.submit();
      }
    }
  };

  searchNutritiveGroup.bindNutritiveGroupChange =function () {
    $(document).on('change', '#nutritive-group-select select', function (e) {
      if ($(this).val() == '') {
        $('.clear-nutritive-group', '#nutritive-group-input').click();
      }
      form.submit();
    });
  };
}