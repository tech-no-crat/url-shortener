$(document).ready(function() {
  $("button#submit").click(function(e) {
    var link = $("#link").val();
    var id = $("#id").val();
    $.post('/', {link: link, id: id}, function(data) {
      if (data.substr(0, 2) === "OK") return submitSuccess(data.substr(4));
      else return submitError(data);
    } );
    return false;
  });
});

function submitSuccess(link) {
  $("#result").html($("label").html().slice(0, -1) + link);
  setResultsClass("success");
};

function submitError(error) {
  $("#result").html(error);
  setResultsClass("failure");
};

function setResultsClass(cl) {
  $("#result").removeClass("failure");
  $("#result").removeClass("success");
  $("#result").addClass(cl);
};
