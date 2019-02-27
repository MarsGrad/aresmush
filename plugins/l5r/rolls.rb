module AresMUSH
  module L5R

    def self.roll_ability(char, roll_str, modifier)
      formatted = L5R.format_roll(roll_str)

      if (L5R.is_valid_rk?(formatted))
        roll = formatted.split("k")
        keep = roll[1]
        keep = keep.to_s
        dice = L5R.roll_rk(formatted, modifier)

      elsif (roll_str =~ /\+/)
        abilities = formatted.split("+")
        abil_1 = abilities[0]
        abil_2 = abilities[1]

        abil_1_rank = L5R.find_ability_rank(char, abil_1)
        if (!abil_1_rank)
          return nil
        end

        abil_2_rank = L5R.find_ability_rank(char, abil_2)
        if (!abil_2_rank)
          return nil
        end

        roll = abil_1_rank + abil_2_rank
        keep = abil_1_rank

        roll = roll.to_s
        keep = keep.to_s

        rk = roll + 'k' + keep
        dice = L5R.roll_rk(rk, modifier)

      else
        rank = L5R.find_ability_rank(char, roll_str)
        if (!rank)
          return nil
        end

        rank = rank.to_s
        keep = rank
        rk = rank + 'k' + rank
        dice = L5R.roll_rk(rk, modifier)
      end
      L5rRollResults.new(roll_str, dice)
    end

    def self.roll_rk(input, modifier)
      return nil if !input
      input = L5R.format_roll(input)

      roll = input.before("k")
      keep = input.after("k")
      roll = roll.to_i
      keep = keep.to_i


      if roll > 10
        until roll == 10 do
          if keep < 10 && roll != 11
            until keep == 10 || roll == 11 || roll == 10 do
              keep += 1
              roll -= 2
            end
          elsif keep < 10 && roll == 11
            roll = 10
          elsif keep >= 10
            roll -= 1
            modifier += 2
          end
        end
      end

      if keep > 10
        until keep == 10 do
          keep -= 1
          modifier += 2
        end
      end

      result_array = []
      until roll == 0 do
        result_array << rand(1..10)
        roll -= 1
      end


      final =    []
      result_array.each do |i|
        if i != 10
          final << i
          next
        end

        add = 0
        stop = 11
        until stop < 10
          explode = rand(1..10)
          add += explode
          stop = explode
        end
        final <<  (i + add)
      end

      final.sort!

      result = {}
      result[:result_array] = final
      result[:keep] = keep
      result[:modifier] = modifier
      return result
    end

    def self.roll_emp_ability(char, roll_str, modifier)
      formatted = L5R.format_roll(roll_str)

      if (L5R.is_valid_rk?(formatted))
        roll = formatted.split("k")
        keep = roll[1]
        keep = keep.to_s
        dice = L5R.roll_emp_rk(formatted, modifier)

      elsif (roll_str =~ /\+/)
        abilities = formatted.split("+")
        abil_1 = abilities[0]
        abil_2 = abilities[1]

        abil_1_rank = L5R.find_ability_rank(char, abil_1)
        if (!abil_1_rank)
          return nil
        end

        abil_2_rank = L5R.find_ability_rank(char, abil_2)
        if (!abil_2_rank)
          return nil
        end

        roll = abil_1_rank + abil_2_rank
        keep = abil_1_rank

        roll = roll.to_s
        keep = keep.to_s

        rk = roll + 'k' + keep
        dice = L5R.roll_emp_rk(rk, modifier)

      else
        rank = L5R.find_ability_rank(char, roll_str)
        if (!rank)
          return nil
        end

        rank = rank.to_s
        keep = rank
        rk = rank + 'k' + rank
        dice = L5R.roll_emp_rk(rk, modifier)
      end
      L5rRollResults.new(roll_str, dice)
    end

    def self.roll_emp_rk(input, modifier)
      return nil if !input
      input = L5R.format_roll(input)

      roll = input.before("k")
      keep = input.after("k")
      roll = roll.to_i
      keep = keep.to_i


      if roll > 10
        until roll == 10 do
          if keep < 10 && roll != 11
            until keep == 10 || roll == 11 || roll == 10 do
              keep += 1
              roll -= 2
            end
          elsif keep < 10 && roll == 11
            roll = 10
          elsif keep >= 10
            roll -= 1
            modifier += 2
          end
        end
      end

      if keep > 10
        until keep == 10 do
          keep -= 1
          modifier += 2
        end
      end

      result_array = []
      until roll == 0 do
        result_array << rand(1..10)
        roll -= 1
      end


      final =    []
      result_array.each do |i|
        if i != 10 && i != 1
          final << i
          next
        end

        if i == 1
          add = rand(1..10)
          final << (i + add)
          next
        end

        add = 0
        stop = 11
        until stop < 10
          explode = rand(1..10)
          add += explode
          stop = explode
        end
        final <<  (i + add)
      end

      final.sort!

      result = {}
      result[:result_array] = final
      result[:keep] = keep
      result[:modifier] = modifier
      return result
    end

    def self.roll_unsk_ability(char, roll_str, modifier)
      formatted = L5R.format_roll(roll_str)

      if (L5R.is_valid_rk?(formatted))
        roll = formatted.split("k")
        keep = roll[1]
        keep = keep.to_s
        dice = L5R.roll_unsk_rk(formatted, modifier)

      elsif (roll_str =~ /\+/)
        abilities = formatted.split("+")
        abil_1 = abilities[0]
        abil_2 = abilities[1]

        abil_1_rank = L5R.find_ability_rank(char, abil_1)
        if (!abil_1_rank)
          return nil
        end

        abil_2_rank = L5R.find_ability_rank(char, abil_2)
        if (!abil_2_rank)
          return nil
        end

        roll = abil_1_rank + abil_2_rank
        keep = abil_1_rank

        roll = roll.to_s
        keep = keep.to_s

        rk = roll + 'k' + keep
        dice = L5R.roll_unsk_rk(rk, modifier)

      else
        rank = L5R.find_ability_rank(char, roll_str)
        if (!rank)
          return nil
        end

        rank = rank.to_s
        keep = rank
        rk = rank + 'k' + rank
        dice = L5R.roll_unsk_rk(rk, modifier)
      end
      L5rRollResults.new(roll_str, dice)
    end

    def self.roll_unsk_rk(input, modifier)
      return nil if !input
      input = L5R.format_roll(input)

      roll = input.before("k")
      keep = input.after("k")
      roll = roll.to_i
      keep = keep.to_i


      if roll > 10
        until roll == 10 do
          if keep < 10 && roll != 11
            until keep == 10 || roll == 11 || roll == 10 do
              keep += 1
              roll -= 2
            end
          elsif keep < 10 && roll == 11
            roll = 10
          elsif keep >= 10
            roll -= 1
            modifier += 2
          end
        end
      end

      if keep > 10
        until keep == 10 do
          keep -= 1
          modifier += 2
        end
      end

      result_array = []
      until roll == 0 do
        result_array << rand(1..10)
        roll -= 1
      end

      result_array.sort!

      result = {}
      result[:result_array] = result_array
      result[:keep] = keep
      result[:modifier] = modifier
      return result
    end

    def self.get_success_message(enactor_name, results, difficulty)
      if (difficulty.blank?)
        return t('l5r.roll_open', :name => enactor_name, :roll_str => results.pretty_input, :keep => results.keep,
          :dice => results.print_dice, :total => results.total)
      end

      if (results.total < difficulty)
        return t('l5r.roll_vs_difficulty_fail', :name => enactor_name, :roll_str => results.pretty_input, :modifier => results.modifier
        :dice => results.print_dice, :keep => results.keep, :total => results.total, :difficulty => difficulty)

      elsif (results.total >= difficulty )
        return t('l5r.roll_vs_difficulty_success', :name => enactor_name, :roll_str => results.pretty_input, :modifier => results.modifier
        :dice => results.print_dice, :keep => results.keep, :total => results.total, :difficulty => difficulty)
      end
    end

    def self.get_emp_success_message(enactor_name, results, difficulty)
      if (difficulty.blank?)
        return t('l5r.roll_open', :name => enactor_name, :roll_str => results.pretty_input, :keep => results.keep,
          :dice => results.print_dice, :total => results.total)
      end

      if (results.total < difficulty)
        return t('l5r.emp_roll_vs_difficulty_fail', :name => enactor_name, :roll_str => results.pretty_input, :modifier => results.modifier
        :dice => results.print_dice, :keep => results.keep, :total => results.total, :difficulty => difficulty)

      elsif (results.total >= difficulty )
        return t('l5r.emp_roll_vs_difficulty_success', :name => enactor_name, :roll_str => results.pretty_input, :modifier => results.modifier
        :dice => results.print_dice, :keep => results.keep, :total => results.total, :difficulty => difficulty)
      end
    end

    def self.get_unsk_success_message(enactor_name, results, difficulty)
      if (difficulty.blank?)
        return t('l5r.roll_open', :name => enactor_name, :roll_str => results.pretty_input, :keep => results.keep,
          :dice => results.print_dice, :total => results.total)
      end

      if (results.total < difficulty)
        return t('l5r.unsk_roll_vs_difficulty_fail', :name => enactor_name, :roll_str => results.pretty_input, :modifier => results.modifier
        :dice => results.print_dice, :keep => results.keep, :total => results.total, :difficulty => difficulty)

      elsif (results.total >= difficulty )
        return t('l5r.unsk_roll_vs_difficulty_success', :name => enactor_name, :roll_str => results.pretty_input, :modifier => results.modifier
        :dice => results.print_dice, :keep => results.keep, :total => results.total, :difficulty => difficulty)
      end
    end

  end
end
