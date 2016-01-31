$('.js-select-player[data-action="select"]').click(function() {
    var match_type = $('.js-match-type.is-active').attr('data-type');
    var player_count = $('#SelectedPlayers .custom-media-profile').length;
  
    if (match_type == "singles" && player_count == 0) {
      
      var selected_player = $(this).parents('li');
      var user_id = $(selected_player).attr('data-player-id');
      $('#SelectedPlayers').removeClass('is-hidden')
      $('#SelectedPlayers').find('input[name="user2[:id]"]').attr('value', user_id);

      // Duplicate player into selection area
      var player_copy = selected_player.clone().appendTo('#SelectedPlayers > .js-selected-players');
      player_copy.find('.js-select-player').attr('data-action', 'unselect');
      player_copy.find('.fa-plus').removeClass('fa-plus').addClass('fa-times');

      selected_player.toggleClass('is-selected');
      $('.js-select-player[data-action="select"]').addClass('is-disabled');

    }

});


$('#SelectedPlayers').on('click', '.js-select-player[data-action="unselect"]', function() {
  var player_copy = $(this).parents('li');
  var user_id = player_copy.attr('data-player-id');

  $('#SelectedPlayers').find('input[name="user2[:id]"]').attr('value', '');
  $('#SelectedPlayers').addClass('is-hidden')

  var selected_player = $('.js-player-selection-list li[data-player-id="' + user_id + '"]');
  selected_player.toggleClass('is-selected');

  $('.js-select-player[data-action="select"]').removeClass('is-disabled');

  player_copy.remove();
});