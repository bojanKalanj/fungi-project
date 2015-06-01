var FungiorbisSearch = (function () {

  var $form;
  var $systematicsTypeahead;

  function init() {
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

    $form = $('#sidebar-search');
    $systematicsTypeahead = $form.find('#systematics-typeahead');
    var bloodhound = {};
    var typeaheadOptions = [

    ];

    $.each(['genus', 'familia', 'ordo', 'subclassis', 'classis', 'subphylum', 'phylum'],
      function (index, category) {
        systematicsBloodhound(category);
        typeaheadOptions.push(systematicsTypeaheadSettings(category))
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
        submit($(this).closest('form'));
      });

    bindSearchDomainSelect();

    resize($systematicsTypeahead);
    $form.find('.systematics.typeahead.tt-input').val('');
  }

  function submit() {
    if ($('#search_domain').val() == 'species') {
      $form.attr('action', $form.data('species-action'));
      if ($form.data('species-search-active') == false) {
        $form.submit();
      }
    }
  }

  function resize($systematicsTypeahead) {
    var $systematicsTypeaheadMenu = $('.tt-menu', '#systematics-input');
    $systematicsTypeaheadMenu.css('max-height', $(window).innerHeight() - $systematicsTypeahead.offset().top );
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