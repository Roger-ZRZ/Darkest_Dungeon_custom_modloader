require 'json'
require 'shellwords'
require 'pathname' 

require_relative 'modloader-config'

# README: 
# Mods are loaded in alphabetical order, mod starting with least alphabetical rank will overwrite mods later in the rank. 

# To load mods: 
# 1. Put all mods in [game_modsrc_dir]; 
# 2. Run script;

# To undo mod loading:
# Requires: [game_backup_dir] was not touched, all folders are present from the start of time. 
# 1. remove all mods from [game_modsrc_dir], put all folders in [game_backup_dir] into the [game_modsrc_dir];
# 2. run script;
# 3. remove all folders and files in [game_backup_dir];


# CHECK

game_overwrite_dir = File.expand_path (GAME_OVERWRITE_DIR)
game_modsrc_dir = File.expand_path (GAME_MODSRC_DIR)
game_backup_dir = File.expand_path (GAME_BACKUP_DIR)

if ( ! Dir.exist? game_overwrite_dir )
	raise "game_overwrite_dir [#{game_overwrite_dir}] not present, abort"
	fail
end
if ( ! Dir.exist? game_modsrc_dir )
	raise "game_modsrc_dir [#{game_modsrc_dir}] not present, abort"
	fail
end

# LOAD

replaced_files_list = Array[]
nonexist_files_list = Array[]
conflict_file_list = Array[]
mod_dir_list = `ls -d #{game_modsrc_dir.shellescape}/*/`.split("\n")

(mod_dir_list).each do |this_mod_dir|
	this_mod_files = Dir.glob("#{this_mod_dir}#{GAME_MOD_IDENTIFIER}")

	(this_mod_files).each do |faddr|
		equiv_name_in_original = "#{game_overwrite_dir}/#{faddr.sub(this_mod_dir, "")}"
		# skip files that do not already exist in the original game files
		if (! File.exist? equiv_name_in_original)
			puts "[!] SKIPPED FILE [#{faddr}] :: NON EXIST IN ORIGINAL FILE SPACE"
			if (! nonexist_files_list.include? equiv_name_in_original) 
				nonexist_files_list.push(equiv_name_in_original) 
			end
			next
		end
		if (replaced_files_list.include? equiv_name_in_original)
			puts "[!] SKIPPED FILE [#{faddr}] :: FILE WAS REPLACED BY A HIGHER PRIORITY MOD"
			if (! conflict_file_list.include? equiv_name_in_original) 
				conflict_file_list.push(equiv_name_in_original) 
			end
			next
		end
		replaced_files_list.push(equiv_name_in_original)

		# backup the old file and rewrite the new file
		
		resp = `mkdir -p #{game_backup_dir.shellescape}/#{(Pathname.new(faddr).dirname).sub(this_mod_dir,"").to_path.shellescape}`
		unless resp.strip.empty?
			puts resp
		end
		resp = `cp #{equiv_name_in_original.shellescape} #{game_backup_dir.shellescape}/#{(Pathname.new(faddr).dirname).sub(this_mod_dir,"").to_path.shellescape}/`
		unless resp.strip.empty?
			puts resp
		end
		resp = `cp #{faddr.shellescape} #{equiv_name_in_original.shellescape}`
		unless resp.strip.empty?
			puts resp
		end
	end
end 

# WRAP UP

puts "\n\n=== DONE ===\n\n\n"

puts "MOD FILE REPLACED:"
puts replaced_files_list
puts "\n\n"
puts "MOD FILE CONFLICTS:"
puts conflict_file_list
puts "\n\n"
puts "MOD FILE NOT REPLACED:"
puts nonexist_files_list
puts "\n\n"

