/*
Copyright © 2012 The Pennsylvania State University

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


// short hand for $(document).ready();
$(function() {

  
  // bootstrap alerts are closed this function
  $('.alert .close').live('click',function(){
    $(this).parent().hide();
  });

 /*
   * adds additional metadata elements
   */
  $('.adder').live('click',function(event){
    //this.id = additional_N_submit
    //id for element to clone = additional_N_clone
    //id for element to append to = additional_N_elements
    //var cloneId = this.id.replace("submit", "clone");
    //var newId = this.id.replace("submit", "elements");

    event.preventDefault();
    var cloneId = this.id.replace("submit", "clone");
    var newId = this.id.replace("submit", "elements");
    var cloneElem = $('#'+cloneId).clone();
    // change the add button to a remove button
    var plusbttn = cloneElem.find('#'+this.id);
    //plusbttn.attr("value","-");
    plusbttn.html('-<span class="accessible-hidden">remove this '+ this.name.replace("_", " ") +'</span>');
    plusbttn.on('click',removeField);

    // remove the help tag on subsequent added fields
    cloneElem.find('.formHelp').remove();
    cloneElem.find('i').remove();
    cloneElem.find('.modal-div').remove();

    //clear out the value for the element being appended
    //so the new element has a blank value
    cloneElem.find('input[type=text]').attr("value", "");
    cloneElem.find('input[type=text]').attr("required", false);


    $('#'+newId).append(cloneElem);
    cloneElem.find('input[type=text]').focus();
    return false;
  });

  $('.remover').click(removeField);

  function removeField () {
    // get parent and remove it
    $(this).parent().remove();
    return false;
  }



 });