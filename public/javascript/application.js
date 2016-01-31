$(document).ready(function() {
$('#header-toggle').click(function() {
  $(this).toggleClass('is-active');
  $('#header-menu').toggleClass('is-active');
});
const max_singles_selection = 1;
const max_doubles_selection = 3;

function allow_player_selection(match_category, player_count) {
  if (match_category == "singles" && player_count < max_singles_selection) {
    return true;
  } else if (match_category == "doubles" && player_count < max_doubles_selection) {
    return true;
  } else {
    return false;
  }
}

function available_user_number() {
  return $('#SelectedPlayers input[value=""]').first().attr('name');
}

function max_selection_reached(match_category, player_count) {
  if (match_category == "singles" && player_count == max_singles_selection) {
    return true;
  } else if (match_category == "doubles" && player_count == max_doubles_selection) {
    return true;
  } else {
    return false;
  }
}

function remove_player_selection(select_button) {
  var player_copy = $(select_button).parents('li');
  var user_id = player_copy.attr('data-player-id');
  var teammate_id = $('#SelectedPlayers input[name="teammate"]').first().attr('value');

  if (user_id == teammate_id) $('#SelectedPlayers').removeClass('has-teammate');

  // Will clear the teammate input value if the player being removed
  //   is the person who was set as the teammate.
  $('#SelectedPlayers').find('input[value="' + user_id + '"]').attr('value', '');

  var selected_player = $('.js-player-selection-list li[data-player-id="' + user_id + '"]');
  selected_player.toggleClass('is-selected');

  player_copy.remove();
}

function allow_match_request() {
  $('#SelectedPlayers form .button').removeClass('is-disabled');
}

function disable_match_creation() {
  $('#SelectedPlayers form .button').addClass('is-disabled');
}

function allow_further_selections() {
  $('.js-select-player[data-action="select"]').removeClass('is-disabled');
}

function disable_further_selections() {
  $('.js-select-player[data-action="select"]').addClass('is-disabled'); 
}

function teammate_exists() {
  res = $('#SelectedPlayers input[name="teammate"]').first().attr('value');
  return res.length;
}

function teammate_option_visibility(user_id, show) {
  option = $('#SelectedPlayers li[data-player-id="' + user_id + '"] .js-set-teammate').first()
  if (show) {
    option.removeClass('is-hidden'); 
  } else {
    option.addClass('is-hidden'); 
  }
}

function move_teammate_to_top(user_id) {
  var teammate = $('#SelectedPlayers li[data-player-id="' + user_id + '"]');
  teammate.detach().prependTo('.js-selected-players');
}

function teammate(user_id) {
  if (teammate_exists()) {
    var current_teammate_id = $('#SelectedPlayers input[name="teammate"]').first().attr('value');
    teammate_option_visibility(current_teammate_id, true);
  } 

  $('#SelectedPlayers input[name="teammate"]').first().attr('value', user_id);
  $('#SelectedPlayers').addClass('has-teammate');
  teammate_option_visibility(user_id, false);
  move_teammate_to_top(user_id);
}

function set_up_team(selected_player) {
  if (teammate_exists()) {
    teammate_option_visibility(selected_player, true);
  } else {
    teammate(selected_player);
  }
}

$('.js-select-player[data-action="select"]').click(function() {
  var match_category = $('.js-match-type.is-active').attr('data-type');
  var player_count = $('#SelectedPlayers .custom-media-profile').length;

  if (allow_player_selection(match_category, player_count)) {
    $('#SelectedPlayers').removeClass('is-hidden')
    var selected_player = $(this).parents('li');
    var user_id = $(selected_player).attr('data-player-id');
    var available_space = available_user_number();

    $('#SelectedPlayers').find('input[name="' + available_space + '"]').attr('value', user_id);

    // Duplicate player into selection area
    var player_copy = selected_player.clone().appendTo('#SelectedPlayers > .js-selected-players');
    player_copy.find('.js-select-player').attr('data-action', 'unselect');
    player_copy.find('.fa-plus').removeClass('fa-plus').addClass('fa-times');

    selected_player.toggleClass('is-selected');
  }

  player_count = $('#SelectedPlayers .custom-media-profile').length;

  if (match_category == 'doubles') set_up_team(user_id);

  if (max_selection_reached(match_category, player_count)) {
    disable_further_selections();
    allow_match_request();
  }

});


$('#SelectedPlayers').on('click', '.js-select-player[data-action="unselect"]', function() {
  remove_player_selection(this);
  disable_match_creation();
  allow_further_selections();

  var player_count = $('#SelectedPlayers .custom-media-profile').length; 
  if (player_count == 0) {
    $('#SelectedPlayers').addClass('is-hidden');
  }
  
});

$('#SelectedPlayers').on('click', '.js-set-teammate', function() {
  var player_copy = $(this).parents('li');
  var user_id = player_copy.attr('data-player-id');  
  teammate(user_id);
});
$('#MatchInvites .js-cancel-invite').click(function() {
  var match_id = $(this).parent().attr('data-match-id');

  $.post('',
  {
    _method: 'put',
    match_id: match_id,
    accept: false
  },
  function(){
  });
});

$('#MatchInvites .js-accept-invite').click(function() {
  var match_id = $(this).parent().attr('data-match-id');

  $.post('',
  {
    _method: 'put',
    match_id: match_id,
    accept: true
  },
  function(){
  });
});
});
