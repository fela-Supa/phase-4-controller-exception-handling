class BirdsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  # GET /birds
  def index
    birds = Bird.all
    render json: birds
  end

  # POST /birds
  def create
    bird = Bird.create(bird_params)
    render json: bird, status: :created
  end

  # GET /birds/:id
  def show
    bird = find_bird
    render json: bird
  rescue ActiveRecord::RecordNotFound
    render_not_found_response
  end
  

  # PATCH /birds/:id
  def update
    bird = find_bird
    bird.update(bird_params)
    render json: bird
  rescue ActiveRecord::RecordNotFound
    render_not_found_response
  end

  # PATCH /birds/:id/like
  def increment_likes
    bird = find_bird
    if bird
      bird.update(likes: bird.likes + 1)
      render json: bird
    else
      render_not_found_response
    end
  end

  # DELETE /birds/:id
  def destroy
    bird = find_bird
    if bird
      bird.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render_not_found_response
    end

private

  def bird_params
    params.permit(:name, :species, :likes)
  end

  def find_bird
    Bird.find(id: params[:id])
  end

  def render_not_found_response
  render json: { error: "Bird not found" }, status: :not_found
end
end