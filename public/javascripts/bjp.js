jQuery().ready(function() {
 
  jQuery.validator.addMethod("phoneNumber", function (phone_number, element) {
    return this.optional(element) || phone_number.match(/^[0-9]{2}[\s-.]*[0-9]{2}[\s-.]*[0-9]{2}[\s-.]*[0-9]{2}[\s-.]*[0-9]{2}[\s-.]*$/);
  }, "Please specify a valid phone number");

  var v = jQuery("#basicform").validate({
      rules: {
        uuid: {
          required: true,
          minlength: 2,
          maxlength: 30
        },
        uname: {
          required: true,
          minlength: 2,
          maxlength: 30
        },
        umanager: {
          required: true,
          minlength: 2,
          maxlength: 30
        },
        cname: {
          required: true,
          minlength: 2,
          maxlength: 50,
        },
        ccontactname: {
          required: true,
          minlength: 2,
          maxlength: 100,
        },
        ccontacttel: {
          required: true,
          minlength: 10,
          maxlength: 14,
          phoneNumber: true
        },
        ccontactaddress: {
          required: true,
          minlength: 5,
          maxlength: 200,
        },
        missionname: {
          required: true,
          minlength: 2,
          maxlength: 100,
        },
        missioncode: {
          required: true,
          minlength: 2,
          maxlength: 100,
        },
        missionnature: {
          required: true,
          minlength: 2,
          maxlength: 100,
        },
 
      },
      errorElement: "span",
      errorClass: "help-inline-error",
      onkeyup: function(element) { $(element).valid(); },
      onfocusout: function(element) { $(element).valid(); },
    });
 
 
  // Binding next button on first step
  $(".open1").click(function() {
      if (v.form()) {
        $(".frm").hide("fast");
        $("#sf2").show("slow");
      }
   });
 
   // Binding next button on second step
   $(".open2").click(function() {
      if (v.form()) {
        $(".frm").hide("fast");
        $("#sf3").show("slow");
      }
    });

   // Binding next button on third step
   $(".open3").click(function() {
      if (v.form()) {
        $(".frm").hide("fast");
        $("#sf4").show("slow");
      }
    });
 
     // Binding back button on second step
    $(".back2").click(function() {
      $(".frm").hide("fast");
      $("#sf1").show("slow");
    });
 
     // Binding back button on third step
     $(".back3").click(function() {
      $(".frm").hide("fast");
      $("#sf2").show("slow");
    });

     // Binding back button on fourth step
     $(".back4").click(function() {
      $(".frm").hide("fast");
      $("#sf3").show("slow");
    });
 
    $(".open4").click(function() {
      if (v.form()) {
        // optional
        // used delay form submission for a seccond and show a loader image
        // setTimeout(function(){
        //   $("#basicform").html('<h2>Thanks for your time.</h2>');
        // }, 1000);
        //// Remove this if you are not using ajax method for submitting values
        //return false;
	$("#basicform").submit();
      }
    });
    
  // Calendar
  var el = document.getElementById('datepickr-half');
  var output = document.getElementById('output-half');

  new Datepickr(el, function(res) {
    output.value = JSON.stringify(res);
  }, {
    halfDay: true,
    greyWeekends: true,
    weekdays: ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'],
    months: ['Janvier', 'Fevrier', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Decembre'],
  });


  var xmlhttp;
  if  (window.ActiveXObject){//if the window is InternetExplorer
    xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }else if(window.XMLHttpRequest){// if Window is Firefox etc..
    xmlhttp= new XMLHttpRequest();
  }else{
    alert ("Get a New Browser")
  }


  $( "#uname" ).keyup(function(myevent) {
    var uid = $('#uuid').val();
    var uname = $('#uname').val();
    xmlhttp.onreadystatechange=function()
    {
      if (xmlhttp.readyState==4 && xmlhttp.status==200)
      {
        //alert( xmlhttp.responseText );
      }
    }
    xmlhttp.open("GET","autocomplete/?uid="+uid+"&uname="+uname,true);
    xmlhttp.send();
  });


});
