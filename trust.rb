#!/usr/bin/ruby

class TrustCalculator
  attr_reader :trust, :dungeon

  def initialize(trust, dungeon)
    @trust = trust
    @dungeon = dungeon
  end

  def dungeons_to_next_bracket
    trust.dungeons_to_next_bracket
  end

  def level_after_dungeon_runs
    exp = exp_after_dungeon_runs
    cap = ExpBracket.new(trust.level).cap
    leveled = 0

    while(exp > cap)
      exp = exp - cap
      cap = ExpBracket.new(trust.level + 1).cap
      leveled = leveled + 1
    end

    trust.level + leveled
  end

  private

  def exp_after_dungeon_runs
    trust.exp + dungeon.exp * dungeon.runs
  end
end

class Trust
  attr_reader :level, :exp

  def initialize(level, exp)
    @level = level
    @exp = exp
  end

  def dungeons_to_next_bracket
    exp_remaining.fdiv(dungeon_exp).ceil
  end

  private

  def dungeon_exp
    Dungeon.new(dungeon_level).exp
  end

  def exp_remaining
    if level.even?
      ExpBracket.new(level).cap - exp
    else
      ExpBracket.new(level).cap + ExpBracket.new(level + 1).cap - exp
    end
  end

  def dungeon_level
    if level.even?
      level - 1
    else
      level
    end
  end
end

class Dungeon
  attr_reader :level, :runs

  def initialize(level, runs = 0)
    @level = level
    @runs = runs
  end

  def exp
    case level
    when 91
      5801800
    when 93
      6689500
    when 95
      7718100
    when 97
      8787000
    when 99
      9012200
    end
  end
end

class ExpBracket
  attr_reader :level

  def initialize(level)
    @level = level
  end

  def cap
    case(level)
    when 91
      13659000
    when 92
      15348000
    when 93
      15912000
    when 94
      17354000
    when 95
      18263000
    when 96
      20322000
    when 97
      20957000
    when 98
      22979000
    when 99
      23789000
    end
  end
end

t = Trust.new(97, 3753600)
d = Dungeon.new(95, 2)
c = TrustCalculator.new(t, d)

puts c.dungeons_to_next_bracket
puts c.level_after_dungeon_runs
