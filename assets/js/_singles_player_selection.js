$('#header-toggle').click(function() {
  $(this).toggleClass('is-active');
  $('#header-menu').toggleClass('is-active');
});

$('.js-select-player').click(function() {
  // Duplicate selection into selected list
  el = $(this).parents('li');
  $(el).clone().appendTo('#CreateInvites > .js-selected-players');

  user_id = $(el).attr('data-player-id');
  user_number = $('#CreateInvites .custom-media-profile').length;
  
  // team number is based on the game type
  teammate = false;
    
  // Add hidden input with userid values
  $("#CreateInvites .button").before('<input type="hidden" name="user' + user_number + '[:id]" value="' + user_id + '">');
  $("#CreateInvites .button").before('<input type="hidden" name="user' + user_number + '[:teammate]" value="' + teammate + '">');

  // hide selected
  $(el).toggleClass('is-selected');

  // limit the matchmaking options based on game type
    
});