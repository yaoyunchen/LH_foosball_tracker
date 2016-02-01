function match_id(ele) {
  return $(ele).parent().attr('data-match-id');
}

$('.js-cancel-match').click(function() {
  $.post('',
  {
    _method: 'put',
    match_id: match_id(this),
    status: 'cancelled'
  },
  function(){
  });
});

$('.js-record-match').click(function() {
  $.post('',
  {
    _method: 'put',
    match_id: match_id(this),
    status: 'over'
  },
  function(){
  });
});