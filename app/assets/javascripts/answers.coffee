#= require ./shared/votes

$ ->
  questionForm = $("#question_form")
  addQuestionBtn = $("#add_question_btn")
  questionInfo = $("#question_info")

  addQuestionBtn.on 'click', (e) ->
    e.preventDefault()
    questionInfo.hide()
    questionForm.show()
    questionForm.find(".cancel-btn").one 'click', ->
      questionForm.hide()
      questionInfo.show()
    false

  questionForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    questionInfo.find('.question-title').text data.question.title
    questionInfo.find('.question-body').text data.question.body
    questionForm.hide()
    questionInfo.show()

  questionForm.on 'ajax:error', App.utils.ajaxErrorHandler

  answerForm = $("#new_answer_form")
  addAnswerBtn = $("#add_answer_btn")
  answersList = $("#answers_list")

  addAnswerBtn.on 'click', (e) ->
    e.preventDefault()
    answerForm.show()
    answerForm.find(".cancel-btn").one 'click', ->
      answerForm.hide()
    false

  answerForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    answersList.append App.utils.render('answer', data.answer)
    answerForm.hide()

  answerForm.on 'ajax:error', App.utils.ajaxErrorHandler

  answersList.on 'ajax:success', '.delete-answer-link', (e, data) ->
    App.utils.successMessage(data?.message)
    $(e.target).closest('.answer')?.remove()

  answersList.on 'ajax:error', '.delete-answer-link, .best-answer-link, .edit-answer-link', App.utils.ajaxErrorHandler

  answersList.on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    cont = $(e.target).closest('.answer')
    form = cont.find('.answer-edit-form')
    info = cont.find('.answer-info')

    info.hide()
    form.show()
    form.find('.cancel-btn').one 'click', ->
      form.hide()
      info.show()
      form.off('ajax:success ajax:error')

    form.one 'ajax:success', (e, data) ->
      App.utils.successMessage(data?.message)
      cont.replaceWith App.utils.render('answer', data.answer)

    form.on 'ajax:error', App.utils.ajaxErrorHandler

  answersList.on 'ajax:success', '.best-answer-link', (e, data) ->
    App.utils.successMessage(data?.message)
    answersList.find('.answer-best-badge').remove()
    $(e.target).closest('.answer')?.remove()
    answersList.prepend App.utils.render('answer', data.answer)
