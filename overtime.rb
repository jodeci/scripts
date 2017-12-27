#!/usr/bin/ruby
abort "usage: [月薪] [加班時數]" if ARGV.empty?
salary = ARGV[0].to_i
hours = ARGV[1].to_f

# 一例一休 平日加班費計算
class OvertimeCalculator
  def initialize(salary, hours)
    @hourly_rate = hourly_rate(salary)
    @hours = hours
  end

  def amount
    if @hours <= 2
      initial_rate * @hours
    else
      initial_rate * 2 + additional_rate * (@hours - 2)
    end
  end

  private

  def hourly_rate(salary)
    salary / 30 / 8
  end

  def initial_rate
    @hourly_rate * 4 / 3
  end

  def additional_rate
    @hourly_rate * 5 / 3
  end
end

otc = OvertimeCalculator.new(salary, hours)
puts otc.amount
