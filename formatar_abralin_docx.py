import docx
from docx.shared import Pt, Cm, Inches
from docx.enum.text import WD_ALIGN_PARAGRAPH

doc = docx.Document("A_Lingua_em_Perpetua_Transmutacao_Abralin.docx")

# Page margins: 2.5 cm on all sides
for s in doc.sections:
    s.top_margin = Cm(2.5)
    s.bottom_margin = Cm(2.5)
    s.left_margin = Cm(2.5)
    s.right_margin = Cm(2.5)

state = 0

for i, p in enumerate(doc.paragraphs):
    text = p.text.strip()
    
    # State transitions
    if text == "Introdução":
        state = 1
    elif "INFORMAÇÕES ADICIONAIS" in text:
        state = 2
    elif text == "Referências":
        state = 3
        
    pf = p.paragraph_format
    
    if state == 0:
        # Pre-textual elements
        pf.space_before = Pt(0)
        pf.space_after = Pt(4)
        pf.line_spacing = 1.15
        pf.first_line_indent = Pt(0)
        
        if i in [0, 1]:  # Titles
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            pf.space_after = Pt(6)
        elif "Tipo de Contribuição" in text or "Leonardo Carneiro" in text:
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
        elif text.startswith("RESUMO") or text.startswith("PALAVRAS-CHAVE") or text.startswith("ABSTRACT") or text.startswith("KEYWORDS"):
            p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
            pf.space_after = Pt(6)
            
    elif state == 1:
        # Body text
        if text.startswith("1. ") or text.startswith("2. ") or text.startswith("3. ") or text.startswith("4. ") or text.startswith("5. ") or text == "Introdução":
            # Section titles
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            pf.space_before = Pt(12)
            pf.space_after = Pt(6)
            pf.line_spacing = 1.5
            pf.first_line_indent = Pt(0)
        elif any(text.startswith(f"{m}.") for m in ["2.1", "2.2", "2.3", "2.4", "2.5", "3.1", "3.2", "3.3", "3.4", "4.1", "4.2", "4.3", "4.4"]):
            # Subsection titles
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            pf.space_before = Pt(10)
            pf.space_after = Pt(4)
            pf.line_spacing = 1.5
            pf.first_line_indent = Pt(0)
        elif p.style.name in ["Quote", "Citao", "Citacao_Epigrafe", "Block Text"]:
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            pf.left_indent = Cm(4.0)
            pf.first_line_indent = Pt(0)
            pf.line_spacing = 1.0
            pf.space_before = Pt(4)
            pf.space_after = Pt(4)
        elif "Figura " in text and ("Tendências" in text or "Evolução" in text):
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            pf.space_before = Pt(4)
            pf.space_after = Pt(2)
            pf.line_spacing = 1.0
            pf.first_line_indent = Pt(0)
        elif text.startswith("Fonte:"):
            p.alignment = WD_ALIGN_PARAGRAPH.CENTER
            pf.space_before = Pt(0)
            pf.space_after = Pt(8)
            pf.line_spacing = 1.0
            pf.first_line_indent = Pt(0)
        elif text.startswith("Convenção de leitura:"):
            p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
            pf.space_before = Pt(2)
            pf.space_after = Pt(6)
            pf.line_spacing = 1.15
            pf.first_line_indent = Pt(0)
            for r in p.runs:
                r.font.name = "Times New Roman"
                r.font.size = Pt(10)
        # Note: We do NOT touch normal body text or tables so pandoc's native table layout is preserved!
            
    elif state == 2:
        # Additional information
        is_heading = ("INFORMAÇÕES ADICIONAIS" in text or 
                      text.endswith("(obrigatório)") or 
                      text.endswith("(opcional)") or 
                      text.endswith("(se aplicável)") or
                      "(obrigatório)" in text or
                      "(opcional)" in text or
                      "(se aplicável)" in text)
        if is_heading:
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            pf.space_before = Pt(8)
            pf.space_after = Pt(2)
            pf.line_spacing = 1.15
            pf.first_line_indent = Pt(0)
        else:
            p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
            pf.space_before = Pt(0)
            pf.space_after = Pt(4)
            pf.line_spacing = 1.15
            pf.first_line_indent = Cm(1.25)
            
    elif state == 3:
        # References
        if text == "Referências":
            p.alignment = WD_ALIGN_PARAGRAPH.LEFT
            pf.space_before = Pt(14)
            pf.space_after = Pt(6)
            pf.line_spacing = 1.5
            pf.first_line_indent = Pt(0)
        else:
            p.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY
            pf.space_before = Pt(0)
            pf.space_after = Pt(6)
            pf.line_spacing = 1.0
            pf.first_line_indent = Pt(0)

doc.save("A_Lingua_em_Perpetua_Transmutacao_Abralin.docx")
print("Successfully formatted A_Lingua_em_Perpetua_Transmutacao_Abralin.docx")
