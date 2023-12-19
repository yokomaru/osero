class Osero
  WHITE = "○"
  BLACK = "●"
  BLANK = "."
  GRID_BOARD_NUM = 6
  CHECKING_DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]

  def game_start
    grid_board = make_field
    # 碁盤のチェック用配列
    preview_grid_board(grid_board)

    # 碁盤に置ける場所がなくなるまでループ
    while grid_board.flatten.include?(".") do
      puts "あなたは○です。置きたいところを入力してください"

      # 入力値を配列に変換
      input_num_array = convert_input_val_to_input_num_array(gets)

      # 入力値チェック
      next puts "数字をカンマ区切りで2つ入力してね" if check_input_num_array_size(input_num_array)
      next puts "碁盤の範囲も数字を入力してね" if check_input_num_array_range(input_num_array)
      next puts "数字を入力してね" if check_input_num_array_content(input_num_array)

      if check_if_disk_can_put(grid_board, input_num_array, WHITE, BLACK)
        grid_board[input_num_array[0]][input_num_array[1]] = WHITE
        myturn_grid_board = reverse_all_disks(grid_board, input_num_array, WHITE, BLACK)
      else
        puts "そこには置けません"
        next
      end

      # 碁盤の再表示
      preview_grid_board(myturn_grid_board)

      puts "相手(●)のターンです。"

      # 敵が置ける場所を探す
      enemy_turn_grid_board = check_enemy_can_put(myturn_grid_board)

      # 碁盤の再表示
      preview_grid_board(enemy_turn_grid_board)
    end

    puts game_result(grid_board)
  end

  def make_field
    grid_board = Array.new(GRID_BOARD_NUM) { Array.new(GRID_BOARD_NUM, BLANK) }
    # 初期位置に碁を交互に置く
    grid_board[2][2] = WHITE
    grid_board[3][2] = BLACK
    grid_board[2][3] = BLACK
    grid_board[3][3] = WHITE
    grid_board
  end

  def preview_grid_board(grid_board)
    grid_board.each do |g|
      p g
    end
  end

  def reverse_all_disks(grid_board, input_num_array, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      my_reverse_array = []
      x, y = input_num_array

      if grid_board.dig(x + c[0], y + c[1]) == enemy_color
        while x + c[0].between?(0, GRID_BOARD_NUM - 1) && y + c[1].between?(0, GRID_BOARD_NUM - 1)
          x += c[0]
          y += c[1]
          case grid_board.dig(x, y)
          when enemy_color
            my_reverse_array << [x, y]
          when my_color
            my_reverse_array.each { |mr| grid_board[mr[0]][mr[1]] = my_color }
            break
          when BLANK
            break
          end
        end
      end
    end
    grid_board
  end

  def check_enemy_can_put(grid_board)
    grid_board.each.with_index do |g, i|
      g.each.with_index do |gg, ii|
        if gg == BLANK && check_if_disk_can_put(grid_board, [i, ii], BLACK, WHITE)
          grid_board[i][ii] = BLACK
          grid_board = reverse_all_disks(grid_board, [i, ii], BLACK, WHITE)
        end
      end
    end
    grid_board
  end

  def check_if_disk_can_put(grid_board, input_num_array, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      x, y = input_num_array

      if grid_board.dig(x + c[0], y + c[1]) == enemy_color
        while x + c[0].between?(0, GRID_BOARD_NUM - 1) && y + c[1].between?(0, GRID_BOARD_NUM - 1)
          x += c[0]
          y += c[1]
          if grid_board.dig(x, y) == my_color
            return true
          elsif grid_board.dig(x, y) == BLANK
            break
          end
        end
      end
    end
    false
  end

  def check_if_disk_can_put(grid_board, input_num_array, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      x, y = input_num_array
      if grid_board.dig(x + c[0], y + c[1]) == enemy_color
        x += c[0]
        y += c[1]
        # 碁盤の範囲内で自分のコマが見つかるまでループ
        while x.between?(0, GRID_BOARD_NUM - 1) && y.between?(0, GRID_BOARD_NUM - 1)
          if grid_board.dig(x, y) == my_color
            return true
          elsif grid_board.dig(x, y) == BLANK
            break
          end
          x += c[0]
          y += c[1]
        end
      end
    end
    false
  end

  def reverse_all_disks(grid_board, input_num_array, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      my_reverse_array = []
      x, y = input_num_array

      if grid_board.dig(x + c[0], y + c[1]) == enemy_color
        while (x + c[0]).between?(0, GRID_BOARD_NUM - 1) && (y + c[1]).between?(0, GRID_BOARD_NUM - 1)
          x += c[0]
          y += c[1]
          case grid_board.dig(x, y)
          when enemy_color
            my_reverse_array << [x, y]
          when my_color
            my_reverse_array.each { |mr| grid_board[mr[0]][mr[1]] = my_color }
            break
          end
        end
      end
    end
    grid_board
  end

  def check_enemy_can_put(grid_board)
    grid_board.each.with_index do |g, i|
      g.each.with_index do |gg, ii|
        if gg == BLANK && check_if_disk_can_put(grid_board, [i, ii], BLACK, WHITE)
          grid_board[i][ii] = BLACK
          grid_board = reverse_all_disks(grid_board, [i, ii], BLACK, WHITE)
          return grid_board
        end
      end
    end
    return grid_board
  end

  def game_result(grid_board)
    result << "ゲーム終了"
    result << "あなたの数 #{g.flatten.count(WHITE)}"
    result << "相手の数 #{g.flatten.count(BLACK)}"
    # 引き分けだった場合
    result << "#{g.flatten.count(WHITE) > g.flatten.count(BLACK) ? "あなたの勝ち" : "あなたの負け"}"
    result.join("\n")
  end

  def check_input_num_array_size(input_num_array)
    input_num_array.size < 2 || input_num_array.size > 2
  end

  def check_input_num_array_range(input_num_array)
    input_num_array[0] > GRID_BOARD_NUM - 1 || input_num_array[1] > GRID_BOARD_NUM - 1 || input_num_array[0] < 0 || input_num_array[1] < 0
  end

  def check_input_num_array_content(input_num_array)
    input_num_array[0].nil? || input_num_array[1].nil?
  end

  def convert_input_val_to_input_num_array(input_val)
    input_val.chomp.split(",").map(&:to_i)
  end
end

osero = Osero.new
osero.game_start