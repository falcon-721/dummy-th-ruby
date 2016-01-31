shared_context "users", users: true do
  let(:user) { create(:user) }
  let(:john) { create(:user, name: "John") }
  let(:jack) { create(:user, name: "Jack") }
end
