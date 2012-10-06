// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
//= require jquery
//= require jquery-ui
//= require jquery-ui-timepicker-addon
//= require best_in_place
//= require facebox

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function() {
  jQuery('.best_in_place').best_in_place();
});

$(document).ready(function() {
  $('#sub_time_start').datetimepicker({
    timeFormat: "h:m",
    ampm: true
  });
});

$(document).ready(function($) {
  $('a[rel*=facebox]').facebox({
    loadingImage: '/assets/loading.gif',
    closeImage  : '/assets/closelabel.png'
  });
});

$(document).ready(function($) {
  jQuery('.accordion .header').click(function($) {
    jQuery(this).next().toggle('slow');
    return false;
  }).next().hide();
});
