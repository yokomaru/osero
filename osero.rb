class Osero
  WHITE = 0
  BLACK = 1

    def game_start
      goban = []
      goban_num = 4
      check_array = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 0], [0, 1], [1, -1], [1, 0], [1, 1]]

      make_field(goban_num, goban)
      # 碁盤のチェック用配列
      preview_goban(goban)

      # 碁盤に置ける場所がなくなるまでループ
      while goban.flatten.include?(nil) do
        puts "あなたは○です。置きたいところを入力してください"

        # ユーザーのキーワード入力を待機
        input_val = gets

        # 入力値を配列に変換
        input_num = input_val.chomp.split(",").map(&:to_i)

        # 入力値チェック
        # 　入力した値が範囲外の場合は再入力
        # 　入力値が1つの場合は再入力
        next if input_num.size == 1

        # 入力された箇所に白の碁を置く
        goban[input_num[0]][input_num[1]] = WHITE

        # 置いた碁の周囲をチェックし、黒の碁があれば白に変換する
        check_array.each do |c|
          if goban.dig(input_num[0] + c[0], input_num[1] + c[1]) == BLACK
            goban[input_num[0] + c[0]][input_num[1] + c[1]] = WHITE
          end
        end

        # 碁盤の再表示
        preview_goban(goban)

        # 相手のターンの処理
        # 裏返す碁の座標を格納する配列
        reverse_array = []
        # フラグ
        flg = false
        # 碁盤を一から走査
        goban.each.with_index do |g, i|
          g.each.with_index do |gg , ii|
            # 黒の碁を探す
            if gg == BLACK
              # 黒の碁の周囲をチェック
              check_array.each do |c|
                # 白の碁があるかをチェック
                p goban.dig(i + c[0], ii + c[1])
                if goban.dig(i + c[0], ii + c[1]) == WHITE
                  # 白の碁を配列に入れる
                  reverse_array << [i + c[0], ii + c[1]]
                  # 白の碁があった場合、その方向に黒の碁があるかをチェック
                  x = i + c[0]
                  y = ii + c[1]
                  # フラグがtrueになるまで、その方向に進める
                  while flg == false
                    x += c[0]
                    y += c[1]
                    p goban.dig(x, y)
                    case goban.dig(x, y)
                    # 白の碁を配列に入れる
                    when WHITE
                      reverse_array << [x, y]
                      next
                    # nilの場合はそこに黒い碁をおきフラグをtrueにしてループを抜ける
                    # todo: digを使わない方法があれば修正する
                    when nil
                      goban[x][y] = BLACK
                      flg = true
                    end
                  end
                  # フラグがtrueの場合、配列に入れた白の碁を黒に変換する
                  if flg
                    reverse_array.each do |r|
                      goban[r[0]][r[1]] = BLACK
                    end
                  end
                end
                break if flg
              end
              break if flg
            end
            break if flg
          end
          break if flg
        end

        # 碁盤の再表示
        preview_goban(goban)
      end
    end

  def make_field(goban_num, goban)
    # 碁盤の作成
      goban_num.times do
        goban << [nil, nil, nil, nil]
      end

      # 初期位置に碁を交互に置く
      goban[1][1] = WHITE
      goban[1][2] = BLACK
      goban[2][1] = BLACK
      goban[2][2] = WHITE
  end

  def preview_goban(goban)
    # 碁盤の表示
    goban.each do |g|
      s = g.map do |gg|
        if gg == WHITE
            "○"
        elsif gg == BLACK
            "●"
        else
            " "
        end
      end
      p s
    end
  end
end

osero = Osero.new
osero.game_start