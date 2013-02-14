require 'spec_helper'

describe Pngnq do

  describe :combine_defaults_with do
    let(:defaults) { Pngnq.combine_defaults_with({}) }

    it 'should return defaults by itself' do
      defaults.should be_a(Hash)
      defaults.keys.count.should == 6
      defaults[:colors].should == 256
      defaults[:speed].should == 1
      defaults[:gamma].should == 1.8
    end

    context :with_merged_hash do
      before(:each) do
        @overrides = { :colors => 32, :speed => 3, :gamma => 1.9 }
        @result = Pngnq.combine_defaults_with @overrides
      end

      it 'should merge in a hash of values properly' do
        @result[:colors].should == @overrides[:colors]
        @result[:speed].should == @overrides[:speed]
        @result[:gamma].should == @overrides[:gamma]
      end

      it 'should retain defaults not overriden' do
        @result[:quantization].should == defaults[:quantization]
      end
    end
  end

  describe :mappings do
    it 'should return a list of default mappings' do
      keys = [:colors, :force, :quantization, :speed, :gamma, :output]
      Pngnq.mappings.keys.should == keys
    end

    it 'should have valid mappings as well' do
      Pngnq.mappings[:colors].should == '-n'
      Pngnq.mappings[:force].should == '-f'
      Pngnq.mappings[:quantization].should == '-Q'
      Pngnq.mappings[:speed].should == '-s'
      Pngnq.mappings[:gamma].should == '-g'
      Pngnq.mappings[:output].should == '-d'
    end
  end

  describe :build_line_for do
    it 'should build a line for exactly what was given' do
      line = Pngnq.build_line_for({:colors => 64, :speed => 3})
      line.should == "-n 64 -s 3"
    end

    it 'should weed out invalid options' do
      line = Pngnq.build_line_for({:colors => 64, :your_mom => 'sucks' })
      line.should == "-n 64"
    end

    it 'should build out a line if all options given' do
      line = Pngnq.build_line_for(Pngnq.combine_defaults_with({}))
      line.should == '-n 256 -f  -Q n -s 1 -g 1.8 -d .'
    end
  end

  describe :cocaine do
    it 'should generate a valid Cocaine command line thingy' do
      line = Pngnq.cocaine.command
      line.should == 'pngnq :options :file'
    end

    it 'should build a command with options' do
      string = Pngnq.build_line_for(Pngnq.combine_defaults_with({}))

      line = Pngnq.cocaine.command(:options => string, :file => 'file.png')
      line.should == "pngnq '-n 256 -f  -Q n -s 1 -g 1.8 -d .' 'file.png'"
    end
  end

  describe :convert do
    before(:each) do
      FileUtils.mkdir_p('./tmp/converted')
      VCR.use_cassette('tux-image', record: :new_episodes) do
        Net::HTTP.start("www.tuxpaint.org") do |http|
          resp = http.get("/stamps/stamps/animals/birds/cartoon/tux.png")
          open("./tmp/tux.png", "wb") { |file| file.write(resp.body) }
        end
      end
    end

    it 'should convert an image!' do
      Pngnq.convert('./tmp/tux.png', :colors => 2, :output => 'tmp/converted')
      File.exists?('./tmp/converted/tux.png').should be_true
    end
  end
end