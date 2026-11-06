library(ggplot2)
library(patchwork)

tema_academico <- function() {
  theme_minimal(base_size = 11) +
    theme(
      text = element_text(color = "#2c3e50"),
      plot.title = element_text(face = "bold", size = 10.0, hjust = 0.5, margin = margin(b = 4)),
      plot.subtitle = element_text(size = 7.9, hjust = 0.5, color = "#555555", margin = margin(b = 8)),
      panel.grid.minor = element_blank(),
      panel.grid.major.x = element_line(color = "#ececec", linewidth = 0.4),
      panel.grid.major.y = element_line(color = "#ececec", linewidth = 0.4),
      axis.title = element_text(face = "bold", size = 8.8),
      axis.text = element_text(size = 8.2, color = "#333333"),
      legend.position = "top",
      legend.title = element_text(face = "bold", size = 8.0),
      legend.text = element_text(size = 7.6),
      legend.box.spacing = unit(2, "pt"),
      legend.margin = margin(b = 2),
      plot.margin = margin(8, 10, 8, 8)
    )
}

seculos <- c("Séc. XVI", "Séc. XVII", "Séc. XVIII", "Séc. XIX", "Séc. XX")
x_vals <- 1:5

# -------------------------------------------------------------
# 1. Painel A: Substituição de 2ª Pessoa (Vós tônico vs. Você)
# -------------------------------------------------------------
df_pA <- data.frame(
  x = rep(x_vals, 2),
  seculo = rep(seculos, 2),
  forma = factor(rep(c("Vós (pronome tônico)", "Você(s) (inovadora)"), each = 5),
                 levels = c("Vós (pronome tônico)", "Você(s) (inovadora)")),
  ppm = c(1427, 1207, 242, 126, 56,
          0, 19, 0, 495, 306),
  vjust_val = c(-0.8, -0.8, -0.8, 1.8, 1.8,
                -0.8, -0.8, -0.8, -0.8, -0.8),
  hjust_val = c(0.5, 0.5, -0.25, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5)
)

pA <- ggplot(df_pA, aes(x = x, y = ppm, color = forma, group = forma)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5) +
  geom_text(aes(label = sprintf("%.0f", ppm), vjust = vjust_val, hjust = hjust_val), 
            size = 2.7, show.legend = FALSE, fontface = "bold") +
  annotate("label", x = 3.85, y = 1150, 
           label = "Proporção [você / (você + vós)]:\n1,6% (séc. XVII) -> 79,7% (séc. XIX)\n-> 84,6% (séc. XX)",
           size = 2.4, fill = "#ffffff", color = "#117733") +
  scale_x_continuous(breaks = x_vals, labels = seculos) +
  scale_y_continuous(limits = c(-80, 1680), breaks = seq(0, 1500, by = 300)) +
  scale_color_manual(values = c("Vós (pronome tônico)" = "#882255", "Você(s) (inovadora)" = "#117733")) +
  labs(
    title = "A: Alocução de 2ª Pessoa na Amostra Literária",
    subtitle = "Retração do pronome tônico 'Vós' e consolidação de 'Você(s)' nos diálogos",
    x = "Período Diacrônico", y = "Freq. por Milhão (PPM)",
    color = "Variante:"
  ) +
  tema_academico()

# -------------------------------------------------------------
# 2. Painel B: Desambiguação de 1ª Pessoa (Nós tônico vs. A gente)
# -------------------------------------------------------------
df_pB_lit <- data.frame(
  x = rep(x_vals, 3),
  seculo = rep(seculos, 3),
  forma = factor(rep(c("Nós (tônico)", "A gente (nominal coletivo)", "A gente (pronominal)"), each = 5),
                 levels = c("Nós (tônico)", "A gente (nominal coletivo)", "A gente (pronominal)")),
  ppm = c(515, 289, 336, 373, 442,
          728, 96, 34, 68, 143,
          39, 39, 22, 108, 118),
  vjust_val = c(1.8, -0.8, -0.8, -0.8, -0.8,
                -0.8, -0.7, -0.9, 1.8, -0.8,
                1.8, 1.8, 1.8, -0.8, 1.8),
  hjust_val = c(0.5, 0.5, 0.5, 0.5, 0.5,
                0.5, -0.25, 0.5, 0.5, 0.5,
                0.5, 0.5, 0.5, 0.5, 0.5)
)

pB <- ggplot(df_pB_lit, aes(x = x, y = ppm, color = forma, linetype = forma, shape = forma, group = forma)) +
  geom_line(linewidth = 1.05) +
  geom_point(size = 2.6) +
  geom_text(aes(label = sprintf("%.0f", ppm), vjust = vjust_val, hjust = hjust_val), 
            size = 2.6, show.legend = FALSE, fontface = "bold") +
  annotate("label", x = 3.55, y = 630, 
           label = "Desambiguação morfossintática:\nDeclínio do coletivo épico ('gente forte')\ne avanço pronominal nos sécs. XIX–XX",
           size = 2.35, fill = "#ffffff", color = "#333333") +
  scale_x_continuous(breaks = x_vals, labels = seculos) +
  scale_y_continuous(limits = c(-50, 840), breaks = seq(0, 800, by = 200)) +
  scale_color_manual(values = c("Nós (tônico)" = "#1f78b4", 
                                "A gente (nominal coletivo)" = "#d95f02", 
                                "A gente (pronominal)" = "#009E73")) +
  scale_linetype_manual(values = c("Nós (tônico)" = "solid", 
                                   "A gente (nominal coletivo)" = "dashed", 
                                   "A gente (pronominal)" = "solid")) +
  scale_shape_manual(values = c("Nós (tônico)" = 16, 
                                "A gente (nominal coletivo)" = 17, 
                                "A gente (pronominal)" = 15)) +
  labs(
    title = "B: 'Nós' Tônico vs. 'A gente' (Nominal e Pronominal)",
    subtitle = "Separação entre substantivo coletivo e pronome inclusivo na amostra Gutenberg",
    x = "Período Diacrônico", y = "Freq. por Milhão (PPM)",
    color = NULL, linetype = NULL, shape = NULL
  ) +
  tema_academico()

# -------------------------------------------------------------
# 3. Painel C: Contraste entre Ambientes Comunicativos (Você vs. Cê / Vc)
# -------------------------------------------------------------
df_pC <- data.frame(
  corpus = factor(c("Fala Espontânea\n(C-ORAL-BRASIL)", "Fala Espontânea\n(C-ORAL-BRASIL)",
                    "Escrita Digital\n(Redes Sociais)", "Escrita Digital\n(Redes Sociais)",
                    "Prosa Literária\n(Amostra Séc. XX)", "Prosa Literária\n(Amostra Séc. XX)"),
                  levels = c("Fala Espontânea\n(C-ORAL-BRASIL)", "Escrita Digital\n(Redes Sociais)", "Prosa Literária\n(Amostra Séc. XX)")),
  variante = factor(rep(c("Forma Reduzida (Cê / Vc)", "Forma Plena (Você)"), 3),
                    levels = c("Forma Reduzida (Cê / Vc)", "Forma Plena (Você)")),
  pct = c(77.3, 12.0, 55.4, 44.6, 1.1, 98.9)
)

pC <- ggplot(df_pC, aes(x = corpus, y = pct, fill = variante)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.75), width = 0.65) +
  geom_text(aes(label = paste0(pct, "%")), 
            position = position_dodge(width = 0.75), vjust = -0.5, size = 2.6, fontface = "bold") +
  annotate("text", x = 1.95, y = 86, label = "Contínuo fala-escrita (Marcuschi, 2001, 2010):\nDiferenças refletem grau de monitoramento estilístico\ne condições de produção de cada modalidade", 
           size = 2.3, fontface = "italic", color = "#444444") +
  scale_y_continuous(limits = c(0, 115), breaks = seq(0, 100, by = 25)) +
  scale_fill_manual(values = c("Forma Reduzida (Cê / Vc)" = "#E69F00", "Forma Plena (Você)" = "#56B4E9")) +
  labs(
    title = "C: Distribuição Sincrônica de Você vs. Cê / Vc por Modalidade",
    subtitle = "Contraste entre ambientes comunicativos: Fala (77,3%) | Redes (55,4%) | Literatura (1,1%)",
    x = "Esfera Comunicativa / Registro", y = "Frequência Relativa (%)",
    fill = "Variante:"
  ) +
  tema_academico()

# -------------------------------------------------------------
# 4. Painel D: Concorrência no Nicho Conectivo Adversativo
# -------------------------------------------------------------
df_pD_long <- data.frame(
  x = rep(x_vals, 2),
  seculo = rep(seculos, 2),
  categoria = factor(rep(c("Inovações: Entretanto + No entanto", "Tradicional: Porém"), each = 5),
                     levels = c("Inovações: Entretanto + No entanto", "Tradicional: Porém")),
  pct = c(12.3, 2.2, 3.7, 31.7, 50.3,
          87.7, 97.8, 96.3, 68.3, 49.7),
  vjust_val = c(-0.8, 1.8, 1.8, -0.8, -0.8,
                -0.8, -0.8, -0.8, -0.8, 1.8)
)

pD <- ggplot(df_pD_long, aes(x = x, y = pct, color = categoria, group = categoria)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.6) +
  geom_text(aes(label = paste0(round(pct, 1), "%"), vjust = vjust_val), 
            size = 2.6, show.legend = FALSE, fontface = "bold") +
  annotate("label", x = 2.35, y = 50, 
           label = "Tendência no nicho adversativo:\n• Sécs. XVI–XVIII: hegemonia de 'Porém' (>87%)\n• Séc. XIX: avanço das inovações (31,7%)\n• Séc. XX: paridade na amostra (50,3%)",
           size = 2.35, fill = "#ffffff", color = "#009E73") +
  scale_x_continuous(breaks = x_vals, labels = seculos) +
  scale_y_continuous(limits = c(-6, 110), breaks = seq(0, 100, by = 20)) +
  scale_color_manual(values = c("Inovações: Entretanto + No entanto" = "#009E73", 
                                "Tradicional: Porém" = "#D55E00")) +
  labs(
    title = "D: Concorrência no Nicho Adversativo [% no Envelope]",
    subtitle = "Participação relativa de 'Entretanto + No entanto' frente a 'Porém'",
    x = "Período Diacrônico", y = "Participação no Envelope (%)",
    color = "Conectivos:"
  ) +
  tema_academico()

# Consolidação da Figura 2
painel_completo <- (pA | pB) / (pC | pD) +
  plot_annotation(
    title = "Tendências de Frequência e Envelopes de Variação no Português (Sécs. XVI a XXI)",
    subtitle = "Amostra Literária Diacrônica do Projeto Gutenberg (1,81M palavras), C-ORAL-BRASIL I e Corpora Digitais (32k postagens)",
    caption = "Fontes: Amostra Diacrônica Gutenberg com desambiguação morfossintática (elaboração própria); C-ORAL-BRASIL I (Ferrari, 2013); ToLD-Br, HateBR e DANTEStocks.",
    theme = theme(
      plot.title = element_text(face = "bold", size = 13.0, hjust = 0.5, color = "#1a252f", margin = margin(b = 4)),
      plot.subtitle = element_text(size = 9.2, hjust = 0.5, color = "#555555", margin = margin(b = 10)),
      plot.caption = element_text(size = 8, color = "#666666", hjust = 0, margin = margin(t = 10))
    )
  )

# Salvar PNG
ggsave("figura2_diacronico_gutenberg.png", painel_completo, width = 11, height = 8.5, dpi = 300)
file.copy("figura2_diacronico_gutenberg.png", "figura3_diacronico_gutenberg.png", overwrite = TRUE)

# Salvar SVG vetorial
svg("figura2_diacronico_gutenberg.svg", width = 11, height = 8.5)
print(painel_completo)
dev.off()
system("python3 converter_tracejados_svg.py figura2_diacronico_gutenberg.svg")
file.copy("figura2_diacronico_gutenberg.svg", "figura3_diacronico_gutenberg.svg", overwrite = TRUE)

# Converter para EMF vetorial com Inkscape
system("inkscape figura2_diacronico_gutenberg.svg --export-filename=figura2_diacronico_gutenberg.emf")
file.copy("figura2_diacronico_gutenberg.emf", "figura3_diacronico_gutenberg.emf", overwrite = TRUE)

cat("Figura 2 (Painel Gutenberg desambiguado) PNG, SVG e EMF gerados com sucesso!\n")
