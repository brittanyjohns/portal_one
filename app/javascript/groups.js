$("#words a.add_fields")
  .data("association-insertion-position", "before")
  .data("association-insertion-node", "this");

$("#words").on("cocoon:after-insert", function () {
  $(".word-group-fields a.add_fields")
    .data("association-insertion-position", "before")
    .data("association-insertion-node", "this");
  $(".word-group-fields").on("cocoon:after-insert", function () {
    $(this).children(".tag_from_list").remove();
    $(this).children("a.add_fields").hide();
  });
});
