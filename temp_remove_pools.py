# Read the file
with open('lib/main.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

print(f'Total lines: {len(lines)}')

# Keep lines 0-24 (first 25 lines - imports and data imports)
# Keep lines 4654 onwards (application logic - index 4654)
# Remove lines 25-4653 (question pool data)

header = ''.join(lines[:25])
app_logic = ''.join(lines[4654:])

new_content = header + '\n\n' + app_logic

# Write back
with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.write(new_content)

print(f'Successfully removed question pools')
print(f'Original lines: {len(lines)}')
print(f'New content lines: {len(new_content.splitlines())}')
