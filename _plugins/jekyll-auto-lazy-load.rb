# Will auto-Lazy youtube and vimeo links in <p></p>s
# Inspired by jekyll-mentions

require "jekyll"

module Jekyll
  class Lazys

    InvalidJekyllLazyConfig = Class.new(Jekyll::Errors::FatalException)

    class << self
      def Lazyify(doc)
        return unless doc.output.include?("<img")
        doc.output = doc.output.gsub(/(<img.*) src=(")(.*)(") (?!data-echo)(.*>)/, '\1 src="data:image/png;base64,R0lGODlhAQABAIAAAMLCwgAAACH5BAAAAAAALAAAAAABAAEAAAICRAEAOw=="" data-echo="\3" \5')
      end

      # Public: Defines the conditions for a document to be Lazyable.
      #
      # doc - the Jekyll::Document or Jekyll::Page
      #
      # Returns true if the doc is written & is HTML.
      def Lazyable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
            doc.output_ext == ".html" || (doc.permalink && doc.permalink.end_with?("/"))
      end

      private

    end
  end
end

Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::Lazys.Lazyify(doc) if Jekyll::Lazys.Lazyable?(doc)
end