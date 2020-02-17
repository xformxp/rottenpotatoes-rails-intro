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
    logger.debug(session.to_hash)
    @all_ratings = Movie.all_ratings
    
    # initialize session
    if not session.has_key?(:ratings)
      session[:ratings] = @all_ratings
    end
    sort_key = params[:sort]
    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings].keys
    end
    @ratings = {}
    @all_ratings.each do |rating|
      if session[:ratings].include?(rating)
        @ratings[rating] = true
      else
        @ratings[rating] = false
      end
    end
    @style = {}
    if sort_key == nil
      @movies = Movie.with_ratings(session[:ratings])
    else
      @style[sort_key.to_sym] = "hilite"
      @movies = Movie.with_ratings(session[:ratings]).order(sort_key)
    end
    #redirect_to movies_path(params)
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
