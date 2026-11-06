# Script em R para geracao de graficos com ggplot2
# Projeto: A Lingua em Perpetua Transmutacao
# Autor: Leonardo Carneiro de Araujo

library(ggplot2)

# Configuracao global de tema academico elegante
tema_academico <- function() {
  theme_minimal(base_size = 12) +
    theme(
      text = element_text(color = "#2c3e50"),
      plot.title = element_text(face = "bold", size = 13, hjust = 0.5, margin = margin(b = 8)),
      plot.subtitle = element_text(size = 9.8, hjust = 0.5, color = "#555555", margin = margin(b = 15)),
      plot.caption = element_text(size = 8.3, color = "#666666", hjust = 0, margin = margin(t = 12)),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(color = "#ebebeb", linewidth = 0.4),
      panel.grid.major.y = element_line(color = "#ebebeb", linewidth = 0.4),
      axis.title = element_text(face = "bold", size = 10.5),
      axis.text = element_text(size = 9.5, color = "#333333"),
      legend.position = "top",
      legend.title = element_text(face = "bold", size = 10),
      legend.text = element_text(size = 9.5),
      plot.margin = margin(15, 20, 15, 15)
    )
}

# ==============================================================================
# FIGURA 1: Insercao diacronica de "a gente" vs "nos"
# Segmento tracejado (SEM PONTOS) e segmento continuo (com pontos e rotulos claros)
# ==============================================================================

# Linha tracejada pura (sem pontos) para a hipotese esquematica (Sec. XIX a 1970)
df_tracejado <- data.frame(
  x_num = c(1, 2, 3, 4),
  agente = c(5, 15, 25, 42),
  nos = c(95, 85, 75, 58)
)

# Segmento empirico auditavel (Decada de 1970 a 1990 - Tabela 5.3, p. 124 de Lopes)
# Nova Amostra (Estudo de Tendencia Comunitario)
df_empirico <- data.frame(
  x_num = c(4, 5),
  agente = c(42.0, 75.0),
  nos = c(58.0, 25.0)
)

# Amostra Recontato (Estudo de Painel com os mesmos individuos)
df_recontato <- data.frame(
  x_num = c(4, 5),
  agente = c(42.0, 54.0),
  nos = c(58.0, 46.0)
)

p1 <- ggplot() +
  # Faixas metodologicas de fundo (PRIMEIRA CAMADA para nao sobrepor nem cobrir linhas no formato vetorial EMF/SVG)
  annotate("rect", xmin = 0.5, xmax = 3.5, ymin = 0, ymax = 105, fill = "#f4f4f4") +
  annotate("text", x = 2.0, y = 100, label = "Reconstituição esquemática (incerteza documental)", 
           size = 3.1, fontface = "italic", color = "#666666") +
  annotate("text", x = 4.5, y = 100, label = "Dados empíricos auditados (NURC / PEUL)", 
           size = 3.1, fontface = "bold", color = "#333333") +

  # Linhas tracejadas PURAS (SEM PONTOS) para a fase esquematica (Séc. XIX a 1970)
  geom_line(data = df_tracejado, aes(x = x_num, y = agente), 
            color = "#1b7837", linewidth = 1.1, linetype = "dashed") +
  geom_line(data = df_tracejado, aes(x = x_num, y = nos), 
            color = "#762a83", linewidth = 1.1, linetype = "dashed") +
  
  # Linhas solidas para a fase empirica comprovada (1970 a 1990 - Nova Amostra)
  geom_line(data = df_empirico, aes(x = x_num, y = agente, color = "a gente (comunidade / nova amostra)"), 
            linewidth = 1.4, linetype = "solid") +
  geom_line(data = df_empirico, aes(x = x_num, y = nos, color = "nós (canônica)"), 
            linewidth = 1.4, linetype = "solid") +
  
  # Linha pontilhada mais fina mostrando a trajetória da Amostra Recontato (painel)
  geom_line(data = df_recontato, aes(x = x_num, y = agente), 
            color = "#1b7837", linewidth = 0.8, linetype = "dotted") +
  geom_line(data = df_recontato, aes(x = x_num, y = nos), 
            color = "#762a83", linewidth = 0.8, linetype = "dotted") +
  
  # Pontos cheios APENAS nos dados empiricos (1970 e 1990)
  geom_point(data = df_empirico, aes(x = x_num, y = agente, color = "a gente (comunidade / nova amostra)"), size = 4, shape = 16) +
  geom_point(data = df_empirico, aes(x = x_num, y = nos, color = "nós (canônica)"), size = 4, shape = 17) +
  
  # Pontos para a Amostra Recontato em 1990
  geom_point(data = data.frame(x = 5, y = 54), aes(x = x, y = y), color = "#1b7837", size = 3, shape = 1) +
  geom_point(data = data.frame(x = 5, y = 46), aes(x = x, y = y), color = "#762a83", size = 3, shape = 2) +
  
  # Rotulos numericos bem posicionados para NAO sobrepor
  # Em 1970: 42% (a gente) e 58% (nós)
  annotate("text", x = 4.0, y = 37.5, label = "42%", fontface = "bold", size = 3.8, color = "#1b7837") +
  annotate("text", x = 4.0, y = 62.5, label = "58%", fontface = "bold", size = 3.8, color = "#762a83") +
  
  # Em 1990: 75% (Nova Amostra a gente) e 25% (Nova Amostra nós)
  annotate("text", x = 5.0, y = 79.5, label = "75%", fontface = "bold", size = 3.8, color = "#1b7837") +
  annotate("text", x = 5.0, y = 20.5, label = "25%", fontface = "bold", size = 3.8, color = "#762a83") +
  
  # Rotulo explicativo para o Recontato (sem poluição)
  annotate("text", x = 5.12, y = 54.0, label = "Recontato: 54%", hjust = 0, size = 3.1, color = "#1b7837", fontface = "italic") +
  annotate("text", x = 5.12, y = 46.0, label = "Recontato: 46%", hjust = 0, size = 3.1, color = "#762a83", fontface = "italic") +
  
  scale_color_manual(name = "Variante de 1ª pessoa plural:",
                     values = c("a gente (comunidade / nova amostra)" = "#1b7837", "nós (canônica)" = "#762a83")) +
  scale_x_continuous(breaks = 1:5, labels = c("Séc. XIX\n(Inicial)", "Virada séc.\n(1900)", "Meados séc. XX\n(1950)", 
                                             "Década de 1970\n(NURC/PEUL)", "Década de 1990\n(NURC/PEUL)")) +
  scale_y_continuous(limits = c(0, 108), breaks = seq(0, 100, 20),
                     labels = function(x) paste0(x, "%")) +
  labs(
    title = "Evolução da Substituição de 'Nós' por 'A Gente' como Sujeito Pronominal",
    subtitle = "Linha contínua: Nova Amostra (comunidade) | Linha pontilhada: Recontato (painel) | Linha tracejada: projeção diacrônica",
    x = "Período / Recorte Temporal",
    y = "Frequência Relativa (%)",
    caption = "Fonte: Dados empíricos (1970–1990) extraídos de Lopes (1999/2003, p. 47-48, 124, Tabela 5.3) com base no Projeto NURC-RJ / PEUL.\nA fase pré-1970 (linha tracejada pura) representa a modelagem teórica da difusão lexical em curva S (Wang, 1969; Kroch, 1989; Lopes, 2003)."
  ) +
  tema_academico() +
  coord_cartesian(xlim = c(0.8, 5.65))

ggsave("figura1_agente_diacronico.png", plot = p1, width = 8.6, height = 5.3, dpi = 300)
cat("Figura 1 regerada com sucesso com correções visuais.\n")

# ==============================================================================
# FIGURA 2: Lei matematica de regularizacao verbal no ingles (Lieberman et al., 2007)
# Meia-vida empírica dos verbos irregulares em anos segundo a frequência de uso
# ==============================================================================
df_culturomics <- data.frame(
  freq_bin = c("1 a 10", "10 a 100", "100 a 1.000", "1.000 a 10.000", "> 10.000"),
  frequencia_central = c(3.16, 31.6, 316, 3162, 31622),
  meia_vida_anos = c(700, 2000, 6000, 14400, 38800),
  rotulo = c("~700 anos\n(chide, smite)", 
             "~2.000 anos\n(strew, tread)", 
             "~6.000 anos\n(blow, freeze)", 
             "~14.400 anos\n(think, come)", 
             "~38.800 anos\n(be, have)")
)

x_teorico <- exp(seq(log(1), log(60000), length.out = 200))
fit <- lm(log10(meia_vida_anos) ~ log10(frequencia_central), data = df_culturomics)

df_teorico <- data.frame(
  frequencia_central = x_teorico,
  meia_vida_anos = 10^(predict(fit, newdata = data.frame(frequencia_central = x_teorico)))
)

p2 <- ggplot() +
  geom_line(data = df_teorico, aes(x = frequencia_central, y = meia_vida_anos),
            color = "#1f78b4", linewidth = 1.2, linetype = "dashed") +
  geom_point(data = df_culturomics, aes(x = frequencia_central, y = meia_vida_anos),
             color = "#e31a1c", size = 4.2) +
  geom_text(data = df_culturomics, 
            aes(x = frequencia_central, y = meia_vida_anos, label = rotulo),
            hjust = -0.08, vjust = 0.5, size = 3.1, color = "#2c3e50") +
  scale_x_log10(breaks = c(1, 10, 100, 1000, 10000, 100000),
                labels = c("1", "10", "100", "1.000", "10.000", "100.000")) +
  scale_y_log10(breaks = c(100, 500, 1000, 5000, 10000, 50000, 100000),
                labels = c("100", "500", "1.000", "5.000", "10.000", "50.000", "100.000")) +
  labs(
    title = "Dinâmica Evolutiva da Regularização dos Verbos no Inglês (Nature, 2007)",
    subtitle = expression(paste("A meia-vida (", t[1/2], ") escala com a raiz quadrada da frequência de uso: ", t[1/2] %prop% sqrt(f), " (expoente empírico ", b %approx% 0.5, ")")),
    x = "Frequência de Uso no Corpus (ocorrências por milhão de palavras - escala log)",
    y = "Meia-Vida do Verbo Irregular em Anos (escala log)",
    caption = "Fonte: Elaborado com base nos dados empíricos de Lieberman et al. (Nature, 2007, v. 449, p. 713-716).\nMeia-vida calculada a partir do decaimento de 177 verbos irregulares rastreados do inglês antigo ao moderno."
  ) +
  tema_academico() +
  coord_cartesian(xlim = c(1, 350000), ylim = c(300, 80000))

ggsave("figura2_culturomics_nature.png", plot = p2, width = 8.6, height = 5.3, dpi = 300)
file.copy("figura2_culturomics_nature.png", "figura3_culturomics_nature.png", overwrite = TRUE)
cat("Figura Culturomics regerada com sucesso em 300 DPI.\n")

# Gerar versões vetoriais SVG e EMF para Figura 1 e Figura 3 (Nature)
svg("figura1_agente_diacronico.svg", width = 8.6, height = 5.3)
print(p1)
dev.off()
system("python3 converter_tracejados_svg.py figura1_agente_diacronico.svg")
system("inkscape figura1_agente_diacronico.svg --export-filename=figura1_agente_diacronico.emf")

svg("figura3_culturomics_nature.svg", width = 8.6, height = 5.3)
print(p2)
dev.off()
system("python3 converter_tracejados_svg.py figura3_culturomics_nature.svg")
system("inkscape figura3_culturomics_nature.svg --export-filename=figura3_culturomics_nature.emf")

# Copiar para figura2 por compatibilidade
file.copy("figura3_culturomics_nature.svg", "figura2_culturomics_nature.svg", overwrite = TRUE)
file.copy("figura3_culturomics_nature.emf", "figura2_culturomics_nature.emf", overwrite = TRUE)

cat("Versões vetoriais SVG e EMF geradas com sucesso para Figuras 1 e 3!\n")
