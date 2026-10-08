# frozen_string_literal: true

# Rewrites root-relative links (ex. `(/config-shell/.config/sh/func.sh)`) into
# links to the file on GitHub, since those files are not part of the site.
module RepoLinks
  GITHUB_USER = "hyperupcall"
  GITHUB_REPO = "dotfiles"
  GITHUB_BRANCH = "trunk"

  def self.rewrite(content, site)
    repo_root = File.expand_path("..", site.source)

    content.gsub(/\[([^\]]+)\]\((\/)([^)]+)\)/) do
      link_text = Regexp.last_match(1)
      path = Regexp.last_match(3)

      # Only rewrite links that point at real paths in the repository. Links to
      # generated pages (already rewritten by jekyll-relative-links) must be
      # left alone, or they end up as 404s on both the site and GitHub.
      target = File.join(repo_root, path.split("#", 2).first)
      next Regexp.last_match(0) unless File.exist?(target)

      kind = File.directory?(target) ? "tree" : "blob"
      "[#{link_text}](https://github.com/#{GITHUB_USER}/#{GITHUB_REPO}/#{kind}/#{GITHUB_BRANCH}/#{path}){:target=\"_blank\"}"
    end
  end
end

Jekyll::Hooks.register :documents, :pre_render do |document|
  next unless document.output_ext == ".html"

  document.content = RepoLinks.rewrite(document.content, document.site)
end

Jekyll::Hooks.register :pages, :pre_render do |page|
  next unless page.output_ext == ".html"

  page.content = RepoLinks.rewrite(page.content, page.site)
end