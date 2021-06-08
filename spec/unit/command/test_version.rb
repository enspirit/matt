module Matt
  class Command
    describe "--version" do

      let(:command){
        base_command
      }

      subject{
        command.call(argv)
      }

      let(:argv){ %w{--version} }

      it 'works as expected' do
        expected = "Matt v#{Matt::VERSION} - (c) Enspirit SRL\n"
        subject
        expect(command.stdout.string).to eql(expected)
      end

    end
  end
end
