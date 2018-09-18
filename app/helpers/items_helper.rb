module ItemsHelper

  def date_dropdown_classes(prefix)
    {year: "#{prefix}_year", month: "#{prefix}_month", day: "#{prefix}_day"}
  end

  def refile_pagination(refile_error_search, refiles)
    result = ''
    if refile_error_search.page != 1
      result << "<a href='#{previous_page_url(refile_error_search)}' class='previous-link pointer' role='link' tabindex='0'>Previous</a>"
    end

    result << "<span class='page-count'>Page #{refile_error_search.page} of #{total_page_count(refile_error_search, refiles)}</span>"

    if refile_error_search.page != total_page_count(refile_error_search, refiles)
      result << "<a href='#{next_page_url(refile_error_search)}' class='next-link pointer' role='link' tabindex='0'>Next</a>"
    end

    result.html_safe
  end

  def cardinality_of_current_results(refile_error_search, refiles)
    first_one = refile_error_search.page == 1 ? 1 : ((refile_error_search.page - 1) * refile_error_search.per_page) + 1
    last_one  = refile_error_search.page == 1 ? refiles['count'] : (first_one + refiles['count']) - 1
    "#{first_one}-#{last_one}".html_safe
  end

  private

  def previous_page_url(refile_error_search)
    request.original_url.gsub(/page=*.*/, "page=#{refile_error_search.page - 1}")
  end

  def total_page_count(refile_error_search, refiles)
    (refiles['totalCount'] / refile_error_search.per_page.to_f).ceil
  end

  def next_page_url(refile_error_search)
    url = request.original_url
    if url.include?('page=')
      url.gsub!(/page=*.*/, "page=#{refile_error_search.page + 1}")
    else
      url << '?' unless url.include?('?')
      url << '&page=2'
    end
    url
  end

end
