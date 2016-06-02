var FungiorbisSearch = (function () {

  var $systematicsTypeahead;

  var form = new FungiorbisSearchForm();
  var habitat = new FungiorbisSearchHabitat();
  var substrate = new FungiorbisSearchSubstrate();
  var nutritiveGroup = new FungiorbisSearchNutritiveGroup();
  var growthType = new FungiorbisSearchGrowthType();
  var usability = new FungiorbisSearchUsability();

  function init() {
    form.initialize();
    $systematicsTypeahead = form.formElement().find('#systematics-typeahead');

    initTypeahead();

    habitat.initialize(form);
    substrate.initialize(form);
    nutritiveGroup.initialize(form);
    growthType.initialize(form);
    usability.initialize(form);
  }

  function resize($systematicsTypeahead) {
    var $systematicsTypeaheadMenu = $('.tt-menu', '#systematics-input');
    $systematicsTypeaheadMenu.css('max-height', $(window).innerHeight() - $systematicsTypeahead.offset().top);
    $systematicsTypeaheadMenu.css('width', $systematicsTypeahead.width());
  }

  //private

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
        form.submit($(this).closest('form'));
      });


    var $input = form.formElement().find('.systematics.typeahead.tt-input');

    if ($input.val().length > 0) {
      $('#cancel-species').removeClass('hidden');
    }

    $(document).on('click', '#cancel-species', function (e) {
      $input.val('');
      $('#cancel-species').addClass('hidden');
      form.submit();
    });

    resize($systematicsTypeahead);
  }



  return {
    init: init,
    resize: resize
  }
}());

$(document).on('ready page:load', function () {

  FungiorbisSearch.init();


//  $(document).on('focusout', '#systematics-input', function (e) {
//    if ($('.sidebar-search').data('species-search-active') == true) {
//      window.location.href = $(this).data('species-search-path')
//    }
//    console.log($(this))
//  });
});

$(window).on('resize', function () {
  FungiorbisSearch.resize($('#systematics-typeahead'));
});