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

  var bloodhound = {};
  bloodhound.genus = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/genus.json" });
  bloodhound.familia = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/familia.json" });
  bloodhound.ordo = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/ordo.json" });
  bloodhound.subclassis = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/subclassis.json" });
  bloodhound.classis = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/classis.json" });
  bloodhound.subphylum = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/subphylum.json" });
  bloodhound.phylum = new Bloodhound({ datumTokenizer: Bloodhound.tokenizers.whitespace, queryTokenizer: Bloodhound.tokenizers.whitespace,
    prefetch: "/systematics/phylum.json" });


  var $systematicsTypeahead = $('.systematics.typeahead');

  $systematicsTypeahead.typeahead({ hint: true, highlight: true, minLength: 1 },
    systematicsTypeaheadSettings('genus'),
    systematicsTypeaheadSettings('familia'),
    systematicsTypeaheadSettings('ordo'),
    systematicsTypeaheadSettings('subclassis'),
    systematicsTypeaheadSettings('classis'),
    systematicsTypeaheadSettings('subphylum'),
    systematicsTypeaheadSettings('phylum')
  );

  function systematicsTypeaheadSettings(name) {
    return { name: name, source: bloodhound[name],
      templates: { header: '<h3 class="systematics-category">' + $systematicsTypeahead.data(name) + '</h3>' }
    }
  }
  var $systematicsTypeaheadMenu = $('.sidebar-search .tt-menu');
  $systematicsTypeaheadMenu.css('max-height', $(window).height() - $systematicsTypeahead.offset().top - 1);
  $systematicsTypeaheadMenu.css('width', $systematicsTypeahead.width());
});