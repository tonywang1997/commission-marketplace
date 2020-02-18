$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})

$('.btn-group .btn.disabled').click(function(event) {
     return false;
});