class HomeController < ApplicationController

  before_filter :init_session_count

  def index
  end

  def convert
    render(status: 503) and return if session[:doc_count] > 10
    render(status: 500) and return unless params[:markdown]

    output = markdown.render(params[:markdown])
    response = create_pdf_in_docraptor(output)

    if response.code == 200
      session[:doc_count] += 1
      send_data response, filename: "updraft_output.pdf", type: 'pdf'
    else
      render inline: response.body, status: response.code
    end
  end

  private

  def init_session_count
    session[:doc_count] ||= 0
  end

  def markdown
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true, :space_after_headers => true)
  end

  def create_pdf_in_docraptor(content)
    options = { 
      :test             => ! Rails.env.production?,
      :document_content => content
    }

    DocRaptor.create(options)
  end
end
