# Download modernizr.js
get "https://github.com/hide2/rails-h5bp/raw/master/assets/javascripts/modernizr.js", "app/assets/javascripts/modernizr.js"

# Download and merge HTML5 Boilerplate stylesheet with application.css
inside('app/assets/stylesheets/') do
  FileUtils.rm_rf 'application.css'
  FileUtils.touch 'application.css'
end
prepend_to_file 'app/assets/stylesheets/application.css' do
  " /*
 * This is a manifest file that'll automatically include all the stylesheets available in this directory
 * and any sub-directories. You're free to add application-wide styles to this file and they'll appear at
 * the top of the compiled file, but it's generally better to create a new file per style scope.
 *= require application-pre
 *= require_self
 *= require application-post
 *= require_tree .
*/
"
end
get "https://github.com/hide2/rails-h5bp/raw/master/assets/stylesheets/style.css", "app/assets/stylesheets/application-pre.css"
get "https://github.com/hide2/rails-h5bp/raw/master/assets/stylesheets/style.css", "app/assets/stylesheets/application-post.css"
gsub_file 'app/assets/stylesheets/application-pre.css', /\n*\/\* ==\|== media queries.* /m, ''
gsub_file 'app/assets/stylesheets/application-post.css', /\A.*?(==\|== primary styles).*?(\*\/){1}\n*/m, ''

# Update application.html.erb with HTML5 Boilerplate index.html content
inside('app/views/layouts') do
  FileUtils.rm_rf 'application.html.erb'
end
get "https://github.com/hide2/rails-h5bp/raw/master/index.html", "app/views/layouts/application.html.erb"
gsub_file 'app/views/layouts/application.html.erb', /<link rel="stylesheet" href="css\/style.css">/ do
  "<%= stylesheet_link_tag \"application\" %>"
end
gsub_file 'app/views/layouts/application.html.erb', /<script.*<\/head>/mi do
   "<%= javascript_include_tag \"modernizr\" %>
</head>"
end
gsub_file 'app/views/layouts/application.html.erb', /<meta charset="utf-8">/ do
  "<meta charset=\"utf-8\">
  <%= csrf_meta_tag %>"
end
gsub_file 'app/views/layouts/application.html.erb', /<div role="main">[\s\S]*<\/div>/ do
  "<div role=\"main\">
    <%= yield %>
  </div>
  "
end
gsub_file 'app/views/layouts/application.html.erb', /<!-- scripts[\s\S]*end scripts -->/, '<%= javascript_include_tag "application" %>'