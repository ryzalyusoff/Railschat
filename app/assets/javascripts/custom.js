$(document).ready(function(){

  /*
    Prevent form submitting on Enter
    (to prevent conflict like google map js api etc.)
  */
  $("form").on("keypress", function (e) {
    if (e.keyCode == 13) {
        return false;
    }
  });

  // Datepicker
  $(".datepicker").datepicker({
      dateFormat: "dd-mm-yy",
      /*minDate: 0*/
  });

  // Wysiwyg editor
  /*
  $('.summernote').summernote({
    height: 100,
    toolbar: [
      // [groupName, [list of button]]
      ['style', ['bold', 'italic', 'underline', 'clear']],
      ['font', ['strikethrough']],
      ['para', ['ul', 'ol']],
      ['insert', ['link']]
    ]
  });
  */

  // Bootstrap Tooltip
  $('[data-toggle="tooltip"]').tooltip();

  /* ==============================2. LOGIN & SIGN-UP ============================== */

  $.fn.serializeObject = function() {
    var values = {}
    $("form input, form select, form textarea").each( function(){
      values[this.name] = $(this).val();
    });

    return values;
  }

  function clear_errors() {
    $('#js-error-block ul').html('');
    $('.form-control').attr('style','1px solid #ccc;');
  }

  String.prototype.titleize = function() {
    return this.replace(/(?:^|\s)\S/g, function(a) { return a.toUpperCase(); });
  };

  $("form#ajax_signin").bind("ajax:success", function(e, response, status, xhr){
    if(response.success){
      window.location.reload();
    }else{
      $('#js-error-block-login').show();
    }
  });

  $( "#user_password, #user_email").focus(function() {
    if ($('#js-error-block-login').is(":visible") == true) {
      $('#js-error-block-login').fadeOut("slow");
    }
  });

  $("form#ajax_signup").submit(function(e){
    clear_errors();

     e.preventDefault();
     var user_info = $(this).serializeObject();
     $.ajax({
       type: "POST",
       url: $(this).attr("action"),
       data: user_info,
       success: function(json){
          location.href = "/";
       },
       error: function(xhr) {

          var errors = jQuery.parseJSON(xhr.responseText).errors;
          for (messages in errors) {
            error_messages =  messages.titleize() + ' ' + errors[messages];
            var field = "form#ajax_signup " + "#user_" + messages;
            var error_message = error_messages;

            $('#js-error-block-signup ul').append("<li>"+error_messages+"</li>");
            $(field).css('border', '1px solid #D9534F');
          }

          $('#js-error-block-signup').show();
       },
       dataType: "json"
     });
  });

  $("#signup-login-form__btn").click(function(){
    $('#loginModal').modal('hide');
    $('#signupModal').modal('show');
  });

  $("#login-signup-form__btn").click(function(){
    $('#signupModal').modal('hide');
    $('#loginModal').modal('show');
  });


});
