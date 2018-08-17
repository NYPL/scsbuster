module ItemsHelper
  def refile_pagination(refile_request, refiles)
    result = ''
    if refile_request.page != 1
      result << "<a href='#{previous_page_url(refile_request)}' class='previous-link pointer' role='link' tabindex='0'>Previous</a>"
    end

    result << "<span class='page-count'>Page #{refile_request.page} of #{total_page_count(refile_request, refiles)}</span>"

    if refile_request.page != total_page_count(refile_request, refiles)
      result << "<a href='#{next_page_url(refile_request)}' class='next-link pointer' role='link' tabindex='0'>Next</a>"
    end

    result.html_safe
  end

  def cardinality_of_current_results(refile_request, refiles)
    first_one = refile_request.page == 1 ? 1 : ((refile_request.page - 1) * refile_request.per_page) + 1
    last_one  = refile_request.page == 1 ? refiles['count'] : (first_one + refiles['count']) - 1
    "#{first_one}-#{last_one}".html_safe
  end

  private

  def previous_page_url(refile_request)
    url = request.original_url
    url.gsub!(/page=*.*/, "page=#{refile_request.page - 1}")
    url
  end

  def total_page_count(refile_request, refiles)
    pages = refiles['totalCount'] / refile_request.per_page
    pages += 1 if refiles['totalCount'] % refile_request.per_page
    pages
  end

  def next_page_url(refile_request)
    url = request.original_url
    if url.include?('page=')
      url.gsub!(/page=*.*/, "page=#{refile_request.page + 1}")
    else
      url << '?' unless url.include?('?')
      url << '&page=2'
    end
    url
  end

end
