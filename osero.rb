class Osero
  WHITE = "○"
  BLACK = "●"
  BLANK = "."
  GOBAN_NUM = 8
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
      # 入力した値が範囲外の場合は再入力
      # 入力値が1つの場合は再入力
      next if input_num.size == 1

      if check_if_disk_can_put(goban, input_num, WHITE, BLACK)
        # 入力された箇所に白の碁を置く
        goban[input_num[0]][input_num[1]] = WHITE
        myturn_goban = reverse_all_disks(goban, input_num, WHITE, BLACK)
      else
        puts "そこには置けません"
        next
      end

      # 碁盤の再表示
      preview_goban(myturn_goban)

      # 敵が置ける場所を探す
      enemy_turn_goban = check_enemy_can_put(myturn_goban)

      # 碁盤の再表示
      preview_goban(enemy_turn_goban)
    end
    puts "ゲーム終了"
    puts "あなたの数 #{goban.flatten.count("○")}"
    puts "相手の数 #{goban.flatten.count("●")}"
    puts "#{goban.flatten.count("○") > goban.flatten.count("●") ? "あなたの勝ち" : "あなたの負け"}"
  end

  def make_field
    # 碁盤の作成
      goban = Array.new(GOBAN_NUM) { Array.new(GOBAN_NUM, BLANK) }
      # 初期位置に碁を交互に置く
      goban[3][3] = WHITE
      goban[3][4] = BLACK
      goban[4][3] = BLACK
      goban[4][4] = WHITE
      goban
  end

  def preview_goban(goban)
    # 碁盤の表示
    goban.each do |g|
      p g
    end
  end

  def check_if_disk_can_put(goban, input_num, my_color, enemy_color)
    ok_flg = false
    CHECKING_DIRECTIONS.each do |c|
      x = input_num[0]
      y = input_num[1]
     if goban.dig(x + c[0], y + c[1]) == enemy_color
        puts "チェックしてる場所 #{c}"
        puts "置けるばしょ [#{x + c[0]},#{y + c[1]}]"
        puts "置いたばしょ [#{x},#{y}]"
        while x >= 0 && x < GOBAN_NUM && y >= 0 && y < GOBAN_NUM
          x += c[0]
          y += c[1]
          if goban.dig(x, y) == my_color
            puts "[#{x},#{y}]は大丈夫"
            ok_flg = true
            break
          elsif goban.dig(x, y) == BLANK
            break
          end
        end
      end
      break if ok_flg
    end
    #p ok_flg
    return ok_flg
  end

  def reverse_all_disks(goban, input_num, my_color, enemy_color)
    CHECKING_DIRECTIONS.each do |c|
      my_reverse_array = []
      x = input_num[0]
      y = input_num[1]
      if goban.dig(x + c[0], y + c[1]) == enemy_color
        while x + c[0] >= 0 && x + c[0] < GOBAN_NUM && y + c[1] >= 0 && y + c[1] < GOBAN_NUM
          x += c[0]
          y += c[1]
          case goban.dig(x, y)
          when enemy_color
            #puts "敵の碁がある場所 [#{x},#{y}]"
            my_reverse_array << [x, y]
          when my_color
            #puts "自分の色の碁がある場所 [#{x},#{y}]"
            #puts "#{goban.dig(x, y)}"
            #p my_reverse_array
            my_reverse_array.each do |mr|
              goban[mr[0]][mr[1]] = my_color
            end
            next
          end
        end
      end
    end
    return goban
  end

  def check_enemy_can_put(goban)
    flg = false
    goban.each.with_index do |g, i|
      g.each.with_index do |gg, ii|
        # 黒の碁を探す
        if gg == BLANK
          p "空白の場所 [#{i},#{ii}]"
          if check_if_disk_can_put(goban, [i, ii], BLACK, WHITE)
            # 入力された箇所に黒の碁を置く
            goban[i][ii] = BLACK
            goban = reverse_all_disks(goban, [i, ii], BLACK, WHITE)
            flg = true
            break
          end
        end
        break if flg
      end
      break if flg
    end
    return goban
  end
end

osero = Osero.new
osero.game_start