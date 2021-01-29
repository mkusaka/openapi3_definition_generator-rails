require 'action_dispatch/routing/inspector'
require 'yaml'

module ActionDispatch
  module Routing
    class OpenAPI3Formatter
      def initialize()
        @view  = nil
        @buffer = []
        @openapi_structute = {
          'openapi' => '3.0.0',
          'info' => {
            'title' => '',
            'description' => '',
            'version' => '0.1.0'
          },
          'paths' => {}
        }
      end

      def section_title(title)
      end

      def section(routes)
        routes.select do |r|
          !r[:verb].empty?
        end.each do |r|
          path = r[:path].gsub(/\(\.:format\)/, '')
          @openapi_structute['paths'][path] ||= {}
          @openapi_structute['paths'][path][r[:verb].downcase] = {}
          @openapi_structute['paths'][path][r[:verb].downcase] = {
            'summary' => r[:name],
            'description' => r[:reqs],
            'responses' => nil
          }
        end
      end

      def header(routes)
      end

      def no_routes(*)
      end

      def result
        YAML.dump @openapi_structute
      end
    end
  end
end
