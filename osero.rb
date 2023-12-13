class Osero
  WHITE = "○"
  BLACK = "●"
  BLANK = "."
  GOBAN_NUM = 6
  CHECKING_DIRECTIONS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]

  def game_start
    goban = make_field
    # 碁盤のチェック用配列
    preview_goban(goban)

    # 碁盤に置ける場所がなくなるまでループ
    while goban.flatten.include?(".") do
      puts "あなたは○です。置きたいところを入力してください"
      # ユーザーのキーワード入力を待機
      input_val = gets

      # 入力値を配列に変換
      input_num = input_val.chomp.split(",").map(&:to_i)

      # 入力値チェック
      next if input_num.size == 1

      if check_if_disk_can_put(goban, input_num, WHITE, BLACK)
        goban[input_num[0]][input_num[1]] = WHITE
        myturn_goban = reverse_all_disks(goban, input_num, WHITE, BLACK)
      else
        puts "そこには置けません"
        next
      end

      # 碁盤の再表示
      preview_goban(myturn_goban)

      puts "相手(●)のターンです。"
      # 敵が置ける場所を探す
      enemy_turn_goban = check_enemy_can_put(myturn_goban)
      # 碁盤の再表示
      preview_goban(enemy_turn_goban)
    end

    puts "ゲーム終了"
    puts "あなたの数 #{goban.flatten.count(WHITE)}"
    puts "相手の数 #{goban.flatten.count(BLACK)}"
    puts "#{goban.flatten.count(WHITE) > goban.flatten.count(BLACK) ? "あなたの勝ち" : "あなたの負け"}"
  end

  def make_field
    goban = Array.new(GOBAN_NUM) { Array.new(GOBAN_NUM, BLANK) }
    # 初期位置に碁を交互に置く
    goban[2][2] = WHITE
    goban[2][3] = BLACK
    goban[3][2] = BLACK
    goban[3][3] = WHITE
    goban
  end

  def preview_goban(goban)
    goban.each do |g|
      p g
    end
  end

  def reverse_all_disks(goban, input_num, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      my_reverse_array = []
      x, y = input_num

      if goban.dig(x + c[0], y + c[1]) == enemy_color
        while x + c[0].between?(0, GOBAN_NUM - 1) && y + c[1].between?(0, GOBAN_NUM - 1)
          x += c[0]
          y += c[1]
          case goban.dig(x, y)
          when enemy_color
            my_reverse_array << [x, y]
          when my_color
            my_reverse_array.each { |mr| goban[mr[0]][mr[1]] = my_color }
            break
          when BLANK
            break
          end
        end
      end
    end
    goban
  end

  def check_enemy_can_put(goban)
    goban.each.with_index do |g, i|
      g.each.with_index do |gg, ii|
        if gg == BLANK && check_if_disk_can_put(goban, [i, ii], BLACK, WHITE)
          goban[i][ii] = BLACK
          goban = reverse_all_disks(goban, [i, ii], BLACK, WHITE)
        end
      end
    end
    goban
  end

  def check_if_disk_can_put(goban, input_num, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      x, y = input_num

      if goban.dig(x + c[0], y + c[1]) == enemy_color
        while x + c[0].between?(0, GOBAN_NUM - 1) && y + c[1].between?(0, GOBAN_NUM - 1)
          x += c[0]
          y += c[1]
          if goban.dig(x, y) == my_color
            return true
          elsif goban.dig(x, y) == BLANK
            break
          end
        end
      end
    end
    false
  end

  def check_if_disk_can_put(goban, input_num, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      x = input_num[0]
      y = input_num[1]
      if goban.dig(x + c[0], y + c[1]) == enemy_color
        x += c[0]
        y += c[1]
        # 碁盤の範囲内で自分のコマが見つかるまでループ
        while x.between?(0, GOBAN_NUM - 1) && y.between?(0, GOBAN_NUM - 1)
          if goban.dig(x, y) == my_color
            return true
          elsif goban.dig(x, y) == BLANK
            break
          end
          x += c[0]
          y += c[1]
        end
      end
    end
    false
  end

  def reverse_all_disks(goban, input_num, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      my_reverse_array = []
      x, y = input_num

      if goban.dig(x + c[0], y + c[1]) == enemy_color
        while (x + c[0]).between?(0, GOBAN_NUM - 1) && (y + c[1]).between?(0, GOBAN_NUM - 1)
          x += c[0]
          y += c[1]
          case goban.dig(x, y)
          when enemy_color
            my_reverse_array << [x, y]
          when my_color
            my_reverse_array.each { |mr| goban[mr[0]][mr[1]] = my_color }
            break
          end
        end
      end
    end
    goban
  end

  def check_enemy_can_put(goban)
    goban.each.with_index do |g, i|
      g.each.with_index do |gg, ii|
        if gg == BLANK && check_if_disk_can_put(goban, [i, ii], BLACK, WHITE)
          goban[i][ii] = BLACK
          goban = reverse_all_disks(goban, [i, ii], BLACK, WHITE)
          return goban
        end
      end
    end
    return goban
  end
end

osero = Osero.new
osero.game_start