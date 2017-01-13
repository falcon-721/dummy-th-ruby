shared_examples "invalid params" do |message, model: nil, code: 403|
	context message do
		it "fails" do
			if model
				expect { subject }.not_to change(model, :count)
			end

			if code
				expect(subject).to have_http_status(code)
			end
		end
	end
end

shared_examples "unauthorized user request" do |message, **hargs|
	include_context "unauthorized user"
	include_examples "invalid params", message, hargs.merge(code: 401)
end
