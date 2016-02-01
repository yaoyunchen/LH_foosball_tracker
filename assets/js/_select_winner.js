$('.js-select-winner').click(function() {
  var selected_team = $(this).attr('data-team')
  $(this).addClass('winner-is-selected');
  $(this).siblings('.js-select-winner').removeClass('winner-is-selected');
  $('#ChooseWinner').find('input[name="team"]').attr('value', selected_team);

  $('#ChooseWinner').find('.button').removeClass('is-disabled').addClass('is-success');
});