$(document).ready(function(){$(".panel-content").hide(),$(".panel-content-active").show(),$(".side-nav li a").click(function(){$(".side-nav li a").each(function(){$(this).hasClass("side-nav-active")&&$(this).removeClass("side-nav-active")}),$(this).addClass("side-nav-active"),$(".panel-content-active").hide(),$(".panel-content-active").removeClass("panel-content-active");var a=$(this).attr("href");$(a).addClass("panel-content-active"),$(a).show();var e=$(this).text();$(".panel-header").html(e)}),$("#upload-avatar-input").on("change",function(a){var e=a.target.files,t=e[0],n=new FileReader;n.onload=function(a){var e=new Image;console.log(a),e.src=a.target.result,$("#avatar-container img").attr("src",e.src)},n.readAsDataURL(t),console.log(e)})});