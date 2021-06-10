module Matt
  module Support
    module Participant
      include Puts

      attr_accessor :name
      attr_accessor :configuration

      def fail!(message)
        raise UnexpectedError, message
      end

      def class_name
        self.class.name.gsub /#<Class(.*?)>::/, ""
      end

      def to_s
        "#{class_name}(#{self.name})"
      end

    end # module Participant
  end # module Support
end # module Matt
