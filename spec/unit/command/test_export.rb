require 'spec_helper'
module Matt
  class Command
    describe "export" do

      let(:command){
        base_command
      }

      subject{
        command.call(argv)
      }

      context 'with no options and one metric' do
        let(:argv){ %w{export account_creations} }

        it 'exports the metric to its default exporters' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("[]\n")
          expect(command.exitcode).to eql(0)
        end
      end

      context 'with no options and more than one metric' do
        let(:argv){ %w{export account_creations account_updates} }

        it 'exports the metrics to their default exporters' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("[]\n[]\n")
          expect(command.exitcode).to eql(0)
        end
      end

      context 'with no options and no metric at all' do
        let(:argv){ %w{export} }

        it 'exports them all' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("[]\n[]\n")
          expect(command.exitcode).to eql(0)
        end
      end

      context 'specifying the exporter(s)' do
        let(:argv){ %w{export --to=stdout,debug account_creations} }

        it 'fails' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to match(/\[\]\n/)
          expect(command.stdout.string).to match(/\(in_memory/)
          expect(command.exitcode).to eql(0)
        end
      end

      context 'specifying the exporter with multiple tos' do
        let(:argv){ %w{export --to=stdout --to=debug account_creations} }

        it 'fails' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to match(/\[\]\n/)
          expect(command.stdout.string).to match(/\(in_memory/)
          expect(command.exitcode).to eql(0)
        end
      end

      context 'with a metric that does not exist' do
        let(:argv){ %w{export nosuchone} }

        it 'fails' do
          subject
          expect(command.stderr.string).to eql("No such measure nosuchone\n")
          expect(command.stdout.string).to eql("")
          expect(command.exitcode).to eql(1)
        end
      end

    end
  end
end
