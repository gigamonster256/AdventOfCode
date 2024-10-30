#!/usr/bin/env python3
import os
import sys

TEST_PATH = "test"
SOLUTION_PATH = "solution"


def year_string(year):
    return f"year_{year}"


def day_string(day):
    return f"day_{day:02d}"


def solution_directory(year):
    return f"{SOLUTION_PATH}/{year_string(year)}"


def test_directory(year):
    return f"{TEST_PATH}/{year_string(year)}"


def solution_path_no_ext(year, day):
    return f"{solution_directory(year)}/{day_string(day)}"


def solution_path(year, day):
    return f"{solution_path_no_ext(year, day)}.py"


def test_path_no_ext(year, day):
    return f"{test_directory(year)}/{day_string(day)}_test"


def test_path(year, day):
    return f"{test_path_no_ext(year, day)}.py"


def solution_template():
    return """def part1(input):
    pass

def part2(input):
    pass"""


def test_template(year, day):
    return f'''from {solution_path_no_ext(year, day).replace('/','.')} import part1, part2
import pytest

input = """
"""


@pytest.mark.skip
def test_part1():
    assert part1(input) == None

@pytest.mark.skip
def test_part2():
    assert part2(input) == None'''


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: gen_year.py <year>")
        sys.exit(1)

    year = sys.argv[1]
    if not year.isdigit():
        print(f"Invalid year: {year}")
        sys.exit(1)

    year = int(year)
    days = range(1, 26)

    solution_dir = solution_directory(year)
    test_dir = test_directory(year)
    print(f"Generating year {year} solutions and tests")
    print(f"Solution directory: {solution_dir}")
    print(f"Test directory: {test_dir}")
    os.makedirs(solution_dir, exist_ok=True)
    os.makedirs(test_dir, exist_ok=True)

    # make __init__.py files
    if not os.path.exists(f"{SOLUTION_PATH}/__init__.py"):
        with open(f"{SOLUTION_PATH}/__init__.py", "w") as f:
            pass

    if not os.path.exists(f"{TEST_PATH}/__init__.py"):
        with open(f"{TEST_PATH}/__init__.py", "w") as f:
            pass

    for day in days:
        # Write solution if it doesn't exist
        solution_file = solution_path(year, day)
        if not os.path.exists(solution_file):
            print(f"Writing solution file: {solution_file}")
            with open(solution_file, "w") as f:
                f.write(solution_template())
        else:
            print(f"Solution file already exists: {solution_file}")

    if not os.path.exists(f"{solution_dir}/__init__.py"):
        with open(f"{solution_dir}/__init__.py", "w") as f:
            pass

    for day in days:
        # Write test if it doesn't exist
        test_file = test_path(year, day)
        if not os.path.exists(test_file):
            print(f"Writing test file: {test_file}")
            with open(test_file, "w") as f:
                f.write(test_template(year, day))
        else:
            print(f"Test file already exists: {test_file}")

    if not os.path.exists(f"{test_dir}/__init__.py"):
        with open(f"{test_dir}/__init__.py", "w") as f:
            pass
