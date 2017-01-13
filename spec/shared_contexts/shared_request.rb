shared_context "request", type: :request do
  include_context "users"

  subject { request; response }
end
