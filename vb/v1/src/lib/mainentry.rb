require 'debugger.rb'
require 'exceptions.rb'
require 'options.rb'


class MainEntry

	attr_accessor :debug;
	attr_accessor :options;

	attr :optionH;
	def initialize
		@debug = Debugger.new(true);
		@optionH = Options.new();
		@options = @optionH.options;
		CommandPanel.setup(@options,@debug);
	end

	def run ##{{{
		sig = 0;
		begin
			@optionH.parse;
			CommandPanel.send(@options[:cmd]); # process cmd
		rescue RunException => e
			sig = e.process
		end
		return sig;
	end ##}}}

end
