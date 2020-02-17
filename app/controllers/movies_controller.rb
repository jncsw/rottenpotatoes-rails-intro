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
    # @all_ratings = ['G','PG','PG-13','R']
    @all_ratings = Movie.all_ratings()
    # puts params[:sort]
    # puts params[:ratings]
    # puts
    
    @movies = Movie.all
    if not params[:ratings].nil?
      session[:ratings] = params[:ratings]
      @ratings = params[:ratings]
      # puts @ratings  #{"G"=>"1", "PG"=>"1", "PG-13"=>"1", "R"=>"1"}
      @movies = @movies.with_ratings(@ratings.keys)

    end
    
    # puts '-------------------------'
    # puts session[:sort]
    # puts '-------------------------'
    if (not params[:sort].nil?) and  params[:sort]!='none'
      session[:sort] = params[:sort]
      @movies = @movies.order(params[:sort]).all
    end
    if session[:sort].nil?
      session[:sort] = 'none'
    end
    # puts '-------------------------'
    # puts session[:sort]
    # puts '-------------------------'
    if params[:sort].nil?
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings])
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
