#!/usr/bin/env python3
"""
Converte atributos stroke-dasharray em subcaminhos vetoriais explícitos (M x y L x y)
no arquivo SVG antes da exportação para EMF via Inkscape, garantindo que o LibreOffice
preserve linhas tracejadas e pontilhadas no DOCX e no PDF vetorial.
"""
import sys
import re
import math

def dash_svg_file(svg_path):
    with open(svg_path, "r", encoding="utf-8") as f:
        content = f.read()

    def repl(match):
        full_tag = match.group(0)
        da_m = re.search(r'stroke-dasharray="([^"]+)"', full_tag)
        d_m = re.search(r'\bd="([^"]+)"', full_tag)
        if not da_m or not d_m:
            return full_tag
        da_vals = [float(x) for x in re.split(r"[\s,]+", da_m.group(1).strip()) if x]
        if len(da_vals) < 2:
            return full_tag
        dash_len, gap_len = da_vals[0], da_vals[1]
        pts_raw = re.findall(r"[ML]\s*([0-9.+-]+)\s+([0-9.+-]+)", d_m.group(1))
        if len(pts_raw) < 2:
            return full_tag
        pts = [(float(x), float(y)) for x, y in pts_raw]
        new_d = []
        for i in range(len(pts) - 1):
            x0, y0 = pts[i]
            x1, y1 = pts[i + 1]
            dx, dy = x1 - x0, y1 - y0
            seg_len = math.hypot(dx, dy)
            if seg_len == 0:
                continue
            ux, uy = dx / seg_len, dy / seg_len
            d_l = min(dash_len, seg_len * 0.35) if seg_len < 25 else dash_len
            g_l = min(gap_len, seg_len * 0.25) if seg_len < 25 else gap_len
            pos = 0.0
            while pos < seg_len:
                end_pos = min(pos + d_l, seg_len)
                sx, sy = x0 + ux * pos, y0 + uy * pos
                ex, ey = x0 + ux * end_pos, y0 + uy * end_pos
                new_d.append(f"M {sx:.3f} {sy:.3f} L {ex:.3f} {ey:.3f}")
                pos += d_l + g_l
        joined_d = " ".join(new_d)
        new_tag = re.sub(r'\s*stroke-dasharray="[^"]+"', "", full_tag)
        new_tag = re.sub(r'\bd="[^"]+"', 'd="' + joined_d + '"', new_tag)
        return new_tag

    new_content = re.sub(r'<path\b[^>]*stroke-dasharray="[^"]+"[^>]*/>', repl, content)
    with open(svg_path, "w", encoding="utf-8") as f:
        f.write(new_content)

if __name__ == "__main__":
    for path in sys.argv[1:]:
        dash_svg_file(path)
