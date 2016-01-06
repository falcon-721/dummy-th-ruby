$ ->
  $('.main').on 'ajax:success', '.vote-link', (e, data) ->
    cont = $(e.target).closest('.votes')
    return unless cont?
    cont.find('.votes-sum').text(data.total)
    cont.toggleClass('has-vote', data.is_voted)

  $('.main').on 'ajax:error', '.vote-link', App.utils.ajaxErrorHandler