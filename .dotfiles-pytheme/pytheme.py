"""Uses a theme file to convert templates for apps into configuration files."""

import json
import re
from pathlib import Path

# Initialize constants and variables.
TEMPLATE_FOLDER_PATH = Path(__file__).parent / "templates"
THEME_FOLDER_PATH = Path(__file__).parent / "themes"
template_files = (list((TEMPLATE_FOLDER_PATH).glob("*")))
theme_files = (list((THEME_FOLDER_PATH).glob("*")))

# Initialize regular expressions.
REGEX_JSONC_COMMENTS = re.compile(r"""
    (?<!:)  # Ensure there is no ":" before matching "/" twice. This is done to
            # prevent URLs from matching.
    /{2}    # Match "/" twice.
    [^\n]*  # Match any character that is not a newline, between 0 and ∞ times.
    |       # OR
    /       # Match "/" once.
    \*      # Match "*" once.
    .*?     # Match any character between 0 and ∞ times, as few times as
            # possible.
    \*      # Match "*" once.
    /       # Match "/" once.""", re.DOTALL | re.VERBOSE)

REGEX_VARIABLE = re.compile(r"""
    &           # Match "&" once.
    {           # Match "{" once.
        ([^}]+) # CAPTURE GROUP 0 | Match any character that is not a "}",
                # between 1 and ∞ times.
    }           # Match "}" once.
    &           # Match "&" once.""", re.VERBOSE)

# Display available theme files as options.
print("Available themes:")
for i, file in enumerate(theme_files, 1):
    print(f"{i} - '{file.stem}'")

# Prompt the user for a theme.
selection = None
while not selection:
    try:
        index = int(input(f"Pick a theme (1 - {len(theme_files)}): ")) - 1
        assert index >= 0
        selection = theme_files[index]
    except (ValueError, IndexError, AssertionError):
        print(f"Please use a number between 1 and {len(theme_files)}).")

# Store theme .jsonc file, remove comments, and load it to a dictionary.
theme_str = Path(selection).read_text()
theme_str = REGEX_JSONC_COMMENTS.sub("", theme_str)
theme_dict = json.loads(theme_str)

# For each template configuration file:
for template_file_path in template_files:
    # Store file contents in a string.
    template_str = Path(template_file_path).read_text()
    template_header, _, template_str = template_str.partition("\n")

    # Strip strings from leading and trailing whitespaces.
    template_header = template_header.strip()
    template_str = template_str.strip()

    # Define path and directory to where converted config will be exported.
    export_path = Path.home() / Path(template_header)
    export_dir = export_path.parent

    # Create export directory if it does not exist.
    export_dir.mkdir(parents=True, exist_ok=True)

    # Create a new file, to where converted config will be exported.
    with open(export_path, "w") as export_file:
        # Find all unique variables present in template file.
        template_vars = set(REGEX_VARIABLE.findall(template_str))

        # For each of those:
        for var in template_vars:
            # Split variable parts, and use those parts to create a key, which
            # should be present in the theme dictionary.
            parts = var.split(".")
            key = "".join(f"['{i}']" for i in parts)

            # Evaluate expression for getting an item from dictionary, using
            # the generated key.
            item = eval(f"theme_dict{key}")

            # Substitute variable on the template to its actual value.
            template_str = re.sub(
                f"&{{{var}}}&",
                str(item),
                template_str
            )

        # Write converted template to export file.
        export_file.write(template_str)

print("Done!")
