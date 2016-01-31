function match_invite_id(ele) {
  return $(ele).parent().attr('data-match-invite-id');
}

$('#MatchInvites .js-cancel-invite').click(function() {
  $.post('',
  {
    _method: 'put',
    match_invite_id: match_invite_id(this),
    accept: false
  },
  function(){
  });
});

$('#MatchInvites .js-accept-invite').click(function() {
  $.post('',
  {
    _method: 'put',
    match_invite_id: match_invite_id(this),
    accept: true
  },
  function(){
  });
});