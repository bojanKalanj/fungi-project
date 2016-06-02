function FungiorbisSearchGrowthType() {
  var searchGrowthType = this;
  var form;

  searchGrowthType.initialize = function (f) {
    try {
      form = f;

      searchGrowthType.bindAddGrowthType();
      searchGrowthType.bindClearGrowthType();
      searchGrowthType.bindGrowthTypeChange();

      var $growthTypeSelect = $('select', '#growth-type-select');
      if ($growthTypeSelect.val().length > 0) {
        $('.add-growth-type', '#growth-type-input').addClass('hidden');
        $('#growth-type-select').removeClass('hidden');
      }
    }
    catch (error) {
//      Notification.send({type: 'Map.initializeMap()', error: error, jsData: {mapData: mapData, hotelMarkerData: hotelMarkerData, selector: mapContainerSelector}});
    }
  };


  searchGrowthType.bindAddGrowthType = function () {
    $(document).on('click', '#growth-type-input .add-growth-type', function (e) {
      $(this).addClass('hidden');
      $('#growth-type-select').removeClass('hidden');
    });
  };

  searchGrowthType.bindClearGrowthType = function () {
    $(document).on('click', '#growth-type-input .clear-growth-type', function (e) {
      resetGrowthType(true);
    });
  };

  searchGrowthType.resetGrowthType = function (shouldSubmit) {
    $('.add-growth-type', '#growth-type-input').removeClass('hidden');
    $('#growth-type-select').addClass('hidden');
    var $select = $('select', '#growth-type-select');
    if ($select.val().length > 0) {
      $select.val('');
      if (shouldSubmit) {
        form.submit();
      }
    }
  };

  searchGrowthType.bindGrowthTypeChange = function () {
    $(document).on('change', '#growth-type-select select', function (e) {
      if ($(this).val() == '') {
        $('.clear-growth-type', '#growth-type-input').click();
      }
      form.submit();
    });
  }
}