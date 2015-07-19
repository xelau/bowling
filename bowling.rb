require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'terminal-table'
require 'paint'

class Bowling
  attr_reader :frames

  def initialize(hits = [])
    @hits = (hits.is_a?(Array) ? hits : [])
    @frames ||= (1..10).map{ |i| Frame.new number: i }
  end

  def hits=(input)
    raise ArgumentError, '[Error] No input found.'      if input.blank?
    raise ArgumentError, '[Error] Incorrect format.'    unless input =~ /^\s*(10|[0-9])(\s*,\s*(10|[0-9]))*\s*$/
    raise ArgumentError, '[Error] More than 21 throws.' if input.scan(/,/).count > 20

    reset
    @hits = input.gsub(/\s+/, '').split(',').map(&:to_i) || []
    calculate
  end

  def hits
    @hits
  end

  def score
    @frames.map{ |f| f.score.to_i }.sum
  end

  def breakdown
    table = Terminal::Table.new title: 'Bowling', headings: ['Frame', 'First Throw', 'Second Throw', 'Extra Throw', 'Score', 'Running Total'] do |t|
      running_total = 0
      @frames.each_with_index do |frame, index|
        first_throw = (frame.strike? ? 'X' : frame.first_throw)
        second_throw = (frame.spare? ? '/' : frame.second_throw)
        extra_throw = (frame.number == 10 ? frame.extra_throw : '-')
        running_total += frame.score.to_i

        t.add_row [index + 1, first_throw, second_throw, extra_throw, frame.score, (frame.score.blank? ? nil : running_total)].map{ |entity| Paint[entity, :yellow] }
        t.add_separator
      end
      t.add_row [nil, nil, nil, nil, 'Total', score].map{ |entity| Paint[entity, :green] }
    end
    puts table
  end

  private

  def reset
    @frames.clear
    @frames = (1..10).map{ |i| Frame.new number: i }
    @hits.clear
  end

  def calculate
    hit_index = 0
    @frames.sort{ |x, y| x.number <=> y.number }.each do |frame|
      break if hit_index > @hits.size

      frame.first_throw = @hits[hit_index]
      hit_index += 1
      if !frame.strike? || frame.number == 10
        frame.second_throw = @hits[hit_index]
        hit_index += 1
      end
      frame.extra_throw = @hits[hit_index] if frame.number == 10 && !@hits[hit_index].nil?

      frame.score = frame.first_throw.to_i + frame.second_throw.to_i + frame.extra_throw.to_i
      unless frame.number == 10
        next_throw = @hits[hit_index] || 0
        next_next_throw = @hits[hit_index + 1] || 0
        frame.score += next_throw + next_next_throw if frame.strike? # strike bonus
        frame.score += next_throw if frame.spare? # spare bonus
      end
    end
  end
end

class Frame
  attr_accessor :number, :first_throw, :second_throw, :extra_throw, :score

  def initialize(attrs = {})
    attrs.each{ |k, v| instance_variable_set("@#{k}", v) }
  end

  def strike?
    first_throw == 10
  end

  def spare?
    first_throw != 10 && (first_throw.to_i + second_throw.to_i) == 10
  end
end
