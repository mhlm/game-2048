# класс игры 2048
class Game2048
  attr_reader :pole, :napravlenie
  def initialize
    @pole=[[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]] # игровое поле
    @m = 4 # ширина поля
    @n = 4 #  длина поля
    @null_yacheek = 0 # количество свободных ячеек
    @flag_sum = 0 # флаг проверки было-ли суммирование
    @flag_drive = 0 # флаг проверки было-ли движение
  end
  
  # выбор координат направления движения
  def koordinaty_dvigeniya ii, jj, nn, mm
    case @napravlenie
    when 3
      i = ii
      j = mm - jj
    when 1
      i = ii
      j = jj
    when 5
      i = jj
      j = ii
    when 2
      i = mm - jj
      j = ii
    end
    return [i, j]
  end

  # суммироваем значения
  def sum_yachejki
    @flag_sum = 0
    nn = @n - 1
    mm = @m - 1
    0.upto(nn){|ii|
      iz = -1
      jz = -1
      0.upto(mm){|jj|
        i, j = koordinaty_dvigeniya(ii, jj, nn, mm)
        if @pole[i][j] > 0
          if iz > -1 and jz > -1 and @pole[i][j] == @pole[iz][jz] 
            @pole[iz][jz] += @pole[i][j]
            @pole[i][j] = 0
            iz = -1
            jz = -1
            @flag_sum = 1 if @flag_sum == 0
          else
            iz = i
            jz = j
          end 
        end
      }
    }
  end
  
  # передвижение ячеек
  def drive_yachejki
    @flag_drive = 0
    nn = @n - 1
    mm = @m - 1
    0.upto(nn){|ii|
      iz = -1
      jz = -1
      0.upto(mm){|jj|
        i, j = koordinaty_dvigeniya(ii, jj, nn, mm)
        if @pole[i][j] == 0
          iz, jz = i, j
          jj.upto(mm){|kk|
            i, k = koordinaty_dvigeniya(ii, kk, nn, mm)
            if @pole[i][k] > 0
              @pole[iz][jz] = @pole[i][k]
              @pole[i][k] = 0
              iz, jz = -1, -1
              @flag_drive = 1 if @flag_drive == 0
              break
            end
          }
        end
      }
    }
  end
  
  # консольный выбор направления движения
  def vybor_napravleniya
    znachenie = ""
    loop do
      puts "3 - вправо, 1 - влево, 5 - вверх, 2 - вниз: "
      znachenie = gets.chomp
      break if znachenie.size == 1 and [3, 1, 5, 2].include?(znachenie.to_i)
    end
    @napravlenie = znachenie.to_i
  end
  
  # передвижение значений на поле  взаданном направлении
  def peredvigenie
    sum_yachejki
    drive_yachejki
  end
  
  # добавление нового значения в свободную ячейку
  def new_znachenie
  
    # определяем количество свободных ячеек
    kolichestvo_null 
    
    # выбираем случайным образом ячейку для заполнения
    svobodnaya_yachejka = rand(@null_yacheek) + 1
    yachejka = 0
    0.upto(@m-1){|i|
      0.upto(@n-1){|j|
        if @pole[i][j] == 0
          yachejka += 1
          if svobodnaya_yachejka == yachejka
          
            # заполняем ячейку
            @pole[i][j] = 2
            return 0
          end
        end
      }
    }        
  end
  
  # определение количества свободных ячеек
  def kolichestvo_null
    @null_yacheek = 0
    0.upto(@m-1){|i|
      0.upto(@n-1){|j|
        @null_yacheek += 1 if @pole[i][j] == 0
      }
    }    
  end
  
  # проверка на заполненное поле и окончание игры
  def end_game
    kolichestvo_null
    @null_yacheek == 0 and @flag_drive == 0 and @flag_sum == 0
  end
  
  # старт игры
  def start_game_console
  
    puts "Старт игры 2048!!!"

    # заполняем случайным образом две ячейки
    new_znachenie
    new_znachenie
   
    # запускаем цикл игры 
    loop do
   
      # проверяем игровое поле на окончание игры
      if end_game
        puts "Конец игры 2048!!!"
        break
      end
      # выводим знаячения поля на экран
      put_pole_console
      
      # куда ходить будем
      vybor_napravleniya
      peredvigenie
      
      # добавляем новое значение
      new_znachenie if @flag_drive > 0 or @flag_sum>0
    end
  end 
  
  # распечатка значений поля
  def put_pole_console
    0.upto(@m-1){|i|
      str = ''
      0.upto(@n-1){|j|
        str += "%-5s" % @pole[i][j]
      }
      puts str
    }
    puts "="*5*4
  end
end

x = Game2048.new
x.start_game_console
