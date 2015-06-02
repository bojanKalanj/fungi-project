var FungiorbisSearch = (function () {

  var $form;
  var $systematicsTypeahead;

  function init() {
    $form = $('#sidebar-search');
    $systematicsTypeahead = $form.find('#systematics-typeahead');

    initTypeahead();
    bindSearchDomainSelect();

    initHabitat();
  }

  function submit() {
    if ($('#search_domain').val() == 'species') {
      $form.attr('action', $form.data('species-action'));
      if ($form.data('remote')) {
        var path = location.protocol + '//' + location.host + location.pathname + '?' + $form.serialize();
        var pageTitle = $('title').html();
        window.history.pushState(pageTitle, pageTitle, path);
      }
      $('#content-column').html('<i class="fa fa-5x fa-spinner fa-pulse"></i>');
      $form.submit();
    }
  }

  function resize($systematicsTypeahead) {
    var $systematicsTypeaheadMenu = $('.tt-menu', '#systematics-input');
    $systematicsTypeaheadMenu.css('max-height', $(window).innerHeight() - $systematicsTypeahead.offset().top);
    $systematicsTypeaheadMenu.css('width', $systematicsTypeahead.width());
  }

  //private

  function bindSearchDomainSelect() {
    $(document).on('click', '#search-domain-select a', function (e) {
      var $searchDomainSelect = $form.find("#search-domain-select");
      $form.find("#search_domain").val($(this).data('search-domain'));
      $searchDomainSelect.find('button i').attr('class', $(this).data('icon'));
      $searchDomainSelect.find('li').toggleClass('active');
      $form.find('input.systematics').attr('placeholder', $(this).data('placeholder'))
    });
  }

  function bindAddHabitat() {
    $(document).on('click', '#habitat-input .add-habitat', function (e) {
      $(this).addClass('hidden');
      $('#habitat-select').removeClass('hidden');
    });
  }

  function bindClearHabitat() {
    $(document).on('click', '#habitat-input .clear-habitat', function (e) {
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
        submit();
      }
    });
  }

  function bindHabitatChange() {
    $(document).on('change', '#habitat-select select', function (e) {
      resetSubhabitat();
      if ($(this).val() == '') {
        $('.clear-habitat', '#habitat-input').click();
      }
      submit();
    });
  }

  function resetSubhabitat($subhabitatSelect) {
    if ($subhabitatSelect == undefined) {
      $subhabitatSelect = $('select', '#subhabitat-select');
    }
    $subhabitatSelect.val('');
    $('#subhabitat-select').addClass('hidden');
    $('#selected-habitat-species').html('');
  }

  function bindAddSubhabitat() {
    $(document).on('click', '#habitat-input .add-subhabitat', function (e) {
      $(this).addClass('hidden');
      $('#subhabitat-select').removeClass('hidden');
      $('#selected-habitat-species').html('');
    });
  }

  function bindClearSubhabitat() {
    $(document).on('click', '#habitat-input .clear-subhabitat', function (e) {
      $('#subhabitat-select').addClass('hidden');
      $('#habitat-species-select').addClass('hidden');
      $('.add-subhabitat', '#habitat-input').removeClass('hidden');
      var $select = $('select', '#subhabitat-select');
      if ($select.val().length > 0) {
        $select.val('');
        submit();
      }
    });
  }

  function bindSubhabitatChange() {
    $(document).on('change', '#subhabitat-select select', function (e) {
      if ($(this).val() == '') {
        $('.clear-subhabitat', '#habitat-input').click();
      }
      $('#selected-habitat-species').html('');
      submit();
    });
  }

  function bindAddHabitatSpecies() {
    $(document).on('click', '#habitat-input .add-habitat-species', function (e) {
      $(this).addClass('hidden');
      $('#habitat-species-select').removeClass('hidden');
    });
  }

  function bindHabitatSpeciesChange() {
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
        submit();
      }
    });
  }

  function bindClearHabitatSpecies() {
    $(document).on('click', '#habitat-input .clear-habitat-species', function (e) {
      var key = $(this).data('sp');
      $('option.' + key, '#habitat-species-select').removeClass('hidden');
      $(this).parent().remove();
      submit();
    });
  }


  function initTypeahead() {
    function systematicsTypeaheadSettings(name) {
      return { name: name, source: bloodhound[name],
        templates: { header: '<h3 class="systematics-category">' + $systematicsTypeahead.data(name) + '</h3>' }
      }
    }

    function systematicsBloodhound(name) {
      bloodhound[name] = new Bloodhound({
        datumTokenizer: Bloodhound.tokenizers.whitespace,
        queryTokenizer: Bloodhound.tokenizers.whitespace,
        prefetch: "/systematics/" + name + ".json"
      });
    }

    var bloodhound = {};

    $.each(['genus', 'familia', 'ordo', 'subclassis', 'classis', 'subphylum', 'phylum'],
      function (index, category) {
        systematicsBloodhound(category);
      });


    $systematicsTypeahead.typeahead(
      { hint: true, highlight: true, minLength: 1 },
      systematicsTypeaheadSettings('genus'),
      systematicsTypeaheadSettings('familia'),
      systematicsTypeaheadSettings('ordo'),
      systematicsTypeaheadSettings('subclassis'),
      systematicsTypeaheadSettings('classis'),
      systematicsTypeaheadSettings('subphylum'),
      systematicsTypeaheadSettings('phylum')).
      bind('typeahead:select', function (ev, suggestion) {
        $('#cancel-species').removeClass('hidden');
        submit($(this).closest('form'));
      });


    var $input = $form.find('.systematics.typeahead.tt-input');
    if ($input.val().length > 0) {
      $('#cancel-species').removeClass('hidden');
    }

    $(document).on('click', '#cancel-species', function (e) {
      $input.val('');
      $('#cancel-species').addClass('hidden');
      submit();
    });

    resize($systematicsTypeahead);
  }

  function initHabitat() {
    bindAddHabitat();
    bindClearHabitat();
    bindHabitatChange();

    bindAddSubhabitat();
    bindClearSubhabitat();
    bindSubhabitatChange();

    bindAddHabitatSpecies();
    bindHabitatSpeciesChange();
    bindClearHabitatSpecies();

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

      var selectedSpecies = $('input[name="sp"]')
    }
  }

  return {
    init: init,
    submit: submit,
    resize: resize
  }
}());

$(document).on('ready page:load', function () {

  FungiorbisSearch.init();


//  $(document).on('focusout', '#systematics-input', function (e) {
//    if ($('.sidebar-search').data('species-search-active') == true) {
//      window.location.href = $(this).data('species-search-path')
//    }
//  });
});

$(window).on('resize', function () {
  FungiorbisSearch.resize($('#systematics-typeahead'));
});