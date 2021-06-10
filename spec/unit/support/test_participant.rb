require 'spec_helper'
module Matt
  module Support
    class ParticipantTest
      include Participant
    end
    describe Participant do

      it 'implements a nice to_s' do
        expect(ParticipantTest.new.to_s).to eql("Matt::Support::ParticipantTest()")
      end

      it 'works fine on a datasource' do
        expect(helloworld_config.ds.main.to_s).to eql("Main(main)")
      end

    end
  end
end