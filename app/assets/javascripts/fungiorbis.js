var Fungiorbis = (function () {

  function transliterate(string) {
    var cyr = ['А', 'а', 'Б', 'б', 'В', 'в', 'Г', 'г', 'Д', 'д', 'Ђ', 'ђ', 'Е', 'е', 'Ж', 'ж', 'З', 'з', 'И', 'и', 'Ј', 'ј', 'К', 'к', 'Л', 'л', 'Љ', 'љ', 'М', 'м', 'Н', 'н', 'Њ', 'њ', 'О', 'о', 'П', 'п', 'Р', 'р', 'С', 'с', 'Т', 'т', 'Ћ', 'ћ', 'У', 'у', 'Ф', 'ф', 'Х', 'х', 'Ц', 'ц', 'Ч', 'ч', 'Џ', 'џ', 'Ш', 'ш'];
    var lat = ['A', 'a', 'B', 'b', 'V', 'v', 'G', 'g', 'D', 'd', 'Đ', 'đ', 'E', 'e', 'Ž', 'ž', 'Z', 'z', 'I', 'i', 'J', 'j', 'K', 'k', 'L', 'l', 'Lj', 'lj', 'M', 'm', 'N', 'n', 'Nj', 'nj', 'O', 'o', 'P', 'p', 'R', 'r', 'S', 's', 'T', 't', 'Ć', 'ć', 'U', 'u', 'F', 'f', 'H', 'h', 'C', 'c', 'Č', 'č', 'Dž', 'dž', 'Š', 'š'];

    for (var i = 0; i < 60; i++) {
      string = string.replace(cyr[i], lat[i]);
    }
    return string;
  }

  return {
    transliterate: transliterate
  }
}());


$(document).on('ready page:load', function () {

  $(document).on('blur', 'input[data-locale]', function (e) {
    var $form = $(this).closest('form');

    $form.find('[data-parent]').each(function (index) {
      var $parentValue = $form.find('[data-locale=' + $(this).data('parent') + ']').val();

      $(this).val(Fungiorbis.transliterate($parentValue));
    });
  });

  $(document).on('click', '[data-toggle]', function (e) {
    var targets = $(this).data('toggle').split(',');

    $.each(targets, function (index, targetSelector) {
      $(targetSelector).toggleClass('hidden');
    });

    e.stopPropagation();
    return false;
  });

  $(document).on('click', '[data-toggle-class]', function (e) {
    var targets = $(this).data('toggle-class-target').split(',');
    var classes = $(this).data('toggle-class').split(',');

    $.each(targets, function (index1, targetSelector) {
      $.each(classes, function (index2, klass) {
        $(targetSelector).toggleClass(klass);
      });
    });

    e.stopPropagation();
    return false;
  });

  $('#page-wrapper').css('min-height', window.innerHeight - $('.navbar-header').height());
  $('.dataTable').dataTable({
    "language": dataTablesI18n[$('html').attr('lang')]
  });

  $(document).on('click', 'a.submit-btn', function (e) {
    e.stopPropagation();
    e.preventDefault();
  });

  $(document).on('change', '#habitats-select', function (e) {
    if ($(this).val().length > 0) {
      var url = $(this).data('url') + $(this).val();
      $('.add-habitat').attr('href', url);
    }
  });

  $(document).on('click', '.add-habitat', function (e) {
    if ($(this).attr('href').split('habitats')[1] === undefined) {
      e.stopPropagation();
      e.preventDefault();
      return false;
    }
    else {
      if ($(this).data('max') == 1) {
        $(this).parent().addClass('hidden');
      }
    }
  });

  $(document).on('click', '.remove-habitat', function (e) {
    $(this).closest('.habitat.panel').remove();
    $('.add-habitat').parent().removeClass('hidden');
    e.stopPropagation();
    e.preventDefault();
  });

  $(document).on('click', '.choose-subhabitat', function (e) {
    $(this).parent().find('select').removeClass('hidden');
    $(this).remove();
    e.stopPropagation();
    e.preventDefault();
  });

  $(document).on('change', '.select.subhabitat', function (e) {
    if ($(this).val().length > 0) {
      $('.select.subhabitat.active').removeClass('active');
      $(this).addClass('active');
      var url = $(this).data('habitats-url') + $(this).val();
      $.get(url, function (data) {
      });
    }
  });

  $(document).on('focusin', '.sidebar-search', function (e) {
    if ($(this).data('species-search-active') == false) {
      window.location.href = $(this).data('species-search-path')
    }
  });

  if ($('#monthly_specimens_count').length > 0 && monthly_specimens_count_data !== undefined){
    setTimeout(function(){
      Morris.Line(monthly_specimens_count_data);
      $('#monthly_specimens_count').find('i').remove();
    }, 2000);
  }

  if ($('#yearly_field_studies').length > 0 && yearly_field_studies !== undefined){
    setTimeout(function(){
      Morris.Area(yearly_field_studies);
      $('#yearly_field_studies').find('i').remove();
    }, 3000);
  }
});