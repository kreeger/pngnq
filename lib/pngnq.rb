require 'cocaine'
require 'fileutils'

require 'pngnq/version'

# A Ruby wrapper around the `pngnq` command line tool.
module Pngnq
  # Converts a file using `pnqnq`.
  # @param [String] file the path to the file.
  # @param [Hash] options a hash of options.
  # @option options [Integer] :colors the number of colors in the output image.
  # @option options [Boolean] :force if true, the destination file will be
  #                           overwritten.
  # @option options [Symbol] :quantization the dithering option to use, either
  #                          :no_dithering (default) or :floyd_steinberg.
  # @option options [Integer] :speed from 1-10, 10 being fastest, with worst
  #                           quality. Default is 1.
  # @option options [Float] :gamma the gamma of the converted image; default
  #                         value is 1.8.
  # @option options [String] :output the output directory where the destination
  #                          file will be stored.
  # @return [Boolean] true if success.
  def self.convert(file, options={})
    options = self.combine_defaults_with(options)
    command = self.build_line_for(options)

    new_file = file.gsub(/\.png$/, '-nq8.png')
    destination = File.join(options[:output], File.basename(file))

    FileUtils.rm(new_file) if File.exists?(new_file)
    FileUtils.rm(destination) if options[:force] && File.exists?(destination)

    result = self.cocaine.run(:options => command, :file => file)
    FileUtils.mv(new_file, destination) if result
    result
  end

  # Generates an instnace of a Cocaine command line runner.
  # @return [Cocaine::CommandLine] a fresh command line runner object.
  def self.cocaine
    Cocaine::CommandLine.new('pngnq', ":options :file")
  end

  # Mashes in a given hash with our defaults.
  # @param [Hash] options a hash of options.
  # @option options [Integer] :colors the number of colors in the output image.
  # @option options [Boolean] :force if true, the destination file will be
  #                           overwritten.
  # @option options [Symbol] :quantization the dithering option to use, either
  #                          :no_dithering (default) or :floyd_steinberg.
  # @option options [Integer] :speed from 1-10, 10 being fastest, with worst
  #                           quality. Default is 1.
  # @option options [Float] :gamma the gamma of the converted image; default
  #                         value is 1.8.
  # @option options [String] :output the output directory where the destination
  #                          file will be stored.
  # @return [Hash] the merged hash.
  def self.combine_defaults_with(options)
    {
      :colors => 256,
      :force => true,
      :quantization => :no_dithering,
      :speed => 1,
      :gamma => 1.8,
      :output => '.',
    }.merge(options)
  end

  # A hash of key-to-flag mappings.
  # @return [Hash] a hash of key-to-flag mappings.
  def self.mappings
    {
      :colors => '-n',
      :force => '-f',
      :quantization => '-Q',
      :speed => '-s',
      :gamma => '-g',
      :output => '-d',
    }
  end

  # A hash of value-to-command-line-value mappings.
  # @return [Hash] a hash of value-to-command-line-value mappings.
  def self.value_mappings
    {
      'true' => '',
      'no_dithering' => 'n',
      'floyd_steinberg' => 'f',
    }
  end

  # Turns a provided hash into the command-line string format `pngnq` wants.
  # @param [Hash] options a hash of key/value options for the command line.
  # @return [String] a valid string for use with `pngnq`.
  def self.build_line_for(options)
    pairs = options.map do |key, value|
      next if value == false
      flag = self.mappings[key]
      val = self.value_mappings[value.to_s] || value.to_s
      flag.nil? ? nil : [flag, val].join(' ')
    end
    pairs.reject { |p| p.nil? }.join(' ').strip
  end
end
