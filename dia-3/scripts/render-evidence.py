"""Genera vistas de las salidas originales para capturas; no inventa resultados."""
from pathlib import Path
import html
import re

folder = Path(__file__).resolve().parent.parent / 'evidence'
for number, title, filenames in [
    ('01', 'Inversión de 100 — rechazada', ['invest-100.log']),
    ('02', 'Inversión de 500 — exitosa y balance RWA', ['invest-500.log', 'balance.log']),
]:
    sections = []
    for name in filenames:
        text = (folder / name).read_text()
        text = re.sub(r'\x1b\[[0-9;]*m', '', text)
        sections.append('<h2>' + html.escape(name) + '</h2><pre>' + html.escape(text) + '</pre>')
    page = '''<!doctype html><html lang="es"><meta charset="utf-8"><title>''' + title + '''</title>
<style>body{margin:0;background:#0f172a;color:#e2e8f0;font-family:system-ui;padding:24px}
h1{font-size:23px;margin:8px 0}p{color:#a9b9cf;font-size:14px}h2{font-size:14px;color:#8bd5ff;margin:12px 0 8px}
pre{background:#172339;border:1px solid #334155;border-radius:8px;margin:0;padding:14px;font:13px/1.4 ui-monospace,Menlo,monospace;white-space:pre-wrap;overflow-wrap:anywhere}
</style><body><p>STELLAR ELITE BOLIVIA · SEMANA 4 · TESTNET</p><h1>''' + title + '''</h1>
<p>Registro original de Stellar CLI ejecutado mediante scripts/user-tool.sh. Vista de los archivos .log guardados.</p>''' + ''.join(sections) + '</body></html>'
    (folder / f'{number}-registro.html').write_text(page)
