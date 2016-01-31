const starting_user_num = 2;
const max_singles_selection = 1;
const max_doubles_selection = 3;

function allow_player_selection(match_type, player_count) {
  if (match_type == "singles" && player_count < max_singles_selection) {
    return true;
  } else if (match_type == "doubles" && player_count < max_doubles_selection) {
    return true;
  } else {
    return false;
  }
}

function available_user_number() {
  return $('#SelectedPlayers input[value=""]').first().attr('name');
}

function max_selection_reached(match_type, player_count) {
  if (match_type == "singles" && player_count == max_singles_selection) {
    return true;
  } else if (match_type == "doubles" && player_count == max_doubles_selection) {
    return true;
  } else {
    return false;
  }
}

function remove_player_selection(select_button) {
  var player_copy = $(select_button).parents('li');
  var user_id = player_copy.attr('data-player-id');

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

$('.js-select-player[data-action="select"]').click(function() {
  var match_type = $('.js-match-type.is-active').attr('data-type');
  var player_count = $('#SelectedPlayers .custom-media-profile').length;

  if (allow_player_selection(match_type, player_count)) {
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

  if (max_selection_reached(match_type, player_count)) {
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