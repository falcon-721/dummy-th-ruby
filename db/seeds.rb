# Create admin user
admin = User.create!(name: 'admin', email: 'admin@demo.th', password: 'qwerty')

# Create users
users = FactoryGirl.create_list(:user, 4, :faker) + [admin]

# Create questions
questions = users.map { |u| FactoryGirl.create_list(:question, rand(2) + 1, :faker, votes_num: rand(5), user: u) }.flatten

# Create answers
answers = questions.each_with_object({}) do |q, obj|
  obj[q.id] = Array.new(rand(5) + 1).map { FactoryGirl.create(:answer, votes_num: rand(5), user: users.sample, question: q) }
end

# Set best answers
answers[questions.first.id].sample.make_best
answers[questions.last.id].sample.make_best

# Create question comments
questions.sample(3).each { |q| FactoryGirl.create_list(:comment, rand(2), commentable: q) }

# Create answers comments
answers.values.flatten.sample(10).each { |a| FactoryGirl.create_list(:comment, rand(2), commentable: a) }
