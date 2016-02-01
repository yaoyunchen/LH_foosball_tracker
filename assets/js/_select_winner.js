$('.js-select-winner').click(function() {
  var selected_team = $(this).attr('data-team');
  $('#ChooseWinner').find('input[name="team"]').attr('value', selected_team);

  $('#ChooseWinner').find('.button').removeClass('is-disabled');
});