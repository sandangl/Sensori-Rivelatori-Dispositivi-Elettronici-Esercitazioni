---
name: emanuele-writing-style
description: Apply Emanuele's signature academic writing style to LaTeX documents, reports, and scientific explanations.
---

# Emanuele's Writing Style

When writing or editing text on behalf of the user, particularly for academic reports, theses, or LaTeX documents, you MUST adopt the following stylistic guidelines to match their signature voice (as demonstrated in scientific publications and LaTeX reports).

## 1. Pedagogical First-Person Plural (Il "Plurale Majestatis" Didattico)
Always use the active first-person plural (`noi`) to guide the reader through the logic of the research and physical modeling. Treat the text as a collaborative journey between the author and the reader.
- **Do use:** "Analizziamo ora...", "Procediamo ad isolare...", "Soffermiamoci su...", "Indaghiamo l'impatto...", "Inquadriamo pertanto...", "Presentiamo...", "Mettiamo a confronto...", "Formalizziamo...", "Sfruttando...", "Realizzeremo..."
- **Do NOT use:** Passive impersonals ("È stato analizzato...", "Viene mostrato..."), third-person agency ("Il capitolo analizza..."), or first-person singular ("Io ho fatto...").

## 2. Rigorous, Rich, and Vivid Academic Vocabulary
The tone must be highly academic, technically precise, yet narrative and engaging. Use strong, descriptive adjectives and precise physical/computational verbs to explain complex processes.
- **Preferred phrasing examples:** "Innumerevoli e caotiche riflessioni", "crolli inesorabili", "tessuto edificato", "dinamica fitopatologica", "motore fisico", "straordinaria efficienza", "firma radar", "baseline radiometrica", "riflessione speculare", "doppio rimbalzo", "scattering di volume", "volta fogliare", "matrice vegetata", "discontinuità strutturali".

## 3. Strict LaTeX Typographical Rules
When writing LaTeX source code, follow these exact formatting conventions:
- **Bold text (`\textbf{}`)**: Use for key concepts, crucial physical mechanisms, primary subjects, or main mathematical indices (e.g., `\textbf{Radar Vegetation Index (RVI)}`, `\textbf{Soil Moisture Index (SMI)}`, `\textbf{VV}`, `\textbf{VH}`, `\textbf{double bounce}`, `\textbf{Z-Score}`, `\textbf{Olea}`, `\textbf{Leccino}`).
- **Italic text (`\textit{}`)**: Use exclusively for English technical terminology, foreign expressions, or Latin biological names (e.g., `\textit{backscatter}`, `\textit{forward scattering}`, `\textit{double bounce}`, `\textit{system losses}`, `\textit{canopy}`, `\textit{phasor}`, `\textit{Xylella fastidiosa}`, `\textit{Toumeyella parvicornis}`).
- **Math & Equations**: Place formal equations in explicit `\begin{equation} ... \end{equation}` blocks with clear `\label{eq:...}` tags. Always define physical parameters and boundary values (e.g., $0$ to $1$) immediately before or after the formula.
- **Cross-Referencing & Formatting**: Use `\cref{...}` or `\ref{...}` for figures, tables (`\label{tab:...}`), and equations. Format ranges with en-dashes (`2015--2025`) and numbers with appropriate Italian/LaTeX formatting.

## 4. Logical Sentence Architecture (Context → Action → Result)
Structure sentences sequentially: first state the *context or objective*, then the *1st-person plural action*, and finally the *physical or theoretical result/rationale*.
- *Example*: "Per analizzare il comportamento radiometrico dei seminativi [CONTEXT], **isoliamo** un appezzamento a grano [ACTION]. La scelta ci consente di monitorare lo sviluppo ciclico della biomassa [RESULT]."

## 5. Seamless Integration of Data, Equations, and Physical Theories
Never present figures, tables, or equations in isolation. Weave them logically into the text narrative by explaining *why* a metric or Region of Interest (ROI) was chosen and what physical mechanism (e.g., specular reflection vs volume scattering) governs the observed behavior.

## Activation
Whenever the user asks to "write in my style", "rewrite this section", or asks for an academic addition to their paper or thesis, automatically apply all of the above rules.
