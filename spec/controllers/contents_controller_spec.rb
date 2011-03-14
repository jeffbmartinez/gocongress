require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe ContentsController do

  def mock_content(stubs={})
    @mock_content ||= mock_model(Content, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all contents as @contents" do
      Content.stub(:all) { [mock_content] }
      get :index
      assigns(:contents).should eq([mock_content])
    end
  end

  describe "GET show" do
    it "assigns the requested content as @content" do
      Content.stub(:find).with("37") { mock_content }
      get :show, :id => "37"
      assigns(:content).should be(mock_content)
    end
  end

  describe "GET new" do
    it "assigns a new content as @content" do
      Content.stub(:new) { mock_content }
      get :new
      assigns(:content).should be(mock_content)
    end
  end

  describe "GET edit" do
    it "assigns the requested content as @content" do
      Content.stub(:find).with("37") { mock_content }
      get :edit, :id => "37"
      assigns(:content).should be(mock_content)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created content as @content" do
        Content.stub(:new).with({'these' => 'params'}) { mock_content(:save => true) }
        post :create, :content => {'these' => 'params'}
        assigns(:content).should be(mock_content)
      end

      it "redirects to the created content" do
        Content.stub(:new) { mock_content(:save => true) }
        post :create, :content => {}
        response.should redirect_to(content_url(mock_content))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved content as @content" do
        Content.stub(:new).with({'these' => 'params'}) { mock_content(:save => false) }
        post :create, :content => {'these' => 'params'}
        assigns(:content).should be(mock_content)
      end

      it "re-renders the 'new' template" do
        Content.stub(:new) { mock_content(:save => false) }
        post :create, :content => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested content" do
        Content.stub(:find).with("37") { mock_content }
        mock_content.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :content => {'these' => 'params'}
      end

      it "assigns the requested content as @content" do
        Content.stub(:find) { mock_content(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:content).should be(mock_content)
      end

      it "redirects to the content" do
        Content.stub(:find) { mock_content(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(content_url(mock_content))
      end
    end

    describe "with invalid params" do
      it "assigns the content as @content" do
        Content.stub(:find) { mock_content(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:content).should be(mock_content)
      end

      it "re-renders the 'edit' template" do
        Content.stub(:find) { mock_content(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested content" do
      Content.stub(:find).with("37") { mock_content }
      mock_content.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the contents list" do
      Content.stub(:find) { mock_content }
      delete :destroy, :id => "1"
      response.should redirect_to(contents_url)
    end
  end

end