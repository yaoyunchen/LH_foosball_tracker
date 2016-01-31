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