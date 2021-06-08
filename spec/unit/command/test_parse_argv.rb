require 'spec_helper'
module Matt
  class Command
    describe Command, "parse_argv" do

      let(:command){
        base_command(false)
      }

      subject{
        command.parse_argv(argv)
      }

      context '-f' do
        let(:argv){
          %w{-f} + [folder.to_s]
        }

        context "with a valid folder" do
          let(:folder){
            fixtures_folder/"foobar"
          }

          it 'sets the configuration object to the path' do
            expect(subject).to eql([])
            expect(command.configuration.folder).to eql(folder)
          end
        end

        context "with an invalid folder" do
          let(:folder){
            fixtures_folder/"nosuchone"
          }

          it 'fails' do
            expect{ subject }.to throw_symbol(:abort)
            expect(command.stderr.string).to match(/No such folder/)
          end
        end
      end

    end
  end
end
