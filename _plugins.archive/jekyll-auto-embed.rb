# Will auto-embed youtube and vimeo links in <p></p>s
# Inspired by jekyll-mentions

require "jekyll"

module Jekyll
  class Embeds

    InvalidJekyllEmbedConfig = Class.new(Jekyll::Errors::FatalException)

    class << self
      def embedify(doc)
        return unless doc.output.include?("https://vimeo.com/") | doc.output.include?("https://www.youtube.com/")
        # Vimeo
        doc.output = doc.output.gsub(/<p>(https:\/\/)(vimeo.com)(\/.*)<\/p>/, "<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='\\1player.\\2\/video\\3' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></div><br>")
        # Square Youtube
        doc.output = doc.output.gsub(/<p class="video-square">(https:\/\/www\.)(youtube.com)(\/watch\?v\=)(.*)<\/p>/, "<style>.embed-container { position: relative; padding-bottom: 100%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='\\1\\2\/embed\/\\4' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></div><br>")
        # 4-3 Youtube
        doc.output = doc.output.gsub(/<p class="video-4-3">(https:\/\/www\.)(youtube.com)(\/watch\?v\=)(.*)<\/p>/, "<style>.embed-container { position: relative; padding-bottom: 75%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='\\1\\2\/embed\/\\4' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></div><br>")
        # Youtube
        doc.output = doc.output.gsub(/<p>(https:\/\/www\.)(youtube.com)(\/watch\?v\=)(.*)<\/p>/, "<style>.embed-container { position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; } .embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }</style><div class='embed-container'><iframe src='\\1\\2\/embed\/\\4' frameborder='0' webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe></div><br>")
      end

      # Public: Defines the conditions for a document to be embedable.
      #
      # doc - the Jekyll::Document or Jekyll::Page
      #
      # Returns true if the doc is written & is HTML.
      def embedable?(doc)
        (doc.is_a?(Jekyll::Page) || doc.write?) &&
            doc.output_ext == ".html" || (doc.permalink && doc.permalink.end_with?("/"))
      end

      private

    end
  end
end

Jekyll::Hooks.register %i[pages documents], :post_render do |doc|
  Jekyll::Embeds.embedify(doc) if Jekyll::Embeds.embedable?(doc)
end