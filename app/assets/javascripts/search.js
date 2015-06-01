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

  var bhGenus = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/genus.json"
  });


  var bhFamilia = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.whitespace,
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/familia.json"
  });

  $('.systematics.typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1
  }, {
    name: 'genus',
    source: bhGenus
//    ,
//    templates: {
//      header: '<h3 class="league-name">NBA Teams</h3>'
//    }
  }, {
    name: 'familia',
    source: bhFamilia
//      ,
//      templates: {
//        header: '<h3 class="league-name">NHL Teams</h3>'
//      }
  });

});