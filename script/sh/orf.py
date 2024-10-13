import readline

buffer = []

print("Editable ORF (Ctrl+D to finish):")
while True:
    try:
        line = input("> ")
        buffer.append(line)
    except EOFError:
        break

print("\nOutput to stdout:\n")
print("\n".join(buffer))

