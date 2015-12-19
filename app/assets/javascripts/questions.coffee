$ ->
  $('.question').on 'click', 'a.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    $('div#edit-question-form-container').show()

  $('.answers').on 'click', 'a.edit-answer-link', (e) ->
    e.preventDefault()
    answer_id = $(this).data('answer-id')
    $(this).hide()
    $('form#edit_answer_' + answer_id).show()


  $('.question').on 'ajax:success', '.vote-plus, .vote-minus, .re-vote', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.question .votes-container').html(response._html)

  $('.answers').on 'ajax:success', '.vote-plus, .vote-minus, .re-vote', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer_' + response.voted_to_id + ' .votes-container').html(response._html)

  PrivatePub.subscribe '/questions', (data, channel) ->
    $('.questions-container').append(data['question'])

  questionId = $('.answers').data('question-id')

  PrivatePub.subscribe "/questions/" + questionId + "/answers", (data, channel) ->
    a = $.parseJSON(data.post)
    if a.type == 'new_comment'
      if a.commentable_type == 'Question'
        $('.question .comments-list').append(a._html)
      if a.commentable_type == 'Answer'
        $('#answer_' + a.commentable_id + ' .comments-list').append(a._html)

    if a.type == 'new_answer'
      $('div.answers div.answers-list').append(a._html)
