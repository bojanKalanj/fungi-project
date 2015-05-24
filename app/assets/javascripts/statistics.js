$(document).on('ready page:load', function () {

  if ($('#monthly_specimens_count').length > 0){
    setTimeout(function(){
      $.get("/statistics/monthly_specimens_count", function (data) {
        Morris.Line(data);
        $('#monthly_specimens_count').find('i').remove();
      });
    }, 2000);
  }

  if ($('#yearly_field_studies').length > 0){
    setTimeout(function(){
      $.get("/statistics/yearly_field_studies", function (data) {
        Morris.Area(data);
        $('#yearly_field_studies').find('i').remove();
      });
    }, 5000);
  }

});