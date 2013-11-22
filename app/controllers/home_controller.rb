class HomeController < ApplicationController

  def index
  end

  def convert
    render(status: 500) and return unless params[:markdown]

    output = markdown.render(params[:markdown])
    response = create_pdf_in_docraptor(output)

    if response.code == 200
      send_data response, filename: "updraft_output.pdf", type: 'pdf'
    else
      render inline: response.body, status: response.code
    end
  end

  private

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
