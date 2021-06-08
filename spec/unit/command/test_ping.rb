require 'spec_helper'
module Matt
  class Command
    describe "ping" do

      let(:command){
        base_command
      }

      subject{
        command.call(argv)
      }

      context 'with a valid datasource' do
        let(:argv){ %w{ping main} }

        it 'pings that one' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("Ok.\n")
          expect(command.exitcode).to eql(0)
        end
      end

      context 'with no datasource' do
        let(:argv){ %w{ping} }

        it 'pings them all' do
          subject
          expect(command.stderr.string).to eql("")
          expect(command.stdout.string).to eql("Ok.\n")
          expect(command.exitcode).to eql(0)
        end
      end

      context 'with an invalid datasource' do
        let(:argv){ %w{ping nosuchone} }

        it 'works as expected' do
          subject
          expect(command.stderr.string).to eql("No such datasource nosuchone\n")
          expect(command.exitcode).to eql(1)
        end
      end

    end
  end
end
