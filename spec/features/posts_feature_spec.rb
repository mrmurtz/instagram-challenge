require 'rails_helper'

feature 'posts' do
    context 'no posts have been added' do
      scenario 'no posts displayed' do
        visit '/posts'
        expect(page).to have_content 'No posts yet'
        expect(page).to have_link 'Upload a photo'
      end
    end

    context 'creating a post' do
      scenario 'clicking link to create post' do
        visit '/posts'
        click_link 'Upload a photo'
        expect(current_path).to eq '/posts/new'
      end

      # scenario 'uploading a photo' do
      #   visit '/posts'
      #   click_link 'Choose a photo'
      #   attach_file('Upload', "spec/files/images/cat.jpg")
      #   click_button 'Create Post'
      #   expect(page).to have_css("ims sg[src*='cat.jpg']")
      # end
    end

    context 'viewing posts' do
      let!(:cat){Post.create(image_file_name: 'cat.jpg', caption:'Awesome cat')}
      scenario 'Clicking full shows the post' do
        visit '/'
        click_link 'Sign up'
        fill_in 'user[email]', with: "testing@test.com"
        fill_in 'user[password]', with: "testing"
        fill_in 'user[password_confirmation]', with: "testing"
        click_button "Sign up"
        save_and_open_page
        click_link 'Awesome cat'
        expect(current_path).to eq "/posts/#{cat.id}"
        expect(page).to have_content 'Awesome cat'
      end
    end

    context 'adding captions when uploading a photo' do
      let!(:cat){Post.create(image_file_name: 'cat.jpg', caption: 'Jokes cat')}
      scenario 'Adding a caption and displaying on index' do
        visit '/posts'
        expect(page).to have_content 'Jokes cat'
      end
    end

    context 'editting posts' do
      let!(:cat){Post.create(image_file_name: 'cat.jpg', caption:'Awesome cat')}
      scenario 'let a user edit caption and img' do
        visit '/posts'
        click_link 'Awesome cat'
        click_link 'Edit'
        fill_in 'post[caption]', with: 'Not so awesome cat'
        click_button 'Update'
        expect(page).to have_content 'Not so awesome cat'
      end
    end

    context 'deleting posts' do
      let!(:cat){Post.create(image_file_name: 'cat.jpg', caption:'Awesome cat')}
      scenario 'posts can be deleted from the edit page' do
        visit '/posts'
        click_link 'Awesome cat'
        click_link 'Edit'
        click_link 'Delete post'
        expect(page).not_to have_content 'Awesome cat'
      end
    end

    context 'a caption longer than 140 characters' do
      scenario 'does not let you submit caption more than 140 chars' do
        visit '/posts'
        click_link 'Upload a photo'
        fill_in 'post[caption]', with: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et mag.'
        click_button 'Upload'
        expect(page).not_to have_content 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et mag.'
      end
    end
  end
