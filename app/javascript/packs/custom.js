import Rails from '@rails/ujs';

document.addEventListener("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip();
  $('[data-toggle="popover"]').popover();
  $('#mycarousel').carousel();

  // Bounty board

  $('#bounty-board-deadline').on('blur', function(e) {
    if (new Date(this.value) < new Date()) {
      this.value = new Date().toISOString().slice(0,10);
    }
  });

  $('.textarea-autoresize').on('input', function() {
    $(this).css({
      'height': 'auto',
      'overflow-y': 'hidden',
    }).height(this.scrollHeight - 
      (parseInt($(this).css('paddingTop')) + 
      parseInt($(this).css('paddingBottom'))));
  });

  $('[data-target="#post_price"').on('click', function() {
    $('#post_price').focus();
  });

  function removeRole() {
    let addRoleBtn = $('#addRole').detach();
    $(this).closest('.role-container').remove();
    $('.role-container').last().find('.role-btns').append(addRoleBtn);
    disableRemoveIfNecessary();
  }

  function disableRemoveIfNecessary() {
    if ($('.role-container').length <= 2) {
      $('.removeRole').attr('disabled', true).addClass('disabled');
    } else {
      $('.removeRole').attr('disabled', false).removeClass('disabled');
    }
  }

  $('#addRole').on('click', function() {
    $(this).data('role-count', $(this).data('role-count') + 1);
    let roleCount = $(this).data('role-count');
    $(this).detach();

    let newRole = $($(this).data('target'))
      .clone()
      .attr('id', `role-${$(this).data('role-count')}`)
      .removeClass('d-none');

    newRole.find('.role-name').attr('id', `name-${roleCount}`).attr('name', `roles[${roleCount}][name]`);
    newRole.find('.role-name-label').attr('for', `name-${roleCount}`);
    newRole.find('.role-category').attr('id', `category-${roleCount}`).attr('name', `roles[${roleCount}][category]`);
    newRole.find('.role-category-label').attr('for', `category-${roleCount}`);
    newRole.find('.role-description').attr('id', `description-${roleCount}`).attr('name', `roles[${roleCount}][description]`);
    newRole.find('.role-description-label').attr('for', `description-${roleCount}`);
    newRole.find('.removeRole').on('click', removeRole);

    $('.role-container').last().after(newRole);
    newRole.find('.role-btns').append($(this));
    disableRemoveIfNecessary();
  });

  disableRemoveIfNecessary();
  $('.removeRole').on('click', removeRole);
  //new post button at top
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
      .css('visibility', 'visible')
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
    $('input[type=radio].submit-form').on('click', function(e) {
      $(this).parent().siblings().removeClass('active');
      $(this).parent().addClass('active');
      if (Rails.fire($(this).closest('form')[0], 'submit')) {
        $(this).closest('form').submit()
      }
    });

    $('#sort-select').on('change', function(e) {
      if ($(this).val() == 'none') {
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

