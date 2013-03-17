require 'rubygems'
require 'albacore'

company_name      = 'Fyhr v/Jesper Fyhr Knudsen'
product_name      = 'BlankSolution'
copyright         = company_name + ' (c) 2013'
solution_path     = product_name + '.sln'
unit_tests        = []
itegraion_tests   = []
assemblyinfo_path = nil
packaged_dll      = product_name + '.dll'

desc 'performs a clean build'
task :default => [:package]

task :clean do
	puts 'clean'
end

assemblyinfo :assemblyinfo => [:clean] do |asm|
	asm.company_name = company_name
	asm.product_name = product_name
	asm.copyright    = copyright
	asm.output_file  = assemblyinfo_path
end

msbuild :compile => [:assemblyinfo] do |msb| 
	msb.properties :configuration => :Debug
	msb.targets    :build
	
	msb.solution = solution_path
end

nunit :unittests => [:compile] do |nunit|
	nunit.path_to_command = 'tools/NUnit-2.6.0.12051/bin/nunit-console.exe'
	nunit.assemblies      = unit_tests
end

nunit :integrationtests => [:unittests] do |nunit|
	nunit.path_to_command = 'tools/NUnit-2.6.0.12051/bin/nunit-console.exe'
	nunit.assemblies      = itegraion_tests
end

ilmerge :package => [:unittests] do |cfg|
	cfg.assemblies 'build/assembly1.dll', 'build/assembly2.dll'
	cfg.command    = 'tools/ILMerge/ILMerge.exe'
	cfg.output     = 'deploy/' + packaged_dll
end