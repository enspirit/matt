module Matt
  class Command
    describe "-f" do

      let(:command){
        base_command
      }

      subject{
        command.call(argv)
      }

      let(:argv){ %w{show -f} + [(Path.dir.parent/"fixtures/foobar").to_s] + %w{--json foobar} }

      it 'works as expected' do
        expected = JSON.pretty_generate([
          {
            :at => Date.parse("2021-01-01"),
            :foo => "bar",
            :count => 20
          }
        ])
        subject
        expect(command.stderr.string).to eql("")
        expect(command.stdout.string).to eql("#{expected}\n")
      end

    end
  end
end
