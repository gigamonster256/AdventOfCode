from solution.year_2023.day_01 import part1, part2
import pytest

input = """1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet"""

input2 = """two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen"""


def test_part1():
    assert part1(input) == 142

def test_part2():
    assert part2(input2) == 281