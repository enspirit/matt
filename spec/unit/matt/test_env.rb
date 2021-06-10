require 'spec_helper'
describe Matt, "env" do

  context 'when the env var exists' do
    before do
      ENV['foo'] = 'bar'
    end

    it 'returns it' do
      expect(Matt.env('foo', 'baz')).to eql('bar')
    end
  end

  context 'when the env var exists but has trailing spaces' do
    before do
      ENV['foo'] = '  bar  '
    end

    it 'returns it' do
      expect(Matt.env('foo', 'baz')).to eql('bar')
    end
  end

  context 'when the env var does not exist' do
    before do
      ENV.delete('foo')
    end

    it 'returns the default value' do
      expect(Matt.env('foo', 'baz')).to eql('baz')
    end
  end

  context 'when the env var does not exist and default is not a string' do
    before do
      ENV.delete('foo')
    end

    it 'returns the default value' do
      expect(Matt.env('foo', 12)).to eql(12)
    end
  end

  context 'using the ! version when variable does not exists' do
    before do
      ENV.delete('foo')
    end

    it 'returns the default value' do
      expect{ Matt.env!('foo') }.to raise_error(Matt::Error)
    end
  end

  context 'using the ! version when variable does exists' do
    before do
      ENV['foo'] = "bar"
    end

    it 'returns the default value' do
      expect(Matt.env!('foo')).to eql('bar')
    end
  end
end