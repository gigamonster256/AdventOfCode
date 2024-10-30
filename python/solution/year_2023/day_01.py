def part1(input):
    lines = input.split("\n")
    return part1_from_lines(lines)   

def part1_from_lines(lines):
    first_digits = [first_digit(line) for line in lines]
    last_digits = [last_digit(line) for line in lines]
    nums = zip(first_digits, last_digits)
    return sum([first*10+last for first, last in nums])

def part2(input):
    lines = input.split("\n")
    new_lines = [part2_line_to_part1_line(line) for line in lines]
    return part1_from_lines(new_lines)           

def first_digit(line):
    for char in line:
        if char.isdigit():
            return int(char)
    raise ValueError("No digit found in line")

def last_digit(line):
    return first_digit(line[::-1])

word2num = {
    "one": "o1e",
    "two": "t2o",
    "three": "t3e",
    "four": "f4r",
    "five": "f5v",
    "six": "s6x",
    "seven": "s7n",
    "eight": "e8t",
    "nine": "n9e",
}

def part2_line_to_part1_line(line):
    for word, num in word2num.items():
        line = line.replace(word, num)
    return line