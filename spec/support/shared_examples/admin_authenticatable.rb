RSpec.shared_examples "requires admin login" do
  it "redirects to the admin login page" do
    make_request
    expect(response).to redirect_to(new_admin_user_session_path)
  end
end
