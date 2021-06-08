require 'spec_helper'
module Matt
  class Command
    describe "show" do

      let(:command){
        base_command
      }

      subject{
        command.call(argv)
      }

      context 'with --json' do
        let(:argv){ %w{show --json account_creations} }

        it 'works as expected' do
          expected = JSON.pretty_generate(helloworld_config.ds.main.account_creations)
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("#{expected}\n")
        end
      end

      context 'with --csv' do
        let(:argv){ %w{show --csv account_creations} }

        it 'works as expected' do
          expected = helloworld_config.ds.main.account_creations.to_csv(helloworld_config.csv_options)
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("#{expected}")
        end
      end

    end
  end
end
