function FungiorbisSearchSubstrate() {
  var searchSubstrate = this;
  var form;

  searchSubstrate.initialize = function (f) {
    try {
      form = f;

      searchSubstrate.bindAddSubstrate();
      searchSubstrate.bindClearSubstrate();
      searchSubstrate.bindSubstrateChange();

      var $substrateSelect = $('select', '#substrate-select');
      if ($substrateSelect.val().length > 0) {
        $('.add-substrate', '#substrate-input').addClass('hidden');
        $('#substrate-select').removeClass('hidden');
      }
    }
    catch (error) {
//      Notification.send({type: 'Map.initializeMap()', error: error, jsData: {mapData: mapData, hotelMarkerData: hotelMarkerData, selector: mapContainerSelector}});
    }
  };



  searchSubstrate.bindAddSubstrate = function() {
    $(document).on('click', '#substrate-input .add-substrate', function (e) {
      $(this).addClass('hidden');
      $('#substrate-select').removeClass('hidden');
    });
  };

  searchSubstrate.bindClearSubstrate = function() {
    $(document).on('click', '#substrate-input .clear-substrate', function (e) {
      searchSubstrate.resetSubstrate(true)
    });
  };

  searchSubstrate.resetSubstrate = function(shouldSubmit){
    $('.add-substrate', '#substrate-input').removeClass('hidden');
    $('#substrate-select').addClass('hidden');
    var $select = $('select', '#substrate-select');
    if ($select.val().length > 0) {
      $select.val('');
      if (shouldSubmit){
        form.submit();
      }
    }
  };

  searchSubstrate.bindSubstrateChange = function() {
    $(document).on('change', '#substrate-select select', function (e) {
      if ($(this).val() == '') {
        $('.clear-substrate', '#substrate-input').click();
      }
      form.submit();
    });
  }
}