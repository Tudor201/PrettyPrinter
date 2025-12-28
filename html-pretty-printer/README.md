# HTML Pretty Printer

Acesta este un script shell care formateaza automat fisierele HTML (indentare corecta).

Echipa:
1. Tudor - se ocupa de partea de baza (citire fisier, indentare tag-uri normale)
2. Andrei - se ocupa de cazurile speciale (tag-uri script, style, comentarii) si teste

Cum se ruleaza:
./prettyhtml.sh fisier.html

Structura:
- prettyhtml.sh: scriptul principal
- tests/: folder cu fisiere de test pentru diverse situatii
