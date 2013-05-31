require 'spec_helper'

describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }

    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector('title', text: '| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:user2) { FactoryGirl.create(:user) }

      describe "with no microposts" do
        before do
          sign_in user
          visit root_path
        end

        it { should have_selector('aside span', text: "0 microposts") }
      end

      describe "with 1 micropost" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          sign_in user
          visit root_path
        end

        it { should have_selector('aside span', text: "1 micropost") }
        it { should_not have_selector('aside span', text: "1 microposts") }
      end

      describe "with 2 microposts" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          FactoryGirl.create(:micropost, user: user2, content: "No delete")
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          sign_in user
          visit root_path
        end

        it { should have_selector('aside span', text: "#{user.feed.size} microposts") }

        it "should render the user's feed" do
          user.feed.each do |item|
            page.should have_selector("li##{item.id}", text: item.content)
          end
        end

        it "should not have delete links for other users posts" do
          should_not have_link('delete', href: micropost_path(user2.microposts.first))
        end

        it "should have delete links for logged in users posts" do
          should have_link('delete', href: micropost_path(user.microposts.first))
        end

      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }

    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About Us')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('')
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign Up')
    click_link "sample app"
    page.should have_selector 'title', text: full_title('')
  end
end
