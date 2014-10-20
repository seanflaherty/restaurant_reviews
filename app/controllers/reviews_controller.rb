class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.order('id desc').limit(5)
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    if (session[:user_id])
      @review = Review.new
      respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @review }
      end
    else
       flash[:notice] = "Please log on to post"
       redirect_to '/reviews'
    end
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    def comment
        Review.find(params[:id]).comments.create(params[:comment])
        redirect_to :action => "show", :id => params[:id]
    end

    def search
        pattern = params[:searchFor]
        pattern = "%" + pattern + "%"

        @reviews = Review.where("title like ?", pattern)
    end

    def newuser
        respond_to do |format|
            user = User.new
            user.userid = params[:userid]
            user.password = params[:password]
            user.fullname = params[:fullname]
            user.email = params[:email]
        if user.save
            session[:user_id] = user.userid
            flash[:notice] = 'New User ID was successfully created.'
        else
            flash[:notice] = 'Sorry, User ID already exists.'
        end
            format.html {redirect_to '/reviews' }
        end
    end

    def validate

    respond_to do |format|
        user = User.authenticate(params[:userid], params[:password])
        if user
            session[:user_id] = user.userid
            flash[:notice] = 'User successfully logged in'
        else
            flash[:notice] = 'Invalid user/password'
        end
        format.html {redirect_to '/reviews' }
        end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:poster, :date, :article)
    end
end
