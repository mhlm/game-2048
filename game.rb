#!/usr/bin/ruby

'''
ZetCode Ruby GTK tutorial

This is a simple Nibbles game
clone.

Author: Jan Bodnar
Website: www.zetcode.com
Last modified: May 2014
'''

require 'gtk3'
require './pole'


class RubyApp < Gtk::Window

  def initialize
    super
   
    set_title "Game 2048!!!"
    signal_connect "destroy" do 
      Gtk.main_quit 
    end
        
    @pole = Pole.new
    signal_connect "key-press-event" do |w, e|
      on_key_down w, e
    end
        
    add @pole

    set_default_size @pole.width, @pole.height
    set_window_position :center
    show_all
  end
    
  def on_key_down widget, event 
   
    key = event.keyval
    @pole.on_key_down event
  end
end

Gtk.init
  window = RubyApp.new
Gtk.main
