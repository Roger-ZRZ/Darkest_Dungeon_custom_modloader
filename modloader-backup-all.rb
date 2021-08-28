require 'json'
require 'shellwords'
require 'pathname' 

require_relative 'modloader-config'

# CHECK

game_overwrite_dir = File.expand_path (GAME_OVERWRITE_DIR)
game_backup_file_ext = (GAME_BACKUP_FILE_EXT)
game_replica_dir = File.expand_path (GAME_REPLICA_DIR)

if ( ! Dir.exist? game_overwrite_dir )
	raise "game_overwrite_dir [#{game_overwrite_dir}] not present, abort"
	fail
end

# BACKUP

all_file_list = Dir.glob("#{game_overwrite_dir}/**/*.*")
select_file_list = Array[]
other_ext_list = Array[]

all_file_list.each do |elem| 
	this_ext = File.extname(elem)
	if ( game_backup_file_ext.include?( this_ext ) )
		select_file_list.push (elem)
	else 
		if (! other_ext_list.include? this_ext) 
			other_ext_list.push(this_ext) 
		end
	end
end

select_file_list.each do |elem| 
	resp = `mkdir -p #{game_replica_dir.shellescape}#{(Pathname.new(elem).dirname).sub(game_overwrite_dir,"").to_path.shellescape}`
	unless resp.strip.empty?
		puts resp
	end
	resp = `cp #{elem.shellescape} #{game_replica_dir.shellescape}#{(Pathname.new(elem).dirname).sub(game_overwrite_dir,"").to_path.shellescape}/`
	unless resp.strip.empty?
		puts resp
	end
end


puts "\n\n=== DONE ===\n\n\n"

puts "Extensions not backed up:"
puts other_ext_list
puts "\n\n"