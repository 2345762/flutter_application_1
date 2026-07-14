# Read the header file
with open('lib/main_new.dart', 'r', encoding='utf-8') as f:
    header = f.read()

# Read the application logic from main.dart (starting from line 4662)
with open('lib/main.dart', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Get everything from line 4662 onwards (index 4661)
app_logic = ''.join(lines[4661:])

# Combine
combined = header + '\n' + app_logic

# Write to main.dart
with open('lib/main.dart', 'w', encoding='utf-8') as f:
    f.write(combined)

print('Successfully combined files')
