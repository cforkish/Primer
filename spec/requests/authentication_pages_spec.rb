require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
        it { should_not have_link('Sign out') }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              sign_in user
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "submitting to the update action" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "visiting the signup page" do
          before { visit signup_path }
          it { should have_title('Sign up') }
        end

        describe "submitting to the create action" do
          before { post users_path, {user: {name: "user"} } }
          specify { expect(response).to be_success }
        end

        describe "after signing in" do
          let(:user) { FactoryGirl.create(:user) }

          describe "visiting the user index" do
            before do
              sign_in user
              visit users_path
            end

            it { should have_title('All users') }
          end

          describe "visiting the signup page" do
            before do
              sign_in user
              visit signup_path
            end

            it { should_not have_title('Sign up') }
          end

          describe "submitting to the create action" do
            before do
              sign_in user, no_capybara: true
              post users_path, {user: {name: "user"} }
            end

            specify { expect(response).to redirect_to(root_path) }
          end
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com", username: "wrong") }

      describe "visiting Users#edit page" do
        before do
          sign_in user
          visit edit_user_path(wrong_user)
        end

        it { should_not have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before do
          sign_in user, no_capybara: true
          patch user_path(wrong_user)
        end

        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as correct user" do
      let(:user) { FactoryGirl.create(:user) }

      describe "visiting Users#edit page" do
        before do
          sign_in user
          visit edit_user_path(user)
        end

        it { should have_title(full_title('Edit user')) }
      end

      describe "submitting a PATCH request to the Users#update action" do
        before do
          sign_in user, no_capybara: true
          patch user_path(user), {user: {name: "user"} }
        end

        specify { expect(response).to be_success }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end

    describe "as admin user" do
      let(:admin) { FactoryGirl.create(:admin) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(non_admin) }
        specify { expect(response).to redirect_to(users_path) }
      end

      describe "submitting a DELETE request to the Users#destroy action for oneself" do
        describe "should redirect" do
          before { delete user_path(admin) }
          specify { expect(response).to redirect_to(root_path) }
        end

        specify do
          expect do
            delete user_path(admin)
          end.to change(User, :count).by(0)
        end
      end
    end
  end
end
