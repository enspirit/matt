require 'spec_helper'
module Matt
  describe Configuration do

    let(:config) {
      helloworld_config
    }

    describe "datasources" do
      subject{
        config.datasources
      }

      it 'returns an OpenStruct' do
        expect(subject).to be_a(OpenStruct)
      end

      it 'sets loaded objects to it' do
        expect(subject.main).to be_a(Matt::Datasource)
      end
    end

    describe "measures" do
      subject{
        config.measures
      }

      it 'returns an OpenStruct' do
        expect(subject).to be_a(OpenStruct)
      end

      it 'sets loaded objects to it' do
        expect(subject.account_creations).to be_a(Matt::Measure)
      end
    end

    describe "exporters" do
      subject{
        config.exporters
      }

      it 'returns an OpenStruct' do
        expect(subject).to be_a(OpenStruct)
      end

      it 'sets loaded objects to it' do
        expect(subject.stdout).to be_a(Matt::Exporter)
      end
    end
  end
end
