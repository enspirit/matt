require 'spec_helper'
module Matt
  class Command
    describe Command, "parse_argv" do

      let(:command){
        base_command(false)
      }

      subject{
        command.on_configuration{|c|
          c.stdout = StringIO.new
          c.stderr = StringIO.new
        }.parse_argv(argv)
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

      context '--all-time' do
        let(:argv){
          %w{--all-time}
        }

        it 'set a true Predicate' do
          expect(subject).to eql([])
          expect(command.configuration.at_predicate).to eql(Predicate.tautology)
        end
      end

      context '--yesterday' do
        let(:argv){
          %w{--yesterday}
        }

        it 'sets a Predicate for yesterday' do
          expect(subject).to eql([])
          expect(command.configuration.at_predicate).to eql(Predicate.gte(:at, Date.today - 1) & Predicate.lt(:at, Date.today))
        end
      end

      context '--today' do
        let(:argv){
          %w{--today}
        }

        it 'sets a Predicate for today' do
          expect(subject).to eql([])
          expect(command.configuration.at_predicate).to eql(Predicate.gte(:at, Date.today) & Predicate.lt(:at, Date.today + 1))
        end
      end

      context '--last' do
        let(:argv){
          %w{--last=7days}
        }

        it 'sets a Predicate for the last 7 days' do
          expect(subject).to eql([])
          expect(command.configuration.at_predicate).to eql(Predicate.gte(:at, Date.today - 7) & Predicate.lt(:at, Date.today + 1))
        end
      end

      context '--since' do
        let(:argv){
          %w{--since=2021-02-13}
        }

        it 'sets a Predicate since the passed date' do
          expect(subject).to eql([])
          expect(command.configuration.at_predicate).to eql(Predicate.gte(:at, Date.parse("2021-02-13")) & Predicate.lt(:at, Date.today + 1))
        end
      end

      context '--silent' do
        let(:argv){
          %w{--silent}
        }

        it 'sets the correct debug level' do
          expect(subject).to eql([])
          expect(command.configuration.debug_level).to eql(Configuration::DEBUG_SILENT)
        end
      end

      context '--verbose' do
        let(:argv){
          %w{--verbose}
        }

        it 'sets the correct debug level' do
          expect(subject).to eql([])
          expect(command.configuration.debug_level).to eql(Configuration::DEBUG_VERBOSE)
        end
      end

    end
  end
end
