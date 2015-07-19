require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'terminal-table'
require 'paint'

class Bowling
  attr_reader :frames

  def initialize(hits = [])
    @hits = (hits.is_a?(Array) ? hits : [])
    @frames ||= []
  end

  def hits=(input)
    raise ArgumentError, '[Error] No input found.'      if input.blank?
    raise ArgumentError, '[Error] Incorrect format.'    unless input =~ /^\s*(10|[0-9])(\s*,\s*(10|[0-9]))*\s*$/
    raise ArgumentError, '[Error] More than 21 throws.' if input.scan(/,/).count > 20

    @frames.clear
    @hits.clear
    @hits = input.gsub(/\s+/, '').split(',').map(&:to_i) || []
    analyze
  end

  def hits
    @hits
  end

  def score
    @frames.first(10).map(&:score).sum
  end

  def breakdown
    table = Terminal::Table.new title: 'Bowling', headings: ['Frame', 'First Throw', 'Second Throw', 'Score', 'Running Total'] do |t|
      running_total = 0
      @frames.each_with_index do |frame, index|
        first_throw = (frame.strike? ? 'X' : frame.first_throw)
        second_throw = (frame.spare? ? '/' : frame.second_throw)
        running_total += frame.score

        t.add_row [index + 1, first_throw, second_throw, frame.score, running_total].map{ |entity| Paint[entity, :yellow] }
        t.add_separator
      end
      if @frames.size <= 10 # print un-finish frames
        frames_to_finish = if @frames.size == 10
                             case
                             when @frames[9].strike? then 12
                             when @frames[9].spare?  then 11
                             end
                           else 10
                           end
        (frames_to_finish - @frames.size).times do |index|
          t.add_row [@frames.size + 1 + index, nil, nil, nil, nil].map{ |entity| Paint[entity, :yellow] }
          t.add_separator
        end
      end
      t.add_row [nil, nil, nil, 'Total', score].map{ |entity| Paint[entity, :green] }
    end
    puts table
  end

  private

  def analyze
    pair = []
    @hits.each_with_index do |h, index|
      next_throw = @hits[index + 1] || 0
      next_next_throw = @hits[index + 2] || 0

      if pair.empty? && h == 10
        @frames.push Frame.new(
                       first_throw: h,
                       score:       (h + next_throw + next_next_throw)
                     )
      else
        pair.push h
        if pair.size == 2 || (index == @hits.size - 1)
          @frames.push Frame.new(
                         first_throw:  pair[0],
                         second_throw: pair[1],
                         score:        (pair.sum + (pair.sum == 10 ? next_throw : 0))
                       )
          pair.clear
        end
      end
    end
    (@frames - @frames.first(10)).each{ |frame| frame.score = 0 } # clear score if it is not the first 10 frames
  end
end

class Frame
  attr_accessor :first_throw, :second_throw, :score

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
