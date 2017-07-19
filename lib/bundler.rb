# Bundler
require 'rubygems'
require 'bundler/setup'
Bundler.require

# dootenv
require 'dotenv'
Dotenv.load('config.env')

# Requires
require 'date'
require 'net/http'
require 'open-uri'
require 'fileutils'

# Files
require_relative 'slack'
require_relative 'mapas'
require_relative 'ipdo'
require_relative 'update_www'
