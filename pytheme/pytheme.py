import sys
import json
import re
from pathlib import Path

theme_file = sys.argv[1]
template_files = (list((Path(__file__).parent / "templates").glob("*")))

for file in template_files:
    with open(file) as template, open(theme_file) as theme:
        s = template.read()
        export_path = Path.home() / Path(re.match(r"\s*#\s*(\S+)?", s.partition("\n")[0]).group(1))
        export_dir = export_path.parent
        if export_dir.is_dir():
            with open(export_path, "w") as outfile:
                t = theme.read()
                clean = re.sub(r"^\s*//.*\n?", "", t, flags=re.MULTILINE)
                j = json.loads(clean)
                variables = set(re.findall(r"&{([^}]+)}&", s))
                for var in variables:
                    parts = var.split(".")
                    key = "".join(f"['{i}']" for i in parts)
                    item = eval(f"j{key}")
                    s = re.sub(f"&{{{var}}}&", str(item), s, flags=re.MULTILINE)
                outfile.write(s)
