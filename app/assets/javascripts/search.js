$(document).on('ready page:load', function () {

  $(document).on('focusin', '.sidebar-search', function (e) {
//    if ($(this).data('species-search-active') == false) {
//      window.location.href = $(this).data('species-search-path')
//    }
  });

  $(document).on('click', '#search-domain-select a', function (e) {
    var $searchDomainSelect = $("#search-domain-select");
    var $form = $(this).closest('form');
    $form.find("#search_domain").val($(this).data('search-domain'));
    $searchDomainSelect.find('button i').attr('class', $(this).data('icon'));
    $searchDomainSelect.find('li').toggleClass('active');
    $form.find('input.systematics').attr('placeholder', $(this).data('placeholder'))
  });

//  var genus = new Bloodhound({
//    datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
//    queryTokenizer: Bloodhound.tokenizers.whitespace,
//    prefetch: "/systematics/genus.json"
//  });
//  genus.initialize();
//
//  var familia = new Bloodhound({
//    datumTokenizer: Bloodhound.tokenizers.obj.whitespace,
//    queryTokenizer: Bloodhound.tokenizers.whitespace,
//    prefetch: "/systematics/familia.json"
//  });
//  familia.initialize();
//
//  $('.systematics.typeahead').typeahead(null,
//    {
//      name: 'genus',
//      source: genus,
//      templates: {
//        header: '<h3 class="league-name">NBA Teams</h3>'
//      }
//    },
//    {
//      name: 'familia',
//      source: familia,
//      templates: {
//        header: '<h3 class="league-name">NHL Teams</h3>'
//      }
//    });

});