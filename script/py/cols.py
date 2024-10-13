import subprocess
import sys

def main():
    # Read input from standard input (stdin)
    input_data = sys.stdin.read()
    # Split the input into lines
    lines = input_data.strip().splitlines()

    output = ""
    for i, line in enumerate(lines):
        padLen = max(0, 15 - len(line))  # Ensure padding is not negative
        pad = ' ' * padLen
        output += f"{line}{pad}"

        # Add a newline after every 3 lines
        if (i + 1) % 3 == 0:
            output += "\n"

    print(output)

if __name__ == "__main__":
    main()
