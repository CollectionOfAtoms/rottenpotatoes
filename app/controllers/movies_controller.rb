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

#---------------------------------------------------------------------------------------------
#Sorting Algorithm for Title and Release Date

	#If no new sort was passed in, then recover old one from session
    if(params[:sort] == nil && session[:sort] != nil)
    	params[:sort] = session[:sort]
    end

    #Sort the data
    if(params[:sort].to_s == 'title')                 #if user clicked title
    	@movies = @movies.sort_by {|mov| mov.title}   #Actually sort the movies by title
    	session[:sort] = params[:sort]                #Remember the sorting later just in case they don't pass you one
    elsif(params[:sort].to_s == 'release')                          #Otherwise if they clicked release
    	@movies = @movies.sort_by {|mov| mov.release_date.to_s}     # Sort the movies by release date
    	session[:sort] = params[:sort]                              # Save the sorting for later
    end
#-------------------------------------------------------------------------------------------------
#Filtering Algorithm for rating

	#If no new filter passed in (AKA all checkboxes left blank), then recover old filter
    if(params[:ratings] == nil  && session[:ratings] != nil)
    	params[:ratings] = session[:ratings]
    end

    #Check the correct boxes
    if params[:ratings] != nil                          #if user passed in a filter
    	@all_ratings.each { |rating|                    # for each rating
    		@checked[rating] = params[:ratings].has_key?(rating)  #use the filter the user selects
    	}
    else
    	@all_ratings.each { |rating|     #If no filter exists in params or session
    		@checked[rating] = true      # Set all checkboxes to checked
    	}
    end

    # Filter Based on Selected Ratings
    if(params[:ratings] != nil) 
    	@movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating) }
    	session[:ratings] = params[:ratings]
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
