$(document).ready(function() {
   $("#post_button") .click(function() {
     $.ajax({
       url: $("#post_form").attr("action"),
       data: $("#post_form").serializeArray(),
       success: function(data) {$("div#feeds").prepend(data);},
       error: function() {alert("Something went wrong");},
       type: "post"
     })
   });
});