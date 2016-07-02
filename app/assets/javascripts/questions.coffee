$ ->
  questionForm = $("#question_form")
  addQuestionBtn = $("#add_question_btn")
  questionsList = $(".questions-list")

  addQuestionBtn.on 'click', (e) ->
    e.preventDefault()
    questionForm.show()
    questionForm.find(".cancel-btn").one 'click', ->
      questionForm.hide()
    false

  questionForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    window.location.href = "/questions/#{data.question.id}"

  questionForm.on 'ajax:error', App.utils.ajaxErrorHandler

  PrivatePub.subscribe "/questions", (data, channel) ->
    questionsList.empty() unless questionsList.find('.collection-item').length
    questionsList.append App.utils.render('question', data.question)
