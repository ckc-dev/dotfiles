"""Uses a theme file to convert templates for apps into configuration files."""

import json
import re
import sys
from pathlib import Path

# Initialize constants and variables.
TEMPLATE_FOLDER_PATH = Path(__file__).parent / "templates"
template_files = (list((TEMPLATE_FOLDER_PATH).glob("*")))
theme_file_path = sys.argv[1]

# Open theme .jsonc file, remove comments, and load it to a dictionary.
with open(theme_file_path) as theme:
    theme_str = theme.read()
    theme_str = re.sub(
        r"^\s*//.*\n?", "",
        theme_str,
        flags=re.MULTILINE
    )
    theme_dict = json.loads(theme_str)

# For each template configuration file:
for file in template_files:
    # Open configration and theme files.
    with open(file) as template:
        # Store file contents in a string.
        template_str = template.read()
        template_header, _, template_str = template_str.partition("\n")

        # Strip strings from leading and trailing whitespaces.
        template_header = template_header.strip()
        template_str = template_str.strip()

        # Define path and directory to where converted config will be exported.
        export_path = Path.home() / Path(template_header)
        export_dir = export_path.parent

        # If export directory exists:
        if export_dir.is_dir():
            # Create a new file, to where converted config will be exported.
            with open(export_path, "w") as export_file:
                # Find all unique variables present in template file.
                template_vars = set(re.findall(r"&{([^}]+)}&", template_str))

                # For each of those:
                for var in template_vars:
                    # Split variable parts, and use those parts to create a
                    # key, which should be present in the theme dictionary.
                    parts = var.split(".")
                    key = "".join(f"['{i}']" for i in parts)

                    # Evaluate expression for getting an item from dictionary,
                    # using the generated key.
                    item = eval(f"theme_dict{key}")

                    # Substitute variable on the template to its actual value.
                    template_str = re.sub(
                        f"&{{{var}}}&",
                        str(item),
                        template_str
                    )

                # Write converted template to export file.
                export_file.write(template_str)
