DELAY = 100

require './2048'

class Pole < Gtk::DrawingArea

  def width
    @x*2+(@width+@interval)*4
  end
    
  def height
    (@y*2+(@height+@interval)*4 + @pole_rezultat)
  end
    
  def initialize
    super
            
      @game2048 = Game2048.new
      @width = 55
      @height = 55
      @interval = 2
      @pole_rezultat = 15
      @x = 10
      @y = 10
      @colors_rgb = {
        0 => {"r" => (161/256.0), "g" => (167/256.0), "b" => (161/256.0)},
        2 => {"r" => (142/256.0), "g" => (232/256.0), "b" => (121/256.0)},
        4 => {"r" => (90/256.0), "g" => (198/256.0), "b" => (217/256.0)},
        8 => {"r" => (210/256.0), "g" => (90/256.0), "b" => (217/256.0)},
        16 => {"r" => (231/256.0), "g" => (241/256.0), "b" => (65/256.0)},
        32 => {"r" => (234/256.0), "g" => (140/256.0), "b" => (133/256.0)},
        64 => {"r" => (26/256.0), "g" => (169/256.0), "b" => (11/256.0)},
        128 => {"r" => (140/256.0), "g" => (12/256.0), "b" => (177/256.0)},
        256 => {"r" => (38/256.0), "g" => (86/256.0), "b" => (241/256.0)},
        512 => {"r" => (237/256.0), "g" => (18/256.0), "b" => (193/256.0)},
        1024 => {"r" => (236/256.0), "g" => (119/256.0), "b" => (15/256.0)},
        2048 => {"r" => (239/256.0), "g" => (17/256.0), "b" => (22/256.0)}
      }

      signal_connect "draw" do  
        on_draw
      end
 
      init_game
  end
    
  def on_timer
#    if @inGame
      queue_draw
      @inGame = !@game2048.end_game
       true
#    else
#      false
#    end
  end
    
  def init_game

    @inGame = true

    GLib::Timeout.add(DELAY) { on_timer }
  end   
        

  def on_draw 
    
    cr = window.create_cairo_context

    if @inGame
      draw_objects cr
    else
      game_over cr
    end      
  end
    
  def draw_objects cr
    
    pole = @game2048.pole

    xx = [0, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048]
    0.upto(3){|i|
      0.upto(3){|j|
        kx = @x + (@width + @interval) * j
        ky = @y + @pole_rezultat + (@height + @interval) * i

        cr.set_source_rgb @colors_rgb[pole[i][j]]["r"], @colors_rgb[pole[i][j]]["g"], @colors_rgb[pole[i][j]]["b"]
        cr.rectangle kx, ky, @width, @height
        cr.fill          
        if pole[i][j] != 0
          cr.set_source_rgb 0.1, 0.1, 0.1
       
          cr.select_font_face "Purisa", Cairo::FONT_SLANT_NORMAL, Cairo::FONT_WEIGHT_NORMAL
          cr.set_font_size 25 
     
          str = pole[i][j].to_s
       
          extents = cr.text_extents str
         
          cr.move_to (kx + @width/2 - extents.width/2), (ky + @height/2 + extents.height/2)
                
          cr.show_text str  
        end        
      }
    }

    cr.select_font_face "Arial", Cairo::FONT_SLANT_NORMAL, Cairo::FONT_WEIGHT_NORMAL
    cr.set_font_size 17 
    cr.set_source_rgb 0.1, 0.1, 0.1
    cr.move_to @x, (@y + @pole_rezultat - 5)
    cr.show_text "Счет: #{@game2048.schet}"
      
  end

  def game_over cr
    
    draw_objects cr

    w = allocation.width / 2
    h = allocation.height / 2

    cr.set_font_size 15
    te = cr.text_extents "Game Over"

    cr.set_source_rgb 114/256.0, 121/256.0, 115/256.0
    cr.rectangle te.width, h-20, te.width+10, 25
    cr.fill          

    cr.set_source_rgb 0, 0, 0

    cr.move_to w - te.width/2, h
    cr.show_text "Game Over"
  end

  def on_key_down event
    
    key = event.keyval
    
    napravlenie = case key
      when Gdk::Keyval::GDK_KEY_Left
        1
      when Gdk::Keyval::GDK_KEY_Right
        3
      when Gdk::Keyval::GDK_KEY_Up
        5
      when Gdk::Keyval::GDK_KEY_Down
        2
      when Gdk::Keyval::GDK_KEY_N, Gdk::Keyval::GDK_KEY_n
        @game2048.new_game
        0
      else
        0
    end
        
    if napravlenie != 0
      @game2048.gtk_dvigenie_add_znachenie napravlenie
    end
  end   
end
