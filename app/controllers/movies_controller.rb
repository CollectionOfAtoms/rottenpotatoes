class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R','NC-17','NR'] #Array of all possible ratings to reference to
    @checked = {}                    #Empty array will be filled with checked values

    if params[:ratings] != nil
    	@all_ratings.each { |rating|
    		@checked[rating] = params[:ratings].has_key?(rating)
    	}
    else
    	@all_ratings.each { |rating|
    		@checked[rating] = true
    	}
    end

    if(params[:sort].to_s == 'title')
    	@movies = @movies.sort_by {|mov| mov.title}
    elsif(params[:sort].to_s == 'release')
    	@movies = @movies.sort_by {|mov| mov.release_date.to_s}
    end


    # set the checked hash to make checkboxes be checked
=begin	@all_ratings.each { |rating|
      if params[:ratings] == nil
        @checked[rating] = false
      else
        @checked[rating] = params[:ratings].has_key?(rating)
      end
    }
=end

    # Sort Based on Selected Ratings
    if(params[:ratings] != nil)
    	@movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating) }
    	session[:ratings] = params[:ratings]
    elsif
    	(session[:ratings] != nil)
   		@movies = @movies.find_all{ |m| session[:ratings].has_key?(m.rating) }
  	end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
