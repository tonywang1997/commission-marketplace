var tags =  
["half-body", "full-body", "icon", "headshot", 
 "bust", "portrait", "chibi", "realistic", "painterly", 
 "cel", "anime", "manga", "shade", "sketch", "line", 
 "base-color", "bright", "dark", "background", 
 "landscape", "fanart", "oc", "character", "boy", "girl",
 "animation", "drawings", "paintings"];

$(document).on("change", "#img-input", function(event) {
    // clear previous uploaded images
    var previews = document.getElementsByClassName("preview-field");
    var portfolio_div = document.getElementById("portfolio_div");
    // previews is a live list
    while(previews[0]) {
      previews[0].parentNode.removeChild(previews[0]);
    }

    // image file input
    var img_input = document.getElementById("image-upload");
    
    // images uploaded
    var img_files = event.target.files
    for (var i = 0; i < img_files.length; i++) {
      // image preview div
      var img_div = document.createElement('div'); 
      img_div.setAttribute("class", "preview-field");

      // preview img
      var preview = document.createElement('img'); 
      preview.src = URL.createObjectURL(img_files[i]);
      preview.setAttribute("style", 
        "margin-bottom: 10px; \
         max-width: 100%; \
         display: block; \
         object-fit: contain;")

      // price range label
      var label = document.createElement('label');
      label.innerHTML = "Price"

      // price div
      var price_div = document.createElement('div')
      price_div.setAttribute("class", "price_low")
      var price_input = document.createElement('input');
      price_input.setAttribute("name", "img-"+i+"-price");
      price_input.setAttribute("placeholder", "100.00");
      price_div.appendChild(price_input);


      img_div.appendChild(preview);
      img_div.appendChild(label);
      img_div.appendChild(price_div);

      img_input.after(img_div);
    }
});

$(document).on('click', '.remove_tag', function(event) {
  event.preventDefault();
  $(this).closest('fieldset').remove(); 
});

$(document).on('click', '.add_tag', function(event) {
  event.preventDefault();
  time = new Date().getTime()
  id = time.toString()
  tag_input = 
  `<fieldset class="tag">\
       <input type="text" \
       class="tag-input" \
       name="portfolio[tags_attributes][${id}][tag_name]" \
       id="portfolio_tags_attributes_${id}_tag_name"
       required="required"> \
       <a class="remove_tag" href="#"><i class="fa fa-minus-square fa-lg"></i></a>\
    </fieldset>`
  $(this).before(tag_input);

  var tag_input = document.getElementById(`portfolio_tags_attributes_${id}_tag_name`);
  autocomplete(tag_input, tags);
});


function autocomplete(inp, arr) {
  /*the autocomplete function takes two arguments,
  the text field element and an array of possible autocompleted values:*/
  var currentFocus;
  /*execute a function when someone writes in the text field:*/
  inp.addEventListener("input", function(e) {
      var a, b, i, val = this.value;
      /*close any already open lists of autocompleted values*/
      closeAllLists();
      if (!val) { return false;}
      currentFocus = -1;
      /*create a DIV element that will contain the items (values):*/
      a = document.createElement("DIV");
      a.setAttribute("id", this.id + "autocomplete-list");
      a.setAttribute("class", "autocomplete-items");
      /*append the DIV element as a child of the autocomplete container:*/
      this.parentNode.appendChild(a);
      /*for each item in the array...*/
      for (i = 0; i < arr.length; i++) {
        /*check if the item starts with the same letters as the text field value:*/
        if (arr[i].substr(0, val.length).toUpperCase() == val.toUpperCase()) {
          /*create a DIV element for each matching element:*/
          b = document.createElement("DIV");
          /*make the matching letters bold:*/
          b.innerHTML = "<strong>" + arr[i].substr(0, val.length) + "</strong>";
          b.innerHTML += arr[i].substr(val.length);
          /*insert a input field that will hold the current array item's value:*/
          b.innerHTML += "<input type='hidden' value='" + arr[i] + "'>";
          /*execute a function when someone clicks on the item value (DIV element):*/
          b.addEventListener("click", function(e) {
              /*insert the value for the autocomplete text field:*/
              inp.value = this.getElementsByTagName("input")[0].value;
              /*close the list of autocompleted values,
              (or any other open lists of autocompleted values:*/
              closeAllLists();
          });
          a.appendChild(b);
        }
      }
  });
  /*execute a function presses a key on the keyboard:*/
  inp.addEventListener("keydown", function(e) {
      var x = document.getElementById(this.id + "autocomplete-list");
      if (x) x = x.getElementsByTagName("div");
      if (e.keyCode == 40) {
        /*If the arrow DOWN key is pressed,
        increase the currentFocus variable:*/
        currentFocus++;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 38) { //up
        /*If the arrow UP key is pressed,
        decrease the currentFocus variable:*/
        currentFocus--;
        /*and and make the current item more visible:*/
        addActive(x);
      } else if (e.keyCode == 13) {
        /*If the ENTER key is pressed, prevent the form from being submitted,*/
        e.preventDefault();
        if (currentFocus > -1) {
          /*and simulate a click on the "active" item:*/
          if (x) x[currentFocus].click();
        }
      }
  });
  function addActive(x) {
    /*a function to classify an item as "active":*/
    if (!x) return false;
    /*start by removing the "active" class on all items:*/
    removeActive(x);
    if (currentFocus >= x.length) currentFocus = 0;
    if (currentFocus < 0) currentFocus = (x.length - 1);
    /*add class "autocomplete-active":*/
    x[currentFocus].classList.add("autocomplete-active");
  }
  function removeActive(x) {
    /*a function to remove the "active" class from all autocomplete items:*/
    for (var i = 0; i < x.length; i++) {
      x[i].classList.remove("autocomplete-active");
    }
  }
  function closeAllLists(elmnt) {
    /*close all autocomplete lists in the document,
    except the one passed as an argument:*/
    var x = document.getElementsByClassName("autocomplete-items");
    for (var i = 0; i < x.length; i++) {
      if (elmnt != x[i] && elmnt != inp) {
        x[i].parentNode.removeChild(x[i]);
      }
    }
  }
  /*execute a function when someone clicks in the document:*/
  document.addEventListener("click", function (e) {
      closeAllLists(e.target);
  });
}

$(document).ready(function(){
  var tag_inputs = document.getElementsByClassName("tag-input");

  for (i = 0; i < tag_inputs.length; i++) {
    autocomplete(tag_inputs[i], tags);
  }
  $('.carousel').carousel('pause');
});
