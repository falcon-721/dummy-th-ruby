$ ->
  answerForm = $("#new_answer_form")
  addAnswerBtn = $("#add_answer_btn")

  addAnswerBtn.on 'click', (e) ->
    e.preventDefault()
    answerForm.show()
    answerForm.find(".cancel-btn").one 'click', ->
      answerForm.hide()
    false

  answerForm.on 'ajax:success', (e, data, status, xhr) ->
    App.utils.successMessage(data?.message)
    console.log(data)

  answerForm.on 'ajax:error', App.utils.ajaxErrorHandler