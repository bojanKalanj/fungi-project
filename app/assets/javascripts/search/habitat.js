function FungiorbisSearchHabitat() {
  var searchHabitat = this;
  var form;

  searchHabitat.initialize = function (f) {
    try {
      form = f;
      searchHabitat.bindAddHabitat();
      searchHabitat.bindClearHabitat();
      searchHabitat.bindHabitatChange();

      searchHabitat.bindAddSubhabitat();
      searchHabitat.bindClearSubhabitat();
      searchHabitat.bindSubhabitatChange();

      searchHabitat.bindAddHabitatSpecies();
      searchHabitat.bindHabitatSpeciesChange();
      searchHabitat.bindClearHabitatSpecies();

      var $habitatSelect = $('select', '#habitat-select');
      if ($habitatSelect.val().length > 0) {
        $('.add-habitat', '#habitat-input').addClass('hidden');
        $('#habitat-select').removeClass('hidden');

        var $subhabitatSelect = $('select', '#subhabitat-select');
        $subhabitatSelect.val($subhabitatSelect.find('[selected]').val());
        if ($subhabitatSelect.length > 0 && $subhabitatSelect.val().length > 0) {
          $('.add-subhabitat', '#habitat-input').addClass('hidden');
          $('#subhabitat-select').removeClass('hidden');
        }
        else {
          $('.add-subhabitat', '#habitat-input').removeClass('hidden');
        }
      }
    }
    catch (error) {
//      Notification.send({type: 'Map.initializeMap()', error: error, jsData: {mapData: mapData, hotelMarkerData: hotelMarkerData, selector: mapContainerSelector}});
    }
  };

  searchHabitat.bindAddHabitat = function () {
    $(document).on('click', '#habitat-input .add-habitat', function (e) {
      $(this).addClass('hidden');
      $('#habitat-select').removeClass('hidden');
    });
  };

  searchHabitat.bindClearHabitat = function () {
    $(document).on('click', '#habitat-input .clear-habitat', function (e) {
      searchHabitat.resetHabitat();
      var $select = $('select', '#habitat-select');
      if ($select.val().length > 0) {
        $select.val('');
        form.submit();
      }
    });
  };

  searchHabitat.bindHabitatChange = function () {
    $(document).on('change', '#habitat-select select', function (e) {
      searchHabitat.resetSubhabitat();
    });
  };

  searchHabitat.resetHabitat = function () {
    $('select', '#subhabitat-select').val('');
    $('.clear-subhabitat', '#habitat-input').click();
    $('.add-habitat', '#habitat-input').addClass('hidden');

    $('#habitat-select').addClass('hidden');
    $('#habitat-species-select').addClass('hidden');
    $('.add-habitat', '#habitat-input').removeClass('hidden');
    $('#selected-habitat-species').html('');

    var $select = $('select', '#habitat-select');
    if ($select.val().length > 0) {
      $select.val('');
      form.submit();
    }
  };

  searchHabitat.resetSubhabitat = function () {
    var $subhabitatSelect = $('select', '#subhabitat-select');

    $subhabitatSelect.val('');
    $('#subhabitat-select').addClass('hidden');
    $('#selected-habitat-species').html('');
    form.submit();
  };

  searchHabitat.bindAddSubhabitat = function () {
    $(document).on('click', '#habitat-input .add-subhabitat', function (e) {
      $(this).addClass('hidden');
      $('#subhabitat-select').removeClass('hidden');
      $('#selected-habitat-species').html('');
    });
  };

  searchHabitat.bindClearSubhabitat = function () {
    $(document).on('click', '#habitat-input .clear-subhabitat', function (e) {
      $('#subhabitat-select').addClass('hidden');
      $('#habitat-species-select').addClass('hidden');
      $('.add-subhabitat', '#habitat-input').removeClass('hidden');
      var $select = $('select', '#subhabitat-select');
      if ($select.val().length > 0) {
        $select.val('');
        form.submit();
      }
    });
  };

  searchHabitat.bindSubhabitatChange = function () {
    $(document).on('change', '#subhabitat-select select', function (e) {
      if ($(this).val() == '') {
        $('.clear-subhabitat', '#habitat-input').click();
      }
      $('#selected-habitat-species').html('');
      form.submit();
    });
  };

  searchHabitat.bindAddHabitatSpecies = function () {
    $(document).on('click', '#habitat-input .add-habitat-species', function (e) {
      $(this).addClass('hidden');
      $('#habitat-species-select').removeClass('hidden');
    });
  };

  searchHabitat.bindHabitatSpeciesChange = function () {
    $(document).on('change', '#habitat-species-select select', function (e) {
      if ($(this).val().length > 0) {
        var key = $(this).val();
        var option = $(this).find('.' + key);
        $('#selected-habitat-species').append(
            '<li>'
            + option.html()
            + '<a class="clear-habitat-species" data-sp="' + key + '"><i class=" fa fa-fw fa-times"></i></a>'
            + '<input type="hidden" name="sp[]" value="' + key + '">' + '</li>');
        option.addClass('hidden');
        $(this).val('');
        $(this).parent().addClass('hidden');
        $('.add-habitat-species', '#habitat-input').removeClass('hidden');
        form.submit();
      }
    });
  };

  searchHabitat.bindClearHabitatSpecies = function () {
    $(document).on('click', '#habitat-input .clear-habitat-species', function (e) {
      var key = $(this).data('sp');
      $('option.' + key, '#habitat-species-select').removeClass('hidden');
      $(this).parent().remove();
      form.submit();
    });
  };

  searchHabitat.resetHabitatSpecies = function () {
    $('option', '#habitat-species-select').removeClass('hidden');
    $('.clear-habitat-species', '#habitat-input').parent().remove();
  }
}