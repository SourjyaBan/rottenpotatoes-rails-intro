class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    title = params[:title] #Flag set if title is sorted
    release_date = params[:release_date] #Flag set if release_date is sorted
    ratings = params[:ratings] #Contains the ratings that are checked
    @all_ratings = Movie.all_ratings #Contains all ratings
    redirect_flag = false #Flag set if redirect required
    #We first check if sorting is required
    if title
      @movies = Movie.order("title") #sort by title
      session[:sort] = "title" #store sort criteria in session
    elsif release_date
      @movies = Movie.order("release_date") #sort by release_date
      session[:sort] = "release_date" #store sort criteria in session
    elsif session[:sort] != nil #We have navigated back but sort param not passed
      @movies = Movie.order(session[:sort]) #Sort by stored sort criteria
      redirect_flag = true #Set redirection to true
    end
    #We check if ratings have been passed 
    if ratings
      if ratings.kind_of?(Array) #This is when redirection occurs or page initializes
        @movies = Movie.where(:rating => ratings).order(session[:sort]) #Get selected ratings and sort by criteria
        @checked_ratings = ratings
      else # This occurs when the form is submitted
        @movies = Movie.where(:rating => ratings.keys).order(session[:sort])
        @checked_ratings = ratings.keys
      end
      session[:checked_ratings] = @checked_ratings #Store checked ratings in session
    elsif session[:checked_ratings] != nil
      @movies = Movie.where(:rating => session[:checked_ratings]).order(session[:sort])
      redirect_flag = true
    else
      @movies = Movie.all
      @checked_ratings = @all_ratings
      session[:checked_ratings] = @checked_ratings
      redirect_flag = true
    end
    #We check if redirection is needed
    if redirect_flag
      if session[:checked_ratings] != nil and session[:sort] == "title"
        redirect_to movies_path(:title => 1, :ratings => session[:checked_ratings])
      elsif session[:checked_ratings] != nil and session[:sort] == "release_date"
        redirect_to movies_path(:release_date => 1, :ratings => session[:checked_ratings])
      elsif session[:checked_ratings] != nil
        redirect_to  movies_path(:ratings => session[:checked_ratings])
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
