class HomeController < ApplicationController

  def index
  end

  def convert
    if params[:markdown]
      output = markdown.render(params[:markdown])
      
    else
      render status: 500
    end
  end

  private

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
  end
end
