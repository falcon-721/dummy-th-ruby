$ ->
  questionForm = $("#question_form")
  addQuestionBtn = $("#add_question_btn")

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