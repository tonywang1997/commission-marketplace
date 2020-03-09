import Rails from '@rails/ujs';

document.addEventListener("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
});

window.addEventListener("turbolinks:load", function() {
  let bootstrapSize = $('#sizer').find('div:visible').data('size');
  let sizeToCols = {
    'xs': 1,
    'sm': 2,
    'md': 4,
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
    $('.img-wrapper.col-view')
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
});


/* ROW VIEW - NOT USED
window.addEventListener("turbolinks:load", function() {
  $(window).resize(function() {
    clearTimeout(window.timeout);
    window.timeout = setTimeout(function() {
      $('.img-wrapper').each(function() {
        $(this).css('height', '150px');
        $(this).css('max-width', '320px');
        img = $(this).find('img');
        if (img.innerHeight() / img.innerWidth() >= 1.5) {
          img.removeClass('grid-img-wide');
          if (!img.hasClass('grid-img-tall')) {
            img.addClass('grid-img-tall');
          }
        } else {
          img.removeClass('grid-img-tall');
          if (!img.hasClass('grid-img-wide')) {
            img.addClass('grid-img-wide');
          }
        }
      })
      resize(5);
    }, 100)
  });

  function resize(n) {
    function resizeImages() { //todo here
      imagesPerRow = 0
      widthPerRow = 0
      currOffset = $('.img-wrapper').offset().top
      $('.img-wrapper').each(function(i) {
        if (currOffset == $(this).offset().top) {
          imagesPerRow++;
          widthPerRow += $(this).outerWidth(true);
        } else {
          factor = $('.img-grid').innerWidth() / widthPerRow;
          $('.img-wrapper').slice(i - imagesPerRow, i).each(function() {
            $(this).css('height', $(this).innerHeight() * factor + 'px');
            $(this).css('max-width', $(this).innerWidth() * factor + 'px');
            if ($(this).find('img').hasClass('grid-img-tall') && $(this).innerHeight() > $(this).find('img').innerHeight()) {
              $(this).find('img').removeClass('grid-img-tall');
              $(this).find('img').addClass('grid-img-wide');
            }
          })
          currOffset = $(this).offset().top;
          imagesPerRow = 1;
          widthPerRow = $(this).outerWidth(true);
        }
      });
    }
    for (let i = 0; i < n; i++) {
      resizeImages();
    }
  }

  resize(5);
}) */