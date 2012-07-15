module Backend::PostsHelper
  
  def markdown2html(txt)    
      Redcarpet.new(txt, :autolink, :no_intraemphasis, :smart, :space_header).to_html
  end
  
end
