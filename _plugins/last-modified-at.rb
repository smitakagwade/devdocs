# frozen_string_literal: true

#
# This custom plugin dynamically sets the 'last_modified_at' parameter
# for each page except 'redirect.html' pages.
# A value of the pararmeter is available as {{ page.last_modified_at }}.
# The parameter contains date and time of the last commit that changed
# the original file.
# For available date formats, refer to https://git-scm.com/docs/git-log#git-log---dateltformatgt
#
Jekyll::Hooks.register :pages, :post_init do |page|
  # Do nothing in serving mode
  next if page.site.config['serving']

  # Do nothing for redirects
  next if page.name == 'redirect.html'

  page_path = page.path

  # If the page is a symlink, use path of the original file
  page_path = File.realpath page_path if File.symlink? page_path

  # Read date of the last committ and assign it to last_modified_at parameter
  # of the page.
  page.data['last_modified_at'] =
    `git log -1 --format=%cd --date=iso -- #{page_path}`.strip
end
