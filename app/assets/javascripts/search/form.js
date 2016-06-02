function FungiorbisSearchForm() {
  var searchForm = this;
  var $form;


  searchForm.initialize = function () {
    $form = $('#sidebar-search');
  };

  searchForm.submit = function () {
    var path = $form.attr('action') + '?' + $form.serialize().replace(/[^&]+=\.?(?:&|$)/g, '');

    if ($form.data('remote')) {
      var pageTitle = $('title').html();
      window.history.pushState(pageTitle, pageTitle, path);
      $('#content-column').html('<i class="fa fa-5x fa-spinner fa-pulse"></i>');
      $form.submit();

    }
    else{
      window.location = path;
    }
  };

  searchForm.formElement = function () {
    return $form;
  };
}