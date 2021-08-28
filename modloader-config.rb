# CONFIG

GAME_NAME = "DarkestDungeon" # game name for identification
CALL_TIME = `date +%Y-%m-%d-%H-%M-%S`.gsub("\n","")
GAME_OVERWRITE_DIR = "~/Games/Darkest Dungeon.app/Contents/Resources/Data" # dir to overwrite files to
GAME_MODSRC_DIR = "~/Games/Darkest Dungeon Mods/mods"
GAME_BACKUP_DIR = "~/Games/Darkest Dungeon Mods/modding-backup-trace/#{GAME_NAME}/#{CALL_TIME}"
GAME_REPLICA_DIR = "~/Games/Darkest Dungeon Mods/full-backup"
GAME_MOD_IDENTIFIER = "**/*.*" # currently identifies all files with extensions to be replaced

GAME_BACKUP_FILE_EXT = [".json", ".xml", ".darkest"]

