class RISBN
  attr_accessor :isbn

  # Gross, but good to catch anything even remotely similar to a ISBN.
  # Later, we can validate to see if it really is a ISBN.
  ISBN_REGEXP = /([0-9\-_X]+)/i

  # returns all the isbn numbers found on the line.
  def self.parse(line)
    line.split(ISBN_REGEXP).map { |n| new(n) }.select(&:valid?)
  end

  # Parses the string returning the first valid isbn number found or an empty isbn.
  def self.parse_first(line)
    line.split(ISBN_REGEXP).map { |c| n = new(c); return n if n.valid? }; new
  end

  # Provide a string with the isbn. Any non digit or X character will be removed.
  def initialize(code = "")
    @isbn = (code || "").to_s.upcase.gsub(/[^0-9X]/, "")
  end

  def valid?
    case isbn.length
    when 10 then valid_isbn10?
    when 13 then valid_isbn13?
    else
      false
    end
  end

  def to_s
    isbn
  end

  def checksum
    last = isbn[-1..-1]
    (last == 'X') ? 10 : last.to_i
  end

  def digits
    isbn[0..-2].split("")
  end

  # adapted from http://github.com/zapnap/isbn_validation/blob/master/lib/isbn_validation.rb#L48
  def valid_isbn10?
    sum = 0
    digits.each_with_index do |value, index|
      sum += (index + 1) * value.to_i
    end
    (sum % 11) == checksum
  end

  def valid_isbn13?
    sum = 0
    digits.each_with_index do |value, index|
      multiplier = (index % 2 == 0) ? 1 : 3
      sum += multiplier * value.to_i
    end
    result = 10 - (sum % 10)
    result = 0 if result == 10
    result == checksum
  end
end
