# require 'svSyntax.rb'
require 'svMethod.rb'
require 'svField.rb'
require 'svFile.rb'

class SVClass < SVFile
	# attr_accessor :sv;

	attr_accessor :classname;
	attr_accessor :basename;
	attr_accessor :methods;
	attr_accessor :fields;

	def initialize(cn,bn,d,uvmct=:component)
		super(cn,d);
		@classname = cn;
		@basename  = bn;
		# @sv = SVSyntax.new();
		@methods={};@fields={};
		builtins(uvmct);
	end

	def constructor(ct)
		a = %Q|string name = "#{@classname}"|;
		a+= %Q|,uvm_component parent=null| if ct==:component;
		m = SVMethod.new(:func,'new',a,'');
		@methods['new'] = m;
	end

	def phases()
		phase('build',:func);
		phase('connect',:func);
		phase('run',:task);
	end

	def phase(n,t)
		mn = "#{n}_phase";
		m = SVMethod.new(t,n,'uvm_phase phase');
		m.qualifier= 'virtual';
		m.procedure("super.#{mn}(phase);");
		@methods[mn] = m;
	end

	def builtins(ct)
		constructor(ct);
		phases() if ct==:component;
	end
	def code(u)
		return self.send(u.to_sym);
	end

	# return code to declare a class
	def declareClass()
		code = %Q|class #{@classname} extends #{@basename}|;
		return [code];
	end

	def declareEnd()
		return ['endclass'];
	end

end