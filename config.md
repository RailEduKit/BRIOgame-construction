<!--
Add here global page variables to use throughout your website.
-->
+++
author = "Martin Scheidt and contributors"
mintoclevel = 2

# uncomment and adjust the following line if the expected base URL of your website is something like [www.thebase.com/yourproject/]
# please do read the docs on deployment to avoid common issues: https://franklinjl.org/workflow/deploy/#deploying_your_website
# prepath = "yourproject"

# Add here files or directories that should be ignored by Franklin, otherwise
# these files might be copied and, if markdown, processed by Franklin which
# you might not want. Indicate directories by ending the name with a `/`.
# Base files such as LICENSE.md and README.md are ignored by default.
ignore = ["node_modules/","deploy.jl","README.md","LICENSE","CITATION.cff"]

# RSS (the website_{title, descr, url} must be defined to get RSS)
generate_rss = true
website_title = "Interactive Signalling Laboratory"
website_descr = "How to construct the SigLab"
website_url   = "https://siglab.railedukit.org/"
prepath       = ""
+++

<!--
Add here global latex commands to use throughout your pages.
-->
\newcommand{\figenv}[3]{
~~~
<figure style="text-align:center;">
<img src="!#2" style="padding:0;#3" alt="#1"/>
<figcaption>#1</figcaption>
</figure>
~~~
}

\newcommand{\figenvLink}[4]{
~~~
<figure style="text-align:center;">
<a href="#4">
<img src="!#2" style="padding:0;#3" alt="#1"/>
<figcaption>#1</figcaption>
</a>
</figure>
~~~
}
