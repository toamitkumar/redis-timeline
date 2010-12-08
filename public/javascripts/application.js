$(document).ready(function() {
   $("#post_button") .click(function() {
     $.ajax({
       url: $("#post_form").attr("action"),
       data: $("#post_form").serializeArray(),
       success: function(data) {$("div#feeds").prepend(data);},
       error: function() {alert("Something went wrong");},
       type: "post"
     });
   });
   
   $("a.message_delete").live('click', function(e){
     e.preventDefault(); 
     $that = $(this);
     $.ajax({
       url: $that.attr("href"),
       data: {_method: "delete"},
       success: function() {$that.closest("div.row").remove();},
       error: function() {alert("Something went wrong");},
       type: "post"
     });
   });
   
   $("#older_posts").live('click', function(e) {
     e.preventDefault(); 
     $that = $(this);
     $.ajax({
       url: $that.attr("href"),
       success: function(data) {$("div#feeds").append(data);},
       error: function() {alert("Something went wrong");}
     });
   });
});