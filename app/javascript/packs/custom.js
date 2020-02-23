document.addEventListener("turbolinks:load", function () {
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="popover"]').popover()
    $('.btn-group .btn.disabled').click(function(event) {
         return false;
    });
});

window.hideModal = function(modal) {
  $(modal).modal('hide').removeClass('show').css('display', 'none');
  $('body').removeClass('modal-open');
  $('.modal-backdrop').remove();
  return modal
}