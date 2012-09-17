// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
jQuery.ajaxSetup({beforeSend:function(e){e.setRequestHeader("Accept","text/javascript")}}),$(document).ready(function(){jQuery(".best_in_place").best_in_place()}),$(document).ready(function(){$("#sub_time_start").datetimepicker({timeFormat:"h:m",ampm:!0})});