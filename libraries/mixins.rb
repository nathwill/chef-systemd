
module Systemd
  module Mixin
    module DirectiveConversion
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Converts a hash into resource attributes
        # See the Systemd module for more details.
        def option_attributes(options = {})
          options.each_pair do |name, config|
            attribute name.underscore.to_sym, config
          end
        end
      end

      # converts configuration hash (keys as directives, config as values)
      # to an array of strings with camelized directive and stringified values
      def options_config(opts = {})
        opts.reject { |o, _| send(o.underscore.to_sym).nil? }.map do |name, _|
          "#{name.camelize}=#{conf_string(send(name.underscore.to_sym))}"
        end
      end

      # converts configuration options into the appropriate string format; it's
      # critical to keep this in mind when choosing the `kind_of` key in the
      # OPTIONS hash in the Systemd module for use with option_attributes.
      def conf_string(obj)
        case obj
        when Hash
          obj.map { |k, v| "\"#{k}=#{v}\"" }.join(' ')
        when Array
          obj.join(' ')
        when TrueClass, FalseClass
          obj ? 'yes' : 'no'
        else
          obj.to_s
        end
      end
    end
  end
end
