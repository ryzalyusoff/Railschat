$(document).ready(function(){

  $(".panel-content").hide();
  $(".panel-content-active").show();

  $('.side-nav li a').click(function(){
    
    // Side Menu
    $('.side-nav li a').each(function() {
      if ( $(this).hasClass("side-nav-active") ) {
        $(this).removeClass("side-nav-active");
      }
    });
    $(this).addClass("side-nav-active");

    // Panel Body
    $('.panel-content-active').hide();
    $('.panel-content-active').removeClass('panel-content-active');

    var panel_body = $(this).attr('href');
    $(panel_body).addClass('panel-content-active');
    $(panel_body).show();

    // Panel Header
    var link_text = $(this).text(); 
    $('.panel-header').html(link_text);

  });

  // Avatar Preview
  $('#upload-avatar-input').on('change', function(event) {
    var files = event.target.files;
    var image = files[0]
    var reader = new FileReader();
    reader.onload = function(file) {
      var img = new Image();
      console.log(file);
      img.src = file.target.result;
      $('#avatar-container img').attr('src', img.src);
    }
    reader.readAsDataURL(image);
    console.log(files);
  });

});