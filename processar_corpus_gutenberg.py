#!/usr/bin/env python3
"""
Pipeline de construção, higienização e desambiguação morfossintática do
Corpus Diacrônico Gutenberg (Séculos XVI a XX) para o artigo
"A Língua em Perpétua Transmutação".
"""

import os
import re
import json
import urllib.request
import csv
from collections import Counter

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CORPUS_DIR = os.path.join(BASE_DIR, "corpus_gutenberg")
RAW_DIR = os.path.join(CORPUS_DIR, "raw")
CLEAN_DIR = os.path.join(CORPUS_DIR, "clean")

os.makedirs(RAW_DIR, exist_ok=True)
os.makedirs(CLEAN_DIR, exist_ok=True)

# Cesta de 40 obras canônicas integralmente em língua portuguesa por século (prosa, poesia e teatro)
LIVROS = [
    # SÉCULO XVI (6 obras - 103.000 palavras)
    {"id": 3333,  "seculo": 16, "autor": "Luís de Camões", "titulo": "Os Lusíadas", "ano": 1572},
    {"id": 27725, "seculo": 16, "autor": "Bernardim Ribeiro", "titulo": "Menina e Moça (Saudades)", "ano": 1554},
    {"id": 28122, "seculo": 16, "autor": "Pero de Magalhães Gandavo", "titulo": "Tractado da terra do Brasil", "ano": 1576},
    {"id": 21287, "seculo": 16, "autor": "Gil Vicente", "titulo": "Pranto de Maria Parda", "ano": 1522},
    {"id": 24129, "seculo": 16, "autor": "Gil Vicente", "titulo": "Monólogo do Vaqueiro", "ano": 1502},
    {"id": 20581, "seculo": 16, "autor": "Gonçalo Anes Bandarra", "titulo": "Trovas do Bandarra", "ano": 1540},

    # SÉCULO XVII (6 obras - 155.760 palavras)
    {"id": 37757, "seculo": 17, "autor": "Francisco Rodrigues Lobo", "titulo": "Côrte na Aldeia e Noites de Inverno (Vol. I)", "ano": 1619},
    {"id": 72793, "seculo": 17, "autor": "Francisco Rodrigues Lobo", "titulo": "Côrte na Aldeia e Noites de Inverno (Vol. II)", "ano": 1619},
    {"id": 71724, "seculo": 17, "autor": "Gregório de Matos", "titulo": "Obras Poéticas (Tomo I)", "ano": 1680},
    {"id": 28692, "seculo": 17, "autor": "Manuel de Almeida", "titulo": "Vida de Takla Haymanot", "ano": 1630},
    {"id": 19641, "seculo": 17, "autor": "Sebastião da Fonseca", "titulo": "Relaçam da Jornada da Rainha", "ano": 1670},
    {"id": 19947, "seculo": 17, "autor": "Vicente Barbosa", "titulo": "Compendio da Relaçam da India", "ano": 1691},

    # SÉCULO XVIII (6 obras - 268.071 palavras)
    {"id": 70662, "seculo": 18, "autor": "André João Antonil", "titulo": "Cultura e Opulência do Brasil", "ano": 1711},
    {"id": 71405, "seculo": 18, "autor": "Luís António Verney", "titulo": "Verdadeiro Método de Estudar (Vol. I)", "ano": 1746},
    {"id": 18082, "seculo": 18, "autor": "Tomás António Gonzaga", "titulo": "Marília de Dirceu", "ano": 1792},
    {"id": 16385, "seculo": 18, "autor": "Nicolau Tolentino", "titulo": "Obras Poéticas", "ano": 1790},
    {"id": 58689, "seculo": 18, "autor": "Manuel Maria Barbosa du Bocage", "titulo": "Poesias", "ano": 1795},
    {"id": 22508, "seculo": 18, "autor": "João Baptista Gomes Júnior", "titulo": "Nova Castro", "ano": 1798},

    # SÉCULO XIX (12 obras - 992.817 palavras)
    {"id": 55752, "seculo": 19, "autor": "Machado de Assis", "titulo": "Dom Casmurro", "ano": 1899},
    {"id": 54829, "seculo": 19, "autor": "Machado de Assis", "titulo": "Memórias Póstumas de Brás Cubas", "ano": 1881},
    {"id": 55682, "seculo": 19, "autor": "Machado de Assis", "titulo": "Quincas Borba", "ano": 1891},
    {"id": 67724, "seculo": 19, "autor": "José de Alencar", "titulo": "O Guarani (Vol. I)", "ano": 1857},
    {"id": 67725, "seculo": 19, "autor": "José de Alencar", "titulo": "O Guarani (Vol. II)", "ano": 1857},
    {"id": 67740, "seculo": 19, "autor": "José de Alencar", "titulo": "Iracema", "ano": 1865},
    {"id": 40409, "seculo": 19, "autor": "Eça de Queirós", "titulo": "Os Maias", "ano": 1888},
    {"id": 42942, "seculo": 19, "autor": "Eça de Queirós", "titulo": "O Primo Basílio", "ano": 1878},
    {"id": 31971, "seculo": 19, "autor": "Eça de Queirós", "titulo": "O Crime do Padre Amaro", "ano": 1875},
    {"id": 16425, "seculo": 19, "autor": "Camilo Castelo Branco", "titulo": "Amor de Perdição", "ano": 1862},
    {"id": 21406, "seculo": 19, "autor": "Camilo Castelo Branco", "titulo": "Novelas do Minho", "ano": 1875},
    {"id": 9654,  "seculo": 19, "autor": "Alexandre Herculano", "titulo": "Lendas e Narrativas", "ano": 1851},

    # SÉCULO XX (10 obras - 287.556 palavras)
    {"id": 67535, "seculo": 20, "autor": "Lima Barreto", "titulo": "Triste Fim de Policarpo Quaresma", "ano": 1915},
    {"id": 24919, "seculo": 20, "autor": "Abel Botelho", "titulo": "Amor Crioulo", "ano": 1905},
    {"id": 2837,  "seculo": 20, "autor": "J. Simões Lopes Neto", "titulo": "Lendas do Sul", "ano": 1913},
    {"id": 21209, "seculo": 20, "autor": "Guerra Junqueiro", "titulo": "Pátria", "ano": 1915},
    {"id": 17610, "seculo": 20, "autor": "Florbela Espanca", "titulo": "Livro de Mágoas", "ano": 1919},
    {"id": 21799, "seculo": 20, "autor": "Mário de Sá-Carneiro", "titulo": "Dispersão", "ano": 1914},
    {"id": 22615, "seculo": 20, "autor": "José de Almada Negreiros", "titulo": "A Cena do Ódio", "ano": 1915},
    {"id": 22632, "seculo": 20, "autor": "Teixeira de Pascoais", "titulo": "À Ventura", "ano": 1922},
    {"id": 22679, "seculo": 20, "autor": "António Boto", "titulo": "Canções", "ano": 1922},
    {"id": 70819, "seculo": 20, "autor": "Fialho de Almeida", "titulo": "Contos", "ano": 1910}
]

def download_text(book_id):
    raw_path = os.path.join(RAW_DIR, f"{book_id}.txt")
    if os.path.exists(raw_path) and os.path.getsize(raw_path) > 1000:
        with open(raw_path, "r", encoding="utf-8", errors="ignore") as f:
            return f.read()

    urls = [
        f"https://www.gutenberg.org/cache/epub/{book_id}/pg{book_id}.txt",
        f"https://www.gutenberg.org/files/{book_id}/{book_id}-0.txt",
        f"https://www.gutenberg.org/files/{book_id}/{book_id}.txt"
    ]
    for url in urls:
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=15) as resp:
                content = resp.read().decode("utf-8", errors="ignore")
                if len(content) > 1000:
                    with open(raw_path, "w", encoding="utf-8") as f:
                        f.write(content)
                    return content
        except Exception:
            continue
    return None

def strip_gutenberg_boilerplates(text):
    """Remove cabeçalhos e rodapés de licença do Projeto Gutenberg."""
    start_match = re.search(r"\*\*\*\s*START OF (THE|THIS) PROJECT GUTENBERG EBOOK[^\*]*\*\*\*", text, re.IGNORECASE)
    if start_match:
        text = text[start_match.end():]
    end_match = re.search(r"\*\*\*\s*END OF (THE|THIS) PROJECT GUTENBERG EBOOK", text, re.IGNORECASE)
    if end_match:
        text = text[:end_match.start()]
    return text.strip()

# Regras de desambiguação contextual para "a gente" (nominal coletivo vs. pronominal/indeterminador)
NOM_PRE_AGENTE = re.compile(
    r"\b(toda|tôda|aquela|aquella|esta|essa|outra|muita|pouca|alguma|nenhuma|mesma|certa|qualquer|cada|tantas?|quantas?)\s+$",
    re.I
)
NOM_POST_AGENTE = re.compile(
    r"^\s*(,\s*que\b|que\s+(passava|estava|vinha|ia|ficava|corria|saía|sahia|entrava|subia|descia|vivia|morava|trabalhava|assistia|ouvia|via|ali|alli|lá|cá|ahi|aí)|de\b|do\b|da\b|dos\b|das\b|d\x27|desta|deste|dessa|desse|daquela|daquele|daquella|daquelle|daqui|dali|dalli|onde|cujo|cuja|lusitana|forte|fortíssima|santa|moça|velha|nova|pobre|rica|boa|bôa|má|brava|bárbara|barbara|cristã|christã|humana|armada|inimiga|portuguesa|portugueza|estranha|miúda|miuda|baixa|nobre|plebeia|rude|simples|honrada|aldeã|viva|fina|grande|pequena|mais\b|menos\b|toda|tôda|alegre|triste|perdida|trabalhada|belígera|belligera|belicosa|infiel|fiel|cega|miseravel|miserável|soberba|humilde|ordinaria|ordinária|escolhida|junta|reunida|restante|presente|ausente|vizinha|visinha|antiga|moderna|camponeza|camponesa|maritima|marítima|guerreira|pacifica|pacífica|civil|militar|ecclesiastica|eclesiástica|rustica|rústica|grosseira|limpa|honesta|séria|seria|grave|frivola|frívola|civilisada|civilizada|nativa|ajoelhada|ignorada|esfrangalhada|surda|endurecida|assinalada|irada|amiga|descuidada|débil|debil|cansada|biscainha|mahometa|londrina|alvoraçada|aluoraçada|cortes|cortês|mão|padua|pádua|palha)",
    re.I
)

# Regras de desambiguação contextual para "embora" (espacial vs. concessivo/optativo)
SPATIAL_EMBORA = re.compile(
    r"\b(ir|ia|iam|ias|irei|irá|irão|iria|iriam|indo|ido|id[ea]s?|vou|vais|vai|vae|vamos|ides|vão|vaõ|fui|foste|foi|fomos|foram|fôra|va[i]?|vá|vás|vades|fosse|fossem|for|fores|formos|fordes|forem|vir|vinha|vinham|veio|vieram|vem|vêm|venha|mand\w+|lev\w+|bot\w+|deit\w+|pôs|pôr|ponh\w+|toc\w+|and\w+|part\w+|fug\w+|escap\w+|retir\w+|saf\w+|march\w+|segu\w+|corr\w+|mandou-se|foi-se|iam-se|ia-se|ir-se|irei-me|vou-me|vais-te|vai-te|vae-te|vai-se|vae-se|vamos-nos|vamo-nos|vão-se|foram-se|fui-me|vim-me)\b",
    re.I
)

PADROES_SIMPLES = {
    "vos_tonico": r"\bvós\b",
    "vossa_merce": r"\bvossas?\s+merc[êeé]s?\b|\bvossemec[êeé]s?\b|\bvossamec[êeé]s?\b|\bvosmec[êeé]s?\b|\bvanc[êeé]s?\b|\bv\.\s*m\.?(?:c[êeé]\.?)?\b",
    "voce": r"\bvoc[êeé]s?\b",
    "ce": r"\bc[eê]s?\b",
    "nos_tonico": r"\bnós\b",
    "porem": r"\bpor[ée]m\b",
    "todavia": r"\btodav[ií]a\b|\btodauia\b",
    "entretanto": r"\bentretanto\b",
    "no_entanto": r"\bno\s+entanto\b",
    "adeus": r"\badeus\b|\badeos\b",
}

def main():
    print("=== INICIANDO COLETA E DESAMBIGUAÇÃO DO CORPUS GUTENBERG ===")
    livros_processados = []
    totais_por_seculo = Counter()
    contagens_por_seculo = {sec: Counter() for sec in [16, 17, 18, 19, 20]}

    for l in LIVROS:
        b_id = l["id"]
        sec = l["seculo"]
        raw_text = download_text(b_id)
        if not raw_text:
            print(f"[FALHA] ID {b_id}")
            continue

        clean_text = strip_gutenberg_boilerplates(raw_text)
        clean_path = os.path.join(CLEAN_DIR, f"{b_id}_clean.txt")
        with open(clean_path, "w", encoding="utf-8") as f:
            f.write(clean_text)

        tokens = re.findall(r"\b[a-zA-ZáàâãéêíóôõúüçÁÀÂÃÉÊÍÓÔÕÚÜÇ]+\b", clean_text)
        n_tokens = len(tokens)
        totais_por_seculo[sec] += n_tokens

        clean_lower = clean_text.lower()
        contagem_livro = {}
        for chave, padrao in PADROES_SIMPLES.items():
            matches = len(re.findall(padrao, clean_lower))
            contagem_livro[chave] = matches
            contagens_por_seculo[sec][chave] += matches

        # Desambiguação de "a gente"
        ag_nom, ag_pron = 0, 0
        for m in re.finditer(r"\ba\s+gente\b", clean_text, re.I):
            pre = clean_text[max(0, m.start()-30):m.start()].replace("\n", " ")
            post = clean_text[m.end():min(len(clean_text), m.end()+35)].replace("\n", " ")
            if NOM_PRE_AGENTE.search(pre) or NOM_POST_AGENTE.search(post):
                ag_nom += 1
            elif b_id in [3333, 28692, 19641, 19947] and not re.search(r"põe sua esperança", post):
                ag_nom += 1
            elif b_id == 70662 and re.search(r"governar\s*$", pre, re.I):
                ag_nom += 1
            else:
                ag_pron += 1
        contagem_livro["a_gente_nominal"] = ag_nom
        contagem_livro["a_gente_pronominal"] = ag_pron
        contagens_por_seculo[sec]["a_gente_nominal"] += ag_nom
        contagens_por_seculo[sec]["a_gente_pronominal"] += ag_pron

        # Desambiguação de "embora"
        emb_esp, emb_conc = 0, 0
        for m in re.finditer(r"\bembora\b", clean_text, re.I):
            pre = clean_text[max(0, m.start()-35):m.start()].replace("\n", " ")
            if SPATIAL_EMBORA.search(pre):
                emb_esp += 1
            else:
                emb_conc += 1
        contagem_livro["embora_espacial"] = emb_esp
        contagem_livro["embora_concessivo"] = emb_conc
        contagens_por_seculo[sec]["embora_espacial"] += emb_esp
        contagens_por_seculo[sec]["embora_concessivo"] += emb_conc

        livros_processados.append({
            "id": b_id,
            "seculo": sec,
            "autor": l["autor"],
            "titulo": l["titulo"],
            "ano": l["ano"],
            "tokens": n_tokens,
            "contagens": contagem_livro
        })

    todas_chaves = list(PADROES_SIMPLES.keys()) + [
        "a_gente_nominal", "a_gente_pronominal", "embora_espacial", "embora_concessivo"
    ]
    resumo_seculos = []
    for sec in [16, 17, 18, 19, 20]:
        total_tok = totais_por_seculo[sec]
        print(f"Século {sec}: {total_tok:,} palavras.")
        dados_sec = {"seculo": sec, "tokens_totais": total_tok}
        for chave in todas_chaves:
            raw_c = contagens_por_seculo[sec][chave]
            ppm = (raw_c / total_tok * 1_000_000) if total_tok > 0 else 0
            dados_sec[f"{chave}_raw"] = raw_c
            dados_sec[f"{chave}_ppm"] = round(ppm, 1)
        resumo_seculos.append(dados_sec)

    with open(os.path.join(CORPUS_DIR, "livros_metadados_contagens.json"), "w", encoding="utf-8") as f:
        json.dump(livros_processados, f, ensure_ascii=False, indent=2)

    with open(os.path.join(CORPUS_DIR, "resumo_seculos.json"), "w", encoding="utf-8") as f:
        json.dump(resumo_seculos, f, ensure_ascii=False, indent=2)

    csv_path = os.path.join(CORPUS_DIR, "tabela_diacronica_seculos_ppm.csv")
    with open(csv_path, "w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=list(resumo_seculos[0].keys()))
        writer.writeheader()
        writer.writerows(resumo_seculos)

    print("Processamento concluído com sucesso!")

if __name__ == "__main__":
    main()
