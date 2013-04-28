module AresMUSH
  def self.game_path
    game_path = File.expand_path(File.join(File.dirname(__FILE__), "..", "game"))
    puts game_path
    game_path
  end
end

# Require this before all other items
require 'bundler/setup'

require 'ansi'
require 'yaml'
require 'eventmachine'
require 'mongo'
require 'i18n'
require "i18n/backend/fallbacks" 
require 'log4r'
require 'log4r/yamlconfigurator'
include Log4r
require 'date'
require 'bcrypt'
require 'rake'
require 'rspec/core/rake_task'

require 'aresmush/bootstrapper'
require 'aresmush/client/client_monitor'
require 'aresmush/client/client.rb'
require 'aresmush/client/client_factory.rb'
require 'aresmush/client/client_greeter.rb'
require 'aresmush/command'
require 'aresmush/command_line'
require 'aresmush/config_reader'
require 'aresmush/connection.rb'
require 'aresmush/container.rb'
require 'aresmush/core_ext/string_ext.rb'
require 'aresmush/core_ext/yaml_ext.rb'
require 'aresmush/core_ext/hash_ext.rb'
require 'aresmush/core_ext/match_data_ext.rb'
require 'aresmush/database.rb'
require 'aresmush/dispatcher.rb'
require 'aresmush/formatters/ansi_formatter.rb'
require 'aresmush/formatters/client_formatter.rb'
require 'aresmush/formatters/pose_formatter.rb'
require 'aresmush/formatters/random_colorizer.rb'
require 'aresmush/formatters/substitution_formatter.rb'
require 'aresmush/hash_reader.rb'
require 'aresmush/locale/locale.rb'
require 'aresmush/locale/locale_loader.rb'
require 'aresmush/logger.rb'
require 'aresmush/models/ares_model.rb'
require 'aresmush/models/character.rb'
require 'aresmush/models/room.rb'
require 'aresmush/models/exit.rb'
require 'aresmush/models/game.rb'
require 'aresmush/plugin/plugin_manager.rb'
require 'aresmush/plugin/plugin_factory.rb'
require 'aresmush/plugin/plugin.rb'
require 'aresmush/plugin_helpers/contents_finder.rb'
require 'aresmush/plugin_helpers/single_result_selector.rb'
require 'aresmush/plugin_helpers/single_target_finder.rb'
require 'aresmush/plugin_helpers/visible_target_finder.rb'
require 'aresmush/plugin_helpers/template_renderer.rb'
require 'aresmush/server.rb'
