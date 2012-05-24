HydraHead = {validation: true, combinedEdit: true, autoSave: true};

// Load appropriate Hydra-Head functions when document is ready
$(document).ready(function() {
  HydraHead.init();
});

// Define Hydra-Head methods for HydraHead object
(function($) {

  /*************************
   * PUBLIC METHODS        *
   *************************/

  HydraHead.init = function() {
    if(this.combinedEdit){
      this.add_asset_links();
    }
    if(this.autoSave){
      this.auto_save();
    }
    this.enable_form_save();
    this.add_keywords();
  }

  // Take Javascript-enabled users to the combined view by
  // adding a parameter to necessary URLs.
  HydraHead.add_asset_links = function() {
    $('.create_asset, .edit-browse .edit, .document .document_title a').each(function() {
      var url = $(this).attr('href');
      // Check to see if there are already URL encoded params before adding our new param
      $(this).attr('href', url + ((url).indexOf('?') != -1 ? "&combined=true" : "?combined=true"));
    });
  };

  // Enable Ajax save functionality on edit pages
  HydraHead.enable_form_save = function() {
    HydraHead.target = null;
    var all_forms = $('.document_edit form.step');

    $('.document_edit input[type="submit"], .all-steps-actions button').not('.delete-button').click(function() {
      HydraHead.target = $(this);
      all_forms.first().submit();
      return false;
    });

    all_forms.submit(function(e) {
      // Only submit the forms if they pass validation
      // and validation is enabled.
      if(!HydraHead.validation || formValidation()){
        formPreSave();
        all_forms.each(function(index) {
          $(this).ajaxSubmit();
        });
        formPostSave();
      }

      // Don't continue to submit or we'll loop infinitely
      return false;
    });

  };

  HydraHead.add_keywords = function() {
    $('.fedora-text-field-add a').click(function() {
      var keyword_count = $(this).parent().siblings('.fedora-text-field').length;
      $(this).parent().before( '<p class="fedora-text-field">' +
      '<input type="hidden" value="subject" name="field_selectors[descMetadata][subject_topic][]" class="fieldselector">' +
      '<input type="hidden" value="topic" name="field_selectors[descMetadata][subject_topic][]" class="fieldselector">' +
      '<input type="text" value="" name="asset[descMetadata][subject_topic][' + keyword_count + ']" data-datastream-name="descMetadata" id="subject_topic_' + keyword_count + '" class="editable-edit edit"></p>');
      return false;
    });
  }

  // When an input changes (using blur for IE consistency),
  // submit the containing form.
  HydraHead.auto_save = function() {
    $('.document_edit input.edit, .document_edit textarea, .document_edit select').blur(function() {
      $(this).closest('form').ajaxSubmit();
    });
  };


  /*************************
   * PRIVATE METHODS       *
   *************************/

  // Display a saving notice and spinner that takes up the whole screen.
  formPreSave = function() {
    var opts = {
      lines: 12, // The number of lines to draw
      length: 14, // The length of each line
      width: 4, // The line thickness
      radius: 12, // The radius of the inner circle
      color: '#000', // #rbg or #rrggbb
      speed: 0.5, // Rounds per second
      trail: 50, // Afterglow percentage
      shadow: false // Whether to render a shadow
    };

    $('#document').prepend('<div id="saving-notice"><h1>Saving...</h1></div>');
    var target = document.getElementById('saving-notice');
    var spinner = new Spinner(opts).spin(target);
  };

  // Redirect to the appropriate page after the user saves
  formPostSave = function() {

    // Wait for all saving calls to finish
    $("#document").ajaxStop(function(){
      var redirect_url = window.location.pathname + "?saved=true";

      //add additional parameters based on input and submission
      redirect_url = addRedirectParams(redirect_url);

      window.location = redirect_url;
    });

  };

  addRedirectParams = function(redirect_url) {

    // Add parameter if we're adding files
    if($('#number_of_files option:selected').length) {
      redirect_url += "&number_of_files=" + $('#number_of_files option:selected').val();
    }

    // Add parameters based on submission button, e.g.
    // adding an author, individual permission, or finishing
    // and switching to browse view.
    switch(HydraHead.target.attr("name")) {
      case "add_another_author":
        redirect_url += "&add_contributor=true";
        break;
      case "add_permission":
        redirect_url += "&add_permission=true&wf_step=permissions";
        break;
      case "all_save_finish":
        redirect_url = redirect_url.replace("/edit","");
        redirect_url += "&viewing_context=browse";
        break;
    }

    return redirect_url;
  };

  // Ensure all fields with an attribute of "required" have some value
  formValidation = function() {
    // Input is innocent until proven guilty
    var valid = true;

    // Remove any existing notices
    $('#invalid_notice').remove();
    $('input[required]').removeClass("invalid-input");
    $('.invalid-input-notice').remove();

    // Check each input's value, switching the flag and appending a
    // notice if blank.
    $('input[required]').each(function(index) {
      if(!$(this).val()) {
        valid = false;
        $(this).addClass("invalid-input").after('<span class="invalid-input-notice">This field is required.</span>');
      }
    });

    // Add a top-level message if there are any invalid fields, and scroll there
    if(!valid) {
      printValidationError();
    }

    return valid;
  };

  // Print notice at top of page of invalid input
  printValidationError = function() {
    $('#document h1').after('<div id="invalid_notice" class="error ui-state-error">Some required fields are incomplete.</div>');
    var new_position = $('#invalid_notice').offset();
    window.scrollTo(new_position.left, new_position.top - 40);
  };

})(jQuery);