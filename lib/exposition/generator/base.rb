module Exposition
  module Generators
    class Base    
      include Exposition::Templates
      include Helpers
      
      def initialize(parsed_docs, template, configuration)
        @docs       = parsed_docs
        @template   = template.to_s
        @config     = configuration
        @symbols    = {
          :objc_classes     => {},
          :objc_categories  => {},
          :objc_protocols   => {}
        }
        @assets     = []
        @properties = config
        
        reconcile_symbols
      end
      
      def generate
        raise 'Implement in a subclass'
      end
      
      def doc_root
        @doc_root ||= Pathname.new(config.output_directory) + config.bundle_name
      end
      
      def template
        @template
      end
      
      def config
        @config
      end
      
      def klasses
        @symbols[:objc_classes]
      end
      
      def protocols
        @symbols[:objc_protocols]
      end
      
      def categories
        @symbols[:objc_categories]
      end
    
      private
        def create_output_directory
          unless File.exists?(doc_root) && !config.force_rebuild
            FileUtils.rm_rf(doc_root)
            doc_root.mkpath
          else
            puts "Directory `#{doc_root}` exists: use `config.force_rebuild = true` to always recreate this directory"
          end
        end
        
        def reconcile_symbols
          @docs.each do |source|
            @symbols.keys.each do |objc_type|
              types = source.info.send(objc_type)
              types.each do |obj|
                sym_name = obj.name.downcase.to_sym        
                if @symbols[objc_type][sym_name].nil? 
                  @symbols[objc_type][sym_name] = obj
                end
              end
            end
          end
        end
    end
  end
end