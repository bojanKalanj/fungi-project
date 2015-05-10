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

  $(document).on('click', 'form[data-transliterate] .btn-primary', function (e) {
    var $form = $(this).closest('form');

    $form.find('[data-parent]').each(function( index ) {
      var $parentValue = $form.find('[data-locale='+ $(this).data('parent')+']').val();

      $(this).val(Fungiorbis.transliterate($parentValue));
    });
  });

  $(document).on('click', '[data-toggle]', function (e) {
    var targets = $(this).data('toggle').split(',');

    $.each(targets, function( index, targetSelector ) {
        $(targetSelector).toggleClass('hidden');
    });

    e.stopPropagation();
    return false;
  });

  $(document).on('click', '[data-toggle-class]', function (e) {
    var targets = $(this).data('toggle-class-target').split(',');
    var classes = $(this).data('toggle-class').split(',');

    $.each(targets, function( index1, targetSelector ) {
      $.each(classes, function( index2, klass ) {
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
});