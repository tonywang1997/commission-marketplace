import Rails from '@rails/ujs';

document.addEventListener("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  $('#mycarousel').carousel();
});

window.addEventListener("turbolinks:load", function() {
  let bootstrapSize = $('#sizer').find('div:visible').data('size');
  let sizeToCols = {
    'xs': 1,
    'sm': 2,
    'md': 3,
    'lg': 4,
    'xl': 4,
  }

  $(window).resize(function() {
    let newSize = $('#sizer').find('div:visible').data('size');
    if (bootstrapSize !== newSize) {
      // reorder images
      bootstrapSize = newSize;
      orderImages(sizeToCols[bootstrapSize]);
    }
  })

  function orderImages(numCols) {
    let col_heights = [];
    for (let i = 0; i < numCols; i++) {
      col_heights.push(0)
    }
    $('.img-wrapper.col-view:visible')
      .sort((a, b) => $(a).attr('data-order') - $(b).attr('data-order'))
      .each(function() {
        // append to shortest column
        let col_idx = col_heights.indexOf(Math.min(...col_heights));
        $('#col-' + col_idx).append($(this));
        col_heights[col_idx] += $(this)[0].offsetHeight + (parseInt(window.getComputedStyle($(this)[0]).marginTop) * 2);
    });
  }

  window.orderImages = function() {
    orderImages(sizeToCols[bootstrapSize]);
  }

  window.applySortButtonFuncs = function() {
    $('input[type=radio].submit-form').on('change', function(e) {
      $(this).parent().siblings().removeClass('active');
      $(this).parent().addClass('active');
      if (Rails.fire($(this).closest('form')[0], 'submit')) {
        $(this).closest('form').submit()
      }
    });

    $('#sort-select').on('change', function(e) {
      if ($(this).val() == '') {
        $('.m-sort-dir').attr('disabled', 'disabled');
      } else {
        $('.m-sort-dir').removeAttr('disabled');
      }
    });
  }

  window.orderImages();
  window.applySortButtonFuncs();

  // this fixes issue where pressing the 'back' button doesn't order images correctly
  window.addEventListener('load', function() {
    window.orderImages();
    window.applySortButtonFuncs();
  });
});

